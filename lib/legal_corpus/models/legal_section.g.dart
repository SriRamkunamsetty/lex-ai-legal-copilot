// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LegalSectionModel _$LegalSectionModelFromJson(Map<String, dynamic> json) =>
    _LegalSectionModel(
      actCode: json['actCode'] as String,
      actName: json['actName'] as String,
      sectionNumber: json['sectionNumber'] as String,
      title: json['title'] as String,
      chapter: json['chapter'] as String,
      text: json['text'] as String,
      sourceUrl: json['sourceUrl'] as String,
      legacyMapping: json['legacyMapping'] as String?,
      plainLanguage: json['plainLanguage'] as String?,
      punishment: json['punishment'] as String?,
      relatedSections:
          (json['relatedSections'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$LegalSectionModelToJson(_LegalSectionModel instance) =>
    <String, dynamic>{
      'actCode': instance.actCode,
      'actName': instance.actName,
      'sectionNumber': instance.sectionNumber,
      'title': instance.title,
      'chapter': instance.chapter,
      'text': instance.text,
      'sourceUrl': instance.sourceUrl,
      'legacyMapping': instance.legacyMapping,
      'plainLanguage': instance.plainLanguage,
      'punishment': instance.punishment,
      'relatedSections': instance.relatedSections,
    };
