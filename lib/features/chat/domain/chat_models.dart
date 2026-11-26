import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/ai/router/model_router.dart';
import 'package:lex_copilot/core/widgets/confidence_badge.dart';

/// Scanned document attached as context to a chat conversation.
@immutable
class ChatAttachment {
  /// Creates a [ChatAttachment].
  const new({
    required this.scanId,
    required this.fileName,
    required this.pageCount,
    required this.documentType,
    required this.extractedText,
    required this.summary,
  });

  /// Reconstructs a [ChatAttachment] from decoded JSON.
  factory fromJson(Map<String, dynamic> json) => ChatAttachment(
    scanId: json['scan_id']?.toString() ?? '',
    fileName: json['file_name']?.toString() ?? 'Document',
    pageCount: (json['page_count'] as num?)?.toInt() ?? 1,
    documentType: json['document_type']?.toString() ?? 'Legal document',
    extractedText: json['extracted_text']?.toString() ?? '',
    summary: json['summary']?.toString() ?? '',
  );

  /// Encrypted database scan record ID.
  final String scanId;

  /// Display file/document title.
  final String fileName;

  /// Number of scanned pages.
  final int pageCount;

  /// Classified legal document type.
  final String documentType;

  /// Combined OCR / vision text passed to [ResearchPipeline].
  final String extractedText;

  /// Plain-language summary shown when first opening chat.
  final String summary;

  /// Serializes attachment metadata for encrypted conversation storage.
  Map<String, dynamic> toJson() => {
    'scan_id': scanId,
    'file_name': fileName,
    'page_count': pageCount,
    'document_type': documentType,
    'extracted_text': extractedText,
    'summary': summary,
  };
}

/// Structured provenance blocks keeping verbatim statutes, amendment footnotes,
/// judicial citations, and AI explanation visibly separated (Module G).
@immutable
class ProvenanceAnswerBlocks {
  /// Creates a [ProvenanceAnswerBlocks].
  const new({
    this.intentLabel = 'General Legal Research',
    this.officialTextExcerpts = const [],
    this.footnoteWarnings = const [],
    this.judicialRulings = const [],
    this.unavailableExternalNotices = const [],
  });

  /// Reconstructs [ProvenanceAnswerBlocks] from JSON.
  factory fromJson(Map<String, dynamic> json) => ProvenanceAnswerBlocks(
    intentLabel: json['intent_label']?.toString() ?? 'General Legal Research',
    officialTextExcerpts:
        (json['official_text_excerpts'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
    footnoteWarnings: (json['footnote_warnings'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    judicialRulings: (json['judicial_rulings'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(),
    unavailableExternalNotices:
        (json['unavailable_external_notices'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
  );

  /// Query classification label (`Constitutional Law`, `Criminal Law`, etc.).
  final String intentLabel;

  /// Verbatim excerpts from locally verified official text.
  final List<String> officialTextExcerpts;

  /// Separated amendment, un-notified, or judicial-invalidation footnote summaries.
  final List<String> footnoteWarnings;

  /// Verified judicial citations linked via footnotes/KG.
  final List<String> judicialRulings;

  /// Explicit notices for referenced external Acts where `full_text_available == false`.
  final List<String> unavailableExternalNotices;

  /// Serializes provenance metadata cleanly.
  Map<String, dynamic> toJson() => {
    'intent_label': intentLabel,
    'official_text_excerpts': officialTextExcerpts,
    'footnote_warnings': footnoteWarnings,
    'judicial_rulings': judicialRulings,
    'unavailable_external_notices': unavailableExternalNotices,
  };
}

/// Single user or Lex assistant turn in the chat thread.
@immutable
class ChatMessageModel {
  /// Creates a [ChatMessageModel].
  const new({
    required this.id,
    required this.isUser,
    required this.text,
    this.isStreaming = false,
    this.errorMessage,
    this.engineLabel,
    this.confidence,
    this.citations = const [],
    this.reasoningTrail,
    this.counterArguments,
    this.droppedUnverifiedCount = 0,
    this.attachment,
    this.provenance,
  });

  /// Unique message identifier.
  final String id;

  /// Whether this turn came from the user.
  final bool isUser;

  /// Rendered message text.
  final String text;

  /// Whether tokens are still streaming in.
  final bool isStreaming;

  /// Non-null when generation failed on this turn.
  final String? errorMessage;

  /// Provenance engine label (`Gemma 4 E2B · On-Device` or `Cloud · Gemma 4`).
  final String? engineLabel;

  /// Verified confidence badge for assistant messages.
  final ConfidenceLevel? confidence;

  /// Corpus-checked statutory citations.
  final List<VerifiedCitation> citations;

  /// Optional retrieval and verification summary.
  final String? reasoningTrail;

  /// Optional opposing considerations and edge cases.
  final String? counterArguments;

  /// Number of unverified citations removed or flagged by the verifier.
  final int droppedUnverifiedCount;

  /// Document attachment card linked to this message, if any.
  final ChatAttachment? attachment;

  /// Separated provenance & external boundary metadata (Module G).
  final ProvenanceAnswerBlocks? provenance;

  /// Returns an updated copy of this message.
  ChatMessageModel copyWith({
    String? text,
    bool? isStreaming,
    String? errorMessage,
    bool clearError = false,
    String? engineLabel,
    ConfidenceLevel? confidence,
    List<VerifiedCitation>? citations,
    String? reasoningTrail,
    String? counterArguments,
    int? droppedUnverifiedCount,
    ProvenanceAnswerBlocks? provenance,
  }) {
    return ChatMessageModel(
      id: id,
      isUser: isUser,
      text: text ?? this.text,
      isStreaming: isStreaming ?? this.isStreaming,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      engineLabel: engineLabel ?? this.engineLabel,
      confidence: confidence ?? this.confidence,
      citations: citations ?? this.citations,
      reasoningTrail: reasoningTrail ?? this.reasoningTrail,
      counterArguments: counterArguments ?? this.counterArguments,
      droppedUnverifiedCount:
          droppedUnverifiedCount ?? this.droppedUnverifiedCount,
      attachment: attachment,
      provenance: provenance ?? this.provenance,
    );
  }
}

/// Immutable state for the Ask Lex conversation screen.
@immutable
class ChatThreadState {
  /// Creates a [ChatThreadState].
  const new({
    this.conversationId,
    this.messages = const [],
    this.attachedScan,
    this.isGenerating = false,
    this.lastFailedPrompt,
    this.pendingCloudConsent,
    this.pendingPromptForConsent,
  });

  /// Active persistent conversation ID in encrypted SQLite storage.
  final String? conversationId;

  /// Ordered conversation messages.
  final List<ChatMessageModel> messages;

  /// Active attached document context, if any.
  final ChatAttachment? attachedScan;

  /// Whether a response stream is currently running.
  final bool isGenerating;

  /// Preserved prompt text when the last send failed.
  final String? lastFailedPrompt;

  /// Cloud escalation request waiting for explicit user approval.
  final CloudConsentRequest? pendingCloudConsent;

  /// Prompt saved while waiting for explicit cloud escalation approval.
  final String? pendingPromptForConsent;

  /// Returns an updated copy of this thread state.
  ChatThreadState copyWith({
    String? conversationId,
    List<ChatMessageModel>? messages,
    ChatAttachment? attachedScan,
    bool clearAttachment = false,
    bool? isGenerating,
    String? lastFailedPrompt,
    bool clearFailedPrompt = false,
    CloudConsentRequest? pendingCloudConsent,
    String? pendingPromptForConsent,
    bool clearPendingConsent = false,
  }) {
    return ChatThreadState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      attachedScan: clearAttachment
          ? null
          : (attachedScan ?? this.attachedScan),
      isGenerating: isGenerating ?? this.isGenerating,
      lastFailedPrompt: clearFailedPrompt
          ? null
          : (lastFailedPrompt ?? this.lastFailedPrompt),
      pendingCloudConsent: clearPendingConsent
          ? null
          : (pendingCloudConsent ?? this.pendingCloudConsent),
      pendingPromptForConsent: clearPendingConsent
          ? null
          : (pendingPromptForConsent ?? this.pendingPromptForConsent),
    );
  }
}
