import 'package:lex_copilot/features/case_file/data/case_file_repository.dart';
import 'package:lex_copilot/features/case_file/data/notification_reminder_service.dart';
import 'package:lex_copilot/features/case_file/domain/case_file_models.dart';
import 'package:lex_copilot/legal_corpus/providers/corpus_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'case_file_providers.g.dart';

/// Provides the local notification reminder scheduler.
@Riverpod(keepAlive: true)
ReminderScheduler reminderScheduler(Ref ref) {
  return LocalNotificationReminderScheduler();
}

/// Provides the encrypted [CaseFileRepository].
@Riverpod(keepAlive: true)
CaseFileRepository caseFileRepository(Ref ref) {
  return CaseFileRepository(ref.watch(appDatabaseProvider));
}

/// Streams all stored case matters.
@riverpod
Stream<List<CaseFileRecord>> casesStream(Ref ref) {
  return ref.watch(caseFileRepositoryProvider).watchCases();
}

/// Streams all upcoming incomplete deadlines across all case matters.
@riverpod
Stream<List<CaseDeadlineRecord>> upcomingDeadlinesStream(Ref ref) {
  return ref.watch(caseFileRepositoryProvider).watchUpcomingDeadlines();
}

/// Streams deadlines for [caseId].
@riverpod
Stream<List<CaseDeadlineRecord>> caseDeadlinesStream(Ref ref, String caseId) {
  return ref.watch(caseFileRepositoryProvider).watchDeadlines(caseId);
}

/// Streams checklist and timeline items for [caseId].
@riverpod
Stream<List<CaseChecklistRecord>> caseItemsStream(Ref ref, String caseId) {
  return ref.watch(caseFileRepositoryProvider).watchChecklistItems(caseId);
}
