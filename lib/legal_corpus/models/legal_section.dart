import 'package:freezed_annotation/freezed_annotation.dart';

part 'legal_section.freezed.dart';
part 'legal_section.g.dart';

/// Immutable domain model representing a verified Indian statutory provision.
@freezed
abstract class LegalSectionModel with _$LegalSectionModel {
  /// Creates a [LegalSectionModel].
  const factory({
    required String actCode,
    required String actName,
    required String sectionNumber,
    required String title,
    required String chapter,
    required String text,
    required String sourceUrl,
    String? legacyMapping,
    String? plainLanguage,
    String? punishment,
    @Default(<String>[]) List<String> relatedSections,
  }) = _LegalSectionModel;

  /// Deserializes a [LegalSectionModel] from JSON.
  factory fromJson(Map<String, dynamic> json) =>
      _$LegalSectionModelFromJson(json);
}
