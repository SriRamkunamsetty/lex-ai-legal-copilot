// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LegalSectionsTable extends LegalSections
    with TableInfo<$LegalSectionsTable, LegalSection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalSectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _actCodeMeta = const VerificationMeta(
    'actCode',
  );
  @override
  late final GeneratedColumn<String> actCode = GeneratedColumn<String>(
    'act_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actNameMeta = const VerificationMeta(
    'actName',
  );
  @override
  late final GeneratedColumn<String> actName = GeneratedColumn<String>(
    'act_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionNumberMeta = const VerificationMeta(
    'sectionNumber',
  );
  @override
  late final GeneratedColumn<String> sectionNumber = GeneratedColumn<String>(
    'section_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<String> chapter = GeneratedColumn<String>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyTextMeta = const VerificationMeta(
    'bodyText',
  );
  @override
  late final GeneratedColumn<String> bodyText = GeneratedColumn<String>(
    'body_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _legacyMappingMeta = const VerificationMeta(
    'legacyMapping',
  );
  @override
  late final GeneratedColumn<String> legacyMapping = GeneratedColumn<String>(
    'legacy_mapping',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plainLanguageMeta = const VerificationMeta(
    'plainLanguage',
  );
  @override
  late final GeneratedColumn<String> plainLanguage = GeneratedColumn<String>(
    'plain_language',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _punishmentMeta = const VerificationMeta(
    'punishment',
  );
  @override
  late final GeneratedColumn<String> punishment = GeneratedColumn<String>(
    'punishment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relatedSectionsJsonMeta =
      const VerificationMeta('relatedSectionsJson');
  @override
  late final GeneratedColumn<String> relatedSectionsJson =
      GeneratedColumn<String>(
        'related_sections_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    actCode,
    actName,
    sectionNumber,
    title,
    chapter,
    bodyText,
    sourceUrl,
    legacyMapping,
    plainLanguage,
    punishment,
    relatedSectionsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_sections';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalSection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('act_code')) {
      context.handle(
        _actCodeMeta,
        actCode.isAcceptableOrUnknown(data['act_code']!, _actCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_actCodeMeta);
    }
    if (data.containsKey('act_name')) {
      context.handle(
        _actNameMeta,
        actName.isAcceptableOrUnknown(data['act_name']!, _actNameMeta),
      );
    } else if (isInserting) {
      context.missing(_actNameMeta);
    }
    if (data.containsKey('section_number')) {
      context.handle(
        _sectionNumberMeta,
        sectionNumber.isAcceptableOrUnknown(
          data['section_number']!,
          _sectionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sectionNumberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('body_text')) {
      context.handle(
        _bodyTextMeta,
        bodyText.isAcceptableOrUnknown(data['body_text']!, _bodyTextMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyTextMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('legacy_mapping')) {
      context.handle(
        _legacyMappingMeta,
        legacyMapping.isAcceptableOrUnknown(
          data['legacy_mapping']!,
          _legacyMappingMeta,
        ),
      );
    }
    if (data.containsKey('plain_language')) {
      context.handle(
        _plainLanguageMeta,
        plainLanguage.isAcceptableOrUnknown(
          data['plain_language']!,
          _plainLanguageMeta,
        ),
      );
    }
    if (data.containsKey('punishment')) {
      context.handle(
        _punishmentMeta,
        punishment.isAcceptableOrUnknown(data['punishment']!, _punishmentMeta),
      );
    }
    if (data.containsKey('related_sections_json')) {
      context.handle(
        _relatedSectionsJsonMeta,
        relatedSectionsJson.isAcceptableOrUnknown(
          data['related_sections_json']!,
          _relatedSectionsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {actCode, sectionNumber};
  @override
  LegalSection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalSection(
      actCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}act_code'],
      )!,
      actName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}act_name'],
      )!,
      sectionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_number'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter'],
      )!,
      bodyText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_text'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      legacyMapping: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legacy_mapping'],
      ),
      plainLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plain_language'],
      ),
      punishment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}punishment'],
      ),
      relatedSectionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_sections_json'],
      )!,
    );
  }

  @override
  $LegalSectionsTable createAlias(String alias) {
    return $LegalSectionsTable(attachedDatabase, alias);
  }
}

class LegalSection extends DataClass implements Insertable<LegalSection> {
  /// Short act code (`BNS`, `BNSS`, `BSA`, etc.).
  final String actCode;

  /// Full act title (`Bharatiya Nyaya Sanhita, 2023`).
  final String actName;

  /// Section identifier (`303`, `304`, `173`, etc.).
  final String sectionNumber;

  /// Official marginal section title.
  final String title;

  /// Chapter heading.
  final String chapter;

  /// Verbatim statutory text.
  final String bodyText;

  /// Official India Code / Gazette source URL.
  final String sourceUrl;

  /// Optional legacy IPC / CrPC / IEA mapping.
  final String? legacyMapping;

  /// Optional curated plain-language explanation.
  final String? plainLanguage;

  /// Optional extracted or curated punishment summary.
  final String? punishment;

  /// JSON-encoded list of related section keys (e.g. `["BNS:303","BNS:309"]`).
  final String relatedSectionsJson;
  const LegalSection({
    required this.actCode,
    required this.actName,
    required this.sectionNumber,
    required this.title,
    required this.chapter,
    required this.bodyText,
    required this.sourceUrl,
    this.legacyMapping,
    this.plainLanguage,
    this.punishment,
    required this.relatedSectionsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['act_code'] = Variable<String>(actCode);
    map['act_name'] = Variable<String>(actName);
    map['section_number'] = Variable<String>(sectionNumber);
    map['title'] = Variable<String>(title);
    map['chapter'] = Variable<String>(chapter);
    map['body_text'] = Variable<String>(bodyText);
    map['source_url'] = Variable<String>(sourceUrl);
    if (!nullToAbsent || legacyMapping != null) {
      map['legacy_mapping'] = Variable<String>(legacyMapping);
    }
    if (!nullToAbsent || plainLanguage != null) {
      map['plain_language'] = Variable<String>(plainLanguage);
    }
    if (!nullToAbsent || punishment != null) {
      map['punishment'] = Variable<String>(punishment);
    }
    map['related_sections_json'] = Variable<String>(relatedSectionsJson);
    return map;
  }

  LegalSectionsCompanion toCompanion(bool nullToAbsent) {
    return LegalSectionsCompanion(
      actCode: Value(actCode),
      actName: Value(actName),
      sectionNumber: Value(sectionNumber),
      title: Value(title),
      chapter: Value(chapter),
      bodyText: Value(bodyText),
      sourceUrl: Value(sourceUrl),
      legacyMapping: legacyMapping == null && nullToAbsent
          ? const Value.absent()
          : Value(legacyMapping),
      plainLanguage: plainLanguage == null && nullToAbsent
          ? const Value.absent()
          : Value(plainLanguage),
      punishment: punishment == null && nullToAbsent
          ? const Value.absent()
          : Value(punishment),
      relatedSectionsJson: Value(relatedSectionsJson),
    );
  }

  factory LegalSection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalSection(
      actCode: serializer.fromJson<String>(json['actCode']),
      actName: serializer.fromJson<String>(json['actName']),
      sectionNumber: serializer.fromJson<String>(json['sectionNumber']),
      title: serializer.fromJson<String>(json['title']),
      chapter: serializer.fromJson<String>(json['chapter']),
      bodyText: serializer.fromJson<String>(json['bodyText']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      legacyMapping: serializer.fromJson<String?>(json['legacyMapping']),
      plainLanguage: serializer.fromJson<String?>(json['plainLanguage']),
      punishment: serializer.fromJson<String?>(json['punishment']),
      relatedSectionsJson: serializer.fromJson<String>(
        json['relatedSectionsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'actCode': serializer.toJson<String>(actCode),
      'actName': serializer.toJson<String>(actName),
      'sectionNumber': serializer.toJson<String>(sectionNumber),
      'title': serializer.toJson<String>(title),
      'chapter': serializer.toJson<String>(chapter),
      'bodyText': serializer.toJson<String>(bodyText),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'legacyMapping': serializer.toJson<String?>(legacyMapping),
      'plainLanguage': serializer.toJson<String?>(plainLanguage),
      'punishment': serializer.toJson<String?>(punishment),
      'relatedSectionsJson': serializer.toJson<String>(relatedSectionsJson),
    };
  }

  LegalSection copyWith({
    String? actCode,
    String? actName,
    String? sectionNumber,
    String? title,
    String? chapter,
    String? bodyText,
    String? sourceUrl,
    Value<String?> legacyMapping = const Value.absent(),
    Value<String?> plainLanguage = const Value.absent(),
    Value<String?> punishment = const Value.absent(),
    String? relatedSectionsJson,
  }) => LegalSection(
    actCode: actCode ?? this.actCode,
    actName: actName ?? this.actName,
    sectionNumber: sectionNumber ?? this.sectionNumber,
    title: title ?? this.title,
    chapter: chapter ?? this.chapter,
    bodyText: bodyText ?? this.bodyText,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    legacyMapping: legacyMapping.present
        ? legacyMapping.value
        : this.legacyMapping,
    plainLanguage: plainLanguage.present
        ? plainLanguage.value
        : this.plainLanguage,
    punishment: punishment.present ? punishment.value : this.punishment,
    relatedSectionsJson: relatedSectionsJson ?? this.relatedSectionsJson,
  );
  LegalSection copyWithCompanion(LegalSectionsCompanion data) {
    return LegalSection(
      actCode: data.actCode.present ? data.actCode.value : this.actCode,
      actName: data.actName.present ? data.actName.value : this.actName,
      sectionNumber: data.sectionNumber.present
          ? data.sectionNumber.value
          : this.sectionNumber,
      title: data.title.present ? data.title.value : this.title,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      bodyText: data.bodyText.present ? data.bodyText.value : this.bodyText,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      legacyMapping: data.legacyMapping.present
          ? data.legacyMapping.value
          : this.legacyMapping,
      plainLanguage: data.plainLanguage.present
          ? data.plainLanguage.value
          : this.plainLanguage,
      punishment: data.punishment.present
          ? data.punishment.value
          : this.punishment,
      relatedSectionsJson: data.relatedSectionsJson.present
          ? data.relatedSectionsJson.value
          : this.relatedSectionsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalSection(')
          ..write('actCode: $actCode, ')
          ..write('actName: $actName, ')
          ..write('sectionNumber: $sectionNumber, ')
          ..write('title: $title, ')
          ..write('chapter: $chapter, ')
          ..write('bodyText: $bodyText, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('legacyMapping: $legacyMapping, ')
          ..write('plainLanguage: $plainLanguage, ')
          ..write('punishment: $punishment, ')
          ..write('relatedSectionsJson: $relatedSectionsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    actCode,
    actName,
    sectionNumber,
    title,
    chapter,
    bodyText,
    sourceUrl,
    legacyMapping,
    plainLanguage,
    punishment,
    relatedSectionsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalSection &&
          other.actCode == this.actCode &&
          other.actName == this.actName &&
          other.sectionNumber == this.sectionNumber &&
          other.title == this.title &&
          other.chapter == this.chapter &&
          other.bodyText == this.bodyText &&
          other.sourceUrl == this.sourceUrl &&
          other.legacyMapping == this.legacyMapping &&
          other.plainLanguage == this.plainLanguage &&
          other.punishment == this.punishment &&
          other.relatedSectionsJson == this.relatedSectionsJson);
}

class LegalSectionsCompanion extends UpdateCompanion<LegalSection> {
  final Value<String> actCode;
  final Value<String> actName;
  final Value<String> sectionNumber;
  final Value<String> title;
  final Value<String> chapter;
  final Value<String> bodyText;
  final Value<String> sourceUrl;
  final Value<String?> legacyMapping;
  final Value<String?> plainLanguage;
  final Value<String?> punishment;
  final Value<String> relatedSectionsJson;
  final Value<int> rowid;
  const LegalSectionsCompanion({
    this.actCode = const Value.absent(),
    this.actName = const Value.absent(),
    this.sectionNumber = const Value.absent(),
    this.title = const Value.absent(),
    this.chapter = const Value.absent(),
    this.bodyText = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.legacyMapping = const Value.absent(),
    this.plainLanguage = const Value.absent(),
    this.punishment = const Value.absent(),
    this.relatedSectionsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalSectionsCompanion.insert({
    required String actCode,
    required String actName,
    required String sectionNumber,
    required String title,
    required String chapter,
    required String bodyText,
    required String sourceUrl,
    this.legacyMapping = const Value.absent(),
    this.plainLanguage = const Value.absent(),
    this.punishment = const Value.absent(),
    this.relatedSectionsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : actCode = Value(actCode),
       actName = Value(actName),
       sectionNumber = Value(sectionNumber),
       title = Value(title),
       chapter = Value(chapter),
       bodyText = Value(bodyText),
       sourceUrl = Value(sourceUrl);
  static Insertable<LegalSection> custom({
    Expression<String>? actCode,
    Expression<String>? actName,
    Expression<String>? sectionNumber,
    Expression<String>? title,
    Expression<String>? chapter,
    Expression<String>? bodyText,
    Expression<String>? sourceUrl,
    Expression<String>? legacyMapping,
    Expression<String>? plainLanguage,
    Expression<String>? punishment,
    Expression<String>? relatedSectionsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (actCode != null) 'act_code': actCode,
      if (actName != null) 'act_name': actName,
      if (sectionNumber != null) 'section_number': sectionNumber,
      if (title != null) 'title': title,
      if (chapter != null) 'chapter': chapter,
      if (bodyText != null) 'body_text': bodyText,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (legacyMapping != null) 'legacy_mapping': legacyMapping,
      if (plainLanguage != null) 'plain_language': plainLanguage,
      if (punishment != null) 'punishment': punishment,
      if (relatedSectionsJson != null)
        'related_sections_json': relatedSectionsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalSectionsCompanion copyWith({
    Value<String>? actCode,
    Value<String>? actName,
    Value<String>? sectionNumber,
    Value<String>? title,
    Value<String>? chapter,
    Value<String>? bodyText,
    Value<String>? sourceUrl,
    Value<String?>? legacyMapping,
    Value<String?>? plainLanguage,
    Value<String?>? punishment,
    Value<String>? relatedSectionsJson,
    Value<int>? rowid,
  }) {
    return LegalSectionsCompanion(
      actCode: actCode ?? this.actCode,
      actName: actName ?? this.actName,
      sectionNumber: sectionNumber ?? this.sectionNumber,
      title: title ?? this.title,
      chapter: chapter ?? this.chapter,
      bodyText: bodyText ?? this.bodyText,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      legacyMapping: legacyMapping ?? this.legacyMapping,
      plainLanguage: plainLanguage ?? this.plainLanguage,
      punishment: punishment ?? this.punishment,
      relatedSectionsJson: relatedSectionsJson ?? this.relatedSectionsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (actCode.present) {
      map['act_code'] = Variable<String>(actCode.value);
    }
    if (actName.present) {
      map['act_name'] = Variable<String>(actName.value);
    }
    if (sectionNumber.present) {
      map['section_number'] = Variable<String>(sectionNumber.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<String>(chapter.value);
    }
    if (bodyText.present) {
      map['body_text'] = Variable<String>(bodyText.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (legacyMapping.present) {
      map['legacy_mapping'] = Variable<String>(legacyMapping.value);
    }
    if (plainLanguage.present) {
      map['plain_language'] = Variable<String>(plainLanguage.value);
    }
    if (punishment.present) {
      map['punishment'] = Variable<String>(punishment.value);
    }
    if (relatedSectionsJson.present) {
      map['related_sections_json'] = Variable<String>(
        relatedSectionsJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalSectionsCompanion(')
          ..write('actCode: $actCode, ')
          ..write('actName: $actName, ')
          ..write('sectionNumber: $sectionNumber, ')
          ..write('title: $title, ')
          ..write('chapter: $chapter, ')
          ..write('bodyText: $bodyText, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('legacyMapping: $legacyMapping, ')
          ..write('plainLanguage: $plainLanguage, ')
          ..write('punishment: $punishment, ')
          ..write('relatedSectionsJson: $relatedSectionsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _actCodeMeta = const VerificationMeta(
    'actCode',
  );
  @override
  late final GeneratedColumn<String> actCode = GeneratedColumn<String>(
    'act_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionNumberMeta = const VerificationMeta(
    'sectionNumber',
  );
  @override
  late final GeneratedColumn<String> sectionNumber = GeneratedColumn<String>(
    'section_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    actCode,
    sectionNumber,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('act_code')) {
      context.handle(
        _actCodeMeta,
        actCode.isAcceptableOrUnknown(data['act_code']!, _actCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_actCodeMeta);
    }
    if (data.containsKey('section_number')) {
      context.handle(
        _sectionNumberMeta,
        sectionNumber.isAcceptableOrUnknown(
          data['section_number']!,
          _sectionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sectionNumberMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      actCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}act_code'],
      )!,
      sectionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_number'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  /// Auto-incrementing row ID.
  final int id;

  /// Act code of the bookmarked section.
  final String actCode;

  /// Section number of the bookmarked section.
  final String sectionNumber;

  /// Optional user note.
  final String? note;

  /// Timestamp when bookmarked.
  final DateTime createdAt;
  const Bookmark({
    required this.id,
    required this.actCode,
    required this.sectionNumber,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['act_code'] = Variable<String>(actCode);
    map['section_number'] = Variable<String>(sectionNumber);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      actCode: Value(actCode),
      sectionNumber: Value(sectionNumber),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      id: serializer.fromJson<int>(json['id']),
      actCode: serializer.fromJson<String>(json['actCode']),
      sectionNumber: serializer.fromJson<String>(json['sectionNumber']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'actCode': serializer.toJson<String>(actCode),
      'sectionNumber': serializer.toJson<String>(sectionNumber),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Bookmark copyWith({
    int? id,
    String? actCode,
    String? sectionNumber,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Bookmark(
    id: id ?? this.id,
    actCode: actCode ?? this.actCode,
    sectionNumber: sectionNumber ?? this.sectionNumber,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      id: data.id.present ? data.id.value : this.id,
      actCode: data.actCode.present ? data.actCode.value : this.actCode,
      sectionNumber: data.sectionNumber.present
          ? data.sectionNumber.value
          : this.sectionNumber,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('actCode: $actCode, ')
          ..write('sectionNumber: $sectionNumber, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, actCode, sectionNumber, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.actCode == this.actCode &&
          other.sectionNumber == this.sectionNumber &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<int> id;
  final Value<String> actCode;
  final Value<String> sectionNumber;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.actCode = const Value.absent(),
    this.sectionNumber = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    required String actCode,
    required String sectionNumber,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : actCode = Value(actCode),
       sectionNumber = Value(sectionNumber);
  static Insertable<Bookmark> custom({
    Expression<int>? id,
    Expression<String>? actCode,
    Expression<String>? sectionNumber,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (actCode != null) 'act_code': actCode,
      if (sectionNumber != null) 'section_number': sectionNumber,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BookmarksCompanion copyWith({
    Value<int>? id,
    Value<String>? actCode,
    Value<String>? sectionNumber,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      actCode: actCode ?? this.actCode,
      sectionNumber: sectionNumber ?? this.sectionNumber,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (actCode.present) {
      map['act_code'] = Variable<String>(actCode.value);
    }
    if (sectionNumber.present) {
      map['section_number'] = Variable<String>(sectionNumber.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('actCode: $actCode, ')
          ..write('sectionNumber: $sectionNumber, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SavedScansTable extends SavedScans
    with TableInfo<$SavedScansTable, SavedScan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedScansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ocrTextMeta = const VerificationMeta(
    'ocrText',
  );
  @override
  late final GeneratedColumn<String> ocrText = GeneratedColumn<String>(
    'ocr_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _summaryJsonMeta = const VerificationMeta(
    'summaryJson',
  );
  @override
  late final GeneratedColumn<String> summaryJson = GeneratedColumn<String>(
    'summary_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    filePath,
    ocrText,
    summaryJson,
    pageCount,
    createdAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_scans';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedScan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('ocr_text')) {
      context.handle(
        _ocrTextMeta,
        ocrText.isAcceptableOrUnknown(data['ocr_text']!, _ocrTextMeta),
      );
    }
    if (data.containsKey('summary_json')) {
      context.handle(
        _summaryJsonMeta,
        summaryJson.isAcceptableOrUnknown(
          data['summary_json']!,
          _summaryJsonMeta,
        ),
      );
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedScan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedScan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      ocrText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_text'],
      )!,
      summaryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_json'],
      )!,
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $SavedScansTable createAlias(String alias) {
    return $SavedScansTable(attachedDatabase, alias);
  }
}

class SavedScan extends DataClass implements Insertable<SavedScan> {
  /// Stable UUID or timestamp ID.
  final String id;

  /// Display file/document title.
  final String title;

  /// Encrypted or app-private local file path.
  final String filePath;

  /// Extracted OCR text.
  final String ocrText;

  /// JSON-encoded structured summary fields.
  final String summaryJson;

  /// Number of scanned pages.
  final int pageCount;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Optional auto-delete expiration timestamp.
  final DateTime? expiresAt;
  const SavedScan({
    required this.id,
    required this.title,
    required this.filePath,
    required this.ocrText,
    required this.summaryJson,
    required this.pageCount,
    required this.createdAt,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['file_path'] = Variable<String>(filePath);
    map['ocr_text'] = Variable<String>(ocrText);
    map['summary_json'] = Variable<String>(summaryJson);
    map['page_count'] = Variable<int>(pageCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  SavedScansCompanion toCompanion(bool nullToAbsent) {
    return SavedScansCompanion(
      id: Value(id),
      title: Value(title),
      filePath: Value(filePath),
      ocrText: Value(ocrText),
      summaryJson: Value(summaryJson),
      pageCount: Value(pageCount),
      createdAt: Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory SavedScan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedScan(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      filePath: serializer.fromJson<String>(json['filePath']),
      ocrText: serializer.fromJson<String>(json['ocrText']),
      summaryJson: serializer.fromJson<String>(json['summaryJson']),
      pageCount: serializer.fromJson<int>(json['pageCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'filePath': serializer.toJson<String>(filePath),
      'ocrText': serializer.toJson<String>(ocrText),
      'summaryJson': serializer.toJson<String>(summaryJson),
      'pageCount': serializer.toJson<int>(pageCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  SavedScan copyWith({
    String? id,
    String? title,
    String? filePath,
    String? ocrText,
    String? summaryJson,
    int? pageCount,
    DateTime? createdAt,
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => SavedScan(
    id: id ?? this.id,
    title: title ?? this.title,
    filePath: filePath ?? this.filePath,
    ocrText: ocrText ?? this.ocrText,
    summaryJson: summaryJson ?? this.summaryJson,
    pageCount: pageCount ?? this.pageCount,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  SavedScan copyWithCompanion(SavedScansCompanion data) {
    return SavedScan(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      ocrText: data.ocrText.present ? data.ocrText.value : this.ocrText,
      summaryJson: data.summaryJson.present
          ? data.summaryJson.value
          : this.summaryJson,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedScan(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('ocrText: $ocrText, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('pageCount: $pageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    filePath,
    ocrText,
    summaryJson,
    pageCount,
    createdAt,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedScan &&
          other.id == this.id &&
          other.title == this.title &&
          other.filePath == this.filePath &&
          other.ocrText == this.ocrText &&
          other.summaryJson == this.summaryJson &&
          other.pageCount == this.pageCount &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt);
}

class SavedScansCompanion extends UpdateCompanion<SavedScan> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> filePath;
  final Value<String> ocrText;
  final Value<String> summaryJson;
  final Value<int> pageCount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const SavedScansCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.filePath = const Value.absent(),
    this.ocrText = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedScansCompanion.insert({
    required String id,
    required String title,
    required String filePath,
    this.ocrText = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       filePath = Value(filePath);
  static Insertable<SavedScan> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? filePath,
    Expression<String>? ocrText,
    Expression<String>? summaryJson,
    Expression<int>? pageCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (filePath != null) 'file_path': filePath,
      if (ocrText != null) 'ocr_text': ocrText,
      if (summaryJson != null) 'summary_json': summaryJson,
      if (pageCount != null) 'page_count': pageCount,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedScansCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? filePath,
    Value<String>? ocrText,
    Value<String>? summaryJson,
    Value<int>? pageCount,
    Value<DateTime>? createdAt,
    Value<DateTime?>? expiresAt,
    Value<int>? rowid,
  }) {
    return SavedScansCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      ocrText: ocrText ?? this.ocrText,
      summaryJson: summaryJson ?? this.summaryJson,
      pageCount: pageCount ?? this.pageCount,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (ocrText.present) {
      map['ocr_text'] = Variable<String>(ocrText.value);
    }
    if (summaryJson.present) {
      map['summary_json'] = Variable<String>(summaryJson.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedScansCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('ocrText: $ocrText, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('pageCount: $pageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedDraftsTable extends SavedDrafts
    with TableInfo<$SavedDraftsTable, SavedDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateTypeMeta = const VerificationMeta(
    'templateType',
  );
  @override
  late final GeneratedColumn<String> templateType = GeneratedColumn<String>(
    'template_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldsJsonMeta = const VerificationMeta(
    'fieldsJson',
  );
  @override
  late final GeneratedColumn<String> fieldsJson = GeneratedColumn<String>(
    'fields_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateType,
    title,
    content,
    fieldsJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_type')) {
      context.handle(
        _templateTypeMeta,
        templateType.isAcceptableOrUnknown(
          data['template_type']!,
          _templateTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('fields_json')) {
      context.handle(
        _fieldsJsonMeta,
        fieldsJson.isAcceptableOrUnknown(data['fields_json']!, _fieldsJsonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedDraft(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      fieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fields_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SavedDraftsTable createAlias(String alias) {
    return $SavedDraftsTable(attachedDatabase, alias);
  }
}

class SavedDraft extends DataClass implements Insertable<SavedDraft> {
  /// Stable draft ID.
  final String id;

  /// Template identifier (`rent_agreement`, `nda`, `legal_notice`, etc.).
  final String templateType;

  /// User-facing draft title.
  final String title;

  /// Draft body text with `[placeholder]` markers if incomplete.
  final String content;

  /// JSON-encoded field values.
  final String fieldsJson;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last update timestamp.
  final DateTime updatedAt;
  const SavedDraft({
    required this.id,
    required this.templateType,
    required this.title,
    required this.content,
    required this.fieldsJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_type'] = Variable<String>(templateType);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['fields_json'] = Variable<String>(fieldsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SavedDraftsCompanion toCompanion(bool nullToAbsent) {
    return SavedDraftsCompanion(
      id: Value(id),
      templateType: Value(templateType),
      title: Value(title),
      content: Value(content),
      fieldsJson: Value(fieldsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SavedDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedDraft(
      id: serializer.fromJson<String>(json['id']),
      templateType: serializer.fromJson<String>(json['templateType']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      fieldsJson: serializer.fromJson<String>(json['fieldsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateType': serializer.toJson<String>(templateType),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'fieldsJson': serializer.toJson<String>(fieldsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SavedDraft copyWith({
    String? id,
    String? templateType,
    String? title,
    String? content,
    String? fieldsJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SavedDraft(
    id: id ?? this.id,
    templateType: templateType ?? this.templateType,
    title: title ?? this.title,
    content: content ?? this.content,
    fieldsJson: fieldsJson ?? this.fieldsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SavedDraft copyWithCompanion(SavedDraftsCompanion data) {
    return SavedDraft(
      id: data.id.present ? data.id.value : this.id,
      templateType: data.templateType.present
          ? data.templateType.value
          : this.templateType,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      fieldsJson: data.fieldsJson.present
          ? data.fieldsJson.value
          : this.fieldsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedDraft(')
          ..write('id: $id, ')
          ..write('templateType: $templateType, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('fieldsJson: $fieldsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateType,
    title,
    content,
    fieldsJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedDraft &&
          other.id == this.id &&
          other.templateType == this.templateType &&
          other.title == this.title &&
          other.content == this.content &&
          other.fieldsJson == this.fieldsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SavedDraftsCompanion extends UpdateCompanion<SavedDraft> {
  final Value<String> id;
  final Value<String> templateType;
  final Value<String> title;
  final Value<String> content;
  final Value<String> fieldsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SavedDraftsCompanion({
    this.id = const Value.absent(),
    this.templateType = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.fieldsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedDraftsCompanion.insert({
    required String id,
    required String templateType,
    required String title,
    required String content,
    this.fieldsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       templateType = Value(templateType),
       title = Value(title),
       content = Value(content);
  static Insertable<SavedDraft> custom({
    Expression<String>? id,
    Expression<String>? templateType,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? fieldsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateType != null) 'template_type': templateType,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (fieldsJson != null) 'fields_json': fieldsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedDraftsCompanion copyWith({
    Value<String>? id,
    Value<String>? templateType,
    Value<String>? title,
    Value<String>? content,
    Value<String>? fieldsJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SavedDraftsCompanion(
      id: id ?? this.id,
      templateType: templateType ?? this.templateType,
      title: title ?? this.title,
      content: content ?? this.content,
      fieldsJson: fieldsJson ?? this.fieldsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateType.present) {
      map['template_type'] = Variable<String>(templateType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (fieldsJson.present) {
      map['fields_json'] = Variable<String>(fieldsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedDraftsCompanion(')
          ..write('id: $id, ')
          ..write('templateType: $templateType, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('fieldsJson: $fieldsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityHistoryTable extends ActivityHistory
    with TableInfo<$ActivityHistoryTable, ActivityHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeMeta = const VerificationMeta('route');
  @override
  late final GeneratedColumn<String> route = GeneratedColumn<String>(
    'route',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    title,
    subtitle,
    route,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    } else if (isInserting) {
      context.missing(_subtitleMeta);
    }
    if (data.containsKey('route')) {
      context.handle(
        _routeMeta,
        route.isAcceptableOrUnknown(data['route']!, _routeMeta),
      );
    } else if (isInserting) {
      context.missing(_routeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      )!,
      route: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivityHistoryTable createAlias(String alias) {
    return $ActivityHistoryTable(attachedDatabase, alias);
  }
}

class ActivityHistoryData extends DataClass
    implements Insertable<ActivityHistoryData> {
  /// Auto-incrementing row ID.
  final int id;

  /// Activity category (`section_view`, `chat`, `scan`, `incident`, `contract`, `draft`).
  final String kind;

  /// Primary history title.
  final String title;

  /// Secondary descriptor.
  final String subtitle;

  /// In-app GoRouter location to reopen the item.
  final String route;

  /// Event timestamp.
  final DateTime createdAt;
  const ActivityHistoryData({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    map['subtitle'] = Variable<String>(subtitle);
    map['route'] = Variable<String>(route);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivityHistoryCompanion toCompanion(bool nullToAbsent) {
    return ActivityHistoryCompanion(
      id: Value(id),
      kind: Value(kind),
      title: Value(title),
      subtitle: Value(subtitle),
      route: Value(route),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityHistoryData(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String>(json['subtitle']),
      route: serializer.fromJson<String>(json['route']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String>(subtitle),
      'route': serializer.toJson<String>(route),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivityHistoryData copyWith({
    int? id,
    String? kind,
    String? title,
    String? subtitle,
    String? route,
    DateTime? createdAt,
  }) => ActivityHistoryData(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    route: route ?? this.route,
    createdAt: createdAt ?? this.createdAt,
  );
  ActivityHistoryData copyWithCompanion(ActivityHistoryCompanion data) {
    return ActivityHistoryData(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      route: data.route.present ? data.route.value : this.route,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityHistoryData(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('route: $route, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, title, subtitle, route, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityHistoryData &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.route == this.route &&
          other.createdAt == this.createdAt);
}

class ActivityHistoryCompanion extends UpdateCompanion<ActivityHistoryData> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String> title;
  final Value<String> subtitle;
  final Value<String> route;
  final Value<DateTime> createdAt;
  const ActivityHistoryCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.route = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ActivityHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required String title,
    required String subtitle,
    required String route,
    this.createdAt = const Value.absent(),
  }) : kind = Value(kind),
       title = Value(title),
       subtitle = Value(subtitle),
       route = Value(route);
  static Insertable<ActivityHistoryData> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? route,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (route != null) 'route': route,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ActivityHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String>? title,
    Value<String>? subtitle,
    Value<String>? route,
    Value<DateTime>? createdAt,
  }) {
    return ActivityHistoryCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      route: route ?? this.route,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (route.present) {
      map['route'] = Variable<String>(route.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityHistoryCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('route: $route, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CaseFilesTable extends CaseFiles
    with TableInfo<$CaseFilesTable, CaseFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaseFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Open'),
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    category,
    status,
    summary,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'case_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaseFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaseFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaseFile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CaseFilesTable createAlias(String alias) {
    return $CaseFilesTable(attachedDatabase, alias);
  }
}

class CaseFile extends DataClass implements Insertable<CaseFile> {
  /// Stable case ID.
  final String id;

  /// Short matter title (e.g. `Security Deposit Dispute`).
  final String title;

  /// Category (`Civil`, `Criminal`, `Consumer`, `Tenancy`, `Employment`).
  final String category;

  /// Current case status (`Open`, `Notice sent`, `In progress`, `Closed`).
  final String status;

  /// Plain-language matter summary / facts.
  final String summary;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last updated timestamp.
  final DateTime updatedAt;
  const CaseFile({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.summary,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['status'] = Variable<String>(status);
    map['summary'] = Variable<String>(summary);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CaseFilesCompanion toCompanion(bool nullToAbsent) {
    return CaseFilesCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      status: Value(status),
      summary: Value(summary),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CaseFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaseFile(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      status: serializer.fromJson<String>(json['status']),
      summary: serializer.fromJson<String>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'status': serializer.toJson<String>(status),
      'summary': serializer.toJson<String>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CaseFile copyWith({
    String? id,
    String? title,
    String? category,
    String? status,
    String? summary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CaseFile(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    status: status ?? this.status,
    summary: summary ?? this.summary,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CaseFile copyWithCompanion(CaseFilesCompanion data) {
    return CaseFile(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaseFile(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, category, status, summary, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaseFile &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.status == this.status &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CaseFilesCompanion extends UpdateCompanion<CaseFile> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> category;
  final Value<String> status;
  final Value<String> summary;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CaseFilesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CaseFilesCompanion.insert({
    required String id,
    required String title,
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<CaseFile> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? status,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CaseFilesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? category,
    Value<String>? status,
    Value<String>? summary,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CaseFilesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      status: status ?? this.status,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaseFilesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CaseDeadlinesTable extends CaseDeadlines
    with TableInfo<$CaseDeadlinesTable, CaseDeadline> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaseDeadlinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<String> caseId = GeneratedColumn<String>(
    'case_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderScheduledMeta = const VerificationMeta(
    'reminderScheduled',
  );
  @override
  late final GeneratedColumn<bool> reminderScheduled = GeneratedColumn<bool>(
    'reminder_scheduled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_scheduled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    caseId,
    title,
    dueAt,
    reminderScheduled,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'case_deadlines';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaseDeadline> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('reminder_scheduled')) {
      context.handle(
        _reminderScheduledMeta,
        reminderScheduled.isAcceptableOrUnknown(
          data['reminder_scheduled']!,
          _reminderScheduledMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaseDeadline map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaseDeadline(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}case_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      reminderScheduled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_scheduled'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
    );
  }

  @override
  $CaseDeadlinesTable createAlias(String alias) {
    return $CaseDeadlinesTable(attachedDatabase, alias);
  }
}

class CaseDeadline extends DataClass implements Insertable<CaseDeadline> {
  /// Auto-incrementing row ID.
  final int id;

  /// Owning case ID.
  final String caseId;

  /// Deadline description (e.g. `Reply to 30-day landlord notice`).
  final String title;

  /// Due date/time.
  final DateTime dueAt;

  /// Whether a local notification has been scheduled.
  final bool reminderScheduled;

  /// Whether the deadline has been completed.
  final bool completed;
  const CaseDeadline({
    required this.id,
    required this.caseId,
    required this.title,
    required this.dueAt,
    required this.reminderScheduled,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['case_id'] = Variable<String>(caseId);
    map['title'] = Variable<String>(title);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['reminder_scheduled'] = Variable<bool>(reminderScheduled);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  CaseDeadlinesCompanion toCompanion(bool nullToAbsent) {
    return CaseDeadlinesCompanion(
      id: Value(id),
      caseId: Value(caseId),
      title: Value(title),
      dueAt: Value(dueAt),
      reminderScheduled: Value(reminderScheduled),
      completed: Value(completed),
    );
  }

  factory CaseDeadline.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaseDeadline(
      id: serializer.fromJson<int>(json['id']),
      caseId: serializer.fromJson<String>(json['caseId']),
      title: serializer.fromJson<String>(json['title']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      reminderScheduled: serializer.fromJson<bool>(json['reminderScheduled']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caseId': serializer.toJson<String>(caseId),
      'title': serializer.toJson<String>(title),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'reminderScheduled': serializer.toJson<bool>(reminderScheduled),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  CaseDeadline copyWith({
    int? id,
    String? caseId,
    String? title,
    DateTime? dueAt,
    bool? reminderScheduled,
    bool? completed,
  }) => CaseDeadline(
    id: id ?? this.id,
    caseId: caseId ?? this.caseId,
    title: title ?? this.title,
    dueAt: dueAt ?? this.dueAt,
    reminderScheduled: reminderScheduled ?? this.reminderScheduled,
    completed: completed ?? this.completed,
  );
  CaseDeadline copyWithCompanion(CaseDeadlinesCompanion data) {
    return CaseDeadline(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      title: data.title.present ? data.title.value : this.title,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      reminderScheduled: data.reminderScheduled.present
          ? data.reminderScheduled.value
          : this.reminderScheduled,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaseDeadline(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('reminderScheduled: $reminderScheduled, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, caseId, title, dueAt, reminderScheduled, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaseDeadline &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.title == this.title &&
          other.dueAt == this.dueAt &&
          other.reminderScheduled == this.reminderScheduled &&
          other.completed == this.completed);
}

class CaseDeadlinesCompanion extends UpdateCompanion<CaseDeadline> {
  final Value<int> id;
  final Value<String> caseId;
  final Value<String> title;
  final Value<DateTime> dueAt;
  final Value<bool> reminderScheduled;
  final Value<bool> completed;
  const CaseDeadlinesCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.title = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.reminderScheduled = const Value.absent(),
    this.completed = const Value.absent(),
  });
  CaseDeadlinesCompanion.insert({
    this.id = const Value.absent(),
    required String caseId,
    required String title,
    required DateTime dueAt,
    this.reminderScheduled = const Value.absent(),
    this.completed = const Value.absent(),
  }) : caseId = Value(caseId),
       title = Value(title),
       dueAt = Value(dueAt);
  static Insertable<CaseDeadline> custom({
    Expression<int>? id,
    Expression<String>? caseId,
    Expression<String>? title,
    Expression<DateTime>? dueAt,
    Expression<bool>? reminderScheduled,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (title != null) 'title': title,
      if (dueAt != null) 'due_at': dueAt,
      if (reminderScheduled != null) 'reminder_scheduled': reminderScheduled,
      if (completed != null) 'completed': completed,
    });
  }

  CaseDeadlinesCompanion copyWith({
    Value<int>? id,
    Value<String>? caseId,
    Value<String>? title,
    Value<DateTime>? dueAt,
    Value<bool>? reminderScheduled,
    Value<bool>? completed,
  }) {
    return CaseDeadlinesCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      reminderScheduled: reminderScheduled ?? this.reminderScheduled,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<String>(caseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (reminderScheduled.present) {
      map['reminder_scheduled'] = Variable<bool>(reminderScheduled.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaseDeadlinesCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('reminderScheduled: $reminderScheduled, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

class $CaseChecklistItemsTable extends CaseChecklistItems
    with TableInfo<$CaseChecklistItemsTable, CaseChecklistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaseChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<String> caseId = GeneratedColumn<String>(
    'case_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('checklist'),
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    caseId,
    title,
    kind,
    referenceId,
    done,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'case_checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaseChecklistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaseChecklistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaseChecklistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}case_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      ),
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CaseChecklistItemsTable createAlias(String alias) {
    return $CaseChecklistItemsTable(attachedDatabase, alias);
  }
}

class CaseChecklistItem extends DataClass
    implements Insertable<CaseChecklistItem> {
  /// Auto-incrementing row ID.
  final int id;

  /// Owning case ID.
  final String caseId;

  /// Step or attached artifact title.
  final String title;

  /// Item category (`checklist`, `timeline`, `scan`, `draft`, `chat`).
  final String kind;

  /// Optional linked resource route or ID.
  final String? referenceId;

  /// Completion state.
  final bool done;

  /// Creation timestamp.
  final DateTime createdAt;
  const CaseChecklistItem({
    required this.id,
    required this.caseId,
    required this.title,
    required this.kind,
    this.referenceId,
    required this.done,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['case_id'] = Variable<String>(caseId);
    map['title'] = Variable<String>(title);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    map['done'] = Variable<bool>(done);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CaseChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return CaseChecklistItemsCompanion(
      id: Value(id),
      caseId: Value(caseId),
      title: Value(title),
      kind: Value(kind),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      done: Value(done),
      createdAt: Value(createdAt),
    );
  }

  factory CaseChecklistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaseChecklistItem(
      id: serializer.fromJson<int>(json['id']),
      caseId: serializer.fromJson<String>(json['caseId']),
      title: serializer.fromJson<String>(json['title']),
      kind: serializer.fromJson<String>(json['kind']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      done: serializer.fromJson<bool>(json['done']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caseId': serializer.toJson<String>(caseId),
      'title': serializer.toJson<String>(title),
      'kind': serializer.toJson<String>(kind),
      'referenceId': serializer.toJson<String?>(referenceId),
      'done': serializer.toJson<bool>(done),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CaseChecklistItem copyWith({
    int? id,
    String? caseId,
    String? title,
    String? kind,
    Value<String?> referenceId = const Value.absent(),
    bool? done,
    DateTime? createdAt,
  }) => CaseChecklistItem(
    id: id ?? this.id,
    caseId: caseId ?? this.caseId,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    referenceId: referenceId.present ? referenceId.value : this.referenceId,
    done: done ?? this.done,
    createdAt: createdAt ?? this.createdAt,
  );
  CaseChecklistItem copyWithCompanion(CaseChecklistItemsCompanion data) {
    return CaseChecklistItem(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      done: data.done.present ? data.done.value : this.done,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaseChecklistItem(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('referenceId: $referenceId, ')
          ..write('done: $done, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, caseId, title, kind, referenceId, done, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaseChecklistItem &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.title == this.title &&
          other.kind == this.kind &&
          other.referenceId == this.referenceId &&
          other.done == this.done &&
          other.createdAt == this.createdAt);
}

class CaseChecklistItemsCompanion extends UpdateCompanion<CaseChecklistItem> {
  final Value<int> id;
  final Value<String> caseId;
  final Value<String> title;
  final Value<String> kind;
  final Value<String?> referenceId;
  final Value<bool> done;
  final Value<DateTime> createdAt;
  const CaseChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.done = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CaseChecklistItemsCompanion.insert({
    this.id = const Value.absent(),
    required String caseId,
    required String title,
    this.kind = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.done = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : caseId = Value(caseId),
       title = Value(title);
  static Insertable<CaseChecklistItem> custom({
    Expression<int>? id,
    Expression<String>? caseId,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<String>? referenceId,
    Expression<bool>? done,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (referenceId != null) 'reference_id': referenceId,
      if (done != null) 'done': done,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CaseChecklistItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? caseId,
    Value<String>? title,
    Value<String>? kind,
    Value<String?>? referenceId,
    Value<bool>? done,
    Value<DateTime>? createdAt,
  }) {
    return CaseChecklistItemsCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      referenceId: referenceId ?? this.referenceId,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<String>(caseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaseChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('referenceId: $referenceId, ')
          ..write('done: $done, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LegalSectionsTable legalSections = $LegalSectionsTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $SavedScansTable savedScans = $SavedScansTable(this);
  late final $SavedDraftsTable savedDrafts = $SavedDraftsTable(this);
  late final $ActivityHistoryTable activityHistory = $ActivityHistoryTable(
    this,
  );
  late final $CaseFilesTable caseFiles = $CaseFilesTable(this);
  late final $CaseDeadlinesTable caseDeadlines = $CaseDeadlinesTable(this);
  late final $CaseChecklistItemsTable caseChecklistItems =
      $CaseChecklistItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    legalSections,
    bookmarks,
    savedScans,
    savedDrafts,
    activityHistory,
    caseFiles,
    caseDeadlines,
    caseChecklistItems,
  ];
}

typedef $$LegalSectionsTableCreateCompanionBuilder =
    LegalSectionsCompanion Function({
      required String actCode,
      required String actName,
      required String sectionNumber,
      required String title,
      required String chapter,
      required String bodyText,
      required String sourceUrl,
      Value<String?> legacyMapping,
      Value<String?> plainLanguage,
      Value<String?> punishment,
      Value<String> relatedSectionsJson,
      Value<int> rowid,
    });
typedef $$LegalSectionsTableUpdateCompanionBuilder =
    LegalSectionsCompanion Function({
      Value<String> actCode,
      Value<String> actName,
      Value<String> sectionNumber,
      Value<String> title,
      Value<String> chapter,
      Value<String> bodyText,
      Value<String> sourceUrl,
      Value<String?> legacyMapping,
      Value<String?> plainLanguage,
      Value<String?> punishment,
      Value<String> relatedSectionsJson,
      Value<int> rowid,
    });

class $$LegalSectionsTableFilterComposer
    extends Composer<_$AppDatabase, $LegalSectionsTable> {
  $$LegalSectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get actCode => $composableBuilder(
    column: $table.actCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actName => $composableBuilder(
    column: $table.actName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionNumber => $composableBuilder(
    column: $table.sectionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legacyMapping => $composableBuilder(
    column: $table.legacyMapping,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plainLanguage => $composableBuilder(
    column: $table.plainLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get punishment => $composableBuilder(
    column: $table.punishment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedSectionsJson => $composableBuilder(
    column: $table.relatedSectionsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalSectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalSectionsTable> {
  $$LegalSectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get actCode => $composableBuilder(
    column: $table.actCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actName => $composableBuilder(
    column: $table.actName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionNumber => $composableBuilder(
    column: $table.sectionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legacyMapping => $composableBuilder(
    column: $table.legacyMapping,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plainLanguage => $composableBuilder(
    column: $table.plainLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get punishment => $composableBuilder(
    column: $table.punishment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedSectionsJson => $composableBuilder(
    column: $table.relatedSectionsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalSectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalSectionsTable> {
  $$LegalSectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get actCode =>
      $composableBuilder(column: $table.actCode, builder: (column) => column);

  GeneratedColumn<String> get actName =>
      $composableBuilder(column: $table.actName, builder: (column) => column);

  GeneratedColumn<String> get sectionNumber => $composableBuilder(
    column: $table.sectionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get bodyText =>
      $composableBuilder(column: $table.bodyText, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get legacyMapping => $composableBuilder(
    column: $table.legacyMapping,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plainLanguage => $composableBuilder(
    column: $table.plainLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get punishment => $composableBuilder(
    column: $table.punishment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relatedSectionsJson => $composableBuilder(
    column: $table.relatedSectionsJson,
    builder: (column) => column,
  );
}

class $$LegalSectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalSectionsTable,
          LegalSection,
          $$LegalSectionsTableFilterComposer,
          $$LegalSectionsTableOrderingComposer,
          $$LegalSectionsTableAnnotationComposer,
          $$LegalSectionsTableCreateCompanionBuilder,
          $$LegalSectionsTableUpdateCompanionBuilder,
          (
            LegalSection,
            BaseReferences<_$AppDatabase, $LegalSectionsTable, LegalSection>,
          ),
          LegalSection,
          PrefetchHooks Function()
        > {
  $$LegalSectionsTableTableManager(_$AppDatabase db, $LegalSectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalSectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalSectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegalSectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> actCode = const Value.absent(),
                Value<String> actName = const Value.absent(),
                Value<String> sectionNumber = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> chapter = const Value.absent(),
                Value<String> bodyText = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String?> legacyMapping = const Value.absent(),
                Value<String?> plainLanguage = const Value.absent(),
                Value<String?> punishment = const Value.absent(),
                Value<String> relatedSectionsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalSectionsCompanion(
                actCode: actCode,
                actName: actName,
                sectionNumber: sectionNumber,
                title: title,
                chapter: chapter,
                bodyText: bodyText,
                sourceUrl: sourceUrl,
                legacyMapping: legacyMapping,
                plainLanguage: plainLanguage,
                punishment: punishment,
                relatedSectionsJson: relatedSectionsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String actCode,
                required String actName,
                required String sectionNumber,
                required String title,
                required String chapter,
                required String bodyText,
                required String sourceUrl,
                Value<String?> legacyMapping = const Value.absent(),
                Value<String?> plainLanguage = const Value.absent(),
                Value<String?> punishment = const Value.absent(),
                Value<String> relatedSectionsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalSectionsCompanion.insert(
                actCode: actCode,
                actName: actName,
                sectionNumber: sectionNumber,
                title: title,
                chapter: chapter,
                bodyText: bodyText,
                sourceUrl: sourceUrl,
                legacyMapping: legacyMapping,
                plainLanguage: plainLanguage,
                punishment: punishment,
                relatedSectionsJson: relatedSectionsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LegalSectionsTable, LegalSection>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LegalSectionsTable,
                    LegalSection
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalSectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalSectionsTable,
      LegalSection,
      $$LegalSectionsTableFilterComposer,
      $$LegalSectionsTableOrderingComposer,
      $$LegalSectionsTableAnnotationComposer,
      $$LegalSectionsTableCreateCompanionBuilder,
      $$LegalSectionsTableUpdateCompanionBuilder,
      (
        LegalSection,
        BaseReferences<_$AppDatabase, $LegalSectionsTable, LegalSection>,
      ),
      LegalSection,
      PrefetchHooks Function()
    >;
typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  Value<int> id,
  required String actCode,
  required String sectionNumber,
  Value<String?> note,
  Value<DateTime> createdAt,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<int> id,
  Value<String> actCode,
  Value<String> sectionNumber,
  Value<String?> note,
  Value<DateTime> createdAt,
});

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actCode => $composableBuilder(
    column: $table.actCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionNumber => $composableBuilder(
    column: $table.sectionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actCode => $composableBuilder(
    column: $table.actCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionNumber => $composableBuilder(
    column: $table.sectionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get actCode =>
      $composableBuilder(column: $table.actCode, builder: (column) => column);

  GeneratedColumn<String> get sectionNumber => $composableBuilder(
    column: $table.sectionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
          Bookmark,
          PrefetchHooks Function()
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> actCode = const Value.absent(),
                Value<String> sectionNumber = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BookmarksCompanion(
                id: id,
                actCode: actCode,
                sectionNumber: sectionNumber,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String actCode,
                required String sectionNumber,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BookmarksCompanion.insert(
                id: id,
                actCode: actCode,
                sectionNumber: sectionNumber,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BookmarksTable, Bookmark>(table),
                  BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
      Bookmark,
      PrefetchHooks Function()
    >;
typedef $$SavedScansTableCreateCompanionBuilder = SavedScansCompanion Function({
  required String id,
  required String title,
  required String filePath,
  Value<String> ocrText,
  Value<String> summaryJson,
  Value<int> pageCount,
  Value<DateTime> createdAt,
  Value<DateTime?> expiresAt,
  Value<int> rowid,
});
typedef $$SavedScansTableUpdateCompanionBuilder = SavedScansCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> filePath,
  Value<String> ocrText,
  Value<String> summaryJson,
  Value<int> pageCount,
  Value<DateTime> createdAt,
  Value<DateTime?> expiresAt,
  Value<int> rowid,
});

class $$SavedScansTableFilterComposer
    extends Composer<_$AppDatabase, $SavedScansTable> {
  $$SavedScansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ocrText => $composableBuilder(
    column: $table.ocrText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedScansTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedScansTable> {
  $$SavedScansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ocrText => $composableBuilder(
    column: $table.ocrText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedScansTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedScansTable> {
  $$SavedScansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get ocrText =>
      $composableBuilder(column: $table.ocrText, builder: (column) => column);

  GeneratedColumn<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$SavedScansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedScansTable,
          SavedScan,
          $$SavedScansTableFilterComposer,
          $$SavedScansTableOrderingComposer,
          $$SavedScansTableAnnotationComposer,
          $$SavedScansTableCreateCompanionBuilder,
          $$SavedScansTableUpdateCompanionBuilder,
          (
            SavedScan,
            BaseReferences<_$AppDatabase, $SavedScansTable, SavedScan>,
          ),
          SavedScan,
          PrefetchHooks Function()
        > {
  $$SavedScansTableTableManager(_$AppDatabase db, $SavedScansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedScansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedScansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedScansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> ocrText = const Value.absent(),
                Value<String> summaryJson = const Value.absent(),
                Value<int> pageCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedScansCompanion(
                id: id,
                title: title,
                filePath: filePath,
                ocrText: ocrText,
                summaryJson: summaryJson,
                pageCount: pageCount,
                createdAt: createdAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String filePath,
                Value<String> ocrText = const Value.absent(),
                Value<String> summaryJson = const Value.absent(),
                Value<int> pageCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedScansCompanion.insert(
                id: id,
                title: title,
                filePath: filePath,
                ocrText: ocrText,
                summaryJson: summaryJson,
                pageCount: pageCount,
                createdAt: createdAt,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavedScansTable, SavedScan>(table),
                  BaseReferences<_$AppDatabase, $SavedScansTable, SavedScan>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedScansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedScansTable,
      SavedScan,
      $$SavedScansTableFilterComposer,
      $$SavedScansTableOrderingComposer,
      $$SavedScansTableAnnotationComposer,
      $$SavedScansTableCreateCompanionBuilder,
      $$SavedScansTableUpdateCompanionBuilder,
      (SavedScan, BaseReferences<_$AppDatabase, $SavedScansTable, SavedScan>),
      SavedScan,
      PrefetchHooks Function()
    >;
typedef $$SavedDraftsTableCreateCompanionBuilder =
    SavedDraftsCompanion Function({
      required String id,
      required String templateType,
      required String title,
      required String content,
      Value<String> fieldsJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SavedDraftsTableUpdateCompanionBuilder =
    SavedDraftsCompanion Function({
      Value<String> id,
      Value<String> templateType,
      Value<String> title,
      Value<String> content,
      Value<String> fieldsJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SavedDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedDraftsTable> {
  $$SavedDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateType => $composableBuilder(
    column: $table.templateType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedDraftsTable> {
  $$SavedDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateType => $composableBuilder(
    column: $table.templateType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedDraftsTable> {
  $$SavedDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get templateType => $composableBuilder(
    column: $table.templateType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SavedDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedDraftsTable,
          SavedDraft,
          $$SavedDraftsTableFilterComposer,
          $$SavedDraftsTableOrderingComposer,
          $$SavedDraftsTableAnnotationComposer,
          $$SavedDraftsTableCreateCompanionBuilder,
          $$SavedDraftsTableUpdateCompanionBuilder,
          (
            SavedDraft,
            BaseReferences<_$AppDatabase, $SavedDraftsTable, SavedDraft>,
          ),
          SavedDraft,
          PrefetchHooks Function()
        > {
  $$SavedDraftsTableTableManager(_$AppDatabase db, $SavedDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> templateType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> fieldsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedDraftsCompanion(
                id: id,
                templateType: templateType,
                title: title,
                content: content,
                fieldsJson: fieldsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String templateType,
                required String title,
                required String content,
                Value<String> fieldsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedDraftsCompanion.insert(
                id: id,
                templateType: templateType,
                title: title,
                content: content,
                fieldsJson: fieldsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavedDraftsTable, SavedDraft>(table),
                  BaseReferences<_$AppDatabase, $SavedDraftsTable, SavedDraft>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedDraftsTable,
      SavedDraft,
      $$SavedDraftsTableFilterComposer,
      $$SavedDraftsTableOrderingComposer,
      $$SavedDraftsTableAnnotationComposer,
      $$SavedDraftsTableCreateCompanionBuilder,
      $$SavedDraftsTableUpdateCompanionBuilder,
      (
        SavedDraft,
        BaseReferences<_$AppDatabase, $SavedDraftsTable, SavedDraft>,
      ),
      SavedDraft,
      PrefetchHooks Function()
    >;
typedef $$ActivityHistoryTableCreateCompanionBuilder =
    ActivityHistoryCompanion Function({
      Value<int> id,
      required String kind,
      required String title,
      required String subtitle,
      required String route,
      Value<DateTime> createdAt,
    });
typedef $$ActivityHistoryTableUpdateCompanionBuilder =
    ActivityHistoryCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<String> title,
      Value<String> subtitle,
      Value<String> route,
      Value<DateTime> createdAt,
    });

class $$ActivityHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityHistoryTable> {
  $$ActivityHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityHistoryTable> {
  $$ActivityHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get route => $composableBuilder(
    column: $table.route,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityHistoryTable> {
  $$ActivityHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get route =>
      $composableBuilder(column: $table.route, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ActivityHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityHistoryTable,
          ActivityHistoryData,
          $$ActivityHistoryTableFilterComposer,
          $$ActivityHistoryTableOrderingComposer,
          $$ActivityHistoryTableAnnotationComposer,
          $$ActivityHistoryTableCreateCompanionBuilder,
          $$ActivityHistoryTableUpdateCompanionBuilder,
          (
            ActivityHistoryData,
            BaseReferences<
              _$AppDatabase,
              $ActivityHistoryTable,
              ActivityHistoryData
            >,
          ),
          ActivityHistoryData,
          PrefetchHooks Function()
        > {
  $$ActivityHistoryTableTableManager(
    _$AppDatabase db,
    $ActivityHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> subtitle = const Value.absent(),
                Value<String> route = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivityHistoryCompanion(
                id: id,
                kind: kind,
                title: title,
                subtitle: subtitle,
                route: route,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required String title,
                required String subtitle,
                required String route,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivityHistoryCompanion.insert(
                id: id,
                kind: kind,
                title: title,
                subtitle: subtitle,
                route: route,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityHistoryTable, ActivityHistoryData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ActivityHistoryTable,
                    ActivityHistoryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityHistoryTable,
      ActivityHistoryData,
      $$ActivityHistoryTableFilterComposer,
      $$ActivityHistoryTableOrderingComposer,
      $$ActivityHistoryTableAnnotationComposer,
      $$ActivityHistoryTableCreateCompanionBuilder,
      $$ActivityHistoryTableUpdateCompanionBuilder,
      (
        ActivityHistoryData,
        BaseReferences<
          _$AppDatabase,
          $ActivityHistoryTable,
          ActivityHistoryData
        >,
      ),
      ActivityHistoryData,
      PrefetchHooks Function()
    >;
typedef $$CaseFilesTableCreateCompanionBuilder = CaseFilesCompanion Function({
  required String id,
  required String title,
  Value<String> category,
  Value<String> status,
  Value<String> summary,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$CaseFilesTableUpdateCompanionBuilder = CaseFilesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> category,
  Value<String> status,
  Value<String> summary,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CaseFilesTableFilterComposer
    extends Composer<_$AppDatabase, $CaseFilesTable> {
  $$CaseFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CaseFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CaseFilesTable> {
  $$CaseFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CaseFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaseFilesTable> {
  $$CaseFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CaseFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CaseFilesTable,
          CaseFile,
          $$CaseFilesTableFilterComposer,
          $$CaseFilesTableOrderingComposer,
          $$CaseFilesTableAnnotationComposer,
          $$CaseFilesTableCreateCompanionBuilder,
          $$CaseFilesTableUpdateCompanionBuilder,
          (CaseFile, BaseReferences<_$AppDatabase, $CaseFilesTable, CaseFile>),
          CaseFile,
          PrefetchHooks Function()
        > {
  $$CaseFilesTableTableManager(_$AppDatabase db, $CaseFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaseFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaseFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaseFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CaseFilesCompanion(
                id: id,
                title: title,
                category: category,
                status: status,
                summary: summary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CaseFilesCompanion.insert(
                id: id,
                title: title,
                category: category,
                status: status,
                summary: summary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CaseFilesTable, CaseFile>(table),
                  BaseReferences<_$AppDatabase, $CaseFilesTable, CaseFile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CaseFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CaseFilesTable,
      CaseFile,
      $$CaseFilesTableFilterComposer,
      $$CaseFilesTableOrderingComposer,
      $$CaseFilesTableAnnotationComposer,
      $$CaseFilesTableCreateCompanionBuilder,
      $$CaseFilesTableUpdateCompanionBuilder,
      (CaseFile, BaseReferences<_$AppDatabase, $CaseFilesTable, CaseFile>),
      CaseFile,
      PrefetchHooks Function()
    >;
typedef $$CaseDeadlinesTableCreateCompanionBuilder =
    CaseDeadlinesCompanion Function({
      Value<int> id,
      required String caseId,
      required String title,
      required DateTime dueAt,
      Value<bool> reminderScheduled,
      Value<bool> completed,
    });
typedef $$CaseDeadlinesTableUpdateCompanionBuilder =
    CaseDeadlinesCompanion Function({
      Value<int> id,
      Value<String> caseId,
      Value<String> title,
      Value<DateTime> dueAt,
      Value<bool> reminderScheduled,
      Value<bool> completed,
    });

class $$CaseDeadlinesTableFilterComposer
    extends Composer<_$AppDatabase, $CaseDeadlinesTable> {
  $$CaseDeadlinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caseId => $composableBuilder(
    column: $table.caseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderScheduled => $composableBuilder(
    column: $table.reminderScheduled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CaseDeadlinesTableOrderingComposer
    extends Composer<_$AppDatabase, $CaseDeadlinesTable> {
  $$CaseDeadlinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caseId => $composableBuilder(
    column: $table.caseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderScheduled => $composableBuilder(
    column: $table.reminderScheduled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CaseDeadlinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaseDeadlinesTable> {
  $$CaseDeadlinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get caseId =>
      $composableBuilder(column: $table.caseId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<bool> get reminderScheduled => $composableBuilder(
    column: $table.reminderScheduled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);
}

class $$CaseDeadlinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CaseDeadlinesTable,
          CaseDeadline,
          $$CaseDeadlinesTableFilterComposer,
          $$CaseDeadlinesTableOrderingComposer,
          $$CaseDeadlinesTableAnnotationComposer,
          $$CaseDeadlinesTableCreateCompanionBuilder,
          $$CaseDeadlinesTableUpdateCompanionBuilder,
          (
            CaseDeadline,
            BaseReferences<_$AppDatabase, $CaseDeadlinesTable, CaseDeadline>,
          ),
          CaseDeadline,
          PrefetchHooks Function()
        > {
  $$CaseDeadlinesTableTableManager(_$AppDatabase db, $CaseDeadlinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaseDeadlinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaseDeadlinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaseDeadlinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> caseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<bool> reminderScheduled = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => CaseDeadlinesCompanion(
                id: id,
                caseId: caseId,
                title: title,
                dueAt: dueAt,
                reminderScheduled: reminderScheduled,
                completed: completed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String caseId,
                required String title,
                required DateTime dueAt,
                Value<bool> reminderScheduled = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => CaseDeadlinesCompanion.insert(
                id: id,
                caseId: caseId,
                title: title,
                dueAt: dueAt,
                reminderScheduled: reminderScheduled,
                completed: completed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CaseDeadlinesTable, CaseDeadline>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CaseDeadlinesTable,
                    CaseDeadline
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CaseDeadlinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CaseDeadlinesTable,
      CaseDeadline,
      $$CaseDeadlinesTableFilterComposer,
      $$CaseDeadlinesTableOrderingComposer,
      $$CaseDeadlinesTableAnnotationComposer,
      $$CaseDeadlinesTableCreateCompanionBuilder,
      $$CaseDeadlinesTableUpdateCompanionBuilder,
      (
        CaseDeadline,
        BaseReferences<_$AppDatabase, $CaseDeadlinesTable, CaseDeadline>,
      ),
      CaseDeadline,
      PrefetchHooks Function()
    >;
typedef $$CaseChecklistItemsTableCreateCompanionBuilder =
    CaseChecklistItemsCompanion Function({
      Value<int> id,
      required String caseId,
      required String title,
      Value<String> kind,
      Value<String?> referenceId,
      Value<bool> done,
      Value<DateTime> createdAt,
    });
typedef $$CaseChecklistItemsTableUpdateCompanionBuilder =
    CaseChecklistItemsCompanion Function({
      Value<int> id,
      Value<String> caseId,
      Value<String> title,
      Value<String> kind,
      Value<String?> referenceId,
      Value<bool> done,
      Value<DateTime> createdAt,
    });

class $$CaseChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CaseChecklistItemsTable> {
  $$CaseChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caseId => $composableBuilder(
    column: $table.caseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CaseChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CaseChecklistItemsTable> {
  $$CaseChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caseId => $composableBuilder(
    column: $table.caseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CaseChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaseChecklistItemsTable> {
  $$CaseChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get caseId =>
      $composableBuilder(column: $table.caseId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CaseChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CaseChecklistItemsTable,
          CaseChecklistItem,
          $$CaseChecklistItemsTableFilterComposer,
          $$CaseChecklistItemsTableOrderingComposer,
          $$CaseChecklistItemsTableAnnotationComposer,
          $$CaseChecklistItemsTableCreateCompanionBuilder,
          $$CaseChecklistItemsTableUpdateCompanionBuilder,
          (
            CaseChecklistItem,
            BaseReferences<
              _$AppDatabase,
              $CaseChecklistItemsTable,
              CaseChecklistItem
            >,
          ),
          CaseChecklistItem,
          PrefetchHooks Function()
        > {
  $$CaseChecklistItemsTableTableManager(
    _$AppDatabase db,
    $CaseChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaseChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaseChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaseChecklistItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> caseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> referenceId = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CaseChecklistItemsCompanion(
                id: id,
                caseId: caseId,
                title: title,
                kind: kind,
                referenceId: referenceId,
                done: done,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String caseId,
                required String title,
                Value<String> kind = const Value.absent(),
                Value<String?> referenceId = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CaseChecklistItemsCompanion.insert(
                id: id,
                caseId: caseId,
                title: title,
                kind: kind,
                referenceId: referenceId,
                done: done,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CaseChecklistItemsTable, CaseChecklistItem>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $CaseChecklistItemsTable,
                    CaseChecklistItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CaseChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CaseChecklistItemsTable,
      CaseChecklistItem,
      $$CaseChecklistItemsTableFilterComposer,
      $$CaseChecklistItemsTableOrderingComposer,
      $$CaseChecklistItemsTableAnnotationComposer,
      $$CaseChecklistItemsTableCreateCompanionBuilder,
      $$CaseChecklistItemsTableUpdateCompanionBuilder,
      (
        CaseChecklistItem,
        BaseReferences<
          _$AppDatabase,
          $CaseChecklistItemsTable,
          CaseChecklistItem
        >,
      ),
      CaseChecklistItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LegalSectionsTableTableManager get legalSections =>
      $$LegalSectionsTableTableManager(_db, _db.legalSections);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$SavedScansTableTableManager get savedScans =>
      $$SavedScansTableTableManager(_db, _db.savedScans);
  $$SavedDraftsTableTableManager get savedDrafts =>
      $$SavedDraftsTableTableManager(_db, _db.savedDrafts);
  $$ActivityHistoryTableTableManager get activityHistory =>
      $$ActivityHistoryTableTableManager(_db, _db.activityHistory);
  $$CaseFilesTableTableManager get caseFiles =>
      $$CaseFilesTableTableManager(_db, _db.caseFiles);
  $$CaseDeadlinesTableTableManager get caseDeadlines =>
      $$CaseDeadlinesTableTableManager(_db, _db.caseDeadlines);
  $$CaseChecklistItemsTableTableManager get caseChecklistItems =>
      $$CaseChecklistItemsTableTableManager(_db, _db.caseChecklistItems);
}
