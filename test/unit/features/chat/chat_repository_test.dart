import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lex_copilot/ai/pipelines/research_pipeline.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/core/widgets/confidence_badge.dart';
import 'package:lex_copilot/features/chat/data/chat_repository.dart';
import 'package:lex_copilot/features/chat/domain/chat_models.dart';

void main() {
  test('ChatRepository persists threads, citations, attachments, and engine provenance', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = ChatRepository(db);

    const attachment = ChatAttachment(
      scanId: 'scan_1',
      fileName: 'Notice.jpg',
      pageCount: 2,
      documentType: 'Legal Notice',
      extractedText: 'Sample OCR body',
      summary: 'Rent reply notice',
    );

    await repo.upsertConversation(
      conversationId: 'convo_1',
      title: 'Notice.jpg',
      attachedScan: attachment,
    );

    await repo.upsertMessage(
      conversationId: 'convo_1',
      message: const ChatMessageModel(
        id: 'm1',
        isUser: false,
        text: 'Reply under BNS 304 within 15 days.',
        engineLabel: 'Gemma 4 E2B · On-Device',
        confidence: ConfidenceLevel.high,
        citations: [
          VerifiedCitation(
            actCode: 'BNS',
            sectionNumber: '304',
            verified: true,
            sectionTitle: 'Snatching',
          ),
        ],
        reasoningTrail: 'Matched BNS 304 cleanly.',
        counterArguments: 'Facts vary.',
        attachment: attachment,
      ),
    );

    final loaded = await repo.loadLatestThread();
    expect(loaded.isSuccess, isTrue);
    final thread = loaded.valueOrNull!;
    expect(thread.conversationId, 'convo_1');
    expect(thread.attachedScan?.fileName, 'Notice.jpg');
    expect(thread.messages.length, 1);
    expect(thread.messages.first.engineLabel, 'Gemma 4 E2B · On-Device');
    expect(thread.messages.first.citations.first.sectionNumber, '304');
    expect(thread.messages.first.confidence, ConfidenceLevel.high);

    await repo.deleteAllChatData();
    final empty = await repo.loadLatestThread();
    expect(empty.valueOrNull, isNull);
  });
}
