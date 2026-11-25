// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'legal_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LegalSectionModel {

 String get actCode; String get actName; String get sectionNumber; String get title; String get chapter; String get text; String get sourceUrl; String? get legacyMapping; String? get plainLanguage; String? get punishment; List<String> get relatedSections;
/// Create a copy of LegalSectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LegalSectionModelCopyWith<LegalSectionModel> get copyWith => _$LegalSectionModelCopyWithImpl<LegalSectionModel>(this as LegalSectionModel, _$identity);

  /// Serializes this LegalSectionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LegalSectionModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalSectionModel&&(identical(other.actCode, _this.actCode) || other.actCode == _this.actCode)&&(identical(other.actName, _this.actName) || other.actName == _this.actName)&&(identical(other.sectionNumber, _this.sectionNumber) || other.sectionNumber == _this.sectionNumber)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.chapter, _this.chapter) || other.chapter == _this.chapter)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.sourceUrl, _this.sourceUrl) || other.sourceUrl == _this.sourceUrl)&&(identical(other.legacyMapping, _this.legacyMapping) || other.legacyMapping == _this.legacyMapping)&&(identical(other.plainLanguage, _this.plainLanguage) || other.plainLanguage == _this.plainLanguage)&&(identical(other.punishment, _this.punishment) || other.punishment == _this.punishment)&&const DeepCollectionEquality().equals(other.relatedSections, _this.relatedSections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LegalSectionModel;
  return Object.hash(runtimeType,_this.actCode,_this.actName,_this.sectionNumber,_this.title,_this.chapter,_this.text,_this.sourceUrl,_this.legacyMapping,_this.plainLanguage,_this.punishment,const DeepCollectionEquality().hash(_this.relatedSections));
}

@override
String toString() {
  final _this = this as LegalSectionModel;
  return 'LegalSectionModel(actCode: ${_this.actCode}, actName: ${_this.actName}, sectionNumber: ${_this.sectionNumber}, title: ${_this.title}, chapter: ${_this.chapter}, text: ${_this.text}, sourceUrl: ${_this.sourceUrl}, legacyMapping: ${_this.legacyMapping}, plainLanguage: ${_this.plainLanguage}, punishment: ${_this.punishment}, relatedSections: ${_this.relatedSections})';
}


}

/// @nodoc
abstract mixin class $LegalSectionModelCopyWith<$Res>  {
  factory $LegalSectionModelCopyWith(LegalSectionModel value, $Res Function(LegalSectionModel) _then) = _$LegalSectionModelCopyWithImpl;
@useResult
$Res call({
 String actCode, String actName, String sectionNumber, String title, String chapter, String text, String sourceUrl, String? legacyMapping, String? plainLanguage, String? punishment, List<String> relatedSections
});




}
/// @nodoc
class _$LegalSectionModelCopyWithImpl<$Res>
    implements $LegalSectionModelCopyWith<$Res> {
  _$LegalSectionModelCopyWithImpl(this._self, this._then);

  final LegalSectionModel _self;
  final $Res Function(LegalSectionModel) _then;

/// Create a copy of LegalSectionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actCode = null,Object? actName = null,Object? sectionNumber = null,Object? title = null,Object? chapter = null,Object? text = null,Object? sourceUrl = null,Object? legacyMapping = freezed,Object? plainLanguage = freezed,Object? punishment = freezed,Object? relatedSections = null,}) {
  return _then(LegalSectionModel(
actCode: null == actCode ? _self.actCode : actCode // ignore: cast_nullable_to_non_nullable
as String,actName: null == actName ? _self.actName : actName // ignore: cast_nullable_to_non_nullable
as String,sectionNumber: null == sectionNumber ? _self.sectionNumber : sectionNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,legacyMapping: freezed == legacyMapping ? _self.legacyMapping : legacyMapping // ignore: cast_nullable_to_non_nullable
as String?,plainLanguage: freezed == plainLanguage ? _self.plainLanguage : plainLanguage // ignore: cast_nullable_to_non_nullable
as String?,punishment: freezed == punishment ? _self.punishment : punishment // ignore: cast_nullable_to_non_nullable
as String?,relatedSections: null == relatedSections ? _self.relatedSections : relatedSections // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LegalSectionModel].
extension LegalSectionModelPatterns on LegalSectionModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LegalSectionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LegalSectionModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LegalSectionModel value)  $default,){
final _that = this;
switch (_that) {
case _LegalSectionModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LegalSectionModel value)?  $default,){
final _that = this;
switch (_that) {
case _LegalSectionModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String actCode,  String actName,  String sectionNumber,  String title,  String chapter,  String text,  String sourceUrl,  String? legacyMapping,  String? plainLanguage,  String? punishment,  List<String> relatedSections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LegalSectionModel() when $default != null:
return $default(_that.actCode,_that.actName,_that.sectionNumber,_that.title,_that.chapter,_that.text,_that.sourceUrl,_that.legacyMapping,_that.plainLanguage,_that.punishment,_that.relatedSections);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String actCode,  String actName,  String sectionNumber,  String title,  String chapter,  String text,  String sourceUrl,  String? legacyMapping,  String? plainLanguage,  String? punishment,  List<String> relatedSections)  $default,) {final _that = this;
switch (_that) {
case _LegalSectionModel():
return $default(_that.actCode,_that.actName,_that.sectionNumber,_that.title,_that.chapter,_that.text,_that.sourceUrl,_that.legacyMapping,_that.plainLanguage,_that.punishment,_that.relatedSections);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String actCode,  String actName,  String sectionNumber,  String title,  String chapter,  String text,  String sourceUrl,  String? legacyMapping,  String? plainLanguage,  String? punishment,  List<String> relatedSections)?  $default,) {final _that = this;
switch (_that) {
case _LegalSectionModel() when $default != null:
return $default(_that.actCode,_that.actName,_that.sectionNumber,_that.title,_that.chapter,_that.text,_that.sourceUrl,_that.legacyMapping,_that.plainLanguage,_that.punishment,_that.relatedSections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LegalSectionModel implements LegalSectionModel {
  const _LegalSectionModel({required this.actCode, required this.actName, required this.sectionNumber, required this.title, required this.chapter, required this.text, required this.sourceUrl, this.legacyMapping, this.plainLanguage, this.punishment,  List<String> relatedSections = const <String>[]}): _relatedSections = relatedSections;
  factory _LegalSectionModel.fromJson(Map<String, dynamic> json) => _$LegalSectionModelFromJson(json);

@override final  String actCode;
@override final  String actName;
@override final  String sectionNumber;
@override final  String title;
@override final  String chapter;
@override final  String text;
@override final  String sourceUrl;
@override final  String? legacyMapping;
@override final  String? plainLanguage;
@override final  String? punishment;
 final  List<String> _relatedSections;
@override@JsonKey() List<String> get relatedSections {
  if (_relatedSections is EqualUnmodifiableListView) return _relatedSections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedSections);
}


/// Create a copy of LegalSectionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LegalSectionModelCopyWith<_LegalSectionModel> get copyWith => __$LegalSectionModelCopyWithImpl<_LegalSectionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LegalSectionModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LegalSectionModel&&(identical(other.actCode, actCode) || other.actCode == actCode)&&(identical(other.actName, actName) || other.actName == actName)&&(identical(other.sectionNumber, sectionNumber) || other.sectionNumber == sectionNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.text, text) || other.text == text)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.legacyMapping, legacyMapping) || other.legacyMapping == legacyMapping)&&(identical(other.plainLanguage, plainLanguage) || other.plainLanguage == plainLanguage)&&(identical(other.punishment, punishment) || other.punishment == punishment)&&const DeepCollectionEquality().equals(other.relatedSections, _relatedSections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,actCode,actName,sectionNumber,title,chapter,text,sourceUrl,legacyMapping,plainLanguage,punishment,const DeepCollectionEquality().hash(_relatedSections));
}

@override
String toString() {
    return 'LegalSectionModel(actCode: $actCode, actName: $actName, sectionNumber: $sectionNumber, title: $title, chapter: $chapter, text: $text, sourceUrl: $sourceUrl, legacyMapping: $legacyMapping, plainLanguage: $plainLanguage, punishment: $punishment, relatedSections: $relatedSections)';
}


}

/// @nodoc
abstract mixin class _$LegalSectionModelCopyWith<$Res> implements $LegalSectionModelCopyWith<$Res> {
  factory _$LegalSectionModelCopyWith(_LegalSectionModel value, $Res Function(_LegalSectionModel) _then) = __$LegalSectionModelCopyWithImpl;
@override @useResult
$Res call({
 String actCode, String actName, String sectionNumber, String title, String chapter, String text, String sourceUrl, String? legacyMapping, String? plainLanguage, String? punishment, List<String> relatedSections
});




}
/// @nodoc
class __$LegalSectionModelCopyWithImpl<$Res>
    implements _$LegalSectionModelCopyWith<$Res> {
  __$LegalSectionModelCopyWithImpl(this._self, this._then);

  final _LegalSectionModel _self;
  final $Res Function(_LegalSectionModel) _then;

/// Create a copy of LegalSectionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actCode = null,Object? actName = null,Object? sectionNumber = null,Object? title = null,Object? chapter = null,Object? text = null,Object? sourceUrl = null,Object? legacyMapping = freezed,Object? plainLanguage = freezed,Object? punishment = freezed,Object? relatedSections = null,}) {
  return _then(_LegalSectionModel(
actCode: null == actCode ? _self.actCode : actCode // ignore: cast_nullable_to_non_nullable
as String,actName: null == actName ? _self.actName : actName // ignore: cast_nullable_to_non_nullable
as String,sectionNumber: null == sectionNumber ? _self.sectionNumber : sectionNumber // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,legacyMapping: freezed == legacyMapping ? _self.legacyMapping : legacyMapping // ignore: cast_nullable_to_non_nullable
as String?,plainLanguage: freezed == plainLanguage ? _self.plainLanguage : plainLanguage // ignore: cast_nullable_to_non_nullable
as String?,punishment: freezed == punishment ? _self.punishment : punishment // ignore: cast_nullable_to_non_nullable
as String?,relatedSections: null == relatedSections ? _self._relatedSections : relatedSections // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
