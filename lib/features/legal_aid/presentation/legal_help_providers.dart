import 'package:lex_copilot/features/legal_aid/data/legal_help_directory_source.dart';
import 'package:lex_copilot/features/legal_aid/domain/legal_help_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'legal_help_providers.g.dart';

/// Pluggable directory provider for legal aid, lawyers, and police desks.
@Riverpod(keepAlive: true)
LegalHelpDirectorySource legalHelpDirectorySource(Ref ref) {
  return const PlaceholderLegalHelpDirectorySource();
}

/// Device GPS location provider.
@Riverpod(keepAlive: true)
DeviceLocationService deviceLocationService(Ref ref) {
  return const GeolocatorLocationService();
}

/// Fetches entries for [category] near optional coordinates.
@riverpod
Future<List<LegalHelpEntry>> legalHelpEntries(
  Ref ref,
  LegalHelpCategory category, {
  double? latitude,
  double? longitude,
}) async {
  final res = await ref
      .read(legalHelpDirectorySourceProvider)
      .fetchEntries(
        category: category,
        latitude: latitude,
        longitude: longitude,
      );
  return res.valueOrNull ?? const <LegalHelpEntry>[];
}
