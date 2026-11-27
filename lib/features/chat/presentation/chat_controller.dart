import 'dart:async';

import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/ai/router/model_router.dart';
import 'package:lex_copilot/core/widgets/confidence_badge.dart';
import 'package:lex_copilot/features/chat/data/chat_repository.dart';
import 'package:lex_copilot/features/chat/domain/chat_models.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

/// Provides the encrypted [ChatRepository] storing persistent threads/messages.
@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(ref.watch(appDatabaseProvider));
}

/// Manages document-grounded chat history, encrypted SQLite persistence,
/// explicit cloud escalation consent, streaming responses, and verification.
@Riverpod(keepAlive: true)
class ChatController extends _$ChatController {
  int _nextId = 1;
  bool _userMutatedThread = false;

  @override
  ChatThreadState build() {
    unawaited(_hydrateLatestThread());
    return const ChatThreadState();
  }

  Future<void> _hydrateLatestThread() async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      final loaded = await repo.loadLatestThread();
      if (_userMutatedThread) return;
      final thread = loaded.valueOrNull;
      if (thread == null) return;
      state = ChatThreadState(
        conversationId: thread.conversationId,
        attachedScan: thread.attachedScan,
        messages: thread.messages,
      );
    } on Object {
      // Keep clean empty thread if DB is unavailable in isolated unit tests.
    }
  }

  String _ensureConversationId() {
    final existing = state.conversationId;
    if (existing != null && existing.isNotEmpty) return existing;
    final created = 'convo_${DateTime.now().microsecondsSinceEpoch}';
    state = state.copyWith(conversationId: created);
    return created;
  }

  /// Attaches a scanned document and seeds an initial grounded assistant card.
  void attachScan(ChatAttachment attachment) {
    _userMutatedThread = true;
    final convoId = _ensureConversationId();
    final assistantId = _takeId();
    final introMsg = ChatMessageModel(
      id: assistantId,
      isUser: false,
      attachment: attachment,
      engineLabel: 'Gemma 4 · On-Device',
      text:
          '${attachment.documentType} attached (${attachment.pageCount} '
          'page${attachment.pageCount == 1 ? '' : 's'}). '
          '${attachment.summary}\n\n'
          '${ResearchPipeline.verifyNotice}',
      confidence: ConfidenceLevel.medium,
      reasoningTrail:
          'Document OCR text (${attachment.extractedText.length} chars) loaded as active chat context.',
    );

    final updatedMessages = List<ChatMessageModel>.from(state.messages)
      ..add(introMsg);

    state = state.copyWith(
      conversationId: convoId,
      attachedScan: attachment,
      messages: updatedMessages,
      clearFailedPrompt: true,
    );

    final repo = ref.read(chatRepositoryProvider);
    unawaited(
      repo.upsertConversation(
        conversationId: convoId,
        title: attachment.fileName,
        attachedScan: attachment,
      ),
    );
    unawaited(repo.upsertMessage(conversationId: convoId, message: introMsg));
  }

  /// Detaches the active document context.
  void clearAttachment() {
    _userMutatedThread = true;
    final convoId = state.conversationId;
    state = state.copyWith(clearAttachment: true);
    if (convoId != null) {
      unawaited(
        ref
            .read(chatRepositoryProvider)
            .upsertConversation(conversationId: convoId, clearAttachment: true),
      );
    }
  }

  /// Clears the visible thread and starts a new conversation ID cleanly.
  void clearThread() {
    _userMutatedThread = true;
    state = ChatThreadState(
      conversationId: 'convo_${DateTime.now().microsecondsSinceEpoch}',
    );
  }

  /// Approves a pending cloud escalation prompt and replays the query.
  Future<bool> approveCloudEscalation() async {
    final pendingPrompt = state.pendingPromptForConsent;
    state = state.copyWith(clearPendingConsent: true);
    if (pendingPrompt == null || pendingPrompt.trim().isEmpty) {
      return false;
    }
    unawaited(
      ref
          .read(chatRepositoryProvider)
          .recordAuditEvent(
            eventType: 'cloud_consent_granted',
            summary: 'User approved PII-redacted cloud escalation in Ask Lex.',
          ),
    );
    return await sendMessage(pendingPrompt, allowCloudConsent: true);
  }

  /// Declines a pending cloud escalation prompt without uploading anything.
  void declineCloudEscalation() {
    final pendingPrompt = state.pendingPromptForConsent;
    state = state.copyWith(
      clearPendingConsent: true,
      lastFailedPrompt: pendingPrompt,
    );
    unawaited(
      ref
          .read(chatRepositoryProvider)
          .recordAuditEvent(
            eventType: 'cloud_consent_denied',
            summary: 'User declined cloud escalation; kept data offline.',
          ),
    );
  }

  /// Sends [rawQuestion] through [ResearchPipeline] and streams tokens live.
  /// Returns `true` if a response completed cleanly, `false` on error or pause.
  Future<bool> sendMessage(
    String rawQuestion, {
    bool allowCloudConsent = false,
  }) async {
    final question = rawQuestion.trim();
    if (question.isEmpty || state.isGenerating) {
      return false;
    }
    _userMutatedThread = true;

    final convoId = _ensureConversationId();
    final userId = _takeId();
    final assistantId = _takeId();

    final priorHistory = state.messages
        .where((m) => m.errorMessage == null && m.text.trim().isNotEmpty)
        .map(
          (m) => LlmMessage(
            role: m.isUser ? LlmRole.user : LlmRole.assistant,
            content: m.text,
          ),
        )
        .toList();

    final userMessage = ChatMessageModel(
      id: userId,
      isUser: true,
      text: question,
    );
    final streamingPlaceholder = ChatMessageModel(
      id: assistantId,
      isUser: false,
      text: '',
      isStreaming: true,
    );

    final initialMessages = <ChatMessageModel>[
      ...state.messages,
      userMessage,
      streamingPlaceholder,
    ];

    state = state.copyWith(
      conversationId: convoId,
      messages: initialMessages,
      isGenerating: true,
      clearFailedPrompt: true,
      clearPendingConsent: true,
    );

    final repo = ref.read(chatRepositoryProvider);
    final titlePreview = question.length > 48
        ? '${question.substring(0, 48)}…'
        : question;
    unawaited(
      repo.upsertConversation(conversationId: convoId, title: titlePreview),
    );
    unawaited(
      repo.upsertMessage(conversationId: convoId, message: userMessage),
    );

    final pipeline = ref.read(researchPipelineProvider);
    final settings = ref.read(settingsControllerProvider);

    try {
      if (allowCloudConsent && state.attachedScan == null) {
        final cloudVerified = await pipeline.tryCloudVerifiedResearch(
          cloudService: ref.read(cloudGemmaServiceProvider),
          question: question,
        );
        if (cloudVerified != null) {
          const cloudLabel = 'Cloud · Gemini/Gemma Verified';
          _updateMessage(
            assistantId,
            (msg) => msg.copyWith(
              text: cloudVerified.answerText,
              isStreaming: false,
              clearError: true,
              engineLabel: cloudLabel,
              confidence: cloudVerified.confidence,
              citations: cloudVerified.citations,
              reasoningTrail: cloudVerified.reasoningTrail,
              counterArguments: cloudVerified.counterArguments,
              droppedUnverifiedCount: cloudVerified.droppedUnverifiedCount,
              provenance: cloudVerified.provenance,
            ),
          );
          final doneMsg = state.messages.firstWhere((m) => m.id == assistantId);
          unawaited(
            repo.upsertMessage(conversationId: convoId, message: doneMsg),
          );
          state = state.copyWith(isGenerating: false, clearFailedPrompt: true);
          return true;
        }
      }

      final prepared = await pipeline.prepareQuery(
        question: question,
        settings: settings,
        documentContext: state.attachedScan?.extractedText,
      );

      final docLen = state.attachedScan?.extractedText.length ?? 0;
      final taskKind = docLen > 4000
          ? RoutingTaskKind.deepResearch
          : RoutingTaskKind.shortPrivate;

      final buffer = StringBuffer();
      final stream = pipeline.streamAnswer(
        systemPrompt: prepared.systemPrompt,
        userPrompt: prepared.userPrompt,
        history: priorHistory.length > 6
            ? priorHistory.sublist(priorHistory.length - 6)
            : priorHistory,
        taskKind: taskKind,
        consentOverride: allowCloudConsent ? (_) async => true : null,
      );

      await for (final chunk in stream) {
        if (chunk.isEmpty) continue;
        buffer.write(chunk);
        _updateMessage(
          assistantId,
          (msg) => msg.copyWith(text: buffer.toString()),
        );
      }

      final rawAnswer = buffer.toString().trim();
      final engineLabel = pipeline.activeEngineLabel;
      if (rawAnswer.isEmpty) {
        _updateMessage(
          assistantId,
          (msg) => msg.copyWith(
            isStreaming: false,
            engineLabel: engineLabel,
            errorMessage: 'No response received from the active model. Check On-Device model setup or network connection and retry.',
          ),
        );
        state = state.copyWith(isGenerating: false, lastFailedPrompt: question);
        return false;
      }

      final verified = await pipeline.verifyAnswer(
        rawAnswer: rawAnswer,
        retrieved: prepared.retrieved,
        strictCitationsOnly: settings.strictCitationsOnly,
        ragBundle: prepared.ragBundle,
        intent: prepared.intent,
      );

      _updateMessage(
        assistantId,
        (msg) => msg.copyWith(
          text: verified.answerText,
          isStreaming: false,
          clearError: true,
          engineLabel: engineLabel,
          confidence: verified.confidence,
          citations: verified.citations,
          reasoningTrail: verified.reasoningTrail,
          counterArguments: verified.counterArguments,
          droppedUnverifiedCount: verified.droppedUnverifiedCount,
          provenance: verified.provenance,
        ),
      );

      final completedMessage = state.messages.firstWhere(
        (m) => m.id == assistantId,
      );
      unawaited(
        repo.upsertMessage(conversationId: convoId, message: completedMessage),
      );

      unawaited(
        ref
            .read(libraryRepositoryProvider)
            .recordActivity(
              kind: 'chat',
              title: question.length > 60
                  ? '${question.substring(0, 60)}…'
                  : question,
              subtitle:
                  '$engineLabel · ${verified.citations.length} verified citation${verified.citations.length == 1 ? '' : 's'}',
              route: '/ask',
            ),
      );

      state = state.copyWith(isGenerating: false, clearFailedPrompt: true);
      return true;
    } on CloudConsentRequiredException catch (consentErr) {
      // Remove provisional turns so explicit approval doesn't duplicate them.
      final cleaned = state.messages
          .where((m) => m.id != userId && m.id != assistantId)
          .toList();
      state = state.copyWith(
        messages: cleaned,
        isGenerating: false,
        pendingCloudConsent: consentErr.request,
        pendingPromptForConsent: question,
      );
      return false;
    } on Object catch (error) {
      _updateMessage(
        assistantId,
        (msg) => msg.copyWith(
          isStreaming: false,
          errorMessage:
              'Unable to complete response ($error). Your question was preserved so you can retry.',
        ),
      );
      state = state.copyWith(isGenerating: false, lastFailedPrompt: question);
      return false;
    }
  }

  /// Retries the most recent failed user prompt without duplicating the failed card.
  Future<bool> retryLast() {
    final failedPrompt = state.lastFailedPrompt;
    if (failedPrompt == null || failedPrompt.trim().isEmpty) {
      return Future.value(false);
    }
    final cleaned = List<ChatMessageModel>.from(state.messages);
    while (cleaned.isNotEmpty &&
        !cleaned.last.isUser &&
        cleaned.last.errorMessage != null) {
      cleaned.removeLast();
    }
    if (cleaned.isNotEmpty && cleaned.last.isUser) {
      cleaned.removeLast();
    }
    state = state.copyWith(messages: cleaned, clearFailedPrompt: true);
    return sendMessage(failedPrompt);
  }

  void _updateMessage(
    String id,
    ChatMessageModel Function(ChatMessageModel current) transform,
  ) {
    final next = state.messages
        .map((m) => m.id == id ? transform(m) : m)
        .toList();
    state = state.copyWith(messages: next);
  }

  String _takeId() =>
      'msg_${DateTime.now().microsecondsSinceEpoch}_${_nextId++}';
}
