import 'package:flutter/foundation.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
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
    this.confidence,
    this.citations = const [],
    this.reasoningTrail,
    this.counterArguments,
    this.droppedUnverifiedCount = 0,
    this.attachment,
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

  /// Returns an updated copy of this message.
  ChatMessageModel copyWith({
    String? text,
    bool? isStreaming,
    String? errorMessage,
    bool clearError = false,
    ConfidenceLevel? confidence,
    List<VerifiedCitation>? citations,
    String? reasoningTrail,
    String? counterArguments,
    int? droppedUnverifiedCount,
  }) {
    return ChatMessageModel(
      id: id,
      isUser: isUser,
      text: text ?? this.text,
      isStreaming: isStreaming ?? this.isStreaming,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      confidence: confidence ?? this.confidence,
      citations: citations ?? this.citations,
      reasoningTrail: reasoningTrail ?? this.reasoningTrail,
      counterArguments: counterArguments ?? this.counterArguments,
      droppedUnverifiedCount:
          droppedUnverifiedCount ?? this.droppedUnverifiedCount,
      attachment: attachment,
    );
  }
}

/// Immutable state for the Ask Lex conversation screen.
@immutable
class ChatThreadState {
  /// Creates a [ChatThreadState].
  const new({
    this.messages = const [],
    this.attachedScan,
    this.isGenerating = false,
    this.lastFailedPrompt,
  });

  /// Ordered conversation messages.
  final List<ChatMessageModel> messages;

  /// Active attached document context, if any.
  final ChatAttachment? attachedScan;

  /// Whether a response stream is currently running.
  final bool isGenerating;

  /// Preserved prompt text when the last send failed.
  final String? lastFailedPrompt;

  /// Returns an updated copy of this thread state.
  ChatThreadState copyWith({
    List<ChatMessageModel>? messages,
    ChatAttachment? attachedScan,
    bool clearAttachment = false,
    bool? isGenerating,
    String? lastFailedPrompt,
    bool clearFailedPrompt = false,
  }) {
    return ChatThreadState(
      messages: messages ?? this.messages,
      attachedScan: clearAttachment
          ? null
          : (attachedScan ?? this.attachedScan),
      isGenerating: isGenerating ?? this.isGenerating,
      lastFailedPrompt: clearFailedPrompt
          ? null
          : (lastFailedPrompt ?? this.lastFailedPrompt),
    );
  }
}
