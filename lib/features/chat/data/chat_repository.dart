import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/core/errors/failure.dart';
import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/core/widgets/confidence_badge.dart';
import 'package:lex_copilot/features/chat/domain/chat_models.dart';

/// Encrypted persistence repository for Ask Lex [Conversations] and [Messages],
/// plus non-PII consent/execution audit logs.
class ChatRepository {
  /// Creates a [ChatRepository].
  const new(this._db);

  final AppDatabase _db;

  /// Loads the latest persisted conversation ID and its ordered messages, or
  /// returns `null` when no conversation has been saved yet.
  Future<
    Result<
      ({
        String conversationId,
        ChatAttachment? attachedScan,
        List<ChatMessageModel> messages,
      })?
    >
  >
  loadLatestThread() => Result.guard(
    () async {
      final convo =
          await (_db.select(_db.conversations)
                ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
                ..limit(1))
              .getSingleOrNull();
      if (convo == null) return null;

      final rows =
          await (_db.select(_db.messages)
                ..where((t) => t.conversationId.equals(convo.id))
                ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
              .get();

      ChatAttachment? attachedScan;
      if (convo.attachedScanJson != null &&
          convo.attachedScanJson!.trim().isNotEmpty) {
        try {
          attachedScan = ChatAttachment.fromJson(
            jsonDecode(convo.attachedScanJson!) as Map<String, dynamic>,
          );
        } on Object {
          attachedScan = null;
        }
      }

      return (
        conversationId: convo.id,
        attachedScan: attachedScan,
        messages: rows.map(_rowToModel).toList(),
      );
    },
    onError: (error, _) =>
        StorageFailure('Failed to load conversation history.', cause: error),
  );

  /// Creates or updates a conversation thread header row.
  Future<Result<void>> upsertConversation({
    required String conversationId,
    String? title,
    ChatAttachment? attachedScan,
    bool clearAttachment = false,
  }) => Result.guard(
    () async {
      final now = DateTime.now();
      final existing = await (_db.select(
        _db.conversations,
      )..where((t) => t.id.equals(conversationId))).getSingleOrNull();

      final encodedAttachment = clearAttachment
          ? null
          : attachedScan != null
          ? jsonEncode(attachedScan.toJson())
          : existing?.attachedScanJson;

      final scanId = clearAttachment
          ? null
          : attachedScan?.scanId ?? existing?.attachedScanId;

      await _db
          .into(_db.conversations)
          .insertOnConflictUpdate(
            ConversationsCompanion.insert(
              id: conversationId,
              title: Value(title ?? existing?.title ?? 'Legal research'),
              attachedScanId: Value(scanId),
              attachedScanJson: Value(encodedAttachment),
              createdAt: Value(existing?.createdAt ?? now),
              updatedAt: Value(now),
            ),
          );
    },
    onError: (error, _) =>
        StorageFailure('Failed to save conversation thread.', cause: error),
  );

  /// Inserts or updates a persisted message within [conversationId].
  Future<Result<void>> upsertMessage({
    required String conversationId,
    required ChatMessageModel message,
  }) => Result.guard(
    () async {
      await _db
          .into(_db.messages)
          .insertOnConflictUpdate(
            MessagesCompanion.insert(
              id: message.id,
              conversationId: conversationId,
              isUser: message.isUser,
              content: message.text,
              engineLabel: Value(message.engineLabel),
              confidence: Value(message.confidence?.name),
              citationsJson: Value(
                jsonEncode(
                  message.citations
                      .map(
                        (c) => {
                          'act_code': c.actCode,
                          'section_number': c.sectionNumber,
                          'verified': c.verified,
                          if (c.sectionTitle != null)
                            'section_title': c.sectionTitle,
                        },
                      )
                      .toList(),
                ),
              ),
              reasoningTrail: Value(message.reasoningTrail),
              counterArguments: Value(message.counterArguments),
              droppedUnverifiedCount: Value(message.droppedUnverifiedCount),
              attachmentJson: Value(
                message.attachment == null
                    ? null
                    : jsonEncode(message.attachment!.toJson()),
              ),
              errorMessage: Value(message.errorMessage),
            ),
          );
      await (_db.update(_db.conversations)
            ..where((t) => t.id.equals(conversationId)))
          .write(ConversationsCompanion(updatedAt: Value(DateTime.now())));
    },
    onError: (error, _) =>
        StorageFailure('Failed to save chat message.', cause: error),
  );

  /// Logs a non-PII security or consent audit event locally.
  Future<void> recordAuditEvent({
    required String eventType,
    required String summary,
  }) async {
    try {
      await _db
          .into(_db.auditEvents)
          .insert(
            AuditEventsCompanion.insert(
              id: 'aud_${DateTime.now().microsecondsSinceEpoch}',
              eventType: eventType,
              summary: summary,
            ),
          );
    } on Object {
      // Non-critical diagnostic event; never surface crash.
    }
  }

  /// Removes a single conversation and its messages.
  Future<Result<void>> deleteConversation(String conversationId) =>
      Result.guard(
        () async {
          await _db.transaction(() async {
            await (_db.delete(
              _db.messages,
            )..where((t) => t.conversationId.equals(conversationId))).go();
            await (_db.delete(
              _db.conversations,
            )..where((t) => t.id.equals(conversationId))).go();
          });
        },
        onError: (error, _) =>
            StorageFailure('Failed to delete conversation.', cause: error),
      );

  /// Removes all persisted conversations, messages, analyses, and logs.
  Future<Result<void>> deleteAllChatData() => Result.guard(
    () async {
      await _db.transaction(() async {
        await _db.delete(_db.messages).go();
        await _db.delete(_db.conversations).go();
        await _db.delete(_db.riskFindings).go();
        await _db.delete(_db.contractAnalyses).go();
        await _db.delete(_db.aiExecutionLogs).go();
        await _db.delete(_db.auditEvents).go();
      });
    },
    onError: (error, _) =>
        StorageFailure('Failed to wipe chat history.', cause: error),
  );

  static ChatMessageModel _rowToModel(Message row) {
    final citations = <VerifiedCitation>[];
    try {
      final decoded = jsonDecode(row.citationsJson) as List<dynamic>;
      for (final item in decoded.whereType<Map<String, dynamic>>()) {
        citations.add(
          VerifiedCitation(
            actCode: item['act_code']?.toString() ?? '',
            sectionNumber: item['section_number']?.toString() ?? '',
            verified: item['verified'] == true,
            sectionTitle: item['section_title']?.toString(),
          ),
        );
      }
    } on Object {
      // Keep empty citations if JSON was corrupt.
    }

    ChatAttachment? attachment;
    if (row.attachmentJson != null && row.attachmentJson!.trim().isNotEmpty) {
      try {
        attachment = ChatAttachment.fromJson(
          jsonDecode(row.attachmentJson!) as Map<String, dynamic>,
        );
      } on Object {
        attachment = null;
      }
    }

    final confidence = switch (row.confidence) {
      'high' => ConfidenceLevel.high,
      'medium' => ConfidenceLevel.medium,
      'low' => ConfidenceLevel.low,
      _ => null,
    };

    return ChatMessageModel(
      id: row.id,
      isUser: row.isUser,
      text: row.content,
      engineLabel: row.engineLabel,
      confidence: confidence,
      citations: citations,
      reasoningTrail: row.reasoningTrail,
      counterArguments: row.counterArguments,
      droppedUnverifiedCount: row.droppedUnverifiedCount,
      attachment: attachment,
      errorMessage: row.errorMessage,
    );
  }
}
