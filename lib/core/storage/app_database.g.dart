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

class $ConversationsTable extends Conversations
    with TableInfo<$ConversationsTable, Conversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTable(this.attachedDatabase, [this._alias]);
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
    requiredDuringInsert: false,
    defaultValue: const Constant('Legal research'),
  );
  static const VerificationMeta _attachedScanIdMeta = const VerificationMeta(
    'attachedScanId',
  );
  @override
  late final GeneratedColumn<String> attachedScanId = GeneratedColumn<String>(
    'attached_scan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attachedScanJsonMeta = const VerificationMeta(
    'attachedScanJson',
  );
  @override
  late final GeneratedColumn<String> attachedScanJson = GeneratedColumn<String>(
    'attached_scan_json',
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
    attachedScanId,
    attachedScanJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Conversation> instance, {
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
    }
    if (data.containsKey('attached_scan_id')) {
      context.handle(
        _attachedScanIdMeta,
        attachedScanId.isAcceptableOrUnknown(
          data['attached_scan_id']!,
          _attachedScanIdMeta,
        ),
      );
    }
    if (data.containsKey('attached_scan_json')) {
      context.handle(
        _attachedScanJsonMeta,
        attachedScanJson.isAcceptableOrUnknown(
          data['attached_scan_json']!,
          _attachedScanJsonMeta,
        ),
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
  Conversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Conversation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      attachedScanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attached_scan_id'],
      ),
      attachedScanJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attached_scan_json'],
      ),
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
  $ConversationsTable createAlias(String alias) {
    return $ConversationsTable(attachedDatabase, alias);
  }
}

class Conversation extends DataClass implements Insertable<Conversation> {
  /// Stable conversation identifier.
  final String id;

  /// Display title of the conversation.
  final String title;

  /// Optional linked scan ID.
  final String? attachedScanId;

  /// JSON-encoded attachment metadata if a scan is attached.
  final String? attachedScanJson;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last message timestamp.
  final DateTime updatedAt;
  const Conversation({
    required this.id,
    required this.title,
    this.attachedScanId,
    this.attachedScanJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || attachedScanId != null) {
      map['attached_scan_id'] = Variable<String>(attachedScanId);
    }
    if (!nullToAbsent || attachedScanJson != null) {
      map['attached_scan_json'] = Variable<String>(attachedScanJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConversationsCompanion toCompanion(bool nullToAbsent) {
    return ConversationsCompanion(
      id: Value(id),
      title: Value(title),
      attachedScanId: attachedScanId == null && nullToAbsent
          ? const Value.absent()
          : Value(attachedScanId),
      attachedScanJson: attachedScanJson == null && nullToAbsent
          ? const Value.absent()
          : Value(attachedScanJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Conversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Conversation(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      attachedScanId: serializer.fromJson<String?>(json['attachedScanId']),
      attachedScanJson: serializer.fromJson<String?>(json['attachedScanJson']),
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
      'attachedScanId': serializer.toJson<String?>(attachedScanId),
      'attachedScanJson': serializer.toJson<String?>(attachedScanJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Conversation copyWith({
    String? id,
    String? title,
    Value<String?> attachedScanId = const Value.absent(),
    Value<String?> attachedScanJson = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Conversation(
    id: id ?? this.id,
    title: title ?? this.title,
    attachedScanId: attachedScanId.present
        ? attachedScanId.value
        : this.attachedScanId,
    attachedScanJson: attachedScanJson.present
        ? attachedScanJson.value
        : this.attachedScanJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Conversation copyWithCompanion(ConversationsCompanion data) {
    return Conversation(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      attachedScanId: data.attachedScanId.present
          ? data.attachedScanId.value
          : this.attachedScanId,
      attachedScanJson: data.attachedScanJson.present
          ? data.attachedScanJson.value
          : this.attachedScanJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Conversation(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('attachedScanId: $attachedScanId, ')
          ..write('attachedScanJson: $attachedScanJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    attachedScanId,
    attachedScanJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Conversation &&
          other.id == this.id &&
          other.title == this.title &&
          other.attachedScanId == this.attachedScanId &&
          other.attachedScanJson == this.attachedScanJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConversationsCompanion extends UpdateCompanion<Conversation> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> attachedScanId;
  final Value<String?> attachedScanJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ConversationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.attachedScanId = const Value.absent(),
    this.attachedScanJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsCompanion.insert({
    required String id,
    this.title = const Value.absent(),
    this.attachedScanId = const Value.absent(),
    this.attachedScanJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Conversation> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? attachedScanId,
    Expression<String>? attachedScanJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (attachedScanId != null) 'attached_scan_id': attachedScanId,
      if (attachedScanJson != null) 'attached_scan_json': attachedScanJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? attachedScanId,
    Value<String?>? attachedScanJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ConversationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      attachedScanId: attachedScanId ?? this.attachedScanId,
      attachedScanJson: attachedScanJson ?? this.attachedScanJson,
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
    if (attachedScanId.present) {
      map['attached_scan_id'] = Variable<String>(attachedScanId.value);
    }
    if (attachedScanJson.present) {
      map['attached_scan_json'] = Variable<String>(attachedScanJson.value);
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
    return (StringBuffer('ConversationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('attachedScanId: $attachedScanId, ')
          ..write('attachedScanJson: $attachedScanJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUserMeta = const VerificationMeta('isUser');
  @override
  late final GeneratedColumn<bool> isUser = GeneratedColumn<bool>(
    'is_user',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_user" IN (0, 1))',
    ),
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
  static const VerificationMeta _engineLabelMeta = const VerificationMeta(
    'engineLabel',
  );
  @override
  late final GeneratedColumn<String> engineLabel = GeneratedColumn<String>(
    'engine_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _citationsJsonMeta = const VerificationMeta(
    'citationsJson',
  );
  @override
  late final GeneratedColumn<String> citationsJson = GeneratedColumn<String>(
    'citations_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _reasoningTrailMeta = const VerificationMeta(
    'reasoningTrail',
  );
  @override
  late final GeneratedColumn<String> reasoningTrail = GeneratedColumn<String>(
    'reasoning_trail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _counterArgumentsMeta = const VerificationMeta(
    'counterArguments',
  );
  @override
  late final GeneratedColumn<String> counterArguments = GeneratedColumn<String>(
    'counter_arguments',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _droppedUnverifiedCountMeta =
      const VerificationMeta('droppedUnverifiedCount');
  @override
  late final GeneratedColumn<int> droppedUnverifiedCount = GeneratedColumn<int>(
    'dropped_unverified_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _attachmentJsonMeta = const VerificationMeta(
    'attachmentJson',
  );
  @override
  late final GeneratedColumn<String> attachmentJson = GeneratedColumn<String>(
    'attachment_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
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
    conversationId,
    isUser,
    content,
    engineLabel,
    confidence,
    citationsJson,
    reasoningTrail,
    counterArguments,
    droppedUnverifiedCount,
    attachmentJson,
    errorMessage,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Message> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('is_user')) {
      context.handle(
        _isUserMeta,
        isUser.isAcceptableOrUnknown(data['is_user']!, _isUserMeta),
      );
    } else if (isInserting) {
      context.missing(_isUserMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('engine_label')) {
      context.handle(
        _engineLabelMeta,
        engineLabel.isAcceptableOrUnknown(
          data['engine_label']!,
          _engineLabelMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('citations_json')) {
      context.handle(
        _citationsJsonMeta,
        citationsJson.isAcceptableOrUnknown(
          data['citations_json']!,
          _citationsJsonMeta,
        ),
      );
    }
    if (data.containsKey('reasoning_trail')) {
      context.handle(
        _reasoningTrailMeta,
        reasoningTrail.isAcceptableOrUnknown(
          data['reasoning_trail']!,
          _reasoningTrailMeta,
        ),
      );
    }
    if (data.containsKey('counter_arguments')) {
      context.handle(
        _counterArgumentsMeta,
        counterArguments.isAcceptableOrUnknown(
          data['counter_arguments']!,
          _counterArgumentsMeta,
        ),
      );
    }
    if (data.containsKey('dropped_unverified_count')) {
      context.handle(
        _droppedUnverifiedCountMeta,
        droppedUnverifiedCount.isAcceptableOrUnknown(
          data['dropped_unverified_count']!,
          _droppedUnverifiedCountMeta,
        ),
      );
    }
    if (data.containsKey('attachment_json')) {
      context.handle(
        _attachmentJsonMeta,
        attachmentJson.isAcceptableOrUnknown(
          data['attachment_json']!,
          _attachmentJsonMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
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
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      isUser: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_user'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      engineLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_label'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      ),
      citationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}citations_json'],
      )!,
      reasoningTrail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reasoning_trail'],
      ),
      counterArguments: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counter_arguments'],
      ),
      droppedUnverifiedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dropped_unverified_count'],
      )!,
      attachmentJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachment_json'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  /// Unique message ID.
  final String id;

  /// Owning conversation ID.
  final String conversationId;

  /// Whether sent by the user (`true`) or Lex (`false`).
  final bool isUser;

  /// Message body text.
  final String content;

  /// Engine provenance label (`Gemma 4 E2B · On-Device` or `Cloud · Gemma 4`).
  final String? engineLabel;

  /// Confidence level (`high`, `medium`, `low`).
  final String? confidence;

  /// JSON-encoded list of verified citations.
  final String citationsJson;

  /// Optional retrieval and verification summary.
  final String? reasoningTrail;

  /// Optional counter-arguments summary.
  final String? counterArguments;

  /// Count of unverified citations removed by verifier.
  final int droppedUnverifiedCount;

  /// Optional JSON-encoded scan attachment snapshot for the turn.
  final String? attachmentJson;

  /// Optional recoverable failure message.
  final String? errorMessage;

  /// Creation timestamp.
  final DateTime createdAt;
  const Message({
    required this.id,
    required this.conversationId,
    required this.isUser,
    required this.content,
    this.engineLabel,
    this.confidence,
    required this.citationsJson,
    this.reasoningTrail,
    this.counterArguments,
    required this.droppedUnverifiedCount,
    this.attachmentJson,
    this.errorMessage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['is_user'] = Variable<bool>(isUser);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || engineLabel != null) {
      map['engine_label'] = Variable<String>(engineLabel);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<String>(confidence);
    }
    map['citations_json'] = Variable<String>(citationsJson);
    if (!nullToAbsent || reasoningTrail != null) {
      map['reasoning_trail'] = Variable<String>(reasoningTrail);
    }
    if (!nullToAbsent || counterArguments != null) {
      map['counter_arguments'] = Variable<String>(counterArguments);
    }
    map['dropped_unverified_count'] = Variable<int>(droppedUnverifiedCount);
    if (!nullToAbsent || attachmentJson != null) {
      map['attachment_json'] = Variable<String>(attachmentJson);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      isUser: Value(isUser),
      content: Value(content),
      engineLabel: engineLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(engineLabel),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      citationsJson: Value(citationsJson),
      reasoningTrail: reasoningTrail == null && nullToAbsent
          ? const Value.absent()
          : Value(reasoningTrail),
      counterArguments: counterArguments == null && nullToAbsent
          ? const Value.absent()
          : Value(counterArguments),
      droppedUnverifiedCount: Value(droppedUnverifiedCount),
      attachmentJson: attachmentJson == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentJson),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      isUser: serializer.fromJson<bool>(json['isUser']),
      content: serializer.fromJson<String>(json['content']),
      engineLabel: serializer.fromJson<String?>(json['engineLabel']),
      confidence: serializer.fromJson<String?>(json['confidence']),
      citationsJson: serializer.fromJson<String>(json['citationsJson']),
      reasoningTrail: serializer.fromJson<String?>(json['reasoningTrail']),
      counterArguments: serializer.fromJson<String?>(json['counterArguments']),
      droppedUnverifiedCount: serializer.fromJson<int>(
        json['droppedUnverifiedCount'],
      ),
      attachmentJson: serializer.fromJson<String?>(json['attachmentJson']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'isUser': serializer.toJson<bool>(isUser),
      'content': serializer.toJson<String>(content),
      'engineLabel': serializer.toJson<String?>(engineLabel),
      'confidence': serializer.toJson<String?>(confidence),
      'citationsJson': serializer.toJson<String>(citationsJson),
      'reasoningTrail': serializer.toJson<String?>(reasoningTrail),
      'counterArguments': serializer.toJson<String?>(counterArguments),
      'droppedUnverifiedCount': serializer.toJson<int>(droppedUnverifiedCount),
      'attachmentJson': serializer.toJson<String?>(attachmentJson),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    bool? isUser,
    String? content,
    Value<String?> engineLabel = const Value.absent(),
    Value<String?> confidence = const Value.absent(),
    String? citationsJson,
    Value<String?> reasoningTrail = const Value.absent(),
    Value<String?> counterArguments = const Value.absent(),
    int? droppedUnverifiedCount,
    Value<String?> attachmentJson = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    DateTime? createdAt,
  }) => Message(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    isUser: isUser ?? this.isUser,
    content: content ?? this.content,
    engineLabel: engineLabel.present ? engineLabel.value : this.engineLabel,
    confidence: confidence.present ? confidence.value : this.confidence,
    citationsJson: citationsJson ?? this.citationsJson,
    reasoningTrail: reasoningTrail.present
        ? reasoningTrail.value
        : this.reasoningTrail,
    counterArguments: counterArguments.present
        ? counterArguments.value
        : this.counterArguments,
    droppedUnverifiedCount:
        droppedUnverifiedCount ?? this.droppedUnverifiedCount,
    attachmentJson: attachmentJson.present
        ? attachmentJson.value
        : this.attachmentJson,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
  );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      isUser: data.isUser.present ? data.isUser.value : this.isUser,
      content: data.content.present ? data.content.value : this.content,
      engineLabel: data.engineLabel.present
          ? data.engineLabel.value
          : this.engineLabel,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      citationsJson: data.citationsJson.present
          ? data.citationsJson.value
          : this.citationsJson,
      reasoningTrail: data.reasoningTrail.present
          ? data.reasoningTrail.value
          : this.reasoningTrail,
      counterArguments: data.counterArguments.present
          ? data.counterArguments.value
          : this.counterArguments,
      droppedUnverifiedCount: data.droppedUnverifiedCount.present
          ? data.droppedUnverifiedCount.value
          : this.droppedUnverifiedCount,
      attachmentJson: data.attachmentJson.present
          ? data.attachmentJson.value
          : this.attachmentJson,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('isUser: $isUser, ')
          ..write('content: $content, ')
          ..write('engineLabel: $engineLabel, ')
          ..write('confidence: $confidence, ')
          ..write('citationsJson: $citationsJson, ')
          ..write('reasoningTrail: $reasoningTrail, ')
          ..write('counterArguments: $counterArguments, ')
          ..write('droppedUnverifiedCount: $droppedUnverifiedCount, ')
          ..write('attachmentJson: $attachmentJson, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    conversationId,
    isUser,
    content,
    engineLabel,
    confidence,
    citationsJson,
    reasoningTrail,
    counterArguments,
    droppedUnverifiedCount,
    attachmentJson,
    errorMessage,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.isUser == this.isUser &&
          other.content == this.content &&
          other.engineLabel == this.engineLabel &&
          other.confidence == this.confidence &&
          other.citationsJson == this.citationsJson &&
          other.reasoningTrail == this.reasoningTrail &&
          other.counterArguments == this.counterArguments &&
          other.droppedUnverifiedCount == this.droppedUnverifiedCount &&
          other.attachmentJson == this.attachmentJson &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<bool> isUser;
  final Value<String> content;
  final Value<String?> engineLabel;
  final Value<String?> confidence;
  final Value<String> citationsJson;
  final Value<String?> reasoningTrail;
  final Value<String?> counterArguments;
  final Value<int> droppedUnverifiedCount;
  final Value<String?> attachmentJson;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.isUser = const Value.absent(),
    this.content = const Value.absent(),
    this.engineLabel = const Value.absent(),
    this.confidence = const Value.absent(),
    this.citationsJson = const Value.absent(),
    this.reasoningTrail = const Value.absent(),
    this.counterArguments = const Value.absent(),
    this.droppedUnverifiedCount = const Value.absent(),
    this.attachmentJson = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String conversationId,
    required bool isUser,
    required String content,
    this.engineLabel = const Value.absent(),
    this.confidence = const Value.absent(),
    this.citationsJson = const Value.absent(),
    this.reasoningTrail = const Value.absent(),
    this.counterArguments = const Value.absent(),
    this.droppedUnverifiedCount = const Value.absent(),
    this.attachmentJson = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       isUser = Value(isUser),
       content = Value(content);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<bool>? isUser,
    Expression<String>? content,
    Expression<String>? engineLabel,
    Expression<String>? confidence,
    Expression<String>? citationsJson,
    Expression<String>? reasoningTrail,
    Expression<String>? counterArguments,
    Expression<int>? droppedUnverifiedCount,
    Expression<String>? attachmentJson,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (isUser != null) 'is_user': isUser,
      if (content != null) 'content': content,
      if (engineLabel != null) 'engine_label': engineLabel,
      if (confidence != null) 'confidence': confidence,
      if (citationsJson != null) 'citations_json': citationsJson,
      if (reasoningTrail != null) 'reasoning_trail': reasoningTrail,
      if (counterArguments != null) 'counter_arguments': counterArguments,
      if (droppedUnverifiedCount != null)
        'dropped_unverified_count': droppedUnverifiedCount,
      if (attachmentJson != null) 'attachment_json': attachmentJson,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<bool>? isUser,
    Value<String>? content,
    Value<String?>? engineLabel,
    Value<String?>? confidence,
    Value<String>? citationsJson,
    Value<String?>? reasoningTrail,
    Value<String?>? counterArguments,
    Value<int>? droppedUnverifiedCount,
    Value<String?>? attachmentJson,
    Value<String?>? errorMessage,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      isUser: isUser ?? this.isUser,
      content: content ?? this.content,
      engineLabel: engineLabel ?? this.engineLabel,
      confidence: confidence ?? this.confidence,
      citationsJson: citationsJson ?? this.citationsJson,
      reasoningTrail: reasoningTrail ?? this.reasoningTrail,
      counterArguments: counterArguments ?? this.counterArguments,
      droppedUnverifiedCount:
          droppedUnverifiedCount ?? this.droppedUnverifiedCount,
      attachmentJson: attachmentJson ?? this.attachmentJson,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (isUser.present) {
      map['is_user'] = Variable<bool>(isUser.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (engineLabel.present) {
      map['engine_label'] = Variable<String>(engineLabel.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (citationsJson.present) {
      map['citations_json'] = Variable<String>(citationsJson.value);
    }
    if (reasoningTrail.present) {
      map['reasoning_trail'] = Variable<String>(reasoningTrail.value);
    }
    if (counterArguments.present) {
      map['counter_arguments'] = Variable<String>(counterArguments.value);
    }
    if (droppedUnverifiedCount.present) {
      map['dropped_unverified_count'] = Variable<int>(
        droppedUnverifiedCount.value,
      );
    }
    if (attachmentJson.present) {
      map['attachment_json'] = Variable<String>(attachmentJson.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('isUser: $isUser, ')
          ..write('content: $content, ')
          ..write('engineLabel: $engineLabel, ')
          ..write('confidence: $confidence, ')
          ..write('citationsJson: $citationsJson, ')
          ..write('reasoningTrail: $reasoningTrail, ')
          ..write('counterArguments: $counterArguments, ')
          ..write('droppedUnverifiedCount: $droppedUnverifiedCount, ')
          ..write('attachmentJson: $attachmentJson, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentChunksTable extends DocumentChunks
    with TableInfo<$DocumentChunksTable, DocumentChunk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentChunksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceKindMeta = const VerificationMeta(
    'sourceKind',
  );
  @override
  late final GeneratedColumn<String> sourceKind = GeneratedColumn<String>(
    'source_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _chunkIndexMeta = const VerificationMeta(
    'chunkIndex',
  );
  @override
  late final GeneratedColumn<int> chunkIndex = GeneratedColumn<int>(
    'chunk_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chunkTextMeta = const VerificationMeta(
    'chunkText',
  );
  @override
  late final GeneratedColumn<String> chunkText = GeneratedColumn<String>(
    'chunk_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _embeddingBlobMeta = const VerificationMeta(
    'embeddingBlob',
  );
  @override
  late final GeneratedColumn<Uint8List> embeddingBlob =
      GeneratedColumn<Uint8List>(
        'embedding_blob',
        aliasedName,
        true,
        type: DriftSqlType.blob,
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
    sourceId,
    sourceKind,
    pageNumber,
    chunkIndex,
    chunkText,
    embeddingBlob,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_chunks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentChunk> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('source_kind')) {
      context.handle(
        _sourceKindMeta,
        sourceKind.isAcceptableOrUnknown(data['source_kind']!, _sourceKindMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceKindMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    }
    if (data.containsKey('chunk_index')) {
      context.handle(
        _chunkIndexMeta,
        chunkIndex.isAcceptableOrUnknown(data['chunk_index']!, _chunkIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_chunkIndexMeta);
    }
    if (data.containsKey('chunk_text')) {
      context.handle(
        _chunkTextMeta,
        chunkText.isAcceptableOrUnknown(data['chunk_text']!, _chunkTextMeta),
      );
    } else if (isInserting) {
      context.missing(_chunkTextMeta);
    }
    if (data.containsKey('embedding_blob')) {
      context.handle(
        _embeddingBlobMeta,
        embeddingBlob.isAcceptableOrUnknown(
          data['embedding_blob']!,
          _embeddingBlobMeta,
        ),
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
  DocumentChunk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentChunk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      sourceKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_kind'],
      )!,
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      )!,
      chunkIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chunk_index'],
      )!,
      chunkText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chunk_text'],
      )!,
      embeddingBlob: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}embedding_blob'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DocumentChunksTable createAlias(String alias) {
    return $DocumentChunksTable(attachedDatabase, alias);
  }
}

class DocumentChunk extends DataClass implements Insertable<DocumentChunk> {
  /// Unique chunk ID.
  final String id;

  /// Source scan, contract, or provision ID.
  final String sourceId;

  /// Source classification (`scan`, `contract`, `statute`).
  final String sourceKind;

  /// 1-based page number when available.
  final int pageNumber;

  /// 0-based sequential chunk index.
  final int chunkIndex;

  /// Normalized chunk content.
  final String chunkText;

  /// Optional JSON or float32 bytes of local semantic embedding.
  final Uint8List? embeddingBlob;

  /// Creation timestamp.
  final DateTime createdAt;
  const DocumentChunk({
    required this.id,
    required this.sourceId,
    required this.sourceKind,
    required this.pageNumber,
    required this.chunkIndex,
    required this.chunkText,
    this.embeddingBlob,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['source_kind'] = Variable<String>(sourceKind);
    map['page_number'] = Variable<int>(pageNumber);
    map['chunk_index'] = Variable<int>(chunkIndex);
    map['chunk_text'] = Variable<String>(chunkText);
    if (!nullToAbsent || embeddingBlob != null) {
      map['embedding_blob'] = Variable<Uint8List>(embeddingBlob);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DocumentChunksCompanion toCompanion(bool nullToAbsent) {
    return DocumentChunksCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      sourceKind: Value(sourceKind),
      pageNumber: Value(pageNumber),
      chunkIndex: Value(chunkIndex),
      chunkText: Value(chunkText),
      embeddingBlob: embeddingBlob == null && nullToAbsent
          ? const Value.absent()
          : Value(embeddingBlob),
      createdAt: Value(createdAt),
    );
  }

  factory DocumentChunk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentChunk(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      sourceKind: serializer.fromJson<String>(json['sourceKind']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      chunkIndex: serializer.fromJson<int>(json['chunkIndex']),
      chunkText: serializer.fromJson<String>(json['chunkText']),
      embeddingBlob: serializer.fromJson<Uint8List?>(json['embeddingBlob']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'sourceKind': serializer.toJson<String>(sourceKind),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'chunkIndex': serializer.toJson<int>(chunkIndex),
      'chunkText': serializer.toJson<String>(chunkText),
      'embeddingBlob': serializer.toJson<Uint8List?>(embeddingBlob),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DocumentChunk copyWith({
    String? id,
    String? sourceId,
    String? sourceKind,
    int? pageNumber,
    int? chunkIndex,
    String? chunkText,
    Value<Uint8List?> embeddingBlob = const Value.absent(),
    DateTime? createdAt,
  }) => DocumentChunk(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    sourceKind: sourceKind ?? this.sourceKind,
    pageNumber: pageNumber ?? this.pageNumber,
    chunkIndex: chunkIndex ?? this.chunkIndex,
    chunkText: chunkText ?? this.chunkText,
    embeddingBlob: embeddingBlob.present
        ? embeddingBlob.value
        : this.embeddingBlob,
    createdAt: createdAt ?? this.createdAt,
  );
  DocumentChunk copyWithCompanion(DocumentChunksCompanion data) {
    return DocumentChunk(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      sourceKind: data.sourceKind.present
          ? data.sourceKind.value
          : this.sourceKind,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      chunkIndex: data.chunkIndex.present
          ? data.chunkIndex.value
          : this.chunkIndex,
      chunkText: data.chunkText.present ? data.chunkText.value : this.chunkText,
      embeddingBlob: data.embeddingBlob.present
          ? data.embeddingBlob.value
          : this.embeddingBlob,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentChunk(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('chunkIndex: $chunkIndex, ')
          ..write('chunkText: $chunkText, ')
          ..write('embeddingBlob: $embeddingBlob, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    sourceKind,
    pageNumber,
    chunkIndex,
    chunkText,
    $driftBlobEquality.hash(embeddingBlob),
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentChunk &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.sourceKind == this.sourceKind &&
          other.pageNumber == this.pageNumber &&
          other.chunkIndex == this.chunkIndex &&
          other.chunkText == this.chunkText &&
          $driftBlobEquality.equals(other.embeddingBlob, this.embeddingBlob) &&
          other.createdAt == this.createdAt);
}

class DocumentChunksCompanion extends UpdateCompanion<DocumentChunk> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> sourceKind;
  final Value<int> pageNumber;
  final Value<int> chunkIndex;
  final Value<String> chunkText;
  final Value<Uint8List?> embeddingBlob;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DocumentChunksCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceKind = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.chunkIndex = const Value.absent(),
    this.chunkText = const Value.absent(),
    this.embeddingBlob = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentChunksCompanion.insert({
    required String id,
    required String sourceId,
    required String sourceKind,
    this.pageNumber = const Value.absent(),
    required int chunkIndex,
    required String chunkText,
    this.embeddingBlob = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       sourceKind = Value(sourceKind),
       chunkIndex = Value(chunkIndex),
       chunkText = Value(chunkText);
  static Insertable<DocumentChunk> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? sourceKind,
    Expression<int>? pageNumber,
    Expression<int>? chunkIndex,
    Expression<String>? chunkText,
    Expression<Uint8List>? embeddingBlob,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (sourceKind != null) 'source_kind': sourceKind,
      if (pageNumber != null) 'page_number': pageNumber,
      if (chunkIndex != null) 'chunk_index': chunkIndex,
      if (chunkText != null) 'chunk_text': chunkText,
      if (embeddingBlob != null) 'embedding_blob': embeddingBlob,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentChunksCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? sourceKind,
    Value<int>? pageNumber,
    Value<int>? chunkIndex,
    Value<String>? chunkText,
    Value<Uint8List?>? embeddingBlob,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return DocumentChunksCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      sourceKind: sourceKind ?? this.sourceKind,
      pageNumber: pageNumber ?? this.pageNumber,
      chunkIndex: chunkIndex ?? this.chunkIndex,
      chunkText: chunkText ?? this.chunkText,
      embeddingBlob: embeddingBlob ?? this.embeddingBlob,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (sourceKind.present) {
      map['source_kind'] = Variable<String>(sourceKind.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (chunkIndex.present) {
      map['chunk_index'] = Variable<int>(chunkIndex.value);
    }
    if (chunkText.present) {
      map['chunk_text'] = Variable<String>(chunkText.value);
    }
    if (embeddingBlob.present) {
      map['embedding_blob'] = Variable<Uint8List>(embeddingBlob.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentChunksCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceKind: $sourceKind, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('chunkIndex: $chunkIndex, ')
          ..write('chunkText: $chunkText, ')
          ..write('embeddingBlob: $embeddingBlob, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContractAnalysesTable extends ContractAnalyses
    with TableInfo<$ContractAnalysesTable, ContractAnalyse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractAnalysesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _documentPathMeta = const VerificationMeta(
    'documentPath',
  );
  @override
  late final GeneratedColumn<String> documentPath = GeneratedColumn<String>(
    'document_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overallScoreMeta = const VerificationMeta(
    'overallScore',
  );
  @override
  late final GeneratedColumn<int> overallScore = GeneratedColumn<int>(
    'overall_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _engineLabelMeta = const VerificationMeta(
    'engineLabel',
  );
  @override
  late final GeneratedColumn<String> engineLabel = GeneratedColumn<String>(
    'engine_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Gemma 4 · On-Device'),
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
    title,
    documentPath,
    overallScore,
    summaryJson,
    engineLabel,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contract_analyses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContractAnalyse> instance, {
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
    if (data.containsKey('document_path')) {
      context.handle(
        _documentPathMeta,
        documentPath.isAcceptableOrUnknown(
          data['document_path']!,
          _documentPathMeta,
        ),
      );
    }
    if (data.containsKey('overall_score')) {
      context.handle(
        _overallScoreMeta,
        overallScore.isAcceptableOrUnknown(
          data['overall_score']!,
          _overallScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_overallScoreMeta);
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
    if (data.containsKey('engine_label')) {
      context.handle(
        _engineLabelMeta,
        engineLabel.isAcceptableOrUnknown(
          data['engine_label']!,
          _engineLabelMeta,
        ),
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
  ContractAnalyse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContractAnalyse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      documentPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_path'],
      ),
      overallScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overall_score'],
      )!,
      summaryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_json'],
      )!,
      engineLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_label'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ContractAnalysesTable createAlias(String alias) {
    return $ContractAnalysesTable(attachedDatabase, alias);
  }
}

class ContractAnalyse extends DataClass implements Insertable<ContractAnalyse> {
  /// Unique analysis ID.
  final String id;

  /// Analyzed document filename/title.
  final String title;

  /// Optional local document path.
  final String? documentPath;

  /// Aggregate 0-100 risk score.
  final int overallScore;

  /// JSON summary / risk factor breakdown.
  final String summaryJson;

  /// Engine provenance (`Gemma 4 · On-Device` / `Cloud · Gemma 4` / `Heuristic`).
  final String engineLabel;

  /// Analysis timestamp.
  final DateTime createdAt;
  const ContractAnalyse({
    required this.id,
    required this.title,
    this.documentPath,
    required this.overallScore,
    required this.summaryJson,
    required this.engineLabel,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || documentPath != null) {
      map['document_path'] = Variable<String>(documentPath);
    }
    map['overall_score'] = Variable<int>(overallScore);
    map['summary_json'] = Variable<String>(summaryJson);
    map['engine_label'] = Variable<String>(engineLabel);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ContractAnalysesCompanion toCompanion(bool nullToAbsent) {
    return ContractAnalysesCompanion(
      id: Value(id),
      title: Value(title),
      documentPath: documentPath == null && nullToAbsent
          ? const Value.absent()
          : Value(documentPath),
      overallScore: Value(overallScore),
      summaryJson: Value(summaryJson),
      engineLabel: Value(engineLabel),
      createdAt: Value(createdAt),
    );
  }

  factory ContractAnalyse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContractAnalyse(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      documentPath: serializer.fromJson<String?>(json['documentPath']),
      overallScore: serializer.fromJson<int>(json['overallScore']),
      summaryJson: serializer.fromJson<String>(json['summaryJson']),
      engineLabel: serializer.fromJson<String>(json['engineLabel']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'documentPath': serializer.toJson<String?>(documentPath),
      'overallScore': serializer.toJson<int>(overallScore),
      'summaryJson': serializer.toJson<String>(summaryJson),
      'engineLabel': serializer.toJson<String>(engineLabel),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ContractAnalyse copyWith({
    String? id,
    String? title,
    Value<String?> documentPath = const Value.absent(),
    int? overallScore,
    String? summaryJson,
    String? engineLabel,
    DateTime? createdAt,
  }) => ContractAnalyse(
    id: id ?? this.id,
    title: title ?? this.title,
    documentPath: documentPath.present ? documentPath.value : this.documentPath,
    overallScore: overallScore ?? this.overallScore,
    summaryJson: summaryJson ?? this.summaryJson,
    engineLabel: engineLabel ?? this.engineLabel,
    createdAt: createdAt ?? this.createdAt,
  );
  ContractAnalyse copyWithCompanion(ContractAnalysesCompanion data) {
    return ContractAnalyse(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      documentPath: data.documentPath.present
          ? data.documentPath.value
          : this.documentPath,
      overallScore: data.overallScore.present
          ? data.overallScore.value
          : this.overallScore,
      summaryJson: data.summaryJson.present
          ? data.summaryJson.value
          : this.summaryJson,
      engineLabel: data.engineLabel.present
          ? data.engineLabel.value
          : this.engineLabel,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContractAnalyse(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('documentPath: $documentPath, ')
          ..write('overallScore: $overallScore, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('engineLabel: $engineLabel, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    documentPath,
    overallScore,
    summaryJson,
    engineLabel,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContractAnalyse &&
          other.id == this.id &&
          other.title == this.title &&
          other.documentPath == this.documentPath &&
          other.overallScore == this.overallScore &&
          other.summaryJson == this.summaryJson &&
          other.engineLabel == this.engineLabel &&
          other.createdAt == this.createdAt);
}

class ContractAnalysesCompanion extends UpdateCompanion<ContractAnalyse> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> documentPath;
  final Value<int> overallScore;
  final Value<String> summaryJson;
  final Value<String> engineLabel;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ContractAnalysesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.documentPath = const Value.absent(),
    this.overallScore = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.engineLabel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContractAnalysesCompanion.insert({
    required String id,
    required String title,
    this.documentPath = const Value.absent(),
    required int overallScore,
    this.summaryJson = const Value.absent(),
    this.engineLabel = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       overallScore = Value(overallScore);
  static Insertable<ContractAnalyse> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? documentPath,
    Expression<int>? overallScore,
    Expression<String>? summaryJson,
    Expression<String>? engineLabel,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (documentPath != null) 'document_path': documentPath,
      if (overallScore != null) 'overall_score': overallScore,
      if (summaryJson != null) 'summary_json': summaryJson,
      if (engineLabel != null) 'engine_label': engineLabel,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContractAnalysesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? documentPath,
    Value<int>? overallScore,
    Value<String>? summaryJson,
    Value<String>? engineLabel,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ContractAnalysesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      documentPath: documentPath ?? this.documentPath,
      overallScore: overallScore ?? this.overallScore,
      summaryJson: summaryJson ?? this.summaryJson,
      engineLabel: engineLabel ?? this.engineLabel,
      createdAt: createdAt ?? this.createdAt,
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
    if (documentPath.present) {
      map['document_path'] = Variable<String>(documentPath.value);
    }
    if (overallScore.present) {
      map['overall_score'] = Variable<int>(overallScore.value);
    }
    if (summaryJson.present) {
      map['summary_json'] = Variable<String>(summaryJson.value);
    }
    if (engineLabel.present) {
      map['engine_label'] = Variable<String>(engineLabel.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractAnalysesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('documentPath: $documentPath, ')
          ..write('overallScore: $overallScore, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('engineLabel: $engineLabel, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RiskFindingsTable extends RiskFindings
    with TableInfo<$RiskFindingsTable, RiskFinding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RiskFindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisIdMeta = const VerificationMeta(
    'analysisId',
  );
  @override
  late final GeneratedColumn<String> analysisId = GeneratedColumn<String>(
    'analysis_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clauseTitleMeta = const VerificationMeta(
    'clauseTitle',
  );
  @override
  late final GeneratedColumn<String> clauseTitle = GeneratedColumn<String>(
    'clause_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clauseReferenceMeta = const VerificationMeta(
    'clauseReference',
  );
  @override
  late final GeneratedColumn<String> clauseReference = GeneratedColumn<String>(
    'clause_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _riskLevelMeta = const VerificationMeta(
    'riskLevel',
  );
  @override
  late final GeneratedColumn<String> riskLevel = GeneratedColumn<String>(
    'risk_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _riskCategoryMeta = const VerificationMeta(
    'riskCategory',
  );
  @override
  late final GeneratedColumn<String> riskCategory = GeneratedColumn<String>(
    'risk_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _originalTextMeta = const VerificationMeta(
    'originalText',
  );
  @override
  late final GeneratedColumn<String> originalText = GeneratedColumn<String>(
    'original_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _evidenceMeta = const VerificationMeta(
    'evidence',
  );
  @override
  late final GeneratedColumn<String> evidence = GeneratedColumn<String>(
    'evidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suggestedRewriteMeta = const VerificationMeta(
    'suggestedRewrite',
  );
  @override
  late final GeneratedColumn<String> suggestedRewrite = GeneratedColumn<String>(
    'suggested_rewrite',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appliedMeta = const VerificationMeta(
    'applied',
  );
  @override
  late final GeneratedColumn<bool> applied = GeneratedColumn<bool>(
    'applied',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("applied" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _verificationStatusMeta =
      const VerificationMeta('verificationStatus');
  @override
  late final GeneratedColumn<String> verificationStatus =
      GeneratedColumn<String>(
        'verification_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('review_required'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    analysisId,
    clauseTitle,
    clauseReference,
    pageNumber,
    riskLevel,
    riskCategory,
    originalText,
    explanation,
    evidence,
    suggestedRewrite,
    applied,
    verificationStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'risk_findings';
  @override
  VerificationContext validateIntegrity(
    Insertable<RiskFinding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('analysis_id')) {
      context.handle(
        _analysisIdMeta,
        analysisId.isAcceptableOrUnknown(data['analysis_id']!, _analysisIdMeta),
      );
    } else if (isInserting) {
      context.missing(_analysisIdMeta);
    }
    if (data.containsKey('clause_title')) {
      context.handle(
        _clauseTitleMeta,
        clauseTitle.isAcceptableOrUnknown(
          data['clause_title']!,
          _clauseTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clauseTitleMeta);
    }
    if (data.containsKey('clause_reference')) {
      context.handle(
        _clauseReferenceMeta,
        clauseReference.isAcceptableOrUnknown(
          data['clause_reference']!,
          _clauseReferenceMeta,
        ),
      );
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    }
    if (data.containsKey('risk_level')) {
      context.handle(
        _riskLevelMeta,
        riskLevel.isAcceptableOrUnknown(data['risk_level']!, _riskLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_riskLevelMeta);
    }
    if (data.containsKey('risk_category')) {
      context.handle(
        _riskCategoryMeta,
        riskCategory.isAcceptableOrUnknown(
          data['risk_category']!,
          _riskCategoryMeta,
        ),
      );
    }
    if (data.containsKey('original_text')) {
      context.handle(
        _originalTextMeta,
        originalText.isAcceptableOrUnknown(
          data['original_text']!,
          _originalTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalTextMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('evidence')) {
      context.handle(
        _evidenceMeta,
        evidence.isAcceptableOrUnknown(data['evidence']!, _evidenceMeta),
      );
    }
    if (data.containsKey('suggested_rewrite')) {
      context.handle(
        _suggestedRewriteMeta,
        suggestedRewrite.isAcceptableOrUnknown(
          data['suggested_rewrite']!,
          _suggestedRewriteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_suggestedRewriteMeta);
    }
    if (data.containsKey('applied')) {
      context.handle(
        _appliedMeta,
        applied.isAcceptableOrUnknown(data['applied']!, _appliedMeta),
      );
    }
    if (data.containsKey('verification_status')) {
      context.handle(
        _verificationStatusMeta,
        verificationStatus.isAcceptableOrUnknown(
          data['verification_status']!,
          _verificationStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RiskFinding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RiskFinding(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      analysisId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}analysis_id'],
      )!,
      clauseTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clause_title'],
      )!,
      clauseReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clause_reference'],
      ),
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      )!,
      riskLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}risk_level'],
      )!,
      riskCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}risk_category'],
      )!,
      originalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_text'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
      evidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence'],
      ),
      suggestedRewrite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_rewrite'],
      )!,
      applied: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}applied'],
      )!,
      verificationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification_status'],
      )!,
    );
  }

  @override
  $RiskFindingsTable createAlias(String alias) {
    return $RiskFindingsTable(attachedDatabase, alias);
  }
}

class RiskFinding extends DataClass implements Insertable<RiskFinding> {
  /// Unique finding ID.
  final String id;

  /// Owning [ContractAnalyses.id].
  final String analysisId;

  /// Clause heading.
  final String clauseTitle;

  /// Clause numbering or section reference.
  final String? clauseReference;

  /// 1-based page number if extracted from PDF/DOCX.
  final int pageNumber;

  /// Risk severity (`high`, `medium`, `low`).
  final String riskLevel;

  /// Legal risk category (e.g. `indemnity`, `termination`, `arbitration`).
  final String riskCategory;

  /// Verbatim clause excerpt.
  final String originalText;

  /// Plain-language legal risk explanation.
  final String explanation;

  /// Grounded statutory or evidence note.
  final String? evidence;

  /// Suggested safer rewrite.
  final String suggestedRewrite;

  /// Whether the user applied the safer rewrite.
  final bool applied;

  /// Verification state (`verified`, `review_required`).
  final String verificationStatus;
  const RiskFinding({
    required this.id,
    required this.analysisId,
    required this.clauseTitle,
    this.clauseReference,
    required this.pageNumber,
    required this.riskLevel,
    required this.riskCategory,
    required this.originalText,
    required this.explanation,
    this.evidence,
    required this.suggestedRewrite,
    required this.applied,
    required this.verificationStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['analysis_id'] = Variable<String>(analysisId);
    map['clause_title'] = Variable<String>(clauseTitle);
    if (!nullToAbsent || clauseReference != null) {
      map['clause_reference'] = Variable<String>(clauseReference);
    }
    map['page_number'] = Variable<int>(pageNumber);
    map['risk_level'] = Variable<String>(riskLevel);
    map['risk_category'] = Variable<String>(riskCategory);
    map['original_text'] = Variable<String>(originalText);
    map['explanation'] = Variable<String>(explanation);
    if (!nullToAbsent || evidence != null) {
      map['evidence'] = Variable<String>(evidence);
    }
    map['suggested_rewrite'] = Variable<String>(suggestedRewrite);
    map['applied'] = Variable<bool>(applied);
    map['verification_status'] = Variable<String>(verificationStatus);
    return map;
  }

  RiskFindingsCompanion toCompanion(bool nullToAbsent) {
    return RiskFindingsCompanion(
      id: Value(id),
      analysisId: Value(analysisId),
      clauseTitle: Value(clauseTitle),
      clauseReference: clauseReference == null && nullToAbsent
          ? const Value.absent()
          : Value(clauseReference),
      pageNumber: Value(pageNumber),
      riskLevel: Value(riskLevel),
      riskCategory: Value(riskCategory),
      originalText: Value(originalText),
      explanation: Value(explanation),
      evidence: evidence == null && nullToAbsent
          ? const Value.absent()
          : Value(evidence),
      suggestedRewrite: Value(suggestedRewrite),
      applied: Value(applied),
      verificationStatus: Value(verificationStatus),
    );
  }

  factory RiskFinding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RiskFinding(
      id: serializer.fromJson<String>(json['id']),
      analysisId: serializer.fromJson<String>(json['analysisId']),
      clauseTitle: serializer.fromJson<String>(json['clauseTitle']),
      clauseReference: serializer.fromJson<String?>(json['clauseReference']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      riskLevel: serializer.fromJson<String>(json['riskLevel']),
      riskCategory: serializer.fromJson<String>(json['riskCategory']),
      originalText: serializer.fromJson<String>(json['originalText']),
      explanation: serializer.fromJson<String>(json['explanation']),
      evidence: serializer.fromJson<String?>(json['evidence']),
      suggestedRewrite: serializer.fromJson<String>(json['suggestedRewrite']),
      applied: serializer.fromJson<bool>(json['applied']),
      verificationStatus: serializer.fromJson<String>(
        json['verificationStatus'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'analysisId': serializer.toJson<String>(analysisId),
      'clauseTitle': serializer.toJson<String>(clauseTitle),
      'clauseReference': serializer.toJson<String?>(clauseReference),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'riskLevel': serializer.toJson<String>(riskLevel),
      'riskCategory': serializer.toJson<String>(riskCategory),
      'originalText': serializer.toJson<String>(originalText),
      'explanation': serializer.toJson<String>(explanation),
      'evidence': serializer.toJson<String?>(evidence),
      'suggestedRewrite': serializer.toJson<String>(suggestedRewrite),
      'applied': serializer.toJson<bool>(applied),
      'verificationStatus': serializer.toJson<String>(verificationStatus),
    };
  }

  RiskFinding copyWith({
    String? id,
    String? analysisId,
    String? clauseTitle,
    Value<String?> clauseReference = const Value.absent(),
    int? pageNumber,
    String? riskLevel,
    String? riskCategory,
    String? originalText,
    String? explanation,
    Value<String?> evidence = const Value.absent(),
    String? suggestedRewrite,
    bool? applied,
    String? verificationStatus,
  }) => RiskFinding(
    id: id ?? this.id,
    analysisId: analysisId ?? this.analysisId,
    clauseTitle: clauseTitle ?? this.clauseTitle,
    clauseReference: clauseReference.present
        ? clauseReference.value
        : this.clauseReference,
    pageNumber: pageNumber ?? this.pageNumber,
    riskLevel: riskLevel ?? this.riskLevel,
    riskCategory: riskCategory ?? this.riskCategory,
    originalText: originalText ?? this.originalText,
    explanation: explanation ?? this.explanation,
    evidence: evidence.present ? evidence.value : this.evidence,
    suggestedRewrite: suggestedRewrite ?? this.suggestedRewrite,
    applied: applied ?? this.applied,
    verificationStatus: verificationStatus ?? this.verificationStatus,
  );
  RiskFinding copyWithCompanion(RiskFindingsCompanion data) {
    return RiskFinding(
      id: data.id.present ? data.id.value : this.id,
      analysisId: data.analysisId.present
          ? data.analysisId.value
          : this.analysisId,
      clauseTitle: data.clauseTitle.present
          ? data.clauseTitle.value
          : this.clauseTitle,
      clauseReference: data.clauseReference.present
          ? data.clauseReference.value
          : this.clauseReference,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      riskLevel: data.riskLevel.present ? data.riskLevel.value : this.riskLevel,
      riskCategory: data.riskCategory.present
          ? data.riskCategory.value
          : this.riskCategory,
      originalText: data.originalText.present
          ? data.originalText.value
          : this.originalText,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      evidence: data.evidence.present ? data.evidence.value : this.evidence,
      suggestedRewrite: data.suggestedRewrite.present
          ? data.suggestedRewrite.value
          : this.suggestedRewrite,
      applied: data.applied.present ? data.applied.value : this.applied,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RiskFinding(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('clauseTitle: $clauseTitle, ')
          ..write('clauseReference: $clauseReference, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('riskCategory: $riskCategory, ')
          ..write('originalText: $originalText, ')
          ..write('explanation: $explanation, ')
          ..write('evidence: $evidence, ')
          ..write('suggestedRewrite: $suggestedRewrite, ')
          ..write('applied: $applied, ')
          ..write('verificationStatus: $verificationStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    analysisId,
    clauseTitle,
    clauseReference,
    pageNumber,
    riskLevel,
    riskCategory,
    originalText,
    explanation,
    evidence,
    suggestedRewrite,
    applied,
    verificationStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RiskFinding &&
          other.id == this.id &&
          other.analysisId == this.analysisId &&
          other.clauseTitle == this.clauseTitle &&
          other.clauseReference == this.clauseReference &&
          other.pageNumber == this.pageNumber &&
          other.riskLevel == this.riskLevel &&
          other.riskCategory == this.riskCategory &&
          other.originalText == this.originalText &&
          other.explanation == this.explanation &&
          other.evidence == this.evidence &&
          other.suggestedRewrite == this.suggestedRewrite &&
          other.applied == this.applied &&
          other.verificationStatus == this.verificationStatus);
}

class RiskFindingsCompanion extends UpdateCompanion<RiskFinding> {
  final Value<String> id;
  final Value<String> analysisId;
  final Value<String> clauseTitle;
  final Value<String?> clauseReference;
  final Value<int> pageNumber;
  final Value<String> riskLevel;
  final Value<String> riskCategory;
  final Value<String> originalText;
  final Value<String> explanation;
  final Value<String?> evidence;
  final Value<String> suggestedRewrite;
  final Value<bool> applied;
  final Value<String> verificationStatus;
  final Value<int> rowid;
  const RiskFindingsCompanion({
    this.id = const Value.absent(),
    this.analysisId = const Value.absent(),
    this.clauseTitle = const Value.absent(),
    this.clauseReference = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.riskLevel = const Value.absent(),
    this.riskCategory = const Value.absent(),
    this.originalText = const Value.absent(),
    this.explanation = const Value.absent(),
    this.evidence = const Value.absent(),
    this.suggestedRewrite = const Value.absent(),
    this.applied = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RiskFindingsCompanion.insert({
    required String id,
    required String analysisId,
    required String clauseTitle,
    this.clauseReference = const Value.absent(),
    this.pageNumber = const Value.absent(),
    required String riskLevel,
    this.riskCategory = const Value.absent(),
    required String originalText,
    required String explanation,
    this.evidence = const Value.absent(),
    required String suggestedRewrite,
    this.applied = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       analysisId = Value(analysisId),
       clauseTitle = Value(clauseTitle),
       riskLevel = Value(riskLevel),
       originalText = Value(originalText),
       explanation = Value(explanation),
       suggestedRewrite = Value(suggestedRewrite);
  static Insertable<RiskFinding> custom({
    Expression<String>? id,
    Expression<String>? analysisId,
    Expression<String>? clauseTitle,
    Expression<String>? clauseReference,
    Expression<int>? pageNumber,
    Expression<String>? riskLevel,
    Expression<String>? riskCategory,
    Expression<String>? originalText,
    Expression<String>? explanation,
    Expression<String>? evidence,
    Expression<String>? suggestedRewrite,
    Expression<bool>? applied,
    Expression<String>? verificationStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (analysisId != null) 'analysis_id': analysisId,
      if (clauseTitle != null) 'clause_title': clauseTitle,
      if (clauseReference != null) 'clause_reference': clauseReference,
      if (pageNumber != null) 'page_number': pageNumber,
      if (riskLevel != null) 'risk_level': riskLevel,
      if (riskCategory != null) 'risk_category': riskCategory,
      if (originalText != null) 'original_text': originalText,
      if (explanation != null) 'explanation': explanation,
      if (evidence != null) 'evidence': evidence,
      if (suggestedRewrite != null) 'suggested_rewrite': suggestedRewrite,
      if (applied != null) 'applied': applied,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RiskFindingsCompanion copyWith({
    Value<String>? id,
    Value<String>? analysisId,
    Value<String>? clauseTitle,
    Value<String?>? clauseReference,
    Value<int>? pageNumber,
    Value<String>? riskLevel,
    Value<String>? riskCategory,
    Value<String>? originalText,
    Value<String>? explanation,
    Value<String?>? evidence,
    Value<String>? suggestedRewrite,
    Value<bool>? applied,
    Value<String>? verificationStatus,
    Value<int>? rowid,
  }) {
    return RiskFindingsCompanion(
      id: id ?? this.id,
      analysisId: analysisId ?? this.analysisId,
      clauseTitle: clauseTitle ?? this.clauseTitle,
      clauseReference: clauseReference ?? this.clauseReference,
      pageNumber: pageNumber ?? this.pageNumber,
      riskLevel: riskLevel ?? this.riskLevel,
      riskCategory: riskCategory ?? this.riskCategory,
      originalText: originalText ?? this.originalText,
      explanation: explanation ?? this.explanation,
      evidence: evidence ?? this.evidence,
      suggestedRewrite: suggestedRewrite ?? this.suggestedRewrite,
      applied: applied ?? this.applied,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (analysisId.present) {
      map['analysis_id'] = Variable<String>(analysisId.value);
    }
    if (clauseTitle.present) {
      map['clause_title'] = Variable<String>(clauseTitle.value);
    }
    if (clauseReference.present) {
      map['clause_reference'] = Variable<String>(clauseReference.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (riskLevel.present) {
      map['risk_level'] = Variable<String>(riskLevel.value);
    }
    if (riskCategory.present) {
      map['risk_category'] = Variable<String>(riskCategory.value);
    }
    if (originalText.present) {
      map['original_text'] = Variable<String>(originalText.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (evidence.present) {
      map['evidence'] = Variable<String>(evidence.value);
    }
    if (suggestedRewrite.present) {
      map['suggested_rewrite'] = Variable<String>(suggestedRewrite.value);
    }
    if (applied.present) {
      map['applied'] = Variable<bool>(applied.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(verificationStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RiskFindingsCompanion(')
          ..write('id: $id, ')
          ..write('analysisId: $analysisId, ')
          ..write('clauseTitle: $clauseTitle, ')
          ..write('clauseReference: $clauseReference, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('riskCategory: $riskCategory, ')
          ..write('originalText: $originalText, ')
          ..write('explanation: $explanation, ')
          ..write('evidence: $evidence, ')
          ..write('suggestedRewrite: $suggestedRewrite, ')
          ..write('applied: $applied, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegalKnowledgePacksTable extends LegalKnowledgePacks
    with TableInfo<$LegalKnowledgePacksTable, LegalKnowledgePack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalKnowledgePacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packNameMeta = const VerificationMeta(
    'packName',
  );
  @override
  late final GeneratedColumn<String> packName = GeneratedColumn<String>(
    'pack_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jurisdictionMeta = const VerificationMeta(
    'jurisdiction',
  );
  @override
  late final GeneratedColumn<String> jurisdiction = GeneratedColumn<String>(
    'jurisdiction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('India'),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceAuthorityMeta = const VerificationMeta(
    'sourceAuthority',
  );
  @override
  late final GeneratedColumn<String> sourceAuthority = GeneratedColumn<String>(
    'source_authority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publicationDateMeta = const VerificationMeta(
    'publicationDate',
  );
  @override
  late final GeneratedColumn<String> publicationDate = GeneratedColumn<String>(
    'publication_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<String> effectiveDate = GeneratedColumn<String>(
    'effective_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provisionCountMeta = const VerificationMeta(
    'provisionCount',
  );
  @override
  late final GeneratedColumn<int> provisionCount = GeneratedColumn<int>(
    'provision_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    packId,
    packName,
    jurisdiction,
    version,
    sourceAuthority,
    publicationDate,
    effectiveDate,
    sha256,
    provisionCount,
    sizeBytes,
    installedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_knowledge_packs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalKnowledgePack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('pack_name')) {
      context.handle(
        _packNameMeta,
        packName.isAcceptableOrUnknown(data['pack_name']!, _packNameMeta),
      );
    } else if (isInserting) {
      context.missing(_packNameMeta);
    }
    if (data.containsKey('jurisdiction')) {
      context.handle(
        _jurisdictionMeta,
        jurisdiction.isAcceptableOrUnknown(
          data['jurisdiction']!,
          _jurisdictionMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('source_authority')) {
      context.handle(
        _sourceAuthorityMeta,
        sourceAuthority.isAcceptableOrUnknown(
          data['source_authority']!,
          _sourceAuthorityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAuthorityMeta);
    }
    if (data.containsKey('publication_date')) {
      context.handle(
        _publicationDateMeta,
        publicationDate.isAcceptableOrUnknown(
          data['publication_date']!,
          _publicationDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publicationDateMeta);
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('provision_count')) {
      context.handle(
        _provisionCountMeta,
        provisionCount.isAcceptableOrUnknown(
          data['provision_count']!,
          _provisionCountMeta,
        ),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packId};
  @override
  LegalKnowledgePack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalKnowledgePack(
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      packName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_name'],
      )!,
      jurisdiction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jurisdiction'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      sourceAuthority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_authority'],
      )!,
      publicationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publication_date'],
      )!,
      effectiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_date'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      provisionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}provision_count'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      )!,
    );
  }

  @override
  $LegalKnowledgePacksTable createAlias(String alias) {
    return $LegalKnowledgePacksTable(attachedDatabase, alias);
  }
}

class LegalKnowledgePack extends DataClass
    implements Insertable<LegalKnowledgePack> {
  /// Unique pack ID (`constitution_in_2026_v1`, `bns_bnss_bsa_v1`, etc.).
  final String packId;

  /// Human-readable pack name.
  final String packName;

  /// Jurisdiction (`India`, `Central`, state code).
  final String jurisdiction;

  /// Semantic or date-based version string.
  final String version;

  /// Publishing authority (`Ministry of Law and Justice`, `India Code`).
  final String sourceAuthority;

  /// Official publication date (`YYYY-MM-DD`).
  final String publicationDate;

  /// Consolidated effective date (`YYYY-MM-DD`).
  final String effectiveDate;

  /// SHA-256 verification digest of the pack bundle.
  final String sha256;

  /// Number of indexed provisions inside this pack.
  final int provisionCount;

  /// Size on disk in bytes.
  final int sizeBytes;

  /// Installation timestamp.
  final DateTime installedAt;
  const LegalKnowledgePack({
    required this.packId,
    required this.packName,
    required this.jurisdiction,
    required this.version,
    required this.sourceAuthority,
    required this.publicationDate,
    required this.effectiveDate,
    required this.sha256,
    required this.provisionCount,
    required this.sizeBytes,
    required this.installedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pack_id'] = Variable<String>(packId);
    map['pack_name'] = Variable<String>(packName);
    map['jurisdiction'] = Variable<String>(jurisdiction);
    map['version'] = Variable<String>(version);
    map['source_authority'] = Variable<String>(sourceAuthority);
    map['publication_date'] = Variable<String>(publicationDate);
    map['effective_date'] = Variable<String>(effectiveDate);
    map['sha256'] = Variable<String>(sha256);
    map['provision_count'] = Variable<int>(provisionCount);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['installed_at'] = Variable<DateTime>(installedAt);
    return map;
  }

  LegalKnowledgePacksCompanion toCompanion(bool nullToAbsent) {
    return LegalKnowledgePacksCompanion(
      packId: Value(packId),
      packName: Value(packName),
      jurisdiction: Value(jurisdiction),
      version: Value(version),
      sourceAuthority: Value(sourceAuthority),
      publicationDate: Value(publicationDate),
      effectiveDate: Value(effectiveDate),
      sha256: Value(sha256),
      provisionCount: Value(provisionCount),
      sizeBytes: Value(sizeBytes),
      installedAt: Value(installedAt),
    );
  }

  factory LegalKnowledgePack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalKnowledgePack(
      packId: serializer.fromJson<String>(json['packId']),
      packName: serializer.fromJson<String>(json['packName']),
      jurisdiction: serializer.fromJson<String>(json['jurisdiction']),
      version: serializer.fromJson<String>(json['version']),
      sourceAuthority: serializer.fromJson<String>(json['sourceAuthority']),
      publicationDate: serializer.fromJson<String>(json['publicationDate']),
      effectiveDate: serializer.fromJson<String>(json['effectiveDate']),
      sha256: serializer.fromJson<String>(json['sha256']),
      provisionCount: serializer.fromJson<int>(json['provisionCount']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packId': serializer.toJson<String>(packId),
      'packName': serializer.toJson<String>(packName),
      'jurisdiction': serializer.toJson<String>(jurisdiction),
      'version': serializer.toJson<String>(version),
      'sourceAuthority': serializer.toJson<String>(sourceAuthority),
      'publicationDate': serializer.toJson<String>(publicationDate),
      'effectiveDate': serializer.toJson<String>(effectiveDate),
      'sha256': serializer.toJson<String>(sha256),
      'provisionCount': serializer.toJson<int>(provisionCount),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'installedAt': serializer.toJson<DateTime>(installedAt),
    };
  }

  LegalKnowledgePack copyWith({
    String? packId,
    String? packName,
    String? jurisdiction,
    String? version,
    String? sourceAuthority,
    String? publicationDate,
    String? effectiveDate,
    String? sha256,
    int? provisionCount,
    int? sizeBytes,
    DateTime? installedAt,
  }) => LegalKnowledgePack(
    packId: packId ?? this.packId,
    packName: packName ?? this.packName,
    jurisdiction: jurisdiction ?? this.jurisdiction,
    version: version ?? this.version,
    sourceAuthority: sourceAuthority ?? this.sourceAuthority,
    publicationDate: publicationDate ?? this.publicationDate,
    effectiveDate: effectiveDate ?? this.effectiveDate,
    sha256: sha256 ?? this.sha256,
    provisionCount: provisionCount ?? this.provisionCount,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    installedAt: installedAt ?? this.installedAt,
  );
  LegalKnowledgePack copyWithCompanion(LegalKnowledgePacksCompanion data) {
    return LegalKnowledgePack(
      packId: data.packId.present ? data.packId.value : this.packId,
      packName: data.packName.present ? data.packName.value : this.packName,
      jurisdiction: data.jurisdiction.present
          ? data.jurisdiction.value
          : this.jurisdiction,
      version: data.version.present ? data.version.value : this.version,
      sourceAuthority: data.sourceAuthority.present
          ? data.sourceAuthority.value
          : this.sourceAuthority,
      publicationDate: data.publicationDate.present
          ? data.publicationDate.value
          : this.publicationDate,
      effectiveDate: data.effectiveDate.present
          ? data.effectiveDate.value
          : this.effectiveDate,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      provisionCount: data.provisionCount.present
          ? data.provisionCount.value
          : this.provisionCount,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalKnowledgePack(')
          ..write('packId: $packId, ')
          ..write('packName: $packName, ')
          ..write('jurisdiction: $jurisdiction, ')
          ..write('version: $version, ')
          ..write('sourceAuthority: $sourceAuthority, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('sha256: $sha256, ')
          ..write('provisionCount: $provisionCount, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('installedAt: $installedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    packId,
    packName,
    jurisdiction,
    version,
    sourceAuthority,
    publicationDate,
    effectiveDate,
    sha256,
    provisionCount,
    sizeBytes,
    installedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalKnowledgePack &&
          other.packId == this.packId &&
          other.packName == this.packName &&
          other.jurisdiction == this.jurisdiction &&
          other.version == this.version &&
          other.sourceAuthority == this.sourceAuthority &&
          other.publicationDate == this.publicationDate &&
          other.effectiveDate == this.effectiveDate &&
          other.sha256 == this.sha256 &&
          other.provisionCount == this.provisionCount &&
          other.sizeBytes == this.sizeBytes &&
          other.installedAt == this.installedAt);
}

class LegalKnowledgePacksCompanion extends UpdateCompanion<LegalKnowledgePack> {
  final Value<String> packId;
  final Value<String> packName;
  final Value<String> jurisdiction;
  final Value<String> version;
  final Value<String> sourceAuthority;
  final Value<String> publicationDate;
  final Value<String> effectiveDate;
  final Value<String> sha256;
  final Value<int> provisionCount;
  final Value<int> sizeBytes;
  final Value<DateTime> installedAt;
  final Value<int> rowid;
  const LegalKnowledgePacksCompanion({
    this.packId = const Value.absent(),
    this.packName = const Value.absent(),
    this.jurisdiction = const Value.absent(),
    this.version = const Value.absent(),
    this.sourceAuthority = const Value.absent(),
    this.publicationDate = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.provisionCount = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalKnowledgePacksCompanion.insert({
    required String packId,
    required String packName,
    this.jurisdiction = const Value.absent(),
    required String version,
    required String sourceAuthority,
    required String publicationDate,
    required String effectiveDate,
    required String sha256,
    this.provisionCount = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : packId = Value(packId),
       packName = Value(packName),
       version = Value(version),
       sourceAuthority = Value(sourceAuthority),
       publicationDate = Value(publicationDate),
       effectiveDate = Value(effectiveDate),
       sha256 = Value(sha256);
  static Insertable<LegalKnowledgePack> custom({
    Expression<String>? packId,
    Expression<String>? packName,
    Expression<String>? jurisdiction,
    Expression<String>? version,
    Expression<String>? sourceAuthority,
    Expression<String>? publicationDate,
    Expression<String>? effectiveDate,
    Expression<String>? sha256,
    Expression<int>? provisionCount,
    Expression<int>? sizeBytes,
    Expression<DateTime>? installedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (packId != null) 'pack_id': packId,
      if (packName != null) 'pack_name': packName,
      if (jurisdiction != null) 'jurisdiction': jurisdiction,
      if (version != null) 'version': version,
      if (sourceAuthority != null) 'source_authority': sourceAuthority,
      if (publicationDate != null) 'publication_date': publicationDate,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (sha256 != null) 'sha256': sha256,
      if (provisionCount != null) 'provision_count': provisionCount,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (installedAt != null) 'installed_at': installedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalKnowledgePacksCompanion copyWith({
    Value<String>? packId,
    Value<String>? packName,
    Value<String>? jurisdiction,
    Value<String>? version,
    Value<String>? sourceAuthority,
    Value<String>? publicationDate,
    Value<String>? effectiveDate,
    Value<String>? sha256,
    Value<int>? provisionCount,
    Value<int>? sizeBytes,
    Value<DateTime>? installedAt,
    Value<int>? rowid,
  }) {
    return LegalKnowledgePacksCompanion(
      packId: packId ?? this.packId,
      packName: packName ?? this.packName,
      jurisdiction: jurisdiction ?? this.jurisdiction,
      version: version ?? this.version,
      sourceAuthority: sourceAuthority ?? this.sourceAuthority,
      publicationDate: publicationDate ?? this.publicationDate,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      sha256: sha256 ?? this.sha256,
      provisionCount: provisionCount ?? this.provisionCount,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      installedAt: installedAt ?? this.installedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (packName.present) {
      map['pack_name'] = Variable<String>(packName.value);
    }
    if (jurisdiction.present) {
      map['jurisdiction'] = Variable<String>(jurisdiction.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (sourceAuthority.present) {
      map['source_authority'] = Variable<String>(sourceAuthority.value);
    }
    if (publicationDate.present) {
      map['publication_date'] = Variable<String>(publicationDate.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<String>(effectiveDate.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (provisionCount.present) {
      map['provision_count'] = Variable<int>(provisionCount.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalKnowledgePacksCompanion(')
          ..write('packId: $packId, ')
          ..write('packName: $packName, ')
          ..write('jurisdiction: $jurisdiction, ')
          ..write('version: $version, ')
          ..write('sourceAuthority: $sourceAuthority, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('sha256: $sha256, ')
          ..write('provisionCount: $provisionCount, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('installedAt: $installedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComplianceRecordsTable extends ComplianceRecords
    with TableInfo<$ComplianceRecordsTable, ComplianceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComplianceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frameworkMeta = const VerificationMeta(
    'framework',
  );
  @override
  late final GeneratedColumn<String> framework = GeneratedColumn<String>(
    'framework',
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
  static const VerificationMeta _citationRefMeta = const VerificationMeta(
    'citationRef',
  );
  @override
  late final GeneratedColumn<String> citationRef = GeneratedColumn<String>(
    'citation_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceAuthorityMeta = const VerificationMeta(
    'sourceAuthority',
  );
  @override
  late final GeneratedColumn<String> sourceAuthority = GeneratedColumn<String>(
    'source_authority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<String> effectiveDate = GeneratedColumn<String>(
    'effective_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verificationStatusMeta =
      const VerificationMeta('verificationStatus');
  @override
  late final GeneratedColumn<String> verificationStatus =
      GeneratedColumn<String>(
        'verification_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    framework,
    title,
    citationRef,
    sourceAuthority,
    effectiveDate,
    verificationStatus,
    status,
    notes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compliance_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComplianceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('framework')) {
      context.handle(
        _frameworkMeta,
        framework.isAcceptableOrUnknown(data['framework']!, _frameworkMeta),
      );
    } else if (isInserting) {
      context.missing(_frameworkMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('citation_ref')) {
      context.handle(
        _citationRefMeta,
        citationRef.isAcceptableOrUnknown(
          data['citation_ref']!,
          _citationRefMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_citationRefMeta);
    }
    if (data.containsKey('source_authority')) {
      context.handle(
        _sourceAuthorityMeta,
        sourceAuthority.isAcceptableOrUnknown(
          data['source_authority']!,
          _sourceAuthorityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAuthorityMeta);
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    if (data.containsKey('verification_status')) {
      context.handle(
        _verificationStatusMeta,
        verificationStatus.isAcceptableOrUnknown(
          data['verification_status']!,
          _verificationStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verificationStatusMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
  ComplianceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComplianceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      framework: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}framework'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      citationRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}citation_ref'],
      )!,
      sourceAuthority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_authority'],
      )!,
      effectiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_date'],
      )!,
      verificationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification_status'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ComplianceRecordsTable createAlias(String alias) {
    return $ComplianceRecordsTable(attachedDatabase, alias);
  }
}

class ComplianceRecord extends DataClass
    implements Insertable<ComplianceRecord> {
  /// Unique record ID.
  final String id;

  /// Compliance framework (`DPDP_2023`, `STARTUP_LABOUR`, etc.).
  final String framework;

  /// Requirement title.
  final String title;

  /// Statutory citation reference (`DPDP:8`, etc.).
  final String citationRef;

  /// Official authority.
  final String sourceAuthority;

  /// Effective / commencement status date.
  final String effectiveDate;

  /// Verification status (`verified`, `partial`, `pending_review`).
  final String verificationStatus;

  /// User progress (`pending`, `in_progress`, `completed`, `not_applicable`).
  final String status;

  /// Optional user compliance note.
  final String notes;

  /// Last update timestamp.
  final DateTime updatedAt;
  const ComplianceRecord({
    required this.id,
    required this.framework,
    required this.title,
    required this.citationRef,
    required this.sourceAuthority,
    required this.effectiveDate,
    required this.verificationStatus,
    required this.status,
    required this.notes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['framework'] = Variable<String>(framework);
    map['title'] = Variable<String>(title);
    map['citation_ref'] = Variable<String>(citationRef);
    map['source_authority'] = Variable<String>(sourceAuthority);
    map['effective_date'] = Variable<String>(effectiveDate);
    map['verification_status'] = Variable<String>(verificationStatus);
    map['status'] = Variable<String>(status);
    map['notes'] = Variable<String>(notes);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ComplianceRecordsCompanion toCompanion(bool nullToAbsent) {
    return ComplianceRecordsCompanion(
      id: Value(id),
      framework: Value(framework),
      title: Value(title),
      citationRef: Value(citationRef),
      sourceAuthority: Value(sourceAuthority),
      effectiveDate: Value(effectiveDate),
      verificationStatus: Value(verificationStatus),
      status: Value(status),
      notes: Value(notes),
      updatedAt: Value(updatedAt),
    );
  }

  factory ComplianceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComplianceRecord(
      id: serializer.fromJson<String>(json['id']),
      framework: serializer.fromJson<String>(json['framework']),
      title: serializer.fromJson<String>(json['title']),
      citationRef: serializer.fromJson<String>(json['citationRef']),
      sourceAuthority: serializer.fromJson<String>(json['sourceAuthority']),
      effectiveDate: serializer.fromJson<String>(json['effectiveDate']),
      verificationStatus: serializer.fromJson<String>(
        json['verificationStatus'],
      ),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'framework': serializer.toJson<String>(framework),
      'title': serializer.toJson<String>(title),
      'citationRef': serializer.toJson<String>(citationRef),
      'sourceAuthority': serializer.toJson<String>(sourceAuthority),
      'effectiveDate': serializer.toJson<String>(effectiveDate),
      'verificationStatus': serializer.toJson<String>(verificationStatus),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ComplianceRecord copyWith({
    String? id,
    String? framework,
    String? title,
    String? citationRef,
    String? sourceAuthority,
    String? effectiveDate,
    String? verificationStatus,
    String? status,
    String? notes,
    DateTime? updatedAt,
  }) => ComplianceRecord(
    id: id ?? this.id,
    framework: framework ?? this.framework,
    title: title ?? this.title,
    citationRef: citationRef ?? this.citationRef,
    sourceAuthority: sourceAuthority ?? this.sourceAuthority,
    effectiveDate: effectiveDate ?? this.effectiveDate,
    verificationStatus: verificationStatus ?? this.verificationStatus,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ComplianceRecord copyWithCompanion(ComplianceRecordsCompanion data) {
    return ComplianceRecord(
      id: data.id.present ? data.id.value : this.id,
      framework: data.framework.present ? data.framework.value : this.framework,
      title: data.title.present ? data.title.value : this.title,
      citationRef: data.citationRef.present
          ? data.citationRef.value
          : this.citationRef,
      sourceAuthority: data.sourceAuthority.present
          ? data.sourceAuthority.value
          : this.sourceAuthority,
      effectiveDate: data.effectiveDate.present
          ? data.effectiveDate.value
          : this.effectiveDate,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComplianceRecord(')
          ..write('id: $id, ')
          ..write('framework: $framework, ')
          ..write('title: $title, ')
          ..write('citationRef: $citationRef, ')
          ..write('sourceAuthority: $sourceAuthority, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    framework,
    title,
    citationRef,
    sourceAuthority,
    effectiveDate,
    verificationStatus,
    status,
    notes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComplianceRecord &&
          other.id == this.id &&
          other.framework == this.framework &&
          other.title == this.title &&
          other.citationRef == this.citationRef &&
          other.sourceAuthority == this.sourceAuthority &&
          other.effectiveDate == this.effectiveDate &&
          other.verificationStatus == this.verificationStatus &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt);
}

class ComplianceRecordsCompanion extends UpdateCompanion<ComplianceRecord> {
  final Value<String> id;
  final Value<String> framework;
  final Value<String> title;
  final Value<String> citationRef;
  final Value<String> sourceAuthority;
  final Value<String> effectiveDate;
  final Value<String> verificationStatus;
  final Value<String> status;
  final Value<String> notes;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ComplianceRecordsCompanion({
    this.id = const Value.absent(),
    this.framework = const Value.absent(),
    this.title = const Value.absent(),
    this.citationRef = const Value.absent(),
    this.sourceAuthority = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ComplianceRecordsCompanion.insert({
    required String id,
    required String framework,
    required String title,
    required String citationRef,
    required String sourceAuthority,
    required String effectiveDate,
    required String verificationStatus,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       framework = Value(framework),
       title = Value(title),
       citationRef = Value(citationRef),
       sourceAuthority = Value(sourceAuthority),
       effectiveDate = Value(effectiveDate),
       verificationStatus = Value(verificationStatus);
  static Insertable<ComplianceRecord> custom({
    Expression<String>? id,
    Expression<String>? framework,
    Expression<String>? title,
    Expression<String>? citationRef,
    Expression<String>? sourceAuthority,
    Expression<String>? effectiveDate,
    Expression<String>? verificationStatus,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (framework != null) 'framework': framework,
      if (title != null) 'title': title,
      if (citationRef != null) 'citation_ref': citationRef,
      if (sourceAuthority != null) 'source_authority': sourceAuthority,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ComplianceRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? framework,
    Value<String>? title,
    Value<String>? citationRef,
    Value<String>? sourceAuthority,
    Value<String>? effectiveDate,
    Value<String>? verificationStatus,
    Value<String>? status,
    Value<String>? notes,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ComplianceRecordsCompanion(
      id: id ?? this.id,
      framework: framework ?? this.framework,
      title: title ?? this.title,
      citationRef: citationRef ?? this.citationRef,
      sourceAuthority: sourceAuthority ?? this.sourceAuthority,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      status: status ?? this.status,
      notes: notes ?? this.notes,
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
    if (framework.present) {
      map['framework'] = Variable<String>(framework.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (citationRef.present) {
      map['citation_ref'] = Variable<String>(citationRef.value);
    }
    if (sourceAuthority.present) {
      map['source_authority'] = Variable<String>(sourceAuthority.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<String>(effectiveDate.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(verificationStatus.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('ComplianceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('framework: $framework, ')
          ..write('title: $title, ')
          ..write('citationRef: $citationRef, ')
          ..write('sourceAuthority: $sourceAuthority, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiExecutionLogsTable extends AiExecutionLogs
    with TableInfo<$AiExecutionLogsTable, AiExecutionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiExecutionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskKindMeta = const VerificationMeta(
    'taskKind',
  );
  @override
  late final GeneratedColumn<String> taskKind = GeneratedColumn<String>(
    'task_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _engineLabelMeta = const VerificationMeta(
    'engineLabel',
  );
  @override
  late final GeneratedColumn<String> engineLabel = GeneratedColumn<String>(
    'engine_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latencyMsMeta = const VerificationMeta(
    'latencyMs',
  );
  @override
  late final GeneratedColumn<int> latencyMs = GeneratedColumn<int>(
    'latency_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenEstimateMeta = const VerificationMeta(
    'tokenEstimate',
  );
  @override
  late final GeneratedColumn<int> tokenEstimate = GeneratedColumn<int>(
    'token_estimate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _successMeta = const VerificationMeta(
    'success',
  );
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
    'success',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success" IN (0, 1))',
    ),
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
    taskKind,
    engineLabel,
    latencyMs,
    tokenEstimate,
    success,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_execution_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiExecutionLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_kind')) {
      context.handle(
        _taskKindMeta,
        taskKind.isAcceptableOrUnknown(data['task_kind']!, _taskKindMeta),
      );
    } else if (isInserting) {
      context.missing(_taskKindMeta);
    }
    if (data.containsKey('engine_label')) {
      context.handle(
        _engineLabelMeta,
        engineLabel.isAcceptableOrUnknown(
          data['engine_label']!,
          _engineLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_engineLabelMeta);
    }
    if (data.containsKey('latency_ms')) {
      context.handle(
        _latencyMsMeta,
        latencyMs.isAcceptableOrUnknown(data['latency_ms']!, _latencyMsMeta),
      );
    } else if (isInserting) {
      context.missing(_latencyMsMeta);
    }
    if (data.containsKey('token_estimate')) {
      context.handle(
        _tokenEstimateMeta,
        tokenEstimate.isAcceptableOrUnknown(
          data['token_estimate']!,
          _tokenEstimateMeta,
        ),
      );
    }
    if (data.containsKey('success')) {
      context.handle(
        _successMeta,
        success.isAcceptableOrUnknown(data['success']!, _successMeta),
      );
    } else if (isInserting) {
      context.missing(_successMeta);
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
  AiExecutionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiExecutionLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_kind'],
      )!,
      engineLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine_label'],
      )!,
      latencyMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}latency_ms'],
      )!,
      tokenEstimate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}token_estimate'],
      )!,
      success: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}success'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AiExecutionLogsTable createAlias(String alias) {
    return $AiExecutionLogsTable(attachedDatabase, alias);
  }
}

class AiExecutionLog extends DataClass implements Insertable<AiExecutionLog> {
  /// Unique event ID.
  final String id;

  /// Task category (`chat`, `scan`, `contract`, `draft`, `incident`).
  final String taskKind;

  /// Active engine (`Gemma 4 E2B · On-Device`, `Cloud · Gemma 4`, etc.).
  final String engineLabel;

  /// Duration in milliseconds.
  final int latencyMs;

  /// Estimated token count (no raw text).
  final int tokenEstimate;

  /// Whether execution completed cleanly.
  final bool success;

  /// Execution timestamp.
  final DateTime createdAt;
  const AiExecutionLog({
    required this.id,
    required this.taskKind,
    required this.engineLabel,
    required this.latencyMs,
    required this.tokenEstimate,
    required this.success,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_kind'] = Variable<String>(taskKind);
    map['engine_label'] = Variable<String>(engineLabel);
    map['latency_ms'] = Variable<int>(latencyMs);
    map['token_estimate'] = Variable<int>(tokenEstimate);
    map['success'] = Variable<bool>(success);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AiExecutionLogsCompanion toCompanion(bool nullToAbsent) {
    return AiExecutionLogsCompanion(
      id: Value(id),
      taskKind: Value(taskKind),
      engineLabel: Value(engineLabel),
      latencyMs: Value(latencyMs),
      tokenEstimate: Value(tokenEstimate),
      success: Value(success),
      createdAt: Value(createdAt),
    );
  }

  factory AiExecutionLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiExecutionLog(
      id: serializer.fromJson<String>(json['id']),
      taskKind: serializer.fromJson<String>(json['taskKind']),
      engineLabel: serializer.fromJson<String>(json['engineLabel']),
      latencyMs: serializer.fromJson<int>(json['latencyMs']),
      tokenEstimate: serializer.fromJson<int>(json['tokenEstimate']),
      success: serializer.fromJson<bool>(json['success']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskKind': serializer.toJson<String>(taskKind),
      'engineLabel': serializer.toJson<String>(engineLabel),
      'latencyMs': serializer.toJson<int>(latencyMs),
      'tokenEstimate': serializer.toJson<int>(tokenEstimate),
      'success': serializer.toJson<bool>(success),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AiExecutionLog copyWith({
    String? id,
    String? taskKind,
    String? engineLabel,
    int? latencyMs,
    int? tokenEstimate,
    bool? success,
    DateTime? createdAt,
  }) => AiExecutionLog(
    id: id ?? this.id,
    taskKind: taskKind ?? this.taskKind,
    engineLabel: engineLabel ?? this.engineLabel,
    latencyMs: latencyMs ?? this.latencyMs,
    tokenEstimate: tokenEstimate ?? this.tokenEstimate,
    success: success ?? this.success,
    createdAt: createdAt ?? this.createdAt,
  );
  AiExecutionLog copyWithCompanion(AiExecutionLogsCompanion data) {
    return AiExecutionLog(
      id: data.id.present ? data.id.value : this.id,
      taskKind: data.taskKind.present ? data.taskKind.value : this.taskKind,
      engineLabel: data.engineLabel.present
          ? data.engineLabel.value
          : this.engineLabel,
      latencyMs: data.latencyMs.present ? data.latencyMs.value : this.latencyMs,
      tokenEstimate: data.tokenEstimate.present
          ? data.tokenEstimate.value
          : this.tokenEstimate,
      success: data.success.present ? data.success.value : this.success,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiExecutionLog(')
          ..write('id: $id, ')
          ..write('taskKind: $taskKind, ')
          ..write('engineLabel: $engineLabel, ')
          ..write('latencyMs: $latencyMs, ')
          ..write('tokenEstimate: $tokenEstimate, ')
          ..write('success: $success, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskKind,
    engineLabel,
    latencyMs,
    tokenEstimate,
    success,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiExecutionLog &&
          other.id == this.id &&
          other.taskKind == this.taskKind &&
          other.engineLabel == this.engineLabel &&
          other.latencyMs == this.latencyMs &&
          other.tokenEstimate == this.tokenEstimate &&
          other.success == this.success &&
          other.createdAt == this.createdAt);
}

class AiExecutionLogsCompanion extends UpdateCompanion<AiExecutionLog> {
  final Value<String> id;
  final Value<String> taskKind;
  final Value<String> engineLabel;
  final Value<int> latencyMs;
  final Value<int> tokenEstimate;
  final Value<bool> success;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AiExecutionLogsCompanion({
    this.id = const Value.absent(),
    this.taskKind = const Value.absent(),
    this.engineLabel = const Value.absent(),
    this.latencyMs = const Value.absent(),
    this.tokenEstimate = const Value.absent(),
    this.success = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiExecutionLogsCompanion.insert({
    required String id,
    required String taskKind,
    required String engineLabel,
    required int latencyMs,
    this.tokenEstimate = const Value.absent(),
    required bool success,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskKind = Value(taskKind),
       engineLabel = Value(engineLabel),
       latencyMs = Value(latencyMs),
       success = Value(success);
  static Insertable<AiExecutionLog> custom({
    Expression<String>? id,
    Expression<String>? taskKind,
    Expression<String>? engineLabel,
    Expression<int>? latencyMs,
    Expression<int>? tokenEstimate,
    Expression<bool>? success,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskKind != null) 'task_kind': taskKind,
      if (engineLabel != null) 'engine_label': engineLabel,
      if (latencyMs != null) 'latency_ms': latencyMs,
      if (tokenEstimate != null) 'token_estimate': tokenEstimate,
      if (success != null) 'success': success,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiExecutionLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskKind,
    Value<String>? engineLabel,
    Value<int>? latencyMs,
    Value<int>? tokenEstimate,
    Value<bool>? success,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AiExecutionLogsCompanion(
      id: id ?? this.id,
      taskKind: taskKind ?? this.taskKind,
      engineLabel: engineLabel ?? this.engineLabel,
      latencyMs: latencyMs ?? this.latencyMs,
      tokenEstimate: tokenEstimate ?? this.tokenEstimate,
      success: success ?? this.success,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskKind.present) {
      map['task_kind'] = Variable<String>(taskKind.value);
    }
    if (engineLabel.present) {
      map['engine_label'] = Variable<String>(engineLabel.value);
    }
    if (latencyMs.present) {
      map['latency_ms'] = Variable<int>(latencyMs.value);
    }
    if (tokenEstimate.present) {
      map['token_estimate'] = Variable<int>(tokenEstimate.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiExecutionLogsCompanion(')
          ..write('id: $id, ')
          ..write('taskKind: $taskKind, ')
          ..write('engineLabel: $engineLabel, ')
          ..write('latencyMs: $latencyMs, ')
          ..write('tokenEstimate: $tokenEstimate, ')
          ..write('success: $success, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditEventsTable extends AuditEvents
    with TableInfo<$AuditEventsTable, AuditEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, eventType, summary, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
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
  AuditEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuditEventsTable createAlias(String alias) {
    return $AuditEventsTable(attachedDatabase, alias);
  }
}

class AuditEvent extends DataClass implements Insertable<AuditEvent> {
  /// Unique event ID.
  final String id;

  /// Event code (`cloud_consent_granted`, `cloud_consent_denied`, `vault_wiped`).
  final String eventType;

  /// Safe audit description without personal identifiers.
  final String summary;

  /// Event timestamp.
  final DateTime createdAt;
  const AuditEvent({
    required this.id,
    required this.eventType,
    required this.summary,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_type'] = Variable<String>(eventType);
    map['summary'] = Variable<String>(summary);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditEventsCompanion toCompanion(bool nullToAbsent) {
    return AuditEventsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      summary: Value(summary),
      createdAt: Value(createdAt),
    );
  }

  factory AuditEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditEvent(
      id: serializer.fromJson<String>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      summary: serializer.fromJson<String>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventType': serializer.toJson<String>(eventType),
      'summary': serializer.toJson<String>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditEvent copyWith({
    String? id,
    String? eventType,
    String? summary,
    DateTime? createdAt,
  }) => AuditEvent(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    summary: summary ?? this.summary,
    createdAt: createdAt ?? this.createdAt,
  );
  AuditEvent copyWithCompanion(AuditEventsCompanion data) {
    return AuditEvent(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditEvent(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventType, summary, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditEvent &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt);
}

class AuditEventsCompanion extends UpdateCompanion<AuditEvent> {
  final Value<String> id;
  final Value<String> eventType;
  final Value<String> summary;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuditEventsCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditEventsCompanion.insert({
    required String id,
    required String eventType,
    required String summary,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventType = Value(eventType),
       summary = Value(summary);
  static Insertable<AuditEvent> custom({
    Expression<String>? id,
    Expression<String>? eventType,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventType,
    Value<String>? summary,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AuditEventsCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditEventsCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegalInstrumentsTable extends LegalInstruments
    with TableInfo<$LegalInstrumentsTable, LegalInstrument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalInstrumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _instrumentIdMeta = const VerificationMeta(
    'instrumentId',
  );
  @override
  late final GeneratedColumn<String> instrumentId = GeneratedColumn<String>(
    'instrument_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instrumentTypeMeta = const VerificationMeta(
    'instrumentType',
  );
  @override
  late final GeneratedColumn<String> instrumentType = GeneratedColumn<String>(
    'instrument_type',
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
  static const VerificationMeta _shortCodeMeta = const VerificationMeta(
    'shortCode',
  );
  @override
  late final GeneratedColumn<String> shortCode = GeneratedColumn<String>(
    'short_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editionDateMeta = const VerificationMeta(
    'editionDate',
  );
  @override
  late final GeneratedColumn<String> editionDate = GeneratedColumn<String>(
    'edition_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceAuthorityMeta = const VerificationMeta(
    'sourceAuthority',
  );
  @override
  late final GeneratedColumn<String> sourceAuthority = GeneratedColumn<String>(
    'source_authority',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fullTextAvailableMeta = const VerificationMeta(
    'fullTextAvailable',
  );
  @override
  late final GeneratedColumn<bool> fullTextAvailable = GeneratedColumn<bool>(
    'full_text_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("full_text_available" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _verificationStatusMeta =
      const VerificationMeta('verificationStatus');
  @override
  late final GeneratedColumn<String> verificationStatus =
      GeneratedColumn<String>(
        'verification_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending_review'),
      );
  static const VerificationMeta _provisionCountMeta = const VerificationMeta(
    'provisionCount',
  );
  @override
  late final GeneratedColumn<int> provisionCount = GeneratedColumn<int>(
    'provision_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    instrumentId,
    instrumentType,
    title,
    shortCode,
    editionDate,
    sourceAuthority,
    sourceUrl,
    fullTextAvailable,
    verificationStatus,
    provisionCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_instruments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalInstrument> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('instrument_id')) {
      context.handle(
        _instrumentIdMeta,
        instrumentId.isAcceptableOrUnknown(
          data['instrument_id']!,
          _instrumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instrumentIdMeta);
    }
    if (data.containsKey('instrument_type')) {
      context.handle(
        _instrumentTypeMeta,
        instrumentType.isAcceptableOrUnknown(
          data['instrument_type']!,
          _instrumentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instrumentTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('short_code')) {
      context.handle(
        _shortCodeMeta,
        shortCode.isAcceptableOrUnknown(data['short_code']!, _shortCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_shortCodeMeta);
    }
    if (data.containsKey('edition_date')) {
      context.handle(
        _editionDateMeta,
        editionDate.isAcceptableOrUnknown(
          data['edition_date']!,
          _editionDateMeta,
        ),
      );
    }
    if (data.containsKey('source_authority')) {
      context.handle(
        _sourceAuthorityMeta,
        sourceAuthority.isAcceptableOrUnknown(
          data['source_authority']!,
          _sourceAuthorityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAuthorityMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('full_text_available')) {
      context.handle(
        _fullTextAvailableMeta,
        fullTextAvailable.isAcceptableOrUnknown(
          data['full_text_available']!,
          _fullTextAvailableMeta,
        ),
      );
    }
    if (data.containsKey('verification_status')) {
      context.handle(
        _verificationStatusMeta,
        verificationStatus.isAcceptableOrUnknown(
          data['verification_status']!,
          _verificationStatusMeta,
        ),
      );
    }
    if (data.containsKey('provision_count')) {
      context.handle(
        _provisionCountMeta,
        provisionCount.isAcceptableOrUnknown(
          data['provision_count']!,
          _provisionCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {instrumentId};
  @override
  LegalInstrument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalInstrument(
      instrumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instrument_id'],
      )!,
      instrumentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instrument_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      shortCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_code'],
      )!,
      editionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_date'],
      ),
      sourceAuthority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_authority'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      fullTextAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}full_text_available'],
      )!,
      verificationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification_status'],
      )!,
      provisionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}provision_count'],
      )!,
    );
  }

  @override
  $LegalInstrumentsTable createAlias(String alias) {
    return $LegalInstrumentsTable(attachedDatabase, alias);
  }
}

class LegalInstrument extends DataClass implements Insertable<LegalInstrument> {
  /// Canonical instrument ID (`CONST_IN_2026`, `DPDP_2023`, `IT_2000`, `ICA_1872`).
  final String instrumentId;

  /// Category (`constitution`, `central_act`, `state_act`, `amendment_act`, `constitutional_order`).
  final String instrumentType;

  /// Official title.
  final String title;

  /// Normalized short code (`CONST`, `DPDP_2023`, `IT_2000`).
  final String shortCode;

  /// Consolidation / publication date (`YYYY-MM-DD`).
  final String? editionDate;

  /// Authoritative government source authority.
  final String sourceAuthority;

  /// Official India Code / MeitY / Gazette source URL.
  final String? sourceUrl;

  /// Whether verified verbatim section text is present locally.
  final bool fullTextAvailable;

  /// Verification state (`verified_in_book`, `verified`, `pending_review`, `outdated`).
  final String verificationStatus;

  /// Indexed provision count.
  final int provisionCount;
  const LegalInstrument({
    required this.instrumentId,
    required this.instrumentType,
    required this.title,
    required this.shortCode,
    this.editionDate,
    required this.sourceAuthority,
    this.sourceUrl,
    required this.fullTextAvailable,
    required this.verificationStatus,
    required this.provisionCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['instrument_id'] = Variable<String>(instrumentId);
    map['instrument_type'] = Variable<String>(instrumentType);
    map['title'] = Variable<String>(title);
    map['short_code'] = Variable<String>(shortCode);
    if (!nullToAbsent || editionDate != null) {
      map['edition_date'] = Variable<String>(editionDate);
    }
    map['source_authority'] = Variable<String>(sourceAuthority);
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    map['full_text_available'] = Variable<bool>(fullTextAvailable);
    map['verification_status'] = Variable<String>(verificationStatus);
    map['provision_count'] = Variable<int>(provisionCount);
    return map;
  }

  LegalInstrumentsCompanion toCompanion(bool nullToAbsent) {
    return LegalInstrumentsCompanion(
      instrumentId: Value(instrumentId),
      instrumentType: Value(instrumentType),
      title: Value(title),
      shortCode: Value(shortCode),
      editionDate: editionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(editionDate),
      sourceAuthority: Value(sourceAuthority),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      fullTextAvailable: Value(fullTextAvailable),
      verificationStatus: Value(verificationStatus),
      provisionCount: Value(provisionCount),
    );
  }

  factory LegalInstrument.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalInstrument(
      instrumentId: serializer.fromJson<String>(json['instrumentId']),
      instrumentType: serializer.fromJson<String>(json['instrumentType']),
      title: serializer.fromJson<String>(json['title']),
      shortCode: serializer.fromJson<String>(json['shortCode']),
      editionDate: serializer.fromJson<String?>(json['editionDate']),
      sourceAuthority: serializer.fromJson<String>(json['sourceAuthority']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      fullTextAvailable: serializer.fromJson<bool>(json['fullTextAvailable']),
      verificationStatus: serializer.fromJson<String>(
        json['verificationStatus'],
      ),
      provisionCount: serializer.fromJson<int>(json['provisionCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'instrumentId': serializer.toJson<String>(instrumentId),
      'instrumentType': serializer.toJson<String>(instrumentType),
      'title': serializer.toJson<String>(title),
      'shortCode': serializer.toJson<String>(shortCode),
      'editionDate': serializer.toJson<String?>(editionDate),
      'sourceAuthority': serializer.toJson<String>(sourceAuthority),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'fullTextAvailable': serializer.toJson<bool>(fullTextAvailable),
      'verificationStatus': serializer.toJson<String>(verificationStatus),
      'provisionCount': serializer.toJson<int>(provisionCount),
    };
  }

  LegalInstrument copyWith({
    String? instrumentId,
    String? instrumentType,
    String? title,
    String? shortCode,
    Value<String?> editionDate = const Value.absent(),
    String? sourceAuthority,
    Value<String?> sourceUrl = const Value.absent(),
    bool? fullTextAvailable,
    String? verificationStatus,
    int? provisionCount,
  }) => LegalInstrument(
    instrumentId: instrumentId ?? this.instrumentId,
    instrumentType: instrumentType ?? this.instrumentType,
    title: title ?? this.title,
    shortCode: shortCode ?? this.shortCode,
    editionDate: editionDate.present ? editionDate.value : this.editionDate,
    sourceAuthority: sourceAuthority ?? this.sourceAuthority,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    fullTextAvailable: fullTextAvailable ?? this.fullTextAvailable,
    verificationStatus: verificationStatus ?? this.verificationStatus,
    provisionCount: provisionCount ?? this.provisionCount,
  );
  LegalInstrument copyWithCompanion(LegalInstrumentsCompanion data) {
    return LegalInstrument(
      instrumentId: data.instrumentId.present
          ? data.instrumentId.value
          : this.instrumentId,
      instrumentType: data.instrumentType.present
          ? data.instrumentType.value
          : this.instrumentType,
      title: data.title.present ? data.title.value : this.title,
      shortCode: data.shortCode.present ? data.shortCode.value : this.shortCode,
      editionDate: data.editionDate.present
          ? data.editionDate.value
          : this.editionDate,
      sourceAuthority: data.sourceAuthority.present
          ? data.sourceAuthority.value
          : this.sourceAuthority,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      fullTextAvailable: data.fullTextAvailable.present
          ? data.fullTextAvailable.value
          : this.fullTextAvailable,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
      provisionCount: data.provisionCount.present
          ? data.provisionCount.value
          : this.provisionCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalInstrument(')
          ..write('instrumentId: $instrumentId, ')
          ..write('instrumentType: $instrumentType, ')
          ..write('title: $title, ')
          ..write('shortCode: $shortCode, ')
          ..write('editionDate: $editionDate, ')
          ..write('sourceAuthority: $sourceAuthority, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('fullTextAvailable: $fullTextAvailable, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('provisionCount: $provisionCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    instrumentId,
    instrumentType,
    title,
    shortCode,
    editionDate,
    sourceAuthority,
    sourceUrl,
    fullTextAvailable,
    verificationStatus,
    provisionCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalInstrument &&
          other.instrumentId == this.instrumentId &&
          other.instrumentType == this.instrumentType &&
          other.title == this.title &&
          other.shortCode == this.shortCode &&
          other.editionDate == this.editionDate &&
          other.sourceAuthority == this.sourceAuthority &&
          other.sourceUrl == this.sourceUrl &&
          other.fullTextAvailable == this.fullTextAvailable &&
          other.verificationStatus == this.verificationStatus &&
          other.provisionCount == this.provisionCount);
}

class LegalInstrumentsCompanion extends UpdateCompanion<LegalInstrument> {
  final Value<String> instrumentId;
  final Value<String> instrumentType;
  final Value<String> title;
  final Value<String> shortCode;
  final Value<String?> editionDate;
  final Value<String> sourceAuthority;
  final Value<String?> sourceUrl;
  final Value<bool> fullTextAvailable;
  final Value<String> verificationStatus;
  final Value<int> provisionCount;
  final Value<int> rowid;
  const LegalInstrumentsCompanion({
    this.instrumentId = const Value.absent(),
    this.instrumentType = const Value.absent(),
    this.title = const Value.absent(),
    this.shortCode = const Value.absent(),
    this.editionDate = const Value.absent(),
    this.sourceAuthority = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.fullTextAvailable = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.provisionCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalInstrumentsCompanion.insert({
    required String instrumentId,
    required String instrumentType,
    required String title,
    required String shortCode,
    this.editionDate = const Value.absent(),
    required String sourceAuthority,
    this.sourceUrl = const Value.absent(),
    this.fullTextAvailable = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.provisionCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : instrumentId = Value(instrumentId),
       instrumentType = Value(instrumentType),
       title = Value(title),
       shortCode = Value(shortCode),
       sourceAuthority = Value(sourceAuthority);
  static Insertable<LegalInstrument> custom({
    Expression<String>? instrumentId,
    Expression<String>? instrumentType,
    Expression<String>? title,
    Expression<String>? shortCode,
    Expression<String>? editionDate,
    Expression<String>? sourceAuthority,
    Expression<String>? sourceUrl,
    Expression<bool>? fullTextAvailable,
    Expression<String>? verificationStatus,
    Expression<int>? provisionCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (instrumentId != null) 'instrument_id': instrumentId,
      if (instrumentType != null) 'instrument_type': instrumentType,
      if (title != null) 'title': title,
      if (shortCode != null) 'short_code': shortCode,
      if (editionDate != null) 'edition_date': editionDate,
      if (sourceAuthority != null) 'source_authority': sourceAuthority,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (fullTextAvailable != null) 'full_text_available': fullTextAvailable,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (provisionCount != null) 'provision_count': provisionCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalInstrumentsCompanion copyWith({
    Value<String>? instrumentId,
    Value<String>? instrumentType,
    Value<String>? title,
    Value<String>? shortCode,
    Value<String?>? editionDate,
    Value<String>? sourceAuthority,
    Value<String?>? sourceUrl,
    Value<bool>? fullTextAvailable,
    Value<String>? verificationStatus,
    Value<int>? provisionCount,
    Value<int>? rowid,
  }) {
    return LegalInstrumentsCompanion(
      instrumentId: instrumentId ?? this.instrumentId,
      instrumentType: instrumentType ?? this.instrumentType,
      title: title ?? this.title,
      shortCode: shortCode ?? this.shortCode,
      editionDate: editionDate ?? this.editionDate,
      sourceAuthority: sourceAuthority ?? this.sourceAuthority,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      fullTextAvailable: fullTextAvailable ?? this.fullTextAvailable,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      provisionCount: provisionCount ?? this.provisionCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (instrumentId.present) {
      map['instrument_id'] = Variable<String>(instrumentId.value);
    }
    if (instrumentType.present) {
      map['instrument_type'] = Variable<String>(instrumentType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (shortCode.present) {
      map['short_code'] = Variable<String>(shortCode.value);
    }
    if (editionDate.present) {
      map['edition_date'] = Variable<String>(editionDate.value);
    }
    if (sourceAuthority.present) {
      map['source_authority'] = Variable<String>(sourceAuthority.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (fullTextAvailable.present) {
      map['full_text_available'] = Variable<bool>(fullTextAvailable.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(verificationStatus.value);
    }
    if (provisionCount.present) {
      map['provision_count'] = Variable<int>(provisionCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalInstrumentsCompanion(')
          ..write('instrumentId: $instrumentId, ')
          ..write('instrumentType: $instrumentType, ')
          ..write('title: $title, ')
          ..write('shortCode: $shortCode, ')
          ..write('editionDate: $editionDate, ')
          ..write('sourceAuthority: $sourceAuthority, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('fullTextAvailable: $fullTextAvailable, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('provisionCount: $provisionCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegalProvisionsTable extends LegalProvisions
    with TableInfo<$LegalProvisionsTable, LegalProvision> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalProvisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _canonicalRefMeta = const VerificationMeta(
    'canonicalRef',
  );
  @override
  late final GeneratedColumn<String> canonicalRef = GeneratedColumn<String>(
    'canonical_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instrumentIdMeta = const VerificationMeta(
    'instrumentId',
  );
  @override
  late final GeneratedColumn<String> instrumentId = GeneratedColumn<String>(
    'instrument_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentRefMeta = const VerificationMeta(
    'parentRef',
  );
  @override
  late final GeneratedColumn<String> parentRef = GeneratedColumn<String>(
    'parent_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _provisionTypeMeta = const VerificationMeta(
    'provisionType',
  );
  @override
  late final GeneratedColumn<String> provisionType = GeneratedColumn<String>(
    'provision_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
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
  static const VerificationMeta _partOrChapterMeta = const VerificationMeta(
    'partOrChapter',
  );
  @override
  late final GeneratedColumn<String> partOrChapter = GeneratedColumn<String>(
    'part_or_chapter',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _officialTextMeta = const VerificationMeta(
    'officialText',
  );
  @override
  late final GeneratedColumn<String> officialText = GeneratedColumn<String>(
    'official_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consolidatedStatusMeta =
      const VerificationMeta('consolidatedStatus');
  @override
  late final GeneratedColumn<String> consolidatedStatus =
      GeneratedColumn<String>(
        'consolidated_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('active'),
      );
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<String> effectiveDate = GeneratedColumn<String>(
    'effective_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookPageMeta = const VerificationMeta(
    'bookPage',
  );
  @override
  late final GeneratedColumn<int> bookPage = GeneratedColumn<int>(
    'book_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _endPageMeta = const VerificationMeta(
    'endPage',
  );
  @override
  late final GeneratedColumn<int> endPage = GeneratedColumn<int>(
    'end_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sourceHashMeta = const VerificationMeta(
    'sourceHash',
  );
  @override
  late final GeneratedColumn<String> sourceHash = GeneratedColumn<String>(
    'source_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fullTextAvailableMeta = const VerificationMeta(
    'fullTextAvailable',
  );
  @override
  late final GeneratedColumn<bool> fullTextAvailable = GeneratedColumn<bool>(
    'full_text_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("full_text_available" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _verificationStatusMeta =
      const VerificationMeta('verificationStatus');
  @override
  late final GeneratedColumn<String> verificationStatus =
      GeneratedColumn<String>(
        'verification_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('verified_in_book'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    canonicalRef,
    instrumentId,
    parentRef,
    provisionType,
    number,
    title,
    partOrChapter,
    officialText,
    consolidatedStatus,
    effectiveDate,
    bookPage,
    endPage,
    sourceHash,
    fullTextAvailable,
    verificationStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_provisions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalProvision> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('canonical_ref')) {
      context.handle(
        _canonicalRefMeta,
        canonicalRef.isAcceptableOrUnknown(
          data['canonical_ref']!,
          _canonicalRefMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalRefMeta);
    }
    if (data.containsKey('instrument_id')) {
      context.handle(
        _instrumentIdMeta,
        instrumentId.isAcceptableOrUnknown(
          data['instrument_id']!,
          _instrumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instrumentIdMeta);
    }
    if (data.containsKey('parent_ref')) {
      context.handle(
        _parentRefMeta,
        parentRef.isAcceptableOrUnknown(data['parent_ref']!, _parentRefMeta),
      );
    }
    if (data.containsKey('provision_type')) {
      context.handle(
        _provisionTypeMeta,
        provisionType.isAcceptableOrUnknown(
          data['provision_type']!,
          _provisionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_provisionTypeMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('part_or_chapter')) {
      context.handle(
        _partOrChapterMeta,
        partOrChapter.isAcceptableOrUnknown(
          data['part_or_chapter']!,
          _partOrChapterMeta,
        ),
      );
    }
    if (data.containsKey('official_text')) {
      context.handle(
        _officialTextMeta,
        officialText.isAcceptableOrUnknown(
          data['official_text']!,
          _officialTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_officialTextMeta);
    }
    if (data.containsKey('consolidated_status')) {
      context.handle(
        _consolidatedStatusMeta,
        consolidatedStatus.isAcceptableOrUnknown(
          data['consolidated_status']!,
          _consolidatedStatusMeta,
        ),
      );
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    }
    if (data.containsKey('book_page')) {
      context.handle(
        _bookPageMeta,
        bookPage.isAcceptableOrUnknown(data['book_page']!, _bookPageMeta),
      );
    }
    if (data.containsKey('end_page')) {
      context.handle(
        _endPageMeta,
        endPage.isAcceptableOrUnknown(data['end_page']!, _endPageMeta),
      );
    }
    if (data.containsKey('source_hash')) {
      context.handle(
        _sourceHashMeta,
        sourceHash.isAcceptableOrUnknown(data['source_hash']!, _sourceHashMeta),
      );
    }
    if (data.containsKey('full_text_available')) {
      context.handle(
        _fullTextAvailableMeta,
        fullTextAvailable.isAcceptableOrUnknown(
          data['full_text_available']!,
          _fullTextAvailableMeta,
        ),
      );
    }
    if (data.containsKey('verification_status')) {
      context.handle(
        _verificationStatusMeta,
        verificationStatus.isAcceptableOrUnknown(
          data['verification_status']!,
          _verificationStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {canonicalRef};
  @override
  LegalProvision map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalProvision(
      canonicalRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_ref'],
      )!,
      instrumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instrument_id'],
      )!,
      parentRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_ref'],
      )!,
      provisionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provision_type'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      partOrChapter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_or_chapter'],
      )!,
      officialText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}official_text'],
      )!,
      consolidatedStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}consolidated_status'],
      )!,
      effectiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_date'],
      ),
      bookPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_page'],
      )!,
      endPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_page'],
      )!,
      sourceHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_hash'],
      )!,
      fullTextAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}full_text_available'],
      )!,
      verificationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification_status'],
      )!,
    );
  }

  @override
  $LegalProvisionsTable createAlias(String alias) {
    return $LegalProvisionsTable(attachedDatabase, alias);
  }
}

class LegalProvision extends DataClass implements Insertable<LegalProvision> {
  /// Canonical key (`CONST:ART:21`, `CONST:PREAMBLE`, `CENTRAL:DPDP_2023:8`).
  final String canonicalRef;

  /// Parent [LegalInstruments.instrumentId].
  final String instrumentId;

  /// Parent entity key (`INST:CONSTITUTION_INDIA_2026`).
  final String parentRef;

  /// Provision type (`preamble`, `constitutional_article`, `schedule`, `appendix`, `section`).
  final String provisionType;

  /// Article / Schedule / Section number string.
  final String number;

  /// Official heading.
  final String title;

  /// Part, Chapter, or Schedule label.
  final String partOrChapter;

  /// Verbatim extracted legal text.
  final String officialText;

  /// Status (`active`, `omitted_repealed`, `unnotified_prospective`, `struck_down_judicial`).
  final String consolidatedStatus;

  /// Commencement / effective date (`w.e.f.`) if known.
  final String? effectiveDate;

  /// Start page number in source book/PDF.
  final int bookPage;

  /// End page number in source book/PDF.
  final int endPage;

  /// SHA-256 content hash.
  final String sourceHash;

  /// Whether full text is verified present.
  final bool fullTextAvailable;

  /// Verification gate status.
  final String verificationStatus;
  const LegalProvision({
    required this.canonicalRef,
    required this.instrumentId,
    required this.parentRef,
    required this.provisionType,
    required this.number,
    required this.title,
    required this.partOrChapter,
    required this.officialText,
    required this.consolidatedStatus,
    this.effectiveDate,
    required this.bookPage,
    required this.endPage,
    required this.sourceHash,
    required this.fullTextAvailable,
    required this.verificationStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['canonical_ref'] = Variable<String>(canonicalRef);
    map['instrument_id'] = Variable<String>(instrumentId);
    map['parent_ref'] = Variable<String>(parentRef);
    map['provision_type'] = Variable<String>(provisionType);
    map['number'] = Variable<String>(number);
    map['title'] = Variable<String>(title);
    map['part_or_chapter'] = Variable<String>(partOrChapter);
    map['official_text'] = Variable<String>(officialText);
    map['consolidated_status'] = Variable<String>(consolidatedStatus);
    if (!nullToAbsent || effectiveDate != null) {
      map['effective_date'] = Variable<String>(effectiveDate);
    }
    map['book_page'] = Variable<int>(bookPage);
    map['end_page'] = Variable<int>(endPage);
    map['source_hash'] = Variable<String>(sourceHash);
    map['full_text_available'] = Variable<bool>(fullTextAvailable);
    map['verification_status'] = Variable<String>(verificationStatus);
    return map;
  }

  LegalProvisionsCompanion toCompanion(bool nullToAbsent) {
    return LegalProvisionsCompanion(
      canonicalRef: Value(canonicalRef),
      instrumentId: Value(instrumentId),
      parentRef: Value(parentRef),
      provisionType: Value(provisionType),
      number: Value(number),
      title: Value(title),
      partOrChapter: Value(partOrChapter),
      officialText: Value(officialText),
      consolidatedStatus: Value(consolidatedStatus),
      effectiveDate: effectiveDate == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveDate),
      bookPage: Value(bookPage),
      endPage: Value(endPage),
      sourceHash: Value(sourceHash),
      fullTextAvailable: Value(fullTextAvailable),
      verificationStatus: Value(verificationStatus),
    );
  }

  factory LegalProvision.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalProvision(
      canonicalRef: serializer.fromJson<String>(json['canonicalRef']),
      instrumentId: serializer.fromJson<String>(json['instrumentId']),
      parentRef: serializer.fromJson<String>(json['parentRef']),
      provisionType: serializer.fromJson<String>(json['provisionType']),
      number: serializer.fromJson<String>(json['number']),
      title: serializer.fromJson<String>(json['title']),
      partOrChapter: serializer.fromJson<String>(json['partOrChapter']),
      officialText: serializer.fromJson<String>(json['officialText']),
      consolidatedStatus: serializer.fromJson<String>(
        json['consolidatedStatus'],
      ),
      effectiveDate: serializer.fromJson<String?>(json['effectiveDate']),
      bookPage: serializer.fromJson<int>(json['bookPage']),
      endPage: serializer.fromJson<int>(json['endPage']),
      sourceHash: serializer.fromJson<String>(json['sourceHash']),
      fullTextAvailable: serializer.fromJson<bool>(json['fullTextAvailable']),
      verificationStatus: serializer.fromJson<String>(
        json['verificationStatus'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'canonicalRef': serializer.toJson<String>(canonicalRef),
      'instrumentId': serializer.toJson<String>(instrumentId),
      'parentRef': serializer.toJson<String>(parentRef),
      'provisionType': serializer.toJson<String>(provisionType),
      'number': serializer.toJson<String>(number),
      'title': serializer.toJson<String>(title),
      'partOrChapter': serializer.toJson<String>(partOrChapter),
      'officialText': serializer.toJson<String>(officialText),
      'consolidatedStatus': serializer.toJson<String>(consolidatedStatus),
      'effectiveDate': serializer.toJson<String?>(effectiveDate),
      'bookPage': serializer.toJson<int>(bookPage),
      'endPage': serializer.toJson<int>(endPage),
      'sourceHash': serializer.toJson<String>(sourceHash),
      'fullTextAvailable': serializer.toJson<bool>(fullTextAvailable),
      'verificationStatus': serializer.toJson<String>(verificationStatus),
    };
  }

  LegalProvision copyWith({
    String? canonicalRef,
    String? instrumentId,
    String? parentRef,
    String? provisionType,
    String? number,
    String? title,
    String? partOrChapter,
    String? officialText,
    String? consolidatedStatus,
    Value<String?> effectiveDate = const Value.absent(),
    int? bookPage,
    int? endPage,
    String? sourceHash,
    bool? fullTextAvailable,
    String? verificationStatus,
  }) => LegalProvision(
    canonicalRef: canonicalRef ?? this.canonicalRef,
    instrumentId: instrumentId ?? this.instrumentId,
    parentRef: parentRef ?? this.parentRef,
    provisionType: provisionType ?? this.provisionType,
    number: number ?? this.number,
    title: title ?? this.title,
    partOrChapter: partOrChapter ?? this.partOrChapter,
    officialText: officialText ?? this.officialText,
    consolidatedStatus: consolidatedStatus ?? this.consolidatedStatus,
    effectiveDate: effectiveDate.present
        ? effectiveDate.value
        : this.effectiveDate,
    bookPage: bookPage ?? this.bookPage,
    endPage: endPage ?? this.endPage,
    sourceHash: sourceHash ?? this.sourceHash,
    fullTextAvailable: fullTextAvailable ?? this.fullTextAvailable,
    verificationStatus: verificationStatus ?? this.verificationStatus,
  );
  LegalProvision copyWithCompanion(LegalProvisionsCompanion data) {
    return LegalProvision(
      canonicalRef: data.canonicalRef.present
          ? data.canonicalRef.value
          : this.canonicalRef,
      instrumentId: data.instrumentId.present
          ? data.instrumentId.value
          : this.instrumentId,
      parentRef: data.parentRef.present ? data.parentRef.value : this.parentRef,
      provisionType: data.provisionType.present
          ? data.provisionType.value
          : this.provisionType,
      number: data.number.present ? data.number.value : this.number,
      title: data.title.present ? data.title.value : this.title,
      partOrChapter: data.partOrChapter.present
          ? data.partOrChapter.value
          : this.partOrChapter,
      officialText: data.officialText.present
          ? data.officialText.value
          : this.officialText,
      consolidatedStatus: data.consolidatedStatus.present
          ? data.consolidatedStatus.value
          : this.consolidatedStatus,
      effectiveDate: data.effectiveDate.present
          ? data.effectiveDate.value
          : this.effectiveDate,
      bookPage: data.bookPage.present ? data.bookPage.value : this.bookPage,
      endPage: data.endPage.present ? data.endPage.value : this.endPage,
      sourceHash: data.sourceHash.present
          ? data.sourceHash.value
          : this.sourceHash,
      fullTextAvailable: data.fullTextAvailable.present
          ? data.fullTextAvailable.value
          : this.fullTextAvailable,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalProvision(')
          ..write('canonicalRef: $canonicalRef, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('parentRef: $parentRef, ')
          ..write('provisionType: $provisionType, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('partOrChapter: $partOrChapter, ')
          ..write('officialText: $officialText, ')
          ..write('consolidatedStatus: $consolidatedStatus, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('bookPage: $bookPage, ')
          ..write('endPage: $endPage, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('fullTextAvailable: $fullTextAvailable, ')
          ..write('verificationStatus: $verificationStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    canonicalRef,
    instrumentId,
    parentRef,
    provisionType,
    number,
    title,
    partOrChapter,
    officialText,
    consolidatedStatus,
    effectiveDate,
    bookPage,
    endPage,
    sourceHash,
    fullTextAvailable,
    verificationStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalProvision &&
          other.canonicalRef == this.canonicalRef &&
          other.instrumentId == this.instrumentId &&
          other.parentRef == this.parentRef &&
          other.provisionType == this.provisionType &&
          other.number == this.number &&
          other.title == this.title &&
          other.partOrChapter == this.partOrChapter &&
          other.officialText == this.officialText &&
          other.consolidatedStatus == this.consolidatedStatus &&
          other.effectiveDate == this.effectiveDate &&
          other.bookPage == this.bookPage &&
          other.endPage == this.endPage &&
          other.sourceHash == this.sourceHash &&
          other.fullTextAvailable == this.fullTextAvailable &&
          other.verificationStatus == this.verificationStatus);
}

class LegalProvisionsCompanion extends UpdateCompanion<LegalProvision> {
  final Value<String> canonicalRef;
  final Value<String> instrumentId;
  final Value<String> parentRef;
  final Value<String> provisionType;
  final Value<String> number;
  final Value<String> title;
  final Value<String> partOrChapter;
  final Value<String> officialText;
  final Value<String> consolidatedStatus;
  final Value<String?> effectiveDate;
  final Value<int> bookPage;
  final Value<int> endPage;
  final Value<String> sourceHash;
  final Value<bool> fullTextAvailable;
  final Value<String> verificationStatus;
  final Value<int> rowid;
  const LegalProvisionsCompanion({
    this.canonicalRef = const Value.absent(),
    this.instrumentId = const Value.absent(),
    this.parentRef = const Value.absent(),
    this.provisionType = const Value.absent(),
    this.number = const Value.absent(),
    this.title = const Value.absent(),
    this.partOrChapter = const Value.absent(),
    this.officialText = const Value.absent(),
    this.consolidatedStatus = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.bookPage = const Value.absent(),
    this.endPage = const Value.absent(),
    this.sourceHash = const Value.absent(),
    this.fullTextAvailable = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalProvisionsCompanion.insert({
    required String canonicalRef,
    required String instrumentId,
    this.parentRef = const Value.absent(),
    required String provisionType,
    required String number,
    required String title,
    this.partOrChapter = const Value.absent(),
    required String officialText,
    this.consolidatedStatus = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.bookPage = const Value.absent(),
    this.endPage = const Value.absent(),
    this.sourceHash = const Value.absent(),
    this.fullTextAvailable = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : canonicalRef = Value(canonicalRef),
       instrumentId = Value(instrumentId),
       provisionType = Value(provisionType),
       number = Value(number),
       title = Value(title),
       officialText = Value(officialText);
  static Insertable<LegalProvision> custom({
    Expression<String>? canonicalRef,
    Expression<String>? instrumentId,
    Expression<String>? parentRef,
    Expression<String>? provisionType,
    Expression<String>? number,
    Expression<String>? title,
    Expression<String>? partOrChapter,
    Expression<String>? officialText,
    Expression<String>? consolidatedStatus,
    Expression<String>? effectiveDate,
    Expression<int>? bookPage,
    Expression<int>? endPage,
    Expression<String>? sourceHash,
    Expression<bool>? fullTextAvailable,
    Expression<String>? verificationStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (canonicalRef != null) 'canonical_ref': canonicalRef,
      if (instrumentId != null) 'instrument_id': instrumentId,
      if (parentRef != null) 'parent_ref': parentRef,
      if (provisionType != null) 'provision_type': provisionType,
      if (number != null) 'number': number,
      if (title != null) 'title': title,
      if (partOrChapter != null) 'part_or_chapter': partOrChapter,
      if (officialText != null) 'official_text': officialText,
      if (consolidatedStatus != null) 'consolidated_status': consolidatedStatus,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (bookPage != null) 'book_page': bookPage,
      if (endPage != null) 'end_page': endPage,
      if (sourceHash != null) 'source_hash': sourceHash,
      if (fullTextAvailable != null) 'full_text_available': fullTextAvailable,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalProvisionsCompanion copyWith({
    Value<String>? canonicalRef,
    Value<String>? instrumentId,
    Value<String>? parentRef,
    Value<String>? provisionType,
    Value<String>? number,
    Value<String>? title,
    Value<String>? partOrChapter,
    Value<String>? officialText,
    Value<String>? consolidatedStatus,
    Value<String?>? effectiveDate,
    Value<int>? bookPage,
    Value<int>? endPage,
    Value<String>? sourceHash,
    Value<bool>? fullTextAvailable,
    Value<String>? verificationStatus,
    Value<int>? rowid,
  }) {
    return LegalProvisionsCompanion(
      canonicalRef: canonicalRef ?? this.canonicalRef,
      instrumentId: instrumentId ?? this.instrumentId,
      parentRef: parentRef ?? this.parentRef,
      provisionType: provisionType ?? this.provisionType,
      number: number ?? this.number,
      title: title ?? this.title,
      partOrChapter: partOrChapter ?? this.partOrChapter,
      officialText: officialText ?? this.officialText,
      consolidatedStatus: consolidatedStatus ?? this.consolidatedStatus,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      bookPage: bookPage ?? this.bookPage,
      endPage: endPage ?? this.endPage,
      sourceHash: sourceHash ?? this.sourceHash,
      fullTextAvailable: fullTextAvailable ?? this.fullTextAvailable,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (canonicalRef.present) {
      map['canonical_ref'] = Variable<String>(canonicalRef.value);
    }
    if (instrumentId.present) {
      map['instrument_id'] = Variable<String>(instrumentId.value);
    }
    if (parentRef.present) {
      map['parent_ref'] = Variable<String>(parentRef.value);
    }
    if (provisionType.present) {
      map['provision_type'] = Variable<String>(provisionType.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (partOrChapter.present) {
      map['part_or_chapter'] = Variable<String>(partOrChapter.value);
    }
    if (officialText.present) {
      map['official_text'] = Variable<String>(officialText.value);
    }
    if (consolidatedStatus.present) {
      map['consolidated_status'] = Variable<String>(consolidatedStatus.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<String>(effectiveDate.value);
    }
    if (bookPage.present) {
      map['book_page'] = Variable<int>(bookPage.value);
    }
    if (endPage.present) {
      map['end_page'] = Variable<int>(endPage.value);
    }
    if (sourceHash.present) {
      map['source_hash'] = Variable<String>(sourceHash.value);
    }
    if (fullTextAvailable.present) {
      map['full_text_available'] = Variable<bool>(fullTextAvailable.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(verificationStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalProvisionsCompanion(')
          ..write('canonicalRef: $canonicalRef, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('parentRef: $parentRef, ')
          ..write('provisionType: $provisionType, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('partOrChapter: $partOrChapter, ')
          ..write('officialText: $officialText, ')
          ..write('consolidatedStatus: $consolidatedStatus, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('bookPage: $bookPage, ')
          ..write('endPage: $endPage, ')
          ..write('sourceHash: $sourceHash, ')
          ..write('fullTextAvailable: $fullTextAvailable, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegalFootnotesTable extends LegalFootnotes
    with TableInfo<$LegalFootnotesTable, LegalFootnote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalFootnotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _footnoteIdMeta = const VerificationMeta(
    'footnoteId',
  );
  @override
  late final GeneratedColumn<String> footnoteId = GeneratedColumn<String>(
    'footnote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provisionRefMeta = const VerificationMeta(
    'provisionRef',
  );
  @override
  late final GeneratedColumn<String> provisionRef = GeneratedColumn<String>(
    'provision_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _footnoteNumberMeta = const VerificationMeta(
    'footnoteNumber',
  );
  @override
  late final GeneratedColumn<String> footnoteNumber = GeneratedColumn<String>(
    'footnote_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookPageMeta = const VerificationMeta(
    'bookPage',
  );
  @override
  late final GeneratedColumn<int> bookPage = GeneratedColumn<int>(
    'book_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _footnoteTypeMeta = const VerificationMeta(
    'footnoteType',
  );
  @override
  late final GeneratedColumn<String> footnoteType = GeneratedColumn<String>(
    'footnote_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteTextMeta = const VerificationMeta(
    'noteText',
  );
  @override
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
    'note_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referencedInstrumentsJsonMeta =
      const VerificationMeta('referencedInstrumentsJson');
  @override
  late final GeneratedColumn<String> referencedInstrumentsJson =
      GeneratedColumn<String>(
        'referenced_instruments_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    footnoteId,
    provisionRef,
    footnoteNumber,
    bookPage,
    footnoteType,
    noteText,
    referencedInstrumentsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_footnotes';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalFootnote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('footnote_id')) {
      context.handle(
        _footnoteIdMeta,
        footnoteId.isAcceptableOrUnknown(data['footnote_id']!, _footnoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_footnoteIdMeta);
    }
    if (data.containsKey('provision_ref')) {
      context.handle(
        _provisionRefMeta,
        provisionRef.isAcceptableOrUnknown(
          data['provision_ref']!,
          _provisionRefMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_provisionRefMeta);
    }
    if (data.containsKey('footnote_number')) {
      context.handle(
        _footnoteNumberMeta,
        footnoteNumber.isAcceptableOrUnknown(
          data['footnote_number']!,
          _footnoteNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_footnoteNumberMeta);
    }
    if (data.containsKey('book_page')) {
      context.handle(
        _bookPageMeta,
        bookPage.isAcceptableOrUnknown(data['book_page']!, _bookPageMeta),
      );
    } else if (isInserting) {
      context.missing(_bookPageMeta);
    }
    if (data.containsKey('footnote_type')) {
      context.handle(
        _footnoteTypeMeta,
        footnoteType.isAcceptableOrUnknown(
          data['footnote_type']!,
          _footnoteTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_footnoteTypeMeta);
    }
    if (data.containsKey('note_text')) {
      context.handle(
        _noteTextMeta,
        noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta),
      );
    } else if (isInserting) {
      context.missing(_noteTextMeta);
    }
    if (data.containsKey('referenced_instruments_json')) {
      context.handle(
        _referencedInstrumentsJsonMeta,
        referencedInstrumentsJson.isAcceptableOrUnknown(
          data['referenced_instruments_json']!,
          _referencedInstrumentsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {footnoteId};
  @override
  LegalFootnote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalFootnote(
      footnoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}footnote_id'],
      )!,
      provisionRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provision_ref'],
      )!,
      footnoteNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}footnote_number'],
      )!,
      bookPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_page'],
      )!,
      footnoteType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}footnote_type'],
      )!,
      noteText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_text'],
      )!,
      referencedInstrumentsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referenced_instruments_json'],
      )!,
    );
  }

  @override
  $LegalFootnotesTable createAlias(String alias) {
    return $LegalFootnotesTable(attachedDatabase, alias);
  }
}

class LegalFootnote extends DataClass implements Insertable<LegalFootnote> {
  /// Unique footnote ID.
  final String footnoteId;

  /// Target provision canonical ref.
  final String provisionRef;

  /// Printed footnote number or asterisk marker.
  final String footnoteNumber;

  /// Source book page number.
  final int bookPage;

  /// Category (`amendment`, `judicial_invalidation`, `commencement_unnotified`, `constitutional_order`, `editorial`).
  final String footnoteType;

  /// Verbatim footnote text.
  final String noteText;

  /// JSON array of referenced instrument IDs mentioned inside the footnote.
  final String referencedInstrumentsJson;
  const LegalFootnote({
    required this.footnoteId,
    required this.provisionRef,
    required this.footnoteNumber,
    required this.bookPage,
    required this.footnoteType,
    required this.noteText,
    required this.referencedInstrumentsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['footnote_id'] = Variable<String>(footnoteId);
    map['provision_ref'] = Variable<String>(provisionRef);
    map['footnote_number'] = Variable<String>(footnoteNumber);
    map['book_page'] = Variable<int>(bookPage);
    map['footnote_type'] = Variable<String>(footnoteType);
    map['note_text'] = Variable<String>(noteText);
    map['referenced_instruments_json'] = Variable<String>(
      referencedInstrumentsJson,
    );
    return map;
  }

  LegalFootnotesCompanion toCompanion(bool nullToAbsent) {
    return LegalFootnotesCompanion(
      footnoteId: Value(footnoteId),
      provisionRef: Value(provisionRef),
      footnoteNumber: Value(footnoteNumber),
      bookPage: Value(bookPage),
      footnoteType: Value(footnoteType),
      noteText: Value(noteText),
      referencedInstrumentsJson: Value(referencedInstrumentsJson),
    );
  }

  factory LegalFootnote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalFootnote(
      footnoteId: serializer.fromJson<String>(json['footnoteId']),
      provisionRef: serializer.fromJson<String>(json['provisionRef']),
      footnoteNumber: serializer.fromJson<String>(json['footnoteNumber']),
      bookPage: serializer.fromJson<int>(json['bookPage']),
      footnoteType: serializer.fromJson<String>(json['footnoteType']),
      noteText: serializer.fromJson<String>(json['noteText']),
      referencedInstrumentsJson: serializer.fromJson<String>(
        json['referencedInstrumentsJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'footnoteId': serializer.toJson<String>(footnoteId),
      'provisionRef': serializer.toJson<String>(provisionRef),
      'footnoteNumber': serializer.toJson<String>(footnoteNumber),
      'bookPage': serializer.toJson<int>(bookPage),
      'footnoteType': serializer.toJson<String>(footnoteType),
      'noteText': serializer.toJson<String>(noteText),
      'referencedInstrumentsJson': serializer.toJson<String>(
        referencedInstrumentsJson,
      ),
    };
  }

  LegalFootnote copyWith({
    String? footnoteId,
    String? provisionRef,
    String? footnoteNumber,
    int? bookPage,
    String? footnoteType,
    String? noteText,
    String? referencedInstrumentsJson,
  }) => LegalFootnote(
    footnoteId: footnoteId ?? this.footnoteId,
    provisionRef: provisionRef ?? this.provisionRef,
    footnoteNumber: footnoteNumber ?? this.footnoteNumber,
    bookPage: bookPage ?? this.bookPage,
    footnoteType: footnoteType ?? this.footnoteType,
    noteText: noteText ?? this.noteText,
    referencedInstrumentsJson:
        referencedInstrumentsJson ?? this.referencedInstrumentsJson,
  );
  LegalFootnote copyWithCompanion(LegalFootnotesCompanion data) {
    return LegalFootnote(
      footnoteId: data.footnoteId.present
          ? data.footnoteId.value
          : this.footnoteId,
      provisionRef: data.provisionRef.present
          ? data.provisionRef.value
          : this.provisionRef,
      footnoteNumber: data.footnoteNumber.present
          ? data.footnoteNumber.value
          : this.footnoteNumber,
      bookPage: data.bookPage.present ? data.bookPage.value : this.bookPage,
      footnoteType: data.footnoteType.present
          ? data.footnoteType.value
          : this.footnoteType,
      noteText: data.noteText.present ? data.noteText.value : this.noteText,
      referencedInstrumentsJson: data.referencedInstrumentsJson.present
          ? data.referencedInstrumentsJson.value
          : this.referencedInstrumentsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalFootnote(')
          ..write('footnoteId: $footnoteId, ')
          ..write('provisionRef: $provisionRef, ')
          ..write('footnoteNumber: $footnoteNumber, ')
          ..write('bookPage: $bookPage, ')
          ..write('footnoteType: $footnoteType, ')
          ..write('noteText: $noteText, ')
          ..write('referencedInstrumentsJson: $referencedInstrumentsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    footnoteId,
    provisionRef,
    footnoteNumber,
    bookPage,
    footnoteType,
    noteText,
    referencedInstrumentsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalFootnote &&
          other.footnoteId == this.footnoteId &&
          other.provisionRef == this.provisionRef &&
          other.footnoteNumber == this.footnoteNumber &&
          other.bookPage == this.bookPage &&
          other.footnoteType == this.footnoteType &&
          other.noteText == this.noteText &&
          other.referencedInstrumentsJson == this.referencedInstrumentsJson);
}

class LegalFootnotesCompanion extends UpdateCompanion<LegalFootnote> {
  final Value<String> footnoteId;
  final Value<String> provisionRef;
  final Value<String> footnoteNumber;
  final Value<int> bookPage;
  final Value<String> footnoteType;
  final Value<String> noteText;
  final Value<String> referencedInstrumentsJson;
  final Value<int> rowid;
  const LegalFootnotesCompanion({
    this.footnoteId = const Value.absent(),
    this.provisionRef = const Value.absent(),
    this.footnoteNumber = const Value.absent(),
    this.bookPage = const Value.absent(),
    this.footnoteType = const Value.absent(),
    this.noteText = const Value.absent(),
    this.referencedInstrumentsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalFootnotesCompanion.insert({
    required String footnoteId,
    required String provisionRef,
    required String footnoteNumber,
    required int bookPage,
    required String footnoteType,
    required String noteText,
    this.referencedInstrumentsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : footnoteId = Value(footnoteId),
       provisionRef = Value(provisionRef),
       footnoteNumber = Value(footnoteNumber),
       bookPage = Value(bookPage),
       footnoteType = Value(footnoteType),
       noteText = Value(noteText);
  static Insertable<LegalFootnote> custom({
    Expression<String>? footnoteId,
    Expression<String>? provisionRef,
    Expression<String>? footnoteNumber,
    Expression<int>? bookPage,
    Expression<String>? footnoteType,
    Expression<String>? noteText,
    Expression<String>? referencedInstrumentsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (footnoteId != null) 'footnote_id': footnoteId,
      if (provisionRef != null) 'provision_ref': provisionRef,
      if (footnoteNumber != null) 'footnote_number': footnoteNumber,
      if (bookPage != null) 'book_page': bookPage,
      if (footnoteType != null) 'footnote_type': footnoteType,
      if (noteText != null) 'note_text': noteText,
      if (referencedInstrumentsJson != null)
        'referenced_instruments_json': referencedInstrumentsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalFootnotesCompanion copyWith({
    Value<String>? footnoteId,
    Value<String>? provisionRef,
    Value<String>? footnoteNumber,
    Value<int>? bookPage,
    Value<String>? footnoteType,
    Value<String>? noteText,
    Value<String>? referencedInstrumentsJson,
    Value<int>? rowid,
  }) {
    return LegalFootnotesCompanion(
      footnoteId: footnoteId ?? this.footnoteId,
      provisionRef: provisionRef ?? this.provisionRef,
      footnoteNumber: footnoteNumber ?? this.footnoteNumber,
      bookPage: bookPage ?? this.bookPage,
      footnoteType: footnoteType ?? this.footnoteType,
      noteText: noteText ?? this.noteText,
      referencedInstrumentsJson:
          referencedInstrumentsJson ?? this.referencedInstrumentsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (footnoteId.present) {
      map['footnote_id'] = Variable<String>(footnoteId.value);
    }
    if (provisionRef.present) {
      map['provision_ref'] = Variable<String>(provisionRef.value);
    }
    if (footnoteNumber.present) {
      map['footnote_number'] = Variable<String>(footnoteNumber.value);
    }
    if (bookPage.present) {
      map['book_page'] = Variable<int>(bookPage.value);
    }
    if (footnoteType.present) {
      map['footnote_type'] = Variable<String>(footnoteType.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    if (referencedInstrumentsJson.present) {
      map['referenced_instruments_json'] = Variable<String>(
        referencedInstrumentsJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalFootnotesCompanion(')
          ..write('footnoteId: $footnoteId, ')
          ..write('provisionRef: $provisionRef, ')
          ..write('footnoteNumber: $footnoteNumber, ')
          ..write('bookPage: $bookPage, ')
          ..write('footnoteType: $footnoteType, ')
          ..write('noteText: $noteText, ')
          ..write('referencedInstrumentsJson: $referencedInstrumentsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegalReferencesTable extends LegalReferences
    with TableInfo<$LegalReferencesTable, LegalReference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalReferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceTypeMeta = const VerificationMeta(
    'referenceType',
  );
  @override
  late final GeneratedColumn<String> referenceType = GeneratedColumn<String>(
    'reference_type',
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
  static const VerificationMeta _referenceNumberMeta = const VerificationMeta(
    'referenceNumber',
  );
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
    'reference_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentDocumentMeta = const VerificationMeta(
    'parentDocument',
  );
  @override
  late final GeneratedColumn<String> parentDocument = GeneratedColumn<String>(
    'parent_document',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookPageMeta = const VerificationMeta(
    'bookPage',
  );
  @override
  late final GeneratedColumn<int> bookPage = GeneratedColumn<int>(
    'book_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTextMeta = const VerificationMeta(
    'sourceText',
  );
  @override
  late final GeneratedColumn<String> sourceText = GeneratedColumn<String>(
    'source_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extractionMethodMeta = const VerificationMeta(
    'extractionMethod',
  );
  @override
  late final GeneratedColumn<String> extractionMethod = GeneratedColumn<String>(
    'extraction_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pdf_text'),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('review_required'),
  );
  static const VerificationMeta _fullTextAvailableMeta = const VerificationMeta(
    'fullTextAvailable',
  );
  @override
  late final GeneratedColumn<bool> fullTextAvailable = GeneratedColumn<bool>(
    'full_text_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("full_text_available" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _verificationStatusMeta =
      const VerificationMeta('verificationStatus');
  @override
  late final GeneratedColumn<String> verificationStatus =
      GeneratedColumn<String>(
        'verification_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('pending_review'),
      );
  static const VerificationMeta _sourceProvisionRefMeta =
      const VerificationMeta('sourceProvisionRef');
  @override
  late final GeneratedColumn<String> sourceProvisionRef =
      GeneratedColumn<String>(
        'source_provision_ref',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    referenceId,
    referenceType,
    title,
    referenceNumber,
    parentDocument,
    bookPage,
    sourceText,
    extractionMethod,
    confidence,
    fullTextAvailable,
    verificationStatus,
    sourceProvisionRef,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_references';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalReference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceIdMeta);
    }
    if (data.containsKey('reference_type')) {
      context.handle(
        _referenceTypeMeta,
        referenceType.isAcceptableOrUnknown(
          data['reference_type']!,
          _referenceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('reference_number')) {
      context.handle(
        _referenceNumberMeta,
        referenceNumber.isAcceptableOrUnknown(
          data['reference_number']!,
          _referenceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceNumberMeta);
    }
    if (data.containsKey('parent_document')) {
      context.handle(
        _parentDocumentMeta,
        parentDocument.isAcceptableOrUnknown(
          data['parent_document']!,
          _parentDocumentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_parentDocumentMeta);
    }
    if (data.containsKey('book_page')) {
      context.handle(
        _bookPageMeta,
        bookPage.isAcceptableOrUnknown(data['book_page']!, _bookPageMeta),
      );
    } else if (isInserting) {
      context.missing(_bookPageMeta);
    }
    if (data.containsKey('source_text')) {
      context.handle(
        _sourceTextMeta,
        sourceText.isAcceptableOrUnknown(data['source_text']!, _sourceTextMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTextMeta);
    }
    if (data.containsKey('extraction_method')) {
      context.handle(
        _extractionMethodMeta,
        extractionMethod.isAcceptableOrUnknown(
          data['extraction_method']!,
          _extractionMethodMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('full_text_available')) {
      context.handle(
        _fullTextAvailableMeta,
        fullTextAvailable.isAcceptableOrUnknown(
          data['full_text_available']!,
          _fullTextAvailableMeta,
        ),
      );
    }
    if (data.containsKey('verification_status')) {
      context.handle(
        _verificationStatusMeta,
        verificationStatus.isAcceptableOrUnknown(
          data['verification_status']!,
          _verificationStatusMeta,
        ),
      );
    }
    if (data.containsKey('source_provision_ref')) {
      context.handle(
        _sourceProvisionRefMeta,
        sourceProvisionRef.isAcceptableOrUnknown(
          data['source_provision_ref']!,
          _sourceProvisionRefMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceProvisionRefMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {referenceId};
  @override
  LegalReference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalReference(
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      )!,
      referenceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      referenceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_number'],
      )!,
      parentDocument: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_document'],
      )!,
      bookPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_page'],
      )!,
      sourceText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_text'],
      )!,
      extractionMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extraction_method'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      )!,
      fullTextAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}full_text_available'],
      )!,
      verificationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification_status'],
      )!,
      sourceProvisionRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_provision_ref'],
      )!,
    );
  }

  @override
  $LegalReferencesTable createAlias(String alias) {
    return $LegalReferencesTable(attachedDatabase, alias);
  }
}

class LegalReference extends DataClass implements Insertable<LegalReference> {
  /// Unique extraction trace ID.
  final String referenceId;

  /// Reference class (`legislative_act`, `amendment_act`, `constitutional_order`, `judicial_decision`).
  final String referenceType;

  /// Extracted Act, Amendment, or Judgment title/citation.
  final String title;

  /// Reference number / Ninth Schedule Entry / Citation.
  final String referenceNumber;

  /// Source book title (`Constitution of India`).
  final String parentDocument;

  /// Exact book page number.
  final int bookPage;

  /// Verbatim excerpt from the source book.
  final String sourceText;

  /// Extraction method (`pdf_text`, `ocr`).
  final String extractionMethod;

  /// Extraction confidence (`high`, `review_required`).
  final String confidence;

  /// Whether full statutory/judgment text is locally available (`false` for external acts in Constitution footnotes).
  final bool fullTextAvailable;

  /// Review status (`verified_in_book`, `pending_review`, `rejected`).
  final String verificationStatus;

  /// Source provision citing this reference.
  final String sourceProvisionRef;
  const LegalReference({
    required this.referenceId,
    required this.referenceType,
    required this.title,
    required this.referenceNumber,
    required this.parentDocument,
    required this.bookPage,
    required this.sourceText,
    required this.extractionMethod,
    required this.confidence,
    required this.fullTextAvailable,
    required this.verificationStatus,
    required this.sourceProvisionRef,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['reference_id'] = Variable<String>(referenceId);
    map['reference_type'] = Variable<String>(referenceType);
    map['title'] = Variable<String>(title);
    map['reference_number'] = Variable<String>(referenceNumber);
    map['parent_document'] = Variable<String>(parentDocument);
    map['book_page'] = Variable<int>(bookPage);
    map['source_text'] = Variable<String>(sourceText);
    map['extraction_method'] = Variable<String>(extractionMethod);
    map['confidence'] = Variable<String>(confidence);
    map['full_text_available'] = Variable<bool>(fullTextAvailable);
    map['verification_status'] = Variable<String>(verificationStatus);
    map['source_provision_ref'] = Variable<String>(sourceProvisionRef);
    return map;
  }

  LegalReferencesCompanion toCompanion(bool nullToAbsent) {
    return LegalReferencesCompanion(
      referenceId: Value(referenceId),
      referenceType: Value(referenceType),
      title: Value(title),
      referenceNumber: Value(referenceNumber),
      parentDocument: Value(parentDocument),
      bookPage: Value(bookPage),
      sourceText: Value(sourceText),
      extractionMethod: Value(extractionMethod),
      confidence: Value(confidence),
      fullTextAvailable: Value(fullTextAvailable),
      verificationStatus: Value(verificationStatus),
      sourceProvisionRef: Value(sourceProvisionRef),
    );
  }

  factory LegalReference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalReference(
      referenceId: serializer.fromJson<String>(json['referenceId']),
      referenceType: serializer.fromJson<String>(json['referenceType']),
      title: serializer.fromJson<String>(json['title']),
      referenceNumber: serializer.fromJson<String>(json['referenceNumber']),
      parentDocument: serializer.fromJson<String>(json['parentDocument']),
      bookPage: serializer.fromJson<int>(json['bookPage']),
      sourceText: serializer.fromJson<String>(json['sourceText']),
      extractionMethod: serializer.fromJson<String>(json['extractionMethod']),
      confidence: serializer.fromJson<String>(json['confidence']),
      fullTextAvailable: serializer.fromJson<bool>(json['fullTextAvailable']),
      verificationStatus: serializer.fromJson<String>(
        json['verificationStatus'],
      ),
      sourceProvisionRef: serializer.fromJson<String>(
        json['sourceProvisionRef'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'referenceId': serializer.toJson<String>(referenceId),
      'referenceType': serializer.toJson<String>(referenceType),
      'title': serializer.toJson<String>(title),
      'referenceNumber': serializer.toJson<String>(referenceNumber),
      'parentDocument': serializer.toJson<String>(parentDocument),
      'bookPage': serializer.toJson<int>(bookPage),
      'sourceText': serializer.toJson<String>(sourceText),
      'extractionMethod': serializer.toJson<String>(extractionMethod),
      'confidence': serializer.toJson<String>(confidence),
      'fullTextAvailable': serializer.toJson<bool>(fullTextAvailable),
      'verificationStatus': serializer.toJson<String>(verificationStatus),
      'sourceProvisionRef': serializer.toJson<String>(sourceProvisionRef),
    };
  }

  LegalReference copyWith({
    String? referenceId,
    String? referenceType,
    String? title,
    String? referenceNumber,
    String? parentDocument,
    int? bookPage,
    String? sourceText,
    String? extractionMethod,
    String? confidence,
    bool? fullTextAvailable,
    String? verificationStatus,
    String? sourceProvisionRef,
  }) => LegalReference(
    referenceId: referenceId ?? this.referenceId,
    referenceType: referenceType ?? this.referenceType,
    title: title ?? this.title,
    referenceNumber: referenceNumber ?? this.referenceNumber,
    parentDocument: parentDocument ?? this.parentDocument,
    bookPage: bookPage ?? this.bookPage,
    sourceText: sourceText ?? this.sourceText,
    extractionMethod: extractionMethod ?? this.extractionMethod,
    confidence: confidence ?? this.confidence,
    fullTextAvailable: fullTextAvailable ?? this.fullTextAvailable,
    verificationStatus: verificationStatus ?? this.verificationStatus,
    sourceProvisionRef: sourceProvisionRef ?? this.sourceProvisionRef,
  );
  LegalReference copyWithCompanion(LegalReferencesCompanion data) {
    return LegalReference(
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      referenceType: data.referenceType.present
          ? data.referenceType.value
          : this.referenceType,
      title: data.title.present ? data.title.value : this.title,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      parentDocument: data.parentDocument.present
          ? data.parentDocument.value
          : this.parentDocument,
      bookPage: data.bookPage.present ? data.bookPage.value : this.bookPage,
      sourceText: data.sourceText.present
          ? data.sourceText.value
          : this.sourceText,
      extractionMethod: data.extractionMethod.present
          ? data.extractionMethod.value
          : this.extractionMethod,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      fullTextAvailable: data.fullTextAvailable.present
          ? data.fullTextAvailable.value
          : this.fullTextAvailable,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
      sourceProvisionRef: data.sourceProvisionRef.present
          ? data.sourceProvisionRef.value
          : this.sourceProvisionRef,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalReference(')
          ..write('referenceId: $referenceId, ')
          ..write('referenceType: $referenceType, ')
          ..write('title: $title, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('parentDocument: $parentDocument, ')
          ..write('bookPage: $bookPage, ')
          ..write('sourceText: $sourceText, ')
          ..write('extractionMethod: $extractionMethod, ')
          ..write('confidence: $confidence, ')
          ..write('fullTextAvailable: $fullTextAvailable, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('sourceProvisionRef: $sourceProvisionRef')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    referenceId,
    referenceType,
    title,
    referenceNumber,
    parentDocument,
    bookPage,
    sourceText,
    extractionMethod,
    confidence,
    fullTextAvailable,
    verificationStatus,
    sourceProvisionRef,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalReference &&
          other.referenceId == this.referenceId &&
          other.referenceType == this.referenceType &&
          other.title == this.title &&
          other.referenceNumber == this.referenceNumber &&
          other.parentDocument == this.parentDocument &&
          other.bookPage == this.bookPage &&
          other.sourceText == this.sourceText &&
          other.extractionMethod == this.extractionMethod &&
          other.confidence == this.confidence &&
          other.fullTextAvailable == this.fullTextAvailable &&
          other.verificationStatus == this.verificationStatus &&
          other.sourceProvisionRef == this.sourceProvisionRef);
}

class LegalReferencesCompanion extends UpdateCompanion<LegalReference> {
  final Value<String> referenceId;
  final Value<String> referenceType;
  final Value<String> title;
  final Value<String> referenceNumber;
  final Value<String> parentDocument;
  final Value<int> bookPage;
  final Value<String> sourceText;
  final Value<String> extractionMethod;
  final Value<String> confidence;
  final Value<bool> fullTextAvailable;
  final Value<String> verificationStatus;
  final Value<String> sourceProvisionRef;
  final Value<int> rowid;
  const LegalReferencesCompanion({
    this.referenceId = const Value.absent(),
    this.referenceType = const Value.absent(),
    this.title = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.parentDocument = const Value.absent(),
    this.bookPage = const Value.absent(),
    this.sourceText = const Value.absent(),
    this.extractionMethod = const Value.absent(),
    this.confidence = const Value.absent(),
    this.fullTextAvailable = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.sourceProvisionRef = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalReferencesCompanion.insert({
    required String referenceId,
    required String referenceType,
    required String title,
    required String referenceNumber,
    required String parentDocument,
    required int bookPage,
    required String sourceText,
    this.extractionMethod = const Value.absent(),
    this.confidence = const Value.absent(),
    this.fullTextAvailable = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    required String sourceProvisionRef,
    this.rowid = const Value.absent(),
  }) : referenceId = Value(referenceId),
       referenceType = Value(referenceType),
       title = Value(title),
       referenceNumber = Value(referenceNumber),
       parentDocument = Value(parentDocument),
       bookPage = Value(bookPage),
       sourceText = Value(sourceText),
       sourceProvisionRef = Value(sourceProvisionRef);
  static Insertable<LegalReference> custom({
    Expression<String>? referenceId,
    Expression<String>? referenceType,
    Expression<String>? title,
    Expression<String>? referenceNumber,
    Expression<String>? parentDocument,
    Expression<int>? bookPage,
    Expression<String>? sourceText,
    Expression<String>? extractionMethod,
    Expression<String>? confidence,
    Expression<bool>? fullTextAvailable,
    Expression<String>? verificationStatus,
    Expression<String>? sourceProvisionRef,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (referenceId != null) 'reference_id': referenceId,
      if (referenceType != null) 'reference_type': referenceType,
      if (title != null) 'title': title,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (parentDocument != null) 'parent_document': parentDocument,
      if (bookPage != null) 'book_page': bookPage,
      if (sourceText != null) 'source_text': sourceText,
      if (extractionMethod != null) 'extraction_method': extractionMethod,
      if (confidence != null) 'confidence': confidence,
      if (fullTextAvailable != null) 'full_text_available': fullTextAvailable,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (sourceProvisionRef != null)
        'source_provision_ref': sourceProvisionRef,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalReferencesCompanion copyWith({
    Value<String>? referenceId,
    Value<String>? referenceType,
    Value<String>? title,
    Value<String>? referenceNumber,
    Value<String>? parentDocument,
    Value<int>? bookPage,
    Value<String>? sourceText,
    Value<String>? extractionMethod,
    Value<String>? confidence,
    Value<bool>? fullTextAvailable,
    Value<String>? verificationStatus,
    Value<String>? sourceProvisionRef,
    Value<int>? rowid,
  }) {
    return LegalReferencesCompanion(
      referenceId: referenceId ?? this.referenceId,
      referenceType: referenceType ?? this.referenceType,
      title: title ?? this.title,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      parentDocument: parentDocument ?? this.parentDocument,
      bookPage: bookPage ?? this.bookPage,
      sourceText: sourceText ?? this.sourceText,
      extractionMethod: extractionMethod ?? this.extractionMethod,
      confidence: confidence ?? this.confidence,
      fullTextAvailable: fullTextAvailable ?? this.fullTextAvailable,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      sourceProvisionRef: sourceProvisionRef ?? this.sourceProvisionRef,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (referenceType.present) {
      map['reference_type'] = Variable<String>(referenceType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (parentDocument.present) {
      map['parent_document'] = Variable<String>(parentDocument.value);
    }
    if (bookPage.present) {
      map['book_page'] = Variable<int>(bookPage.value);
    }
    if (sourceText.present) {
      map['source_text'] = Variable<String>(sourceText.value);
    }
    if (extractionMethod.present) {
      map['extraction_method'] = Variable<String>(extractionMethod.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (fullTextAvailable.present) {
      map['full_text_available'] = Variable<bool>(fullTextAvailable.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(verificationStatus.value);
    }
    if (sourceProvisionRef.present) {
      map['source_provision_ref'] = Variable<String>(sourceProvisionRef.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalReferencesCompanion(')
          ..write('referenceId: $referenceId, ')
          ..write('referenceType: $referenceType, ')
          ..write('title: $title, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('parentDocument: $parentDocument, ')
          ..write('bookPage: $bookPage, ')
          ..write('sourceText: $sourceText, ')
          ..write('extractionMethod: $extractionMethod, ')
          ..write('confidence: $confidence, ')
          ..write('fullTextAvailable: $fullTextAvailable, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('sourceProvisionRef: $sourceProvisionRef, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegalEntitiesTable extends LegalEntities
    with TableInfo<$LegalEntitiesTable, LegalEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalEntitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalRefMeta = const VerificationMeta(
    'canonicalRef',
  );
  @override
  late final GeneratedColumn<String> canonicalRef = GeneratedColumn<String>(
    'canonical_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullTextAvailableMeta = const VerificationMeta(
    'fullTextAvailable',
  );
  @override
  late final GeneratedColumn<bool> fullTextAvailable = GeneratedColumn<bool>(
    'full_text_available',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("full_text_available" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    entityId,
    entityType,
    canonicalRef,
    label,
    fullTextAvailable,
    metadataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_entities';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('canonical_ref')) {
      context.handle(
        _canonicalRefMeta,
        canonicalRef.isAcceptableOrUnknown(
          data['canonical_ref']!,
          _canonicalRefMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalRefMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('full_text_available')) {
      context.handle(
        _fullTextAvailableMeta,
        fullTextAvailable.isAcceptableOrUnknown(
          data['full_text_available']!,
          _fullTextAvailableMeta,
        ),
      );
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  LegalEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalEntity(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      canonicalRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_ref'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      fullTextAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}full_text_available'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      )!,
    );
  }

  @override
  $LegalEntitiesTable createAlias(String alias) {
    return $LegalEntitiesTable(attachedDatabase, alias);
  }
}

class LegalEntity extends DataClass implements Insertable<LegalEntity> {
  /// Unique entity ID.
  final String entityId;

  /// Node type (`constitution`, `constitutional_article`, `legislative_act`, `judicial_decision`, etc.).
  final String entityType;

  /// Canonical ID string.
  final String canonicalRef;

  /// Human-readable node label.
  final String label;

  /// Whether verified full text exists for this node.
  final bool fullTextAvailable;

  /// JSON metadata payload.
  final String metadataJson;
  const LegalEntity({
    required this.entityId,
    required this.entityType,
    required this.canonicalRef,
    required this.label,
    required this.fullTextAvailable,
    required this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    map['entity_type'] = Variable<String>(entityType);
    map['canonical_ref'] = Variable<String>(canonicalRef);
    map['label'] = Variable<String>(label);
    map['full_text_available'] = Variable<bool>(fullTextAvailable);
    map['metadata_json'] = Variable<String>(metadataJson);
    return map;
  }

  LegalEntitiesCompanion toCompanion(bool nullToAbsent) {
    return LegalEntitiesCompanion(
      entityId: Value(entityId),
      entityType: Value(entityType),
      canonicalRef: Value(canonicalRef),
      label: Value(label),
      fullTextAvailable: Value(fullTextAvailable),
      metadataJson: Value(metadataJson),
    );
  }

  factory LegalEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalEntity(
      entityId: serializer.fromJson<String>(json['entityId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      canonicalRef: serializer.fromJson<String>(json['canonicalRef']),
      label: serializer.fromJson<String>(json['label']),
      fullTextAvailable: serializer.fromJson<bool>(json['fullTextAvailable']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityId': serializer.toJson<String>(entityId),
      'entityType': serializer.toJson<String>(entityType),
      'canonicalRef': serializer.toJson<String>(canonicalRef),
      'label': serializer.toJson<String>(label),
      'fullTextAvailable': serializer.toJson<bool>(fullTextAvailable),
      'metadataJson': serializer.toJson<String>(metadataJson),
    };
  }

  LegalEntity copyWith({
    String? entityId,
    String? entityType,
    String? canonicalRef,
    String? label,
    bool? fullTextAvailable,
    String? metadataJson,
  }) => LegalEntity(
    entityId: entityId ?? this.entityId,
    entityType: entityType ?? this.entityType,
    canonicalRef: canonicalRef ?? this.canonicalRef,
    label: label ?? this.label,
    fullTextAvailable: fullTextAvailable ?? this.fullTextAvailable,
    metadataJson: metadataJson ?? this.metadataJson,
  );
  LegalEntity copyWithCompanion(LegalEntitiesCompanion data) {
    return LegalEntity(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      canonicalRef: data.canonicalRef.present
          ? data.canonicalRef.value
          : this.canonicalRef,
      label: data.label.present ? data.label.value : this.label,
      fullTextAvailable: data.fullTextAvailable.present
          ? data.fullTextAvailable.value
          : this.fullTextAvailable,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalEntity(')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('canonicalRef: $canonicalRef, ')
          ..write('label: $label, ')
          ..write('fullTextAvailable: $fullTextAvailable, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    entityId,
    entityType,
    canonicalRef,
    label,
    fullTextAvailable,
    metadataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalEntity &&
          other.entityId == this.entityId &&
          other.entityType == this.entityType &&
          other.canonicalRef == this.canonicalRef &&
          other.label == this.label &&
          other.fullTextAvailable == this.fullTextAvailable &&
          other.metadataJson == this.metadataJson);
}

class LegalEntitiesCompanion extends UpdateCompanion<LegalEntity> {
  final Value<String> entityId;
  final Value<String> entityType;
  final Value<String> canonicalRef;
  final Value<String> label;
  final Value<bool> fullTextAvailable;
  final Value<String> metadataJson;
  final Value<int> rowid;
  const LegalEntitiesCompanion({
    this.entityId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.canonicalRef = const Value.absent(),
    this.label = const Value.absent(),
    this.fullTextAvailable = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalEntitiesCompanion.insert({
    required String entityId,
    required String entityType,
    required String canonicalRef,
    required String label,
    this.fullTextAvailable = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId),
       entityType = Value(entityType),
       canonicalRef = Value(canonicalRef),
       label = Value(label);
  static Insertable<LegalEntity> custom({
    Expression<String>? entityId,
    Expression<String>? entityType,
    Expression<String>? canonicalRef,
    Expression<String>? label,
    Expression<bool>? fullTextAvailable,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (entityType != null) 'entity_type': entityType,
      if (canonicalRef != null) 'canonical_ref': canonicalRef,
      if (label != null) 'label': label,
      if (fullTextAvailable != null) 'full_text_available': fullTextAvailable,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalEntitiesCompanion copyWith({
    Value<String>? entityId,
    Value<String>? entityType,
    Value<String>? canonicalRef,
    Value<String>? label,
    Value<bool>? fullTextAvailable,
    Value<String>? metadataJson,
    Value<int>? rowid,
  }) {
    return LegalEntitiesCompanion(
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      canonicalRef: canonicalRef ?? this.canonicalRef,
      label: label ?? this.label,
      fullTextAvailable: fullTextAvailable ?? this.fullTextAvailable,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (canonicalRef.present) {
      map['canonical_ref'] = Variable<String>(canonicalRef.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (fullTextAvailable.present) {
      map['full_text_available'] = Variable<bool>(fullTextAvailable.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalEntitiesCompanion(')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('canonicalRef: $canonicalRef, ')
          ..write('label: $label, ')
          ..write('fullTextAvailable: $fullTextAvailable, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegalRelationsTable extends LegalRelations
    with TableInfo<$LegalRelationsTable, LegalRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _relationIdMeta = const VerificationMeta(
    'relationId',
  );
  @override
  late final GeneratedColumn<String> relationId = GeneratedColumn<String>(
    'relation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromEntityMeta = const VerificationMeta(
    'fromEntity',
  );
  @override
  late final GeneratedColumn<String> fromEntity = GeneratedColumn<String>(
    'from_entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationTypeMeta = const VerificationMeta(
    'relationType',
  );
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
    'relation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toEntityMeta = const VerificationMeta(
    'toEntity',
  );
  @override
  late final GeneratedColumn<String> toEntity = GeneratedColumn<String>(
    'to_entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceRefMeta = const VerificationMeta(
    'sourceRef',
  );
  @override
  late final GeneratedColumn<String> sourceRef = GeneratedColumn<String>(
    'source_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookPageMeta = const VerificationMeta(
    'bookPage',
  );
  @override
  late final GeneratedColumn<int> bookPage = GeneratedColumn<int>(
    'book_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('high'),
  );
  static const VerificationMeta _verificationStatusMeta =
      const VerificationMeta('verificationStatus');
  @override
  late final GeneratedColumn<String> verificationStatus =
      GeneratedColumn<String>(
        'verification_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('verified_in_book'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    relationId,
    fromEntity,
    relationType,
    toEntity,
    sourceRef,
    bookPage,
    confidence,
    verificationStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalRelation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('relation_id')) {
      context.handle(
        _relationIdMeta,
        relationId.isAcceptableOrUnknown(data['relation_id']!, _relationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_relationIdMeta);
    }
    if (data.containsKey('from_entity')) {
      context.handle(
        _fromEntityMeta,
        fromEntity.isAcceptableOrUnknown(data['from_entity']!, _fromEntityMeta),
      );
    } else if (isInserting) {
      context.missing(_fromEntityMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
        _relationTypeMeta,
        relationType.isAcceptableOrUnknown(
          data['relation_type']!,
          _relationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relationTypeMeta);
    }
    if (data.containsKey('to_entity')) {
      context.handle(
        _toEntityMeta,
        toEntity.isAcceptableOrUnknown(data['to_entity']!, _toEntityMeta),
      );
    } else if (isInserting) {
      context.missing(_toEntityMeta);
    }
    if (data.containsKey('source_ref')) {
      context.handle(
        _sourceRefMeta,
        sourceRef.isAcceptableOrUnknown(data['source_ref']!, _sourceRefMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceRefMeta);
    }
    if (data.containsKey('book_page')) {
      context.handle(
        _bookPageMeta,
        bookPage.isAcceptableOrUnknown(data['book_page']!, _bookPageMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('verification_status')) {
      context.handle(
        _verificationStatusMeta,
        verificationStatus.isAcceptableOrUnknown(
          data['verification_status']!,
          _verificationStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {relationId};
  @override
  LegalRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalRelation(
      relationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_id'],
      )!,
      fromEntity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_entity'],
      )!,
      relationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_type'],
      )!,
      toEntity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_entity'],
      )!,
      sourceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_ref'],
      )!,
      bookPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_page'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      )!,
      verificationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verification_status'],
      )!,
    );
  }

  @override
  $LegalRelationsTable createAlias(String alias) {
    return $LegalRelationsTable(attachedDatabase, alias);
  }
}

class LegalRelation extends DataClass implements Insertable<LegalRelation> {
  /// Unique edge ID.
  final String relationId;

  /// Source entity ID.
  final String fromEntity;

  /// Directed relation (`amends`, `omits`, `struck_down_by`, `interprets`, `protected_under_schedule_9`, `cross_references`).
  final String relationType;

  /// Target entity ID.
  final String toEntity;

  /// Provenance note (`Constitution fn p.89`).
  final String sourceRef;

  /// Source page number.
  final int bookPage;

  /// Edge confidence (`high`, `review_required`).
  final String confidence;

  /// Verification state (`verified_in_book`, `pending_review`).
  final String verificationStatus;
  const LegalRelation({
    required this.relationId,
    required this.fromEntity,
    required this.relationType,
    required this.toEntity,
    required this.sourceRef,
    required this.bookPage,
    required this.confidence,
    required this.verificationStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['relation_id'] = Variable<String>(relationId);
    map['from_entity'] = Variable<String>(fromEntity);
    map['relation_type'] = Variable<String>(relationType);
    map['to_entity'] = Variable<String>(toEntity);
    map['source_ref'] = Variable<String>(sourceRef);
    map['book_page'] = Variable<int>(bookPage);
    map['confidence'] = Variable<String>(confidence);
    map['verification_status'] = Variable<String>(verificationStatus);
    return map;
  }

  LegalRelationsCompanion toCompanion(bool nullToAbsent) {
    return LegalRelationsCompanion(
      relationId: Value(relationId),
      fromEntity: Value(fromEntity),
      relationType: Value(relationType),
      toEntity: Value(toEntity),
      sourceRef: Value(sourceRef),
      bookPage: Value(bookPage),
      confidence: Value(confidence),
      verificationStatus: Value(verificationStatus),
    );
  }

  factory LegalRelation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalRelation(
      relationId: serializer.fromJson<String>(json['relationId']),
      fromEntity: serializer.fromJson<String>(json['fromEntity']),
      relationType: serializer.fromJson<String>(json['relationType']),
      toEntity: serializer.fromJson<String>(json['toEntity']),
      sourceRef: serializer.fromJson<String>(json['sourceRef']),
      bookPage: serializer.fromJson<int>(json['bookPage']),
      confidence: serializer.fromJson<String>(json['confidence']),
      verificationStatus: serializer.fromJson<String>(
        json['verificationStatus'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'relationId': serializer.toJson<String>(relationId),
      'fromEntity': serializer.toJson<String>(fromEntity),
      'relationType': serializer.toJson<String>(relationType),
      'toEntity': serializer.toJson<String>(toEntity),
      'sourceRef': serializer.toJson<String>(sourceRef),
      'bookPage': serializer.toJson<int>(bookPage),
      'confidence': serializer.toJson<String>(confidence),
      'verificationStatus': serializer.toJson<String>(verificationStatus),
    };
  }

  LegalRelation copyWith({
    String? relationId,
    String? fromEntity,
    String? relationType,
    String? toEntity,
    String? sourceRef,
    int? bookPage,
    String? confidence,
    String? verificationStatus,
  }) => LegalRelation(
    relationId: relationId ?? this.relationId,
    fromEntity: fromEntity ?? this.fromEntity,
    relationType: relationType ?? this.relationType,
    toEntity: toEntity ?? this.toEntity,
    sourceRef: sourceRef ?? this.sourceRef,
    bookPage: bookPage ?? this.bookPage,
    confidence: confidence ?? this.confidence,
    verificationStatus: verificationStatus ?? this.verificationStatus,
  );
  LegalRelation copyWithCompanion(LegalRelationsCompanion data) {
    return LegalRelation(
      relationId: data.relationId.present
          ? data.relationId.value
          : this.relationId,
      fromEntity: data.fromEntity.present
          ? data.fromEntity.value
          : this.fromEntity,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
      toEntity: data.toEntity.present ? data.toEntity.value : this.toEntity,
      sourceRef: data.sourceRef.present ? data.sourceRef.value : this.sourceRef,
      bookPage: data.bookPage.present ? data.bookPage.value : this.bookPage,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      verificationStatus: data.verificationStatus.present
          ? data.verificationStatus.value
          : this.verificationStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalRelation(')
          ..write('relationId: $relationId, ')
          ..write('fromEntity: $fromEntity, ')
          ..write('relationType: $relationType, ')
          ..write('toEntity: $toEntity, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('bookPage: $bookPage, ')
          ..write('confidence: $confidence, ')
          ..write('verificationStatus: $verificationStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    relationId,
    fromEntity,
    relationType,
    toEntity,
    sourceRef,
    bookPage,
    confidence,
    verificationStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalRelation &&
          other.relationId == this.relationId &&
          other.fromEntity == this.fromEntity &&
          other.relationType == this.relationType &&
          other.toEntity == this.toEntity &&
          other.sourceRef == this.sourceRef &&
          other.bookPage == this.bookPage &&
          other.confidence == this.confidence &&
          other.verificationStatus == this.verificationStatus);
}

class LegalRelationsCompanion extends UpdateCompanion<LegalRelation> {
  final Value<String> relationId;
  final Value<String> fromEntity;
  final Value<String> relationType;
  final Value<String> toEntity;
  final Value<String> sourceRef;
  final Value<int> bookPage;
  final Value<String> confidence;
  final Value<String> verificationStatus;
  final Value<int> rowid;
  const LegalRelationsCompanion({
    this.relationId = const Value.absent(),
    this.fromEntity = const Value.absent(),
    this.relationType = const Value.absent(),
    this.toEntity = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.bookPage = const Value.absent(),
    this.confidence = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalRelationsCompanion.insert({
    required String relationId,
    required String fromEntity,
    required String relationType,
    required String toEntity,
    required String sourceRef,
    this.bookPage = const Value.absent(),
    this.confidence = const Value.absent(),
    this.verificationStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : relationId = Value(relationId),
       fromEntity = Value(fromEntity),
       relationType = Value(relationType),
       toEntity = Value(toEntity),
       sourceRef = Value(sourceRef);
  static Insertable<LegalRelation> custom({
    Expression<String>? relationId,
    Expression<String>? fromEntity,
    Expression<String>? relationType,
    Expression<String>? toEntity,
    Expression<String>? sourceRef,
    Expression<int>? bookPage,
    Expression<String>? confidence,
    Expression<String>? verificationStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (relationId != null) 'relation_id': relationId,
      if (fromEntity != null) 'from_entity': fromEntity,
      if (relationType != null) 'relation_type': relationType,
      if (toEntity != null) 'to_entity': toEntity,
      if (sourceRef != null) 'source_ref': sourceRef,
      if (bookPage != null) 'book_page': bookPage,
      if (confidence != null) 'confidence': confidence,
      if (verificationStatus != null) 'verification_status': verificationStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalRelationsCompanion copyWith({
    Value<String>? relationId,
    Value<String>? fromEntity,
    Value<String>? relationType,
    Value<String>? toEntity,
    Value<String>? sourceRef,
    Value<int>? bookPage,
    Value<String>? confidence,
    Value<String>? verificationStatus,
    Value<int>? rowid,
  }) {
    return LegalRelationsCompanion(
      relationId: relationId ?? this.relationId,
      fromEntity: fromEntity ?? this.fromEntity,
      relationType: relationType ?? this.relationType,
      toEntity: toEntity ?? this.toEntity,
      sourceRef: sourceRef ?? this.sourceRef,
      bookPage: bookPage ?? this.bookPage,
      confidence: confidence ?? this.confidence,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (relationId.present) {
      map['relation_id'] = Variable<String>(relationId.value);
    }
    if (fromEntity.present) {
      map['from_entity'] = Variable<String>(fromEntity.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (toEntity.present) {
      map['to_entity'] = Variable<String>(toEntity.value);
    }
    if (sourceRef.present) {
      map['source_ref'] = Variable<String>(sourceRef.value);
    }
    if (bookPage.present) {
      map['book_page'] = Variable<int>(bookPage.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (verificationStatus.present) {
      map['verification_status'] = Variable<String>(verificationStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalRelationsCompanion(')
          ..write('relationId: $relationId, ')
          ..write('fromEntity: $fromEntity, ')
          ..write('relationType: $relationType, ')
          ..write('toEntity: $toEntity, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('bookPage: $bookPage, ')
          ..write('confidence: $confidence, ')
          ..write('verificationStatus: $verificationStatus, ')
          ..write('rowid: $rowid')
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
  late final $ConversationsTable conversations = $ConversationsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $DocumentChunksTable documentChunks = $DocumentChunksTable(this);
  late final $ContractAnalysesTable contractAnalyses = $ContractAnalysesTable(
    this,
  );
  late final $RiskFindingsTable riskFindings = $RiskFindingsTable(this);
  late final $LegalKnowledgePacksTable legalKnowledgePacks =
      $LegalKnowledgePacksTable(this);
  late final $ComplianceRecordsTable complianceRecords =
      $ComplianceRecordsTable(this);
  late final $AiExecutionLogsTable aiExecutionLogs = $AiExecutionLogsTable(
    this,
  );
  late final $AuditEventsTable auditEvents = $AuditEventsTable(this);
  late final $LegalInstrumentsTable legalInstruments = $LegalInstrumentsTable(
    this,
  );
  late final $LegalProvisionsTable legalProvisions = $LegalProvisionsTable(
    this,
  );
  late final $LegalFootnotesTable legalFootnotes = $LegalFootnotesTable(this);
  late final $LegalReferencesTable legalReferences = $LegalReferencesTable(
    this,
  );
  late final $LegalEntitiesTable legalEntities = $LegalEntitiesTable(this);
  late final $LegalRelationsTable legalRelations = $LegalRelationsTable(this);
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
    conversations,
    messages,
    documentChunks,
    contractAnalyses,
    riskFindings,
    legalKnowledgePacks,
    complianceRecords,
    aiExecutionLogs,
    auditEvents,
    legalInstruments,
    legalProvisions,
    legalFootnotes,
    legalReferences,
    legalEntities,
    legalRelations,
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
typedef $$ConversationsTableCreateCompanionBuilder =
    ConversationsCompanion Function({
      required String id,
      Value<String> title,
      Value<String?> attachedScanId,
      Value<String?> attachedScanJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ConversationsTableUpdateCompanionBuilder =
    ConversationsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> attachedScanId,
      Value<String?> attachedScanJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableFilterComposer({
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

  ColumnFilters<String> get attachedScanId => $composableBuilder(
    column: $table.attachedScanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachedScanJson => $composableBuilder(
    column: $table.attachedScanJson,
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

class $$ConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableOrderingComposer({
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

  ColumnOrderings<String> get attachedScanId => $composableBuilder(
    column: $table.attachedScanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachedScanJson => $composableBuilder(
    column: $table.attachedScanJson,
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

class $$ConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationsTable> {
  $$ConversationsTableAnnotationComposer({
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

  GeneratedColumn<String> get attachedScanId => $composableBuilder(
    column: $table.attachedScanId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attachedScanJson => $composableBuilder(
    column: $table.attachedScanJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationsTable,
          Conversation,
          $$ConversationsTableFilterComposer,
          $$ConversationsTableOrderingComposer,
          $$ConversationsTableAnnotationComposer,
          $$ConversationsTableCreateCompanionBuilder,
          $$ConversationsTableUpdateCompanionBuilder,
          (
            Conversation,
            BaseReferences<_$AppDatabase, $ConversationsTable, Conversation>,
          ),
          Conversation,
          PrefetchHooks Function()
        > {
  $$ConversationsTableTableManager(_$AppDatabase db, $ConversationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> attachedScanId = const Value.absent(),
                Value<String?> attachedScanJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion(
                id: id,
                title: title,
                attachedScanId: attachedScanId,
                attachedScanJson: attachedScanJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> title = const Value.absent(),
                Value<String?> attachedScanId = const Value.absent(),
                Value<String?> attachedScanJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationsCompanion.insert(
                id: id,
                title: title,
                attachedScanId: attachedScanId,
                attachedScanJson: attachedScanJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConversationsTable, Conversation>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ConversationsTable,
                    Conversation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationsTable,
      Conversation,
      $$ConversationsTableFilterComposer,
      $$ConversationsTableOrderingComposer,
      $$ConversationsTableAnnotationComposer,
      $$ConversationsTableCreateCompanionBuilder,
      $$ConversationsTableUpdateCompanionBuilder,
      (
        Conversation,
        BaseReferences<_$AppDatabase, $ConversationsTable, Conversation>,
      ),
      Conversation,
      PrefetchHooks Function()
    >;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String id,
  required String conversationId,
  required bool isUser,
  required String content,
  Value<String?> engineLabel,
  Value<String?> confidence,
  Value<String> citationsJson,
  Value<String?> reasoningTrail,
  Value<String?> counterArguments,
  Value<int> droppedUnverifiedCount,
  Value<String?> attachmentJson,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String> conversationId,
  Value<bool> isUser,
  Value<String> content,
  Value<String?> engineLabel,
  Value<String?> confidence,
  Value<String> citationsJson,
  Value<String?> reasoningTrail,
  Value<String?> counterArguments,
  Value<int> droppedUnverifiedCount,
  Value<String?> attachmentJson,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
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

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUser => $composableBuilder(
    column: $table.isUser,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineLabel => $composableBuilder(
    column: $table.engineLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get citationsJson => $composableBuilder(
    column: $table.citationsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasoningTrail => $composableBuilder(
    column: $table.reasoningTrail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterArguments => $composableBuilder(
    column: $table.counterArguments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get droppedUnverifiedCount => $composableBuilder(
    column: $table.droppedUnverifiedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachmentJson => $composableBuilder(
    column: $table.attachmentJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
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

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUser => $composableBuilder(
    column: $table.isUser,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineLabel => $composableBuilder(
    column: $table.engineLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citationsJson => $composableBuilder(
    column: $table.citationsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasoningTrail => $composableBuilder(
    column: $table.reasoningTrail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterArguments => $composableBuilder(
    column: $table.counterArguments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get droppedUnverifiedCount => $composableBuilder(
    column: $table.droppedUnverifiedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachmentJson => $composableBuilder(
    column: $table.attachmentJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUser =>
      $composableBuilder(column: $table.isUser, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get engineLabel => $composableBuilder(
    column: $table.engineLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get citationsJson => $composableBuilder(
    column: $table.citationsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasoningTrail => $composableBuilder(
    column: $table.reasoningTrail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get counterArguments => $composableBuilder(
    column: $table.counterArguments,
    builder: (column) => column,
  );

  GeneratedColumn<int> get droppedUnverifiedCount => $composableBuilder(
    column: $table.droppedUnverifiedCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attachmentJson => $composableBuilder(
    column: $table.attachmentJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          Message,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
          Message,
          PrefetchHooks Function()
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<bool> isUser = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> engineLabel = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<String> citationsJson = const Value.absent(),
                Value<String?> reasoningTrail = const Value.absent(),
                Value<String?> counterArguments = const Value.absent(),
                Value<int> droppedUnverifiedCount = const Value.absent(),
                Value<String?> attachmentJson = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                conversationId: conversationId,
                isUser: isUser,
                content: content,
                engineLabel: engineLabel,
                confidence: confidence,
                citationsJson: citationsJson,
                reasoningTrail: reasoningTrail,
                counterArguments: counterArguments,
                droppedUnverifiedCount: droppedUnverifiedCount,
                attachmentJson: attachmentJson,
                errorMessage: errorMessage,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required bool isUser,
                required String content,
                Value<String?> engineLabel = const Value.absent(),
                Value<String?> confidence = const Value.absent(),
                Value<String> citationsJson = const Value.absent(),
                Value<String?> reasoningTrail = const Value.absent(),
                Value<String?> counterArguments = const Value.absent(),
                Value<int> droppedUnverifiedCount = const Value.absent(),
                Value<String?> attachmentJson = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                isUser: isUser,
                content: content,
                engineLabel: engineLabel,
                confidence: confidence,
                citationsJson: citationsJson,
                reasoningTrail: reasoningTrail,
                counterArguments: counterArguments,
                droppedUnverifiedCount: droppedUnverifiedCount,
                attachmentJson: attachmentJson,
                errorMessage: errorMessage,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesTable, Message>(table),
                  BaseReferences<_$AppDatabase, $MessagesTable, Message>(
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

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      Message,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
      Message,
      PrefetchHooks Function()
    >;
typedef $$DocumentChunksTableCreateCompanionBuilder =
    DocumentChunksCompanion Function({
      required String id,
      required String sourceId,
      required String sourceKind,
      Value<int> pageNumber,
      required int chunkIndex,
      required String chunkText,
      Value<Uint8List?> embeddingBlob,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$DocumentChunksTableUpdateCompanionBuilder =
    DocumentChunksCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> sourceKind,
      Value<int> pageNumber,
      Value<int> chunkIndex,
      Value<String> chunkText,
      Value<Uint8List?> embeddingBlob,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$DocumentChunksTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentChunksTable> {
  $$DocumentChunksTableFilterComposer({
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

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chunkIndex => $composableBuilder(
    column: $table.chunkIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chunkText => $composableBuilder(
    column: $table.chunkText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get embeddingBlob => $composableBuilder(
    column: $table.embeddingBlob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentChunksTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentChunksTable> {
  $$DocumentChunksTableOrderingComposer({
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

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chunkIndex => $composableBuilder(
    column: $table.chunkIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chunkText => $composableBuilder(
    column: $table.chunkText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get embeddingBlob => $composableBuilder(
    column: $table.embeddingBlob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentChunksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentChunksTable> {
  $$DocumentChunksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get sourceKind => $composableBuilder(
    column: $table.sourceKind,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chunkIndex => $composableBuilder(
    column: $table.chunkIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chunkText =>
      $composableBuilder(column: $table.chunkText, builder: (column) => column);

  GeneratedColumn<Uint8List> get embeddingBlob => $composableBuilder(
    column: $table.embeddingBlob,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DocumentChunksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentChunksTable,
          DocumentChunk,
          $$DocumentChunksTableFilterComposer,
          $$DocumentChunksTableOrderingComposer,
          $$DocumentChunksTableAnnotationComposer,
          $$DocumentChunksTableCreateCompanionBuilder,
          $$DocumentChunksTableUpdateCompanionBuilder,
          (
            DocumentChunk,
            BaseReferences<_$AppDatabase, $DocumentChunksTable, DocumentChunk>,
          ),
          DocumentChunk,
          PrefetchHooks Function()
        > {
  $$DocumentChunksTableTableManager(
    _$AppDatabase db,
    $DocumentChunksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentChunksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentChunksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> sourceKind = const Value.absent(),
                Value<int> pageNumber = const Value.absent(),
                Value<int> chunkIndex = const Value.absent(),
                Value<String> chunkText = const Value.absent(),
                Value<Uint8List?> embeddingBlob = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentChunksCompanion(
                id: id,
                sourceId: sourceId,
                sourceKind: sourceKind,
                pageNumber: pageNumber,
                chunkIndex: chunkIndex,
                chunkText: chunkText,
                embeddingBlob: embeddingBlob,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String sourceKind,
                Value<int> pageNumber = const Value.absent(),
                required int chunkIndex,
                required String chunkText,
                Value<Uint8List?> embeddingBlob = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentChunksCompanion.insert(
                id: id,
                sourceId: sourceId,
                sourceKind: sourceKind,
                pageNumber: pageNumber,
                chunkIndex: chunkIndex,
                chunkText: chunkText,
                embeddingBlob: embeddingBlob,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentChunksTable, DocumentChunk>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DocumentChunksTable,
                    DocumentChunk
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentChunksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentChunksTable,
      DocumentChunk,
      $$DocumentChunksTableFilterComposer,
      $$DocumentChunksTableOrderingComposer,
      $$DocumentChunksTableAnnotationComposer,
      $$DocumentChunksTableCreateCompanionBuilder,
      $$DocumentChunksTableUpdateCompanionBuilder,
      (
        DocumentChunk,
        BaseReferences<_$AppDatabase, $DocumentChunksTable, DocumentChunk>,
      ),
      DocumentChunk,
      PrefetchHooks Function()
    >;
typedef $$ContractAnalysesTableCreateCompanionBuilder =
    ContractAnalysesCompanion Function({
      required String id,
      required String title,
      Value<String?> documentPath,
      required int overallScore,
      Value<String> summaryJson,
      Value<String> engineLabel,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ContractAnalysesTableUpdateCompanionBuilder =
    ContractAnalysesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> documentPath,
      Value<int> overallScore,
      Value<String> summaryJson,
      Value<String> engineLabel,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ContractAnalysesTableFilterComposer
    extends Composer<_$AppDatabase, $ContractAnalysesTable> {
  $$ContractAnalysesTableFilterComposer({
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

  ColumnFilters<String> get documentPath => $composableBuilder(
    column: $table.documentPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineLabel => $composableBuilder(
    column: $table.engineLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContractAnalysesTableOrderingComposer
    extends Composer<_$AppDatabase, $ContractAnalysesTable> {
  $$ContractAnalysesTableOrderingComposer({
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

  ColumnOrderings<String> get documentPath => $composableBuilder(
    column: $table.documentPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineLabel => $composableBuilder(
    column: $table.engineLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContractAnalysesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContractAnalysesTable> {
  $$ContractAnalysesTableAnnotationComposer({
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

  GeneratedColumn<String> get documentPath => $composableBuilder(
    column: $table.documentPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get engineLabel => $composableBuilder(
    column: $table.engineLabel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ContractAnalysesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContractAnalysesTable,
          ContractAnalyse,
          $$ContractAnalysesTableFilterComposer,
          $$ContractAnalysesTableOrderingComposer,
          $$ContractAnalysesTableAnnotationComposer,
          $$ContractAnalysesTableCreateCompanionBuilder,
          $$ContractAnalysesTableUpdateCompanionBuilder,
          (
            ContractAnalyse,
            BaseReferences<
              _$AppDatabase,
              $ContractAnalysesTable,
              ContractAnalyse
            >,
          ),
          ContractAnalyse,
          PrefetchHooks Function()
        > {
  $$ContractAnalysesTableTableManager(
    _$AppDatabase db,
    $ContractAnalysesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractAnalysesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractAnalysesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractAnalysesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> documentPath = const Value.absent(),
                Value<int> overallScore = const Value.absent(),
                Value<String> summaryJson = const Value.absent(),
                Value<String> engineLabel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContractAnalysesCompanion(
                id: id,
                title: title,
                documentPath: documentPath,
                overallScore: overallScore,
                summaryJson: summaryJson,
                engineLabel: engineLabel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> documentPath = const Value.absent(),
                required int overallScore,
                Value<String> summaryJson = const Value.absent(),
                Value<String> engineLabel = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContractAnalysesCompanion.insert(
                id: id,
                title: title,
                documentPath: documentPath,
                overallScore: overallScore,
                summaryJson: summaryJson,
                engineLabel: engineLabel,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContractAnalysesTable, ContractAnalyse>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ContractAnalysesTable,
                    ContractAnalyse
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContractAnalysesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContractAnalysesTable,
      ContractAnalyse,
      $$ContractAnalysesTableFilterComposer,
      $$ContractAnalysesTableOrderingComposer,
      $$ContractAnalysesTableAnnotationComposer,
      $$ContractAnalysesTableCreateCompanionBuilder,
      $$ContractAnalysesTableUpdateCompanionBuilder,
      (
        ContractAnalyse,
        BaseReferences<_$AppDatabase, $ContractAnalysesTable, ContractAnalyse>,
      ),
      ContractAnalyse,
      PrefetchHooks Function()
    >;
typedef $$RiskFindingsTableCreateCompanionBuilder =
    RiskFindingsCompanion Function({
      required String id,
      required String analysisId,
      required String clauseTitle,
      Value<String?> clauseReference,
      Value<int> pageNumber,
      required String riskLevel,
      Value<String> riskCategory,
      required String originalText,
      required String explanation,
      Value<String?> evidence,
      required String suggestedRewrite,
      Value<bool> applied,
      Value<String> verificationStatus,
      Value<int> rowid,
    });
typedef $$RiskFindingsTableUpdateCompanionBuilder =
    RiskFindingsCompanion Function({
      Value<String> id,
      Value<String> analysisId,
      Value<String> clauseTitle,
      Value<String?> clauseReference,
      Value<int> pageNumber,
      Value<String> riskLevel,
      Value<String> riskCategory,
      Value<String> originalText,
      Value<String> explanation,
      Value<String?> evidence,
      Value<String> suggestedRewrite,
      Value<bool> applied,
      Value<String> verificationStatus,
      Value<int> rowid,
    });

class $$RiskFindingsTableFilterComposer
    extends Composer<_$AppDatabase, $RiskFindingsTable> {
  $$RiskFindingsTableFilterComposer({
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

  ColumnFilters<String> get analysisId => $composableBuilder(
    column: $table.analysisId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clauseTitle => $composableBuilder(
    column: $table.clauseTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clauseReference => $composableBuilder(
    column: $table.clauseReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get riskLevel => $composableBuilder(
    column: $table.riskLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get riskCategory => $composableBuilder(
    column: $table.riskCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedRewrite => $composableBuilder(
    column: $table.suggestedRewrite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get applied => $composableBuilder(
    column: $table.applied,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RiskFindingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RiskFindingsTable> {
  $$RiskFindingsTableOrderingComposer({
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

  ColumnOrderings<String> get analysisId => $composableBuilder(
    column: $table.analysisId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clauseTitle => $composableBuilder(
    column: $table.clauseTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clauseReference => $composableBuilder(
    column: $table.clauseReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get riskLevel => $composableBuilder(
    column: $table.riskLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get riskCategory => $composableBuilder(
    column: $table.riskCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidence => $composableBuilder(
    column: $table.evidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedRewrite => $composableBuilder(
    column: $table.suggestedRewrite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get applied => $composableBuilder(
    column: $table.applied,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RiskFindingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RiskFindingsTable> {
  $$RiskFindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get analysisId => $composableBuilder(
    column: $table.analysisId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clauseTitle => $composableBuilder(
    column: $table.clauseTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clauseReference => $composableBuilder(
    column: $table.clauseReference,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get riskLevel =>
      $composableBuilder(column: $table.riskLevel, builder: (column) => column);

  GeneratedColumn<String> get riskCategory => $composableBuilder(
    column: $table.riskCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get evidence =>
      $composableBuilder(column: $table.evidence, builder: (column) => column);

  GeneratedColumn<String> get suggestedRewrite => $composableBuilder(
    column: $table.suggestedRewrite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get applied =>
      $composableBuilder(column: $table.applied, builder: (column) => column);

  GeneratedColumn<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => column,
  );
}

class $$RiskFindingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RiskFindingsTable,
          RiskFinding,
          $$RiskFindingsTableFilterComposer,
          $$RiskFindingsTableOrderingComposer,
          $$RiskFindingsTableAnnotationComposer,
          $$RiskFindingsTableCreateCompanionBuilder,
          $$RiskFindingsTableUpdateCompanionBuilder,
          (
            RiskFinding,
            BaseReferences<_$AppDatabase, $RiskFindingsTable, RiskFinding>,
          ),
          RiskFinding,
          PrefetchHooks Function()
        > {
  $$RiskFindingsTableTableManager(_$AppDatabase db, $RiskFindingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RiskFindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RiskFindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RiskFindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> analysisId = const Value.absent(),
                Value<String> clauseTitle = const Value.absent(),
                Value<String?> clauseReference = const Value.absent(),
                Value<int> pageNumber = const Value.absent(),
                Value<String> riskLevel = const Value.absent(),
                Value<String> riskCategory = const Value.absent(),
                Value<String> originalText = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<String?> evidence = const Value.absent(),
                Value<String> suggestedRewrite = const Value.absent(),
                Value<bool> applied = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiskFindingsCompanion(
                id: id,
                analysisId: analysisId,
                clauseTitle: clauseTitle,
                clauseReference: clauseReference,
                pageNumber: pageNumber,
                riskLevel: riskLevel,
                riskCategory: riskCategory,
                originalText: originalText,
                explanation: explanation,
                evidence: evidence,
                suggestedRewrite: suggestedRewrite,
                applied: applied,
                verificationStatus: verificationStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String analysisId,
                required String clauseTitle,
                Value<String?> clauseReference = const Value.absent(),
                Value<int> pageNumber = const Value.absent(),
                required String riskLevel,
                Value<String> riskCategory = const Value.absent(),
                required String originalText,
                required String explanation,
                Value<String?> evidence = const Value.absent(),
                required String suggestedRewrite,
                Value<bool> applied = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiskFindingsCompanion.insert(
                id: id,
                analysisId: analysisId,
                clauseTitle: clauseTitle,
                clauseReference: clauseReference,
                pageNumber: pageNumber,
                riskLevel: riskLevel,
                riskCategory: riskCategory,
                originalText: originalText,
                explanation: explanation,
                evidence: evidence,
                suggestedRewrite: suggestedRewrite,
                applied: applied,
                verificationStatus: verificationStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RiskFindingsTable, RiskFinding>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RiskFindingsTable,
                    RiskFinding
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RiskFindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RiskFindingsTable,
      RiskFinding,
      $$RiskFindingsTableFilterComposer,
      $$RiskFindingsTableOrderingComposer,
      $$RiskFindingsTableAnnotationComposer,
      $$RiskFindingsTableCreateCompanionBuilder,
      $$RiskFindingsTableUpdateCompanionBuilder,
      (
        RiskFinding,
        BaseReferences<_$AppDatabase, $RiskFindingsTable, RiskFinding>,
      ),
      RiskFinding,
      PrefetchHooks Function()
    >;
typedef $$LegalKnowledgePacksTableCreateCompanionBuilder =
    LegalKnowledgePacksCompanion Function({
      required String packId,
      required String packName,
      Value<String> jurisdiction,
      required String version,
      required String sourceAuthority,
      required String publicationDate,
      required String effectiveDate,
      required String sha256,
      Value<int> provisionCount,
      Value<int> sizeBytes,
      Value<DateTime> installedAt,
      Value<int> rowid,
    });
typedef $$LegalKnowledgePacksTableUpdateCompanionBuilder =
    LegalKnowledgePacksCompanion Function({
      Value<String> packId,
      Value<String> packName,
      Value<String> jurisdiction,
      Value<String> version,
      Value<String> sourceAuthority,
      Value<String> publicationDate,
      Value<String> effectiveDate,
      Value<String> sha256,
      Value<int> provisionCount,
      Value<int> sizeBytes,
      Value<DateTime> installedAt,
      Value<int> rowid,
    });

class $$LegalKnowledgePacksTableFilterComposer
    extends Composer<_$AppDatabase, $LegalKnowledgePacksTable> {
  $$LegalKnowledgePacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packName => $composableBuilder(
    column: $table.packName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jurisdiction => $composableBuilder(
    column: $table.jurisdiction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceAuthority => $composableBuilder(
    column: $table.sourceAuthority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get provisionCount => $composableBuilder(
    column: $table.provisionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalKnowledgePacksTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalKnowledgePacksTable> {
  $$LegalKnowledgePacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packName => $composableBuilder(
    column: $table.packName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jurisdiction => $composableBuilder(
    column: $table.jurisdiction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceAuthority => $composableBuilder(
    column: $table.sourceAuthority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get provisionCount => $composableBuilder(
    column: $table.provisionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalKnowledgePacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalKnowledgePacksTable> {
  $$LegalKnowledgePacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get packName =>
      $composableBuilder(column: $table.packName, builder: (column) => column);

  GeneratedColumn<String> get jurisdiction => $composableBuilder(
    column: $table.jurisdiction,
    builder: (column) => column,
  );

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get sourceAuthority => $composableBuilder(
    column: $table.sourceAuthority,
    builder: (column) => column,
  );

  GeneratedColumn<String> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<int> get provisionCount => $composableBuilder(
    column: $table.provisionCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );
}

class $$LegalKnowledgePacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalKnowledgePacksTable,
          LegalKnowledgePack,
          $$LegalKnowledgePacksTableFilterComposer,
          $$LegalKnowledgePacksTableOrderingComposer,
          $$LegalKnowledgePacksTableAnnotationComposer,
          $$LegalKnowledgePacksTableCreateCompanionBuilder,
          $$LegalKnowledgePacksTableUpdateCompanionBuilder,
          (
            LegalKnowledgePack,
            BaseReferences<
              _$AppDatabase,
              $LegalKnowledgePacksTable,
              LegalKnowledgePack
            >,
          ),
          LegalKnowledgePack,
          PrefetchHooks Function()
        > {
  $$LegalKnowledgePacksTableTableManager(
    _$AppDatabase db,
    $LegalKnowledgePacksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalKnowledgePacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalKnowledgePacksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LegalKnowledgePacksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> packId = const Value.absent(),
                Value<String> packName = const Value.absent(),
                Value<String> jurisdiction = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> sourceAuthority = const Value.absent(),
                Value<String> publicationDate = const Value.absent(),
                Value<String> effectiveDate = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<int> provisionCount = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalKnowledgePacksCompanion(
                packId: packId,
                packName: packName,
                jurisdiction: jurisdiction,
                version: version,
                sourceAuthority: sourceAuthority,
                publicationDate: publicationDate,
                effectiveDate: effectiveDate,
                sha256: sha256,
                provisionCount: provisionCount,
                sizeBytes: sizeBytes,
                installedAt: installedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String packId,
                required String packName,
                Value<String> jurisdiction = const Value.absent(),
                required String version,
                required String sourceAuthority,
                required String publicationDate,
                required String effectiveDate,
                required String sha256,
                Value<int> provisionCount = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalKnowledgePacksCompanion.insert(
                packId: packId,
                packName: packName,
                jurisdiction: jurisdiction,
                version: version,
                sourceAuthority: sourceAuthority,
                publicationDate: publicationDate,
                effectiveDate: effectiveDate,
                sha256: sha256,
                provisionCount: provisionCount,
                sizeBytes: sizeBytes,
                installedAt: installedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LegalKnowledgePacksTable, LegalKnowledgePack>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $LegalKnowledgePacksTable,
                    LegalKnowledgePack
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalKnowledgePacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalKnowledgePacksTable,
      LegalKnowledgePack,
      $$LegalKnowledgePacksTableFilterComposer,
      $$LegalKnowledgePacksTableOrderingComposer,
      $$LegalKnowledgePacksTableAnnotationComposer,
      $$LegalKnowledgePacksTableCreateCompanionBuilder,
      $$LegalKnowledgePacksTableUpdateCompanionBuilder,
      (
        LegalKnowledgePack,
        BaseReferences<
          _$AppDatabase,
          $LegalKnowledgePacksTable,
          LegalKnowledgePack
        >,
      ),
      LegalKnowledgePack,
      PrefetchHooks Function()
    >;
typedef $$ComplianceRecordsTableCreateCompanionBuilder =
    ComplianceRecordsCompanion Function({
      required String id,
      required String framework,
      required String title,
      required String citationRef,
      required String sourceAuthority,
      required String effectiveDate,
      required String verificationStatus,
      Value<String> status,
      Value<String> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ComplianceRecordsTableUpdateCompanionBuilder =
    ComplianceRecordsCompanion Function({
      Value<String> id,
      Value<String> framework,
      Value<String> title,
      Value<String> citationRef,
      Value<String> sourceAuthority,
      Value<String> effectiveDate,
      Value<String> verificationStatus,
      Value<String> status,
      Value<String> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ComplianceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ComplianceRecordsTable> {
  $$ComplianceRecordsTableFilterComposer({
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

  ColumnFilters<String> get framework => $composableBuilder(
    column: $table.framework,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get citationRef => $composableBuilder(
    column: $table.citationRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceAuthority => $composableBuilder(
    column: $table.sourceAuthority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ComplianceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComplianceRecordsTable> {
  $$ComplianceRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get framework => $composableBuilder(
    column: $table.framework,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get citationRef => $composableBuilder(
    column: $table.citationRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceAuthority => $composableBuilder(
    column: $table.sourceAuthority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComplianceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComplianceRecordsTable> {
  $$ComplianceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get framework =>
      $composableBuilder(column: $table.framework, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get citationRef => $composableBuilder(
    column: $table.citationRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceAuthority => $composableBuilder(
    column: $table.sourceAuthority,
    builder: (column) => column,
  );

  GeneratedColumn<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ComplianceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComplianceRecordsTable,
          ComplianceRecord,
          $$ComplianceRecordsTableFilterComposer,
          $$ComplianceRecordsTableOrderingComposer,
          $$ComplianceRecordsTableAnnotationComposer,
          $$ComplianceRecordsTableCreateCompanionBuilder,
          $$ComplianceRecordsTableUpdateCompanionBuilder,
          (
            ComplianceRecord,
            BaseReferences<
              _$AppDatabase,
              $ComplianceRecordsTable,
              ComplianceRecord
            >,
          ),
          ComplianceRecord,
          PrefetchHooks Function()
        > {
  $$ComplianceRecordsTableTableManager(
    _$AppDatabase db,
    $ComplianceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComplianceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComplianceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComplianceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> framework = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> citationRef = const Value.absent(),
                Value<String> sourceAuthority = const Value.absent(),
                Value<String> effectiveDate = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComplianceRecordsCompanion(
                id: id,
                framework: framework,
                title: title,
                citationRef: citationRef,
                sourceAuthority: sourceAuthority,
                effectiveDate: effectiveDate,
                verificationStatus: verificationStatus,
                status: status,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String framework,
                required String title,
                required String citationRef,
                required String sourceAuthority,
                required String effectiveDate,
                required String verificationStatus,
                Value<String> status = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ComplianceRecordsCompanion.insert(
                id: id,
                framework: framework,
                title: title,
                citationRef: citationRef,
                sourceAuthority: sourceAuthority,
                effectiveDate: effectiveDate,
                verificationStatus: verificationStatus,
                status: status,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ComplianceRecordsTable, ComplianceRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ComplianceRecordsTable,
                    ComplianceRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ComplianceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComplianceRecordsTable,
      ComplianceRecord,
      $$ComplianceRecordsTableFilterComposer,
      $$ComplianceRecordsTableOrderingComposer,
      $$ComplianceRecordsTableAnnotationComposer,
      $$ComplianceRecordsTableCreateCompanionBuilder,
      $$ComplianceRecordsTableUpdateCompanionBuilder,
      (
        ComplianceRecord,
        BaseReferences<
          _$AppDatabase,
          $ComplianceRecordsTable,
          ComplianceRecord
        >,
      ),
      ComplianceRecord,
      PrefetchHooks Function()
    >;
typedef $$AiExecutionLogsTableCreateCompanionBuilder =
    AiExecutionLogsCompanion Function({
      required String id,
      required String taskKind,
      required String engineLabel,
      required int latencyMs,
      Value<int> tokenEstimate,
      required bool success,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$AiExecutionLogsTableUpdateCompanionBuilder =
    AiExecutionLogsCompanion Function({
      Value<String> id,
      Value<String> taskKind,
      Value<String> engineLabel,
      Value<int> latencyMs,
      Value<int> tokenEstimate,
      Value<bool> success,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AiExecutionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AiExecutionLogsTable> {
  $$AiExecutionLogsTableFilterComposer({
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

  ColumnFilters<String> get taskKind => $composableBuilder(
    column: $table.taskKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engineLabel => $composableBuilder(
    column: $table.engineLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get latencyMs => $composableBuilder(
    column: $table.latencyMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokenEstimate => $composableBuilder(
    column: $table.tokenEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiExecutionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AiExecutionLogsTable> {
  $$AiExecutionLogsTableOrderingComposer({
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

  ColumnOrderings<String> get taskKind => $composableBuilder(
    column: $table.taskKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engineLabel => $composableBuilder(
    column: $table.engineLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get latencyMs => $composableBuilder(
    column: $table.latencyMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokenEstimate => $composableBuilder(
    column: $table.tokenEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiExecutionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiExecutionLogsTable> {
  $$AiExecutionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskKind =>
      $composableBuilder(column: $table.taskKind, builder: (column) => column);

  GeneratedColumn<String> get engineLabel => $composableBuilder(
    column: $table.engineLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get latencyMs =>
      $composableBuilder(column: $table.latencyMs, builder: (column) => column);

  GeneratedColumn<int> get tokenEstimate => $composableBuilder(
    column: $table.tokenEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get success =>
      $composableBuilder(column: $table.success, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AiExecutionLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiExecutionLogsTable,
          AiExecutionLog,
          $$AiExecutionLogsTableFilterComposer,
          $$AiExecutionLogsTableOrderingComposer,
          $$AiExecutionLogsTableAnnotationComposer,
          $$AiExecutionLogsTableCreateCompanionBuilder,
          $$AiExecutionLogsTableUpdateCompanionBuilder,
          (
            AiExecutionLog,
            BaseReferences<
              _$AppDatabase,
              $AiExecutionLogsTable,
              AiExecutionLog
            >,
          ),
          AiExecutionLog,
          PrefetchHooks Function()
        > {
  $$AiExecutionLogsTableTableManager(
    _$AppDatabase db,
    $AiExecutionLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiExecutionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiExecutionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiExecutionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskKind = const Value.absent(),
                Value<String> engineLabel = const Value.absent(),
                Value<int> latencyMs = const Value.absent(),
                Value<int> tokenEstimate = const Value.absent(),
                Value<bool> success = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiExecutionLogsCompanion(
                id: id,
                taskKind: taskKind,
                engineLabel: engineLabel,
                latencyMs: latencyMs,
                tokenEstimate: tokenEstimate,
                success: success,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskKind,
                required String engineLabel,
                required int latencyMs,
                Value<int> tokenEstimate = const Value.absent(),
                required bool success,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiExecutionLogsCompanion.insert(
                id: id,
                taskKind: taskKind,
                engineLabel: engineLabel,
                latencyMs: latencyMs,
                tokenEstimate: tokenEstimate,
                success: success,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiExecutionLogsTable, AiExecutionLog>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AiExecutionLogsTable,
                    AiExecutionLog
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiExecutionLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiExecutionLogsTable,
      AiExecutionLog,
      $$AiExecutionLogsTableFilterComposer,
      $$AiExecutionLogsTableOrderingComposer,
      $$AiExecutionLogsTableAnnotationComposer,
      $$AiExecutionLogsTableCreateCompanionBuilder,
      $$AiExecutionLogsTableUpdateCompanionBuilder,
      (
        AiExecutionLog,
        BaseReferences<_$AppDatabase, $AiExecutionLogsTable, AiExecutionLog>,
      ),
      AiExecutionLog,
      PrefetchHooks Function()
    >;
typedef $$AuditEventsTableCreateCompanionBuilder =
    AuditEventsCompanion Function({
      required String id,
      required String eventType,
      required String summary,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$AuditEventsTableUpdateCompanionBuilder =
    AuditEventsCompanion Function({
      Value<String> id,
      Value<String> eventType,
      Value<String> summary,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AuditEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableFilterComposer({
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

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
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
}

class $$AuditEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableOrderingComposer({
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

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
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
}

class $$AuditEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditEventsTable> {
  $$AuditEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditEventsTable,
          AuditEvent,
          $$AuditEventsTableFilterComposer,
          $$AuditEventsTableOrderingComposer,
          $$AuditEventsTableAnnotationComposer,
          $$AuditEventsTableCreateCompanionBuilder,
          $$AuditEventsTableUpdateCompanionBuilder,
          (
            AuditEvent,
            BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent>,
          ),
          AuditEvent,
          PrefetchHooks Function()
        > {
  $$AuditEventsTableTableManager(_$AppDatabase db, $AuditEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditEventsCompanion(
                id: id,
                eventType: eventType,
                summary: summary,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventType,
                required String summary,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditEventsCompanion.insert(
                id: id,
                eventType: eventType,
                summary: summary,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuditEventsTable, AuditEvent>(table),
                  BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent>(
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

typedef $$AuditEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditEventsTable,
      AuditEvent,
      $$AuditEventsTableFilterComposer,
      $$AuditEventsTableOrderingComposer,
      $$AuditEventsTableAnnotationComposer,
      $$AuditEventsTableCreateCompanionBuilder,
      $$AuditEventsTableUpdateCompanionBuilder,
      (
        AuditEvent,
        BaseReferences<_$AppDatabase, $AuditEventsTable, AuditEvent>,
      ),
      AuditEvent,
      PrefetchHooks Function()
    >;
typedef $$LegalInstrumentsTableCreateCompanionBuilder =
    LegalInstrumentsCompanion Function({
      required String instrumentId,
      required String instrumentType,
      required String title,
      required String shortCode,
      Value<String?> editionDate,
      required String sourceAuthority,
      Value<String?> sourceUrl,
      Value<bool> fullTextAvailable,
      Value<String> verificationStatus,
      Value<int> provisionCount,
      Value<int> rowid,
    });
typedef $$LegalInstrumentsTableUpdateCompanionBuilder =
    LegalInstrumentsCompanion Function({
      Value<String> instrumentId,
      Value<String> instrumentType,
      Value<String> title,
      Value<String> shortCode,
      Value<String?> editionDate,
      Value<String> sourceAuthority,
      Value<String?> sourceUrl,
      Value<bool> fullTextAvailable,
      Value<String> verificationStatus,
      Value<int> provisionCount,
      Value<int> rowid,
    });

class $$LegalInstrumentsTableFilterComposer
    extends Composer<_$AppDatabase, $LegalInstrumentsTable> {
  $$LegalInstrumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get instrumentId => $composableBuilder(
    column: $table.instrumentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instrumentType => $composableBuilder(
    column: $table.instrumentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortCode => $composableBuilder(
    column: $table.shortCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionDate => $composableBuilder(
    column: $table.editionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceAuthority => $composableBuilder(
    column: $table.sourceAuthority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get provisionCount => $composableBuilder(
    column: $table.provisionCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalInstrumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalInstrumentsTable> {
  $$LegalInstrumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get instrumentId => $composableBuilder(
    column: $table.instrumentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instrumentType => $composableBuilder(
    column: $table.instrumentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortCode => $composableBuilder(
    column: $table.shortCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionDate => $composableBuilder(
    column: $table.editionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceAuthority => $composableBuilder(
    column: $table.sourceAuthority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get provisionCount => $composableBuilder(
    column: $table.provisionCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalInstrumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalInstrumentsTable> {
  $$LegalInstrumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get instrumentId => $composableBuilder(
    column: $table.instrumentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instrumentType => $composableBuilder(
    column: $table.instrumentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get shortCode =>
      $composableBuilder(column: $table.shortCode, builder: (column) => column);

  GeneratedColumn<String> get editionDate => $composableBuilder(
    column: $table.editionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceAuthority => $composableBuilder(
    column: $table.sourceAuthority,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get provisionCount => $composableBuilder(
    column: $table.provisionCount,
    builder: (column) => column,
  );
}

class $$LegalInstrumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalInstrumentsTable,
          LegalInstrument,
          $$LegalInstrumentsTableFilterComposer,
          $$LegalInstrumentsTableOrderingComposer,
          $$LegalInstrumentsTableAnnotationComposer,
          $$LegalInstrumentsTableCreateCompanionBuilder,
          $$LegalInstrumentsTableUpdateCompanionBuilder,
          (
            LegalInstrument,
            BaseReferences<
              _$AppDatabase,
              $LegalInstrumentsTable,
              LegalInstrument
            >,
          ),
          LegalInstrument,
          PrefetchHooks Function()
        > {
  $$LegalInstrumentsTableTableManager(
    _$AppDatabase db,
    $LegalInstrumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalInstrumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalInstrumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegalInstrumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> instrumentId = const Value.absent(),
                Value<String> instrumentType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> shortCode = const Value.absent(),
                Value<String?> editionDate = const Value.absent(),
                Value<String> sourceAuthority = const Value.absent(),
                Value<String?> sourceUrl = const Value.absent(),
                Value<bool> fullTextAvailable = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<int> provisionCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalInstrumentsCompanion(
                instrumentId: instrumentId,
                instrumentType: instrumentType,
                title: title,
                shortCode: shortCode,
                editionDate: editionDate,
                sourceAuthority: sourceAuthority,
                sourceUrl: sourceUrl,
                fullTextAvailable: fullTextAvailable,
                verificationStatus: verificationStatus,
                provisionCount: provisionCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String instrumentId,
                required String instrumentType,
                required String title,
                required String shortCode,
                Value<String?> editionDate = const Value.absent(),
                required String sourceAuthority,
                Value<String?> sourceUrl = const Value.absent(),
                Value<bool> fullTextAvailable = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<int> provisionCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalInstrumentsCompanion.insert(
                instrumentId: instrumentId,
                instrumentType: instrumentType,
                title: title,
                shortCode: shortCode,
                editionDate: editionDate,
                sourceAuthority: sourceAuthority,
                sourceUrl: sourceUrl,
                fullTextAvailable: fullTextAvailable,
                verificationStatus: verificationStatus,
                provisionCount: provisionCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LegalInstrumentsTable, LegalInstrument>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LegalInstrumentsTable,
                    LegalInstrument
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalInstrumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalInstrumentsTable,
      LegalInstrument,
      $$LegalInstrumentsTableFilterComposer,
      $$LegalInstrumentsTableOrderingComposer,
      $$LegalInstrumentsTableAnnotationComposer,
      $$LegalInstrumentsTableCreateCompanionBuilder,
      $$LegalInstrumentsTableUpdateCompanionBuilder,
      (
        LegalInstrument,
        BaseReferences<_$AppDatabase, $LegalInstrumentsTable, LegalInstrument>,
      ),
      LegalInstrument,
      PrefetchHooks Function()
    >;
typedef $$LegalProvisionsTableCreateCompanionBuilder =
    LegalProvisionsCompanion Function({
      required String canonicalRef,
      required String instrumentId,
      Value<String> parentRef,
      required String provisionType,
      required String number,
      required String title,
      Value<String> partOrChapter,
      required String officialText,
      Value<String> consolidatedStatus,
      Value<String?> effectiveDate,
      Value<int> bookPage,
      Value<int> endPage,
      Value<String> sourceHash,
      Value<bool> fullTextAvailable,
      Value<String> verificationStatus,
      Value<int> rowid,
    });
typedef $$LegalProvisionsTableUpdateCompanionBuilder =
    LegalProvisionsCompanion Function({
      Value<String> canonicalRef,
      Value<String> instrumentId,
      Value<String> parentRef,
      Value<String> provisionType,
      Value<String> number,
      Value<String> title,
      Value<String> partOrChapter,
      Value<String> officialText,
      Value<String> consolidatedStatus,
      Value<String?> effectiveDate,
      Value<int> bookPage,
      Value<int> endPage,
      Value<String> sourceHash,
      Value<bool> fullTextAvailable,
      Value<String> verificationStatus,
      Value<int> rowid,
    });

class $$LegalProvisionsTableFilterComposer
    extends Composer<_$AppDatabase, $LegalProvisionsTable> {
  $$LegalProvisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get canonicalRef => $composableBuilder(
    column: $table.canonicalRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instrumentId => $composableBuilder(
    column: $table.instrumentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentRef => $composableBuilder(
    column: $table.parentRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provisionType => $composableBuilder(
    column: $table.provisionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partOrChapter => $composableBuilder(
    column: $table.partOrChapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get officialText => $composableBuilder(
    column: $table.officialText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get consolidatedStatus => $composableBuilder(
    column: $table.consolidatedStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookPage => $composableBuilder(
    column: $table.bookPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endPage => $composableBuilder(
    column: $table.endPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalProvisionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalProvisionsTable> {
  $$LegalProvisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get canonicalRef => $composableBuilder(
    column: $table.canonicalRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instrumentId => $composableBuilder(
    column: $table.instrumentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentRef => $composableBuilder(
    column: $table.parentRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provisionType => $composableBuilder(
    column: $table.provisionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partOrChapter => $composableBuilder(
    column: $table.partOrChapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get officialText => $composableBuilder(
    column: $table.officialText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consolidatedStatus => $composableBuilder(
    column: $table.consolidatedStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookPage => $composableBuilder(
    column: $table.bookPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endPage => $composableBuilder(
    column: $table.endPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalProvisionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalProvisionsTable> {
  $$LegalProvisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get canonicalRef => $composableBuilder(
    column: $table.canonicalRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instrumentId => $composableBuilder(
    column: $table.instrumentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentRef =>
      $composableBuilder(column: $table.parentRef, builder: (column) => column);

  GeneratedColumn<String> get provisionType => $composableBuilder(
    column: $table.provisionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get partOrChapter => $composableBuilder(
    column: $table.partOrChapter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get officialText => $composableBuilder(
    column: $table.officialText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get consolidatedStatus => $composableBuilder(
    column: $table.consolidatedStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bookPage =>
      $composableBuilder(column: $table.bookPage, builder: (column) => column);

  GeneratedColumn<int> get endPage =>
      $composableBuilder(column: $table.endPage, builder: (column) => column);

  GeneratedColumn<String> get sourceHash => $composableBuilder(
    column: $table.sourceHash,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => column,
  );
}

class $$LegalProvisionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalProvisionsTable,
          LegalProvision,
          $$LegalProvisionsTableFilterComposer,
          $$LegalProvisionsTableOrderingComposer,
          $$LegalProvisionsTableAnnotationComposer,
          $$LegalProvisionsTableCreateCompanionBuilder,
          $$LegalProvisionsTableUpdateCompanionBuilder,
          (
            LegalProvision,
            BaseReferences<
              _$AppDatabase,
              $LegalProvisionsTable,
              LegalProvision
            >,
          ),
          LegalProvision,
          PrefetchHooks Function()
        > {
  $$LegalProvisionsTableTableManager(
    _$AppDatabase db,
    $LegalProvisionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalProvisionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalProvisionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegalProvisionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> canonicalRef = const Value.absent(),
                Value<String> instrumentId = const Value.absent(),
                Value<String> parentRef = const Value.absent(),
                Value<String> provisionType = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> partOrChapter = const Value.absent(),
                Value<String> officialText = const Value.absent(),
                Value<String> consolidatedStatus = const Value.absent(),
                Value<String?> effectiveDate = const Value.absent(),
                Value<int> bookPage = const Value.absent(),
                Value<int> endPage = const Value.absent(),
                Value<String> sourceHash = const Value.absent(),
                Value<bool> fullTextAvailable = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalProvisionsCompanion(
                canonicalRef: canonicalRef,
                instrumentId: instrumentId,
                parentRef: parentRef,
                provisionType: provisionType,
                number: number,
                title: title,
                partOrChapter: partOrChapter,
                officialText: officialText,
                consolidatedStatus: consolidatedStatus,
                effectiveDate: effectiveDate,
                bookPage: bookPage,
                endPage: endPage,
                sourceHash: sourceHash,
                fullTextAvailable: fullTextAvailable,
                verificationStatus: verificationStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String canonicalRef,
                required String instrumentId,
                Value<String> parentRef = const Value.absent(),
                required String provisionType,
                required String number,
                required String title,
                Value<String> partOrChapter = const Value.absent(),
                required String officialText,
                Value<String> consolidatedStatus = const Value.absent(),
                Value<String?> effectiveDate = const Value.absent(),
                Value<int> bookPage = const Value.absent(),
                Value<int> endPage = const Value.absent(),
                Value<String> sourceHash = const Value.absent(),
                Value<bool> fullTextAvailable = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalProvisionsCompanion.insert(
                canonicalRef: canonicalRef,
                instrumentId: instrumentId,
                parentRef: parentRef,
                provisionType: provisionType,
                number: number,
                title: title,
                partOrChapter: partOrChapter,
                officialText: officialText,
                consolidatedStatus: consolidatedStatus,
                effectiveDate: effectiveDate,
                bookPage: bookPage,
                endPage: endPage,
                sourceHash: sourceHash,
                fullTextAvailable: fullTextAvailable,
                verificationStatus: verificationStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LegalProvisionsTable, LegalProvision>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LegalProvisionsTable,
                    LegalProvision
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalProvisionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalProvisionsTable,
      LegalProvision,
      $$LegalProvisionsTableFilterComposer,
      $$LegalProvisionsTableOrderingComposer,
      $$LegalProvisionsTableAnnotationComposer,
      $$LegalProvisionsTableCreateCompanionBuilder,
      $$LegalProvisionsTableUpdateCompanionBuilder,
      (
        LegalProvision,
        BaseReferences<_$AppDatabase, $LegalProvisionsTable, LegalProvision>,
      ),
      LegalProvision,
      PrefetchHooks Function()
    >;
typedef $$LegalFootnotesTableCreateCompanionBuilder =
    LegalFootnotesCompanion Function({
      required String footnoteId,
      required String provisionRef,
      required String footnoteNumber,
      required int bookPage,
      required String footnoteType,
      required String noteText,
      Value<String> referencedInstrumentsJson,
      Value<int> rowid,
    });
typedef $$LegalFootnotesTableUpdateCompanionBuilder =
    LegalFootnotesCompanion Function({
      Value<String> footnoteId,
      Value<String> provisionRef,
      Value<String> footnoteNumber,
      Value<int> bookPage,
      Value<String> footnoteType,
      Value<String> noteText,
      Value<String> referencedInstrumentsJson,
      Value<int> rowid,
    });

class $$LegalFootnotesTableFilterComposer
    extends Composer<_$AppDatabase, $LegalFootnotesTable> {
  $$LegalFootnotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get footnoteId => $composableBuilder(
    column: $table.footnoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provisionRef => $composableBuilder(
    column: $table.provisionRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get footnoteNumber => $composableBuilder(
    column: $table.footnoteNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookPage => $composableBuilder(
    column: $table.bookPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get footnoteType => $composableBuilder(
    column: $table.footnoteType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referencedInstrumentsJson => $composableBuilder(
    column: $table.referencedInstrumentsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalFootnotesTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalFootnotesTable> {
  $$LegalFootnotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get footnoteId => $composableBuilder(
    column: $table.footnoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provisionRef => $composableBuilder(
    column: $table.provisionRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get footnoteNumber => $composableBuilder(
    column: $table.footnoteNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookPage => $composableBuilder(
    column: $table.bookPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get footnoteType => $composableBuilder(
    column: $table.footnoteType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referencedInstrumentsJson => $composableBuilder(
    column: $table.referencedInstrumentsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalFootnotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalFootnotesTable> {
  $$LegalFootnotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get footnoteId => $composableBuilder(
    column: $table.footnoteId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provisionRef => $composableBuilder(
    column: $table.provisionRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get footnoteNumber => $composableBuilder(
    column: $table.footnoteNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bookPage =>
      $composableBuilder(column: $table.bookPage, builder: (column) => column);

  GeneratedColumn<String> get footnoteType => $composableBuilder(
    column: $table.footnoteType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get noteText =>
      $composableBuilder(column: $table.noteText, builder: (column) => column);

  GeneratedColumn<String> get referencedInstrumentsJson => $composableBuilder(
    column: $table.referencedInstrumentsJson,
    builder: (column) => column,
  );
}

class $$LegalFootnotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalFootnotesTable,
          LegalFootnote,
          $$LegalFootnotesTableFilterComposer,
          $$LegalFootnotesTableOrderingComposer,
          $$LegalFootnotesTableAnnotationComposer,
          $$LegalFootnotesTableCreateCompanionBuilder,
          $$LegalFootnotesTableUpdateCompanionBuilder,
          (
            LegalFootnote,
            BaseReferences<_$AppDatabase, $LegalFootnotesTable, LegalFootnote>,
          ),
          LegalFootnote,
          PrefetchHooks Function()
        > {
  $$LegalFootnotesTableTableManager(
    _$AppDatabase db,
    $LegalFootnotesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalFootnotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalFootnotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegalFootnotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> footnoteId = const Value.absent(),
                Value<String> provisionRef = const Value.absent(),
                Value<String> footnoteNumber = const Value.absent(),
                Value<int> bookPage = const Value.absent(),
                Value<String> footnoteType = const Value.absent(),
                Value<String> noteText = const Value.absent(),
                Value<String> referencedInstrumentsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalFootnotesCompanion(
                footnoteId: footnoteId,
                provisionRef: provisionRef,
                footnoteNumber: footnoteNumber,
                bookPage: bookPage,
                footnoteType: footnoteType,
                noteText: noteText,
                referencedInstrumentsJson: referencedInstrumentsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String footnoteId,
                required String provisionRef,
                required String footnoteNumber,
                required int bookPage,
                required String footnoteType,
                required String noteText,
                Value<String> referencedInstrumentsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalFootnotesCompanion.insert(
                footnoteId: footnoteId,
                provisionRef: provisionRef,
                footnoteNumber: footnoteNumber,
                bookPage: bookPage,
                footnoteType: footnoteType,
                noteText: noteText,
                referencedInstrumentsJson: referencedInstrumentsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LegalFootnotesTable, LegalFootnote>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LegalFootnotesTable,
                    LegalFootnote
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalFootnotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalFootnotesTable,
      LegalFootnote,
      $$LegalFootnotesTableFilterComposer,
      $$LegalFootnotesTableOrderingComposer,
      $$LegalFootnotesTableAnnotationComposer,
      $$LegalFootnotesTableCreateCompanionBuilder,
      $$LegalFootnotesTableUpdateCompanionBuilder,
      (
        LegalFootnote,
        BaseReferences<_$AppDatabase, $LegalFootnotesTable, LegalFootnote>,
      ),
      LegalFootnote,
      PrefetchHooks Function()
    >;
typedef $$LegalReferencesTableCreateCompanionBuilder =
    LegalReferencesCompanion Function({
      required String referenceId,
      required String referenceType,
      required String title,
      required String referenceNumber,
      required String parentDocument,
      required int bookPage,
      required String sourceText,
      Value<String> extractionMethod,
      Value<String> confidence,
      Value<bool> fullTextAvailable,
      Value<String> verificationStatus,
      required String sourceProvisionRef,
      Value<int> rowid,
    });
typedef $$LegalReferencesTableUpdateCompanionBuilder =
    LegalReferencesCompanion Function({
      Value<String> referenceId,
      Value<String> referenceType,
      Value<String> title,
      Value<String> referenceNumber,
      Value<String> parentDocument,
      Value<int> bookPage,
      Value<String> sourceText,
      Value<String> extractionMethod,
      Value<String> confidence,
      Value<bool> fullTextAvailable,
      Value<String> verificationStatus,
      Value<String> sourceProvisionRef,
      Value<int> rowid,
    });

class $$LegalReferencesTableFilterComposer
    extends Composer<_$AppDatabase, $LegalReferencesTable> {
  $$LegalReferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentDocument => $composableBuilder(
    column: $table.parentDocument,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookPage => $composableBuilder(
    column: $table.bookPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extractionMethod => $composableBuilder(
    column: $table.extractionMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceProvisionRef => $composableBuilder(
    column: $table.sourceProvisionRef,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalReferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalReferencesTable> {
  $$LegalReferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentDocument => $composableBuilder(
    column: $table.parentDocument,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookPage => $composableBuilder(
    column: $table.bookPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extractionMethod => $composableBuilder(
    column: $table.extractionMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceProvisionRef => $composableBuilder(
    column: $table.sourceProvisionRef,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalReferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalReferencesTable> {
  $$LegalReferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceType => $composableBuilder(
    column: $table.referenceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
    column: $table.referenceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentDocument => $composableBuilder(
    column: $table.parentDocument,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bookPage =>
      $composableBuilder(column: $table.bookPage, builder: (column) => column);

  GeneratedColumn<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get extractionMethod => $composableBuilder(
    column: $table.extractionMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceProvisionRef => $composableBuilder(
    column: $table.sourceProvisionRef,
    builder: (column) => column,
  );
}

class $$LegalReferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalReferencesTable,
          LegalReference,
          $$LegalReferencesTableFilterComposer,
          $$LegalReferencesTableOrderingComposer,
          $$LegalReferencesTableAnnotationComposer,
          $$LegalReferencesTableCreateCompanionBuilder,
          $$LegalReferencesTableUpdateCompanionBuilder,
          (
            LegalReference,
            BaseReferences<
              _$AppDatabase,
              $LegalReferencesTable,
              LegalReference
            >,
          ),
          LegalReference,
          PrefetchHooks Function()
        > {
  $$LegalReferencesTableTableManager(
    _$AppDatabase db,
    $LegalReferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalReferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalReferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegalReferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> referenceId = const Value.absent(),
                Value<String> referenceType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> referenceNumber = const Value.absent(),
                Value<String> parentDocument = const Value.absent(),
                Value<int> bookPage = const Value.absent(),
                Value<String> sourceText = const Value.absent(),
                Value<String> extractionMethod = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<bool> fullTextAvailable = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<String> sourceProvisionRef = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalReferencesCompanion(
                referenceId: referenceId,
                referenceType: referenceType,
                title: title,
                referenceNumber: referenceNumber,
                parentDocument: parentDocument,
                bookPage: bookPage,
                sourceText: sourceText,
                extractionMethod: extractionMethod,
                confidence: confidence,
                fullTextAvailable: fullTextAvailable,
                verificationStatus: verificationStatus,
                sourceProvisionRef: sourceProvisionRef,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String referenceId,
                required String referenceType,
                required String title,
                required String referenceNumber,
                required String parentDocument,
                required int bookPage,
                required String sourceText,
                Value<String> extractionMethod = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<bool> fullTextAvailable = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                required String sourceProvisionRef,
                Value<int> rowid = const Value.absent(),
              }) => LegalReferencesCompanion.insert(
                referenceId: referenceId,
                referenceType: referenceType,
                title: title,
                referenceNumber: referenceNumber,
                parentDocument: parentDocument,
                bookPage: bookPage,
                sourceText: sourceText,
                extractionMethod: extractionMethod,
                confidence: confidence,
                fullTextAvailable: fullTextAvailable,
                verificationStatus: verificationStatus,
                sourceProvisionRef: sourceProvisionRef,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LegalReferencesTable, LegalReference>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LegalReferencesTable,
                    LegalReference
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalReferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalReferencesTable,
      LegalReference,
      $$LegalReferencesTableFilterComposer,
      $$LegalReferencesTableOrderingComposer,
      $$LegalReferencesTableAnnotationComposer,
      $$LegalReferencesTableCreateCompanionBuilder,
      $$LegalReferencesTableUpdateCompanionBuilder,
      (
        LegalReference,
        BaseReferences<_$AppDatabase, $LegalReferencesTable, LegalReference>,
      ),
      LegalReference,
      PrefetchHooks Function()
    >;
typedef $$LegalEntitiesTableCreateCompanionBuilder =
    LegalEntitiesCompanion Function({
      required String entityId,
      required String entityType,
      required String canonicalRef,
      required String label,
      Value<bool> fullTextAvailable,
      Value<String> metadataJson,
      Value<int> rowid,
    });
typedef $$LegalEntitiesTableUpdateCompanionBuilder =
    LegalEntitiesCompanion Function({
      Value<String> entityId,
      Value<String> entityType,
      Value<String> canonicalRef,
      Value<String> label,
      Value<bool> fullTextAvailable,
      Value<String> metadataJson,
      Value<int> rowid,
    });

class $$LegalEntitiesTableFilterComposer
    extends Composer<_$AppDatabase, $LegalEntitiesTable> {
  $$LegalEntitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalRef => $composableBuilder(
    column: $table.canonicalRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalEntitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalEntitiesTable> {
  $$LegalEntitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalRef => $composableBuilder(
    column: $table.canonicalRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalEntitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalEntitiesTable> {
  $$LegalEntitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get canonicalRef => $composableBuilder(
    column: $table.canonicalRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get fullTextAvailable => $composableBuilder(
    column: $table.fullTextAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );
}

class $$LegalEntitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalEntitiesTable,
          LegalEntity,
          $$LegalEntitiesTableFilterComposer,
          $$LegalEntitiesTableOrderingComposer,
          $$LegalEntitiesTableAnnotationComposer,
          $$LegalEntitiesTableCreateCompanionBuilder,
          $$LegalEntitiesTableUpdateCompanionBuilder,
          (
            LegalEntity,
            BaseReferences<_$AppDatabase, $LegalEntitiesTable, LegalEntity>,
          ),
          LegalEntity,
          PrefetchHooks Function()
        > {
  $$LegalEntitiesTableTableManager(_$AppDatabase db, $LegalEntitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalEntitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalEntitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegalEntitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> canonicalRef = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool> fullTextAvailable = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalEntitiesCompanion(
                entityId: entityId,
                entityType: entityType,
                canonicalRef: canonicalRef,
                label: label,
                fullTextAvailable: fullTextAvailable,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityId,
                required String entityType,
                required String canonicalRef,
                required String label,
                Value<bool> fullTextAvailable = const Value.absent(),
                Value<String> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalEntitiesCompanion.insert(
                entityId: entityId,
                entityType: entityType,
                canonicalRef: canonicalRef,
                label: label,
                fullTextAvailable: fullTextAvailable,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LegalEntitiesTable, LegalEntity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LegalEntitiesTable,
                    LegalEntity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalEntitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalEntitiesTable,
      LegalEntity,
      $$LegalEntitiesTableFilterComposer,
      $$LegalEntitiesTableOrderingComposer,
      $$LegalEntitiesTableAnnotationComposer,
      $$LegalEntitiesTableCreateCompanionBuilder,
      $$LegalEntitiesTableUpdateCompanionBuilder,
      (
        LegalEntity,
        BaseReferences<_$AppDatabase, $LegalEntitiesTable, LegalEntity>,
      ),
      LegalEntity,
      PrefetchHooks Function()
    >;
typedef $$LegalRelationsTableCreateCompanionBuilder =
    LegalRelationsCompanion Function({
      required String relationId,
      required String fromEntity,
      required String relationType,
      required String toEntity,
      required String sourceRef,
      Value<int> bookPage,
      Value<String> confidence,
      Value<String> verificationStatus,
      Value<int> rowid,
    });
typedef $$LegalRelationsTableUpdateCompanionBuilder =
    LegalRelationsCompanion Function({
      Value<String> relationId,
      Value<String> fromEntity,
      Value<String> relationType,
      Value<String> toEntity,
      Value<String> sourceRef,
      Value<int> bookPage,
      Value<String> confidence,
      Value<String> verificationStatus,
      Value<int> rowid,
    });

class $$LegalRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $LegalRelationsTable> {
  $$LegalRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get relationId => $composableBuilder(
    column: $table.relationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromEntity => $composableBuilder(
    column: $table.fromEntity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toEntity => $composableBuilder(
    column: $table.toEntity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookPage => $composableBuilder(
    column: $table.bookPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalRelationsTable> {
  $$LegalRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get relationId => $composableBuilder(
    column: $table.relationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromEntity => $composableBuilder(
    column: $table.fromEntity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toEntity => $composableBuilder(
    column: $table.toEntity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookPage => $composableBuilder(
    column: $table.bookPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalRelationsTable> {
  $$LegalRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get relationId => $composableBuilder(
    column: $table.relationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromEntity => $composableBuilder(
    column: $table.fromEntity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toEntity =>
      $composableBuilder(column: $table.toEntity, builder: (column) => column);

  GeneratedColumn<String> get sourceRef =>
      $composableBuilder(column: $table.sourceRef, builder: (column) => column);

  GeneratedColumn<int> get bookPage =>
      $composableBuilder(column: $table.bookPage, builder: (column) => column);

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verificationStatus => $composableBuilder(
    column: $table.verificationStatus,
    builder: (column) => column,
  );
}

class $$LegalRelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalRelationsTable,
          LegalRelation,
          $$LegalRelationsTableFilterComposer,
          $$LegalRelationsTableOrderingComposer,
          $$LegalRelationsTableAnnotationComposer,
          $$LegalRelationsTableCreateCompanionBuilder,
          $$LegalRelationsTableUpdateCompanionBuilder,
          (
            LegalRelation,
            BaseReferences<_$AppDatabase, $LegalRelationsTable, LegalRelation>,
          ),
          LegalRelation,
          PrefetchHooks Function()
        > {
  $$LegalRelationsTableTableManager(
    _$AppDatabase db,
    $LegalRelationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegalRelationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> relationId = const Value.absent(),
                Value<String> fromEntity = const Value.absent(),
                Value<String> relationType = const Value.absent(),
                Value<String> toEntity = const Value.absent(),
                Value<String> sourceRef = const Value.absent(),
                Value<int> bookPage = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalRelationsCompanion(
                relationId: relationId,
                fromEntity: fromEntity,
                relationType: relationType,
                toEntity: toEntity,
                sourceRef: sourceRef,
                bookPage: bookPage,
                confidence: confidence,
                verificationStatus: verificationStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String relationId,
                required String fromEntity,
                required String relationType,
                required String toEntity,
                required String sourceRef,
                Value<int> bookPage = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<String> verificationStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalRelationsCompanion.insert(
                relationId: relationId,
                fromEntity: fromEntity,
                relationType: relationType,
                toEntity: toEntity,
                sourceRef: sourceRef,
                bookPage: bookPage,
                confidence: confidence,
                verificationStatus: verificationStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LegalRelationsTable, LegalRelation>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LegalRelationsTable,
                    LegalRelation
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalRelationsTable,
      LegalRelation,
      $$LegalRelationsTableFilterComposer,
      $$LegalRelationsTableOrderingComposer,
      $$LegalRelationsTableAnnotationComposer,
      $$LegalRelationsTableCreateCompanionBuilder,
      $$LegalRelationsTableUpdateCompanionBuilder,
      (
        LegalRelation,
        BaseReferences<_$AppDatabase, $LegalRelationsTable, LegalRelation>,
      ),
      LegalRelation,
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
  $$ConversationsTableTableManager get conversations =>
      $$ConversationsTableTableManager(_db, _db.conversations);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$DocumentChunksTableTableManager get documentChunks =>
      $$DocumentChunksTableTableManager(_db, _db.documentChunks);
  $$ContractAnalysesTableTableManager get contractAnalyses =>
      $$ContractAnalysesTableTableManager(_db, _db.contractAnalyses);
  $$RiskFindingsTableTableManager get riskFindings =>
      $$RiskFindingsTableTableManager(_db, _db.riskFindings);
  $$LegalKnowledgePacksTableTableManager get legalKnowledgePacks =>
      $$LegalKnowledgePacksTableTableManager(_db, _db.legalKnowledgePacks);
  $$ComplianceRecordsTableTableManager get complianceRecords =>
      $$ComplianceRecordsTableTableManager(_db, _db.complianceRecords);
  $$AiExecutionLogsTableTableManager get aiExecutionLogs =>
      $$AiExecutionLogsTableTableManager(_db, _db.aiExecutionLogs);
  $$AuditEventsTableTableManager get auditEvents =>
      $$AuditEventsTableTableManager(_db, _db.auditEvents);
  $$LegalInstrumentsTableTableManager get legalInstruments =>
      $$LegalInstrumentsTableTableManager(_db, _db.legalInstruments);
  $$LegalProvisionsTableTableManager get legalProvisions =>
      $$LegalProvisionsTableTableManager(_db, _db.legalProvisions);
  $$LegalFootnotesTableTableManager get legalFootnotes =>
      $$LegalFootnotesTableTableManager(_db, _db.legalFootnotes);
  $$LegalReferencesTableTableManager get legalReferences =>
      $$LegalReferencesTableTableManager(_db, _db.legalReferences);
  $$LegalEntitiesTableTableManager get legalEntities =>
      $$LegalEntitiesTableTableManager(_db, _db.legalEntities);
  $$LegalRelationsTableTableManager get legalRelations =>
      $$LegalRelationsTableTableManager(_db, _db.legalRelations);
}
