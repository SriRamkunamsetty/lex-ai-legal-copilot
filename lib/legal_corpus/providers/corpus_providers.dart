import 'package:lex_copilot/core/result.dart';
import 'package:lex_copilot/core/storage/app_database.dart';
import 'package:lex_copilot/legal_corpus/models/legal_section.dart';
import 'package:lex_copilot/legal_corpus/packs/knowledge_pack_service.dart';
import 'package:lex_copilot/legal_corpus/repository/legal_corpus_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'corpus_providers.g.dart';

/// Provides the initialized encrypted [AppDatabase].
///
/// Overridden during app startup in `bootstrap` and in tests.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden during bootstrap.',
  );
}

/// Provides the offline [LegalCorpusRepository].
@Riverpod(keepAlive: true)
LegalCorpusRepository legalCorpusRepository(Ref ref) {
  return LegalCorpusRepository(ref.watch(appDatabaseProvider));
}

/// Provides the offline [KnowledgePackService] verifying & hydrating
/// signed Constitution and Central Act Knowledge Packs.
@Riverpod(keepAlive: true)
KnowledgePackService knowledgePackService(Ref ref) {
  return KnowledgePackService(ref.watch(appDatabaseProvider));
}

/// Seeds the offline legal corpus & verified Knowledge Packs on first access.
@Riverpod(keepAlive: true)
Future<Result<int>> corpusSeed(Ref ref) async {
  final baseRes = await ref.watch(legalCorpusRepositoryProvider).ensureSeeded();
  final packRes = await ref
      .watch(knowledgePackServiceProvider)
      .ensureBundledPacksInstalled();
  return baseRes.map((baseCount) => baseCount + (packRes.valueOrNull ?? 0));
}

/// Fetches a single statutory section by [actCode] and [sectionNumber] after
/// ensuring the corpus is seeded.
@riverpod
Future<Result<LegalSectionModel>> legalSection(
  Ref ref,
  String actCode,
  String sectionNumber,
) async {
  await ref.watch(corpusSeedProvider.future);
  return await ref
      .watch(legalCorpusRepositoryProvider)
      .getSection(actCode, sectionNumber);
}

/// Searches the offline statutory corpus for [query] and optional [actCode].
@riverpod
Future<Result<List<LegalSectionModel>>> corpusSearch(
  Ref ref,
  String query, {
  String? actCode,
}) async {
  await ref.watch(corpusSeedProvider.future);
  return await ref
      .watch(legalCorpusRepositoryProvider)
      .search(query, actCode: actCode);
}
