import 'dart:async';

import 'package:lex_copilot/ai/ai_providers.dart';
import 'package:lex_copilot/ai/llm_service.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/core/widgets/confidence_badge.dart';
import 'package:lex_copilot/features/chat/domain/chat_models.dart';
import 'package:lex_copilot/features/library/presentation/library_providers.dart';
import 'package:lex_copilot/features/settings/presentation/settings_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

/// Manages document-grounded chat history, streaming responses, verification,
/// and failure recovery for the Ask Lex screen.
@Riverpod(keepAlive: true)
class ChatController extends _$ChatController {
  int _nextId = 1;

  @override
  ChatThreadState build() => const ChatThreadState();

  /// Attaches a scanned document and seeds an initial grounded assistant card.
  void attachScan(ChatAttachment attachment) {
    final assistantId = _takeId();
    final updatedMessages = List<ChatMessageModel>.from(state.messages)
      ..add(
        ChatMessageModel(
          id: assistantId,
          isUser: false,
          attachment: attachment,
          text:
              '${attachment.documentType} attached (${attachment.pageCount} '
              'page${attachment.pageCount == 1 ? '' : 's'}). '
              '${attachment.summary}\n\n'
              '${ResearchPipeline.verifyNotice}',
          confidence: ConfidenceLevel.medium,
          reasoningTrail:
              'Document OCR text (${attachment.extractedText.length} chars) loaded as active chat context.',
        ),
      );

    state = state.copyWith(
      attachedScan: attachment,
      messages: updatedMessages,
      clearFailedPrompt: true,
    );
  }

  /// Detaches the active document context.
  void clearAttachment() {
    state = state.copyWith(clearAttachment: true);
  }

  /// Clears all messages from the current thread.
  void clearThread() {
    state = const ChatThreadState();
  }

  /// Sends [rawQuestion] through [ResearchPipeline] and streams tokens live.
  /// Returns `true` if a response completed cleanly, `false` on error.
  Future<bool> sendMessage(String rawQuestion) async {
    final question = rawQuestion.trim();
    if (question.isEmpty || state.isGenerating) {
      return false;
    }

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

    final initialMessages = <ChatMessageModel>[
      ...state.messages,
      ChatMessageModel(id: userId, isUser: true, text: question),
      ChatMessageModel(
        id: assistantId,
        isUser: false,
        text: '',
        isStreaming: true,
      ),
    ];

    state = state.copyWith(
      messages: initialMessages,
      isGenerating: true,
      clearFailedPrompt: true,
    );

    final pipeline = ref.read(researchPipelineProvider);
    final settings = ref.read(settingsControllerProvider);

    try {
      final prepared = await pipeline.prepareQuery(
        question: question,
        settings: settings,
        documentContext: state.attachedScan?.extractedText,
      );

      final buffer = StringBuffer();
      final stream = pipeline.streamAnswer(
        systemPrompt: prepared.systemPrompt,
        userPrompt: prepared.userPrompt,
        history: priorHistory.length > 6
            ? priorHistory.sublist(priorHistory.length - 6)
            : priorHistory,
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
      if (rawAnswer.isEmpty) {
        _updateMessage(
          assistantId,
          (msg) => msg.copyWith(
            isStreaming: false,
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
      );

      _updateMessage(
        assistantId,
        (msg) => msg.copyWith(
          text: verified.answerText,
          isStreaming: false,
          clearError: true,
          confidence: verified.confidence,
          citations: verified.citations,
          reasoningTrail: verified.reasoningTrail,
          counterArguments: verified.counterArguments,
          droppedUnverifiedCount: verified.droppedUnverifiedCount,
        ),
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
                  '${verified.citations.length} verified citation${verified.citations.length == 1 ? '' : 's'}',
              route: '/ask',
            ),
      );

      state = state.copyWith(isGenerating: false, clearFailedPrompt: true);
      return true;
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

  String _takeId() => 'msg_${_nextId++}';
}
