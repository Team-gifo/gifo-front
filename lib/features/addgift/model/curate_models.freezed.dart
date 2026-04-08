// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curate_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CurateSurveyRequest {

 String get relationship; String get situation; String get tone; String get targetAge; String? get targetName;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurateSurveyRequestCopyWith<CurateSurveyRequest> get copyWith => _$CurateSurveyRequestCopyWithImpl<CurateSurveyRequest>(this as CurateSurveyRequest, _$identity);

  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurateSurveyRequest&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.targetAge, targetAge) || other.targetAge == targetAge)&&(identical(other.targetName, targetName) || other.targetName == targetName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,relationship,situation,tone,targetAge,targetName);

@override
String toString() {
  return 'CurateSurveyRequest(relationship: $relationship, situation: $situation, tone: $tone, targetAge: $targetAge, targetName: $targetName)';
}


}

/// @nodoc
abstract mixin class $CurateSurveyRequestCopyWith<$Res>  {
  factory $CurateSurveyRequestCopyWith(CurateSurveyRequest value, $Res Function(CurateSurveyRequest) _then) = _$CurateSurveyRequestCopyWithImpl;
@useResult
$Res call({
 String relationship, String situation, String tone, String targetAge, String? targetName
});




}
/// @nodoc
class _$CurateSurveyRequestCopyWithImpl<$Res>
    implements $CurateSurveyRequestCopyWith<$Res> {
  _$CurateSurveyRequestCopyWithImpl(this._self, this._then);

  final CurateSurveyRequest _self;
  final $Res Function(CurateSurveyRequest) _then;

/// Create a copy of CurateSurveyRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? relationship = null,Object? situation = null,Object? tone = null,Object? targetAge = null,Object? targetName = freezed,}) {
  return _then(_self.copyWith(
relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,targetAge: null == targetAge ? _self.targetAge : targetAge // ignore: cast_nullable_to_non_nullable
as String,targetName: freezed == targetName ? _self.targetName : targetName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CurateSurveyRequest].
extension CurateSurveyRequestPatterns on CurateSurveyRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurateSurveyRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurateSurveyRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurateSurveyRequest value)  $default,){
final _that = this;
switch (_that) {
case _CurateSurveyRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurateSurveyRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CurateSurveyRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String relationship,  String situation,  String tone,  String targetAge,  String? targetName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurateSurveyRequest() when $default != null:
return $default(_that.relationship,_that.situation,_that.tone,_that.targetAge,_that.targetName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String relationship,  String situation,  String tone,  String targetAge,  String? targetName)  $default,) {final _that = this;
switch (_that) {
case _CurateSurveyRequest():
return $default(_that.relationship,_that.situation,_that.tone,_that.targetAge,_that.targetName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String relationship,  String situation,  String tone,  String targetAge,  String? targetName)?  $default,) {final _that = this;
switch (_that) {
case _CurateSurveyRequest() when $default != null:
return $default(_that.relationship,_that.situation,_that.tone,_that.targetAge,_that.targetName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurateSurveyRequest implements CurateSurveyRequest {
  const _CurateSurveyRequest({required this.relationship, required this.situation, required this.tone, required this.targetAge, this.targetName});
  factory _CurateSurveyRequest.fromJson(Map<String, dynamic> json) => _$CurateSurveyRequestFromJson(json);

@override final  String relationship;
@override final  String situation;
@override final  String tone;
@override final  String targetAge;
@override final  String? targetName;

/// Create a copy of CurateSurveyRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurateSurveyRequestCopyWith<_CurateSurveyRequest> get copyWith => __$CurateSurveyRequestCopyWithImpl<_CurateSurveyRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurateSurveyRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurateSurveyRequest&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.targetAge, targetAge) || other.targetAge == targetAge)&&(identical(other.targetName, targetName) || other.targetName == targetName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,relationship,situation,tone,targetAge,targetName);

@override
String toString() {
  return 'CurateSurveyRequest(relationship: $relationship, situation: $situation, tone: $tone, targetAge: $targetAge, targetName: $targetName)';
}


}

/// @nodoc
abstract mixin class _$CurateSurveyRequestCopyWith<$Res> implements $CurateSurveyRequestCopyWith<$Res> {
  factory _$CurateSurveyRequestCopyWith(_CurateSurveyRequest value, $Res Function(_CurateSurveyRequest) _then) = __$CurateSurveyRequestCopyWithImpl;
@override @useResult
$Res call({
 String relationship, String situation, String tone, String targetAge, String? targetName
});




}
/// @nodoc
class __$CurateSurveyRequestCopyWithImpl<$Res>
    implements _$CurateSurveyRequestCopyWith<$Res> {
  __$CurateSurveyRequestCopyWithImpl(this._self, this._then);

  final _CurateSurveyRequest _self;
  final $Res Function(_CurateSurveyRequest) _then;

/// Create a copy of CurateSurveyRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? relationship = null,Object? situation = null,Object? tone = null,Object? targetAge = null,Object? targetName = freezed,}) {
  return _then(_CurateSurveyRequest(
relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,targetAge: null == targetAge ? _self.targetAge : targetAge // ignore: cast_nullable_to_non_nullable
as String,targetName: freezed == targetName ? _self.targetName : targetName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CurateResponseData {

 String get user;@JsonKey(name: 'sub_title') String get subTitle; String get bgm; List<GalleryItem> get gallery; GiftContent get content;
/// Create a copy of CurateResponseData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurateResponseDataCopyWith<CurateResponseData> get copyWith => _$CurateResponseDataCopyWithImpl<CurateResponseData>(this as CurateResponseData, _$identity);

  /// Serializes this CurateResponseData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurateResponseData&&(identical(other.user, user) || other.user == user)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.bgm, bgm) || other.bgm == bgm)&&const DeepCollectionEquality().equals(other.gallery, gallery)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,subTitle,bgm,const DeepCollectionEquality().hash(gallery),content);

@override
String toString() {
  return 'CurateResponseData(user: $user, subTitle: $subTitle, bgm: $bgm, gallery: $gallery, content: $content)';
}


}

/// @nodoc
abstract mixin class $CurateResponseDataCopyWith<$Res>  {
  factory $CurateResponseDataCopyWith(CurateResponseData value, $Res Function(CurateResponseData) _then) = _$CurateResponseDataCopyWithImpl;
@useResult
$Res call({
 String user,@JsonKey(name: 'sub_title') String subTitle, String bgm, List<GalleryItem> gallery, GiftContent content
});


$GiftContentCopyWith<$Res> get content;

}
/// @nodoc
class _$CurateResponseDataCopyWithImpl<$Res>
    implements $CurateResponseDataCopyWith<$Res> {
  _$CurateResponseDataCopyWithImpl(this._self, this._then);

  final CurateResponseData _self;
  final $Res Function(CurateResponseData) _then;

/// Create a copy of CurateResponseData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? subTitle = null,Object? bgm = null,Object? gallery = null,Object? content = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,subTitle: null == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String,bgm: null == bgm ? _self.bgm : bgm // ignore: cast_nullable_to_non_nullable
as String,gallery: null == gallery ? _self.gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<GalleryItem>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as GiftContent,
  ));
}
/// Create a copy of CurateResponseData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GiftContentCopyWith<$Res> get content {
  
  return $GiftContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [CurateResponseData].
extension CurateResponseDataPatterns on CurateResponseData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurateResponseData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurateResponseData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurateResponseData value)  $default,){
final _that = this;
switch (_that) {
case _CurateResponseData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurateResponseData value)?  $default,){
final _that = this;
switch (_that) {
case _CurateResponseData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String user, @JsonKey(name: 'sub_title')  String subTitle,  String bgm,  List<GalleryItem> gallery,  GiftContent content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurateResponseData() when $default != null:
return $default(_that.user,_that.subTitle,_that.bgm,_that.gallery,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String user, @JsonKey(name: 'sub_title')  String subTitle,  String bgm,  List<GalleryItem> gallery,  GiftContent content)  $default,) {final _that = this;
switch (_that) {
case _CurateResponseData():
return $default(_that.user,_that.subTitle,_that.bgm,_that.gallery,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String user, @JsonKey(name: 'sub_title')  String subTitle,  String bgm,  List<GalleryItem> gallery,  GiftContent content)?  $default,) {final _that = this;
switch (_that) {
case _CurateResponseData() when $default != null:
return $default(_that.user,_that.subTitle,_that.bgm,_that.gallery,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurateResponseData implements CurateResponseData {
  const _CurateResponseData({this.user = '', @JsonKey(name: 'sub_title') this.subTitle = '', this.bgm = '', final  List<GalleryItem> gallery = const <GalleryItem>[], this.content = const GiftContent()}): _gallery = gallery;
  factory _CurateResponseData.fromJson(Map<String, dynamic> json) => _$CurateResponseDataFromJson(json);

@override@JsonKey() final  String user;
@override@JsonKey(name: 'sub_title') final  String subTitle;
@override@JsonKey() final  String bgm;
 final  List<GalleryItem> _gallery;
@override@JsonKey() List<GalleryItem> get gallery {
  if (_gallery is EqualUnmodifiableListView) return _gallery;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gallery);
}

@override@JsonKey() final  GiftContent content;

/// Create a copy of CurateResponseData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurateResponseDataCopyWith<_CurateResponseData> get copyWith => __$CurateResponseDataCopyWithImpl<_CurateResponseData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurateResponseDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurateResponseData&&(identical(other.user, user) || other.user == user)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.bgm, bgm) || other.bgm == bgm)&&const DeepCollectionEquality().equals(other._gallery, _gallery)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,subTitle,bgm,const DeepCollectionEquality().hash(_gallery),content);

@override
String toString() {
  return 'CurateResponseData(user: $user, subTitle: $subTitle, bgm: $bgm, gallery: $gallery, content: $content)';
}


}

/// @nodoc
abstract mixin class _$CurateResponseDataCopyWith<$Res> implements $CurateResponseDataCopyWith<$Res> {
  factory _$CurateResponseDataCopyWith(_CurateResponseData value, $Res Function(_CurateResponseData) _then) = __$CurateResponseDataCopyWithImpl;
@override @useResult
$Res call({
 String user,@JsonKey(name: 'sub_title') String subTitle, String bgm, List<GalleryItem> gallery, GiftContent content
});


@override $GiftContentCopyWith<$Res> get content;

}
/// @nodoc
class __$CurateResponseDataCopyWithImpl<$Res>
    implements _$CurateResponseDataCopyWith<$Res> {
  __$CurateResponseDataCopyWithImpl(this._self, this._then);

  final _CurateResponseData _self;
  final $Res Function(_CurateResponseData) _then;

/// Create a copy of CurateResponseData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? subTitle = null,Object? bgm = null,Object? gallery = null,Object? content = null,}) {
  return _then(_CurateResponseData(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,subTitle: null == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String,bgm: null == bgm ? _self.bgm : bgm // ignore: cast_nullable_to_non_nullable
as String,gallery: null == gallery ? _self._gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<GalleryItem>,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as GiftContent,
  ));
}

/// Create a copy of CurateResponseData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GiftContentCopyWith<$Res> get content {
  
  return $GiftContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// @nodoc
mixin _$CurateApiEnvelope {

 String get code; String get message; CurateResponseData get data;
/// Create a copy of CurateApiEnvelope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurateApiEnvelopeCopyWith<CurateApiEnvelope> get copyWith => _$CurateApiEnvelopeCopyWithImpl<CurateApiEnvelope>(this as CurateApiEnvelope, _$identity);

  /// Serializes this CurateApiEnvelope to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurateApiEnvelope&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'CurateApiEnvelope(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $CurateApiEnvelopeCopyWith<$Res>  {
  factory $CurateApiEnvelopeCopyWith(CurateApiEnvelope value, $Res Function(CurateApiEnvelope) _then) = _$CurateApiEnvelopeCopyWithImpl;
@useResult
$Res call({
 String code, String message, CurateResponseData data
});


$CurateResponseDataCopyWith<$Res> get data;

}
/// @nodoc
class _$CurateApiEnvelopeCopyWithImpl<$Res>
    implements $CurateApiEnvelopeCopyWith<$Res> {
  _$CurateApiEnvelopeCopyWithImpl(this._self, this._then);

  final CurateApiEnvelope _self;
  final $Res Function(CurateApiEnvelope) _then;

/// Create a copy of CurateApiEnvelope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CurateResponseData,
  ));
}
/// Create a copy of CurateApiEnvelope
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurateResponseDataCopyWith<$Res> get data {
  
  return $CurateResponseDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CurateApiEnvelope].
extension CurateApiEnvelopePatterns on CurateApiEnvelope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurateApiEnvelope value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurateApiEnvelope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurateApiEnvelope value)  $default,){
final _that = this;
switch (_that) {
case _CurateApiEnvelope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurateApiEnvelope value)?  $default,){
final _that = this;
switch (_that) {
case _CurateApiEnvelope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  CurateResponseData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurateApiEnvelope() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  CurateResponseData data)  $default,) {final _that = this;
switch (_that) {
case _CurateApiEnvelope():
return $default(_that.code,_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  CurateResponseData data)?  $default,) {final _that = this;
switch (_that) {
case _CurateApiEnvelope() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurateApiEnvelope implements CurateApiEnvelope {
  const _CurateApiEnvelope({this.code = '', this.message = '', required this.data});
  factory _CurateApiEnvelope.fromJson(Map<String, dynamic> json) => _$CurateApiEnvelopeFromJson(json);

@override@JsonKey() final  String code;
@override@JsonKey() final  String message;
@override final  CurateResponseData data;

/// Create a copy of CurateApiEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurateApiEnvelopeCopyWith<_CurateApiEnvelope> get copyWith => __$CurateApiEnvelopeCopyWithImpl<_CurateApiEnvelope>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurateApiEnvelopeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurateApiEnvelope&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'CurateApiEnvelope(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CurateApiEnvelopeCopyWith<$Res> implements $CurateApiEnvelopeCopyWith<$Res> {
  factory _$CurateApiEnvelopeCopyWith(_CurateApiEnvelope value, $Res Function(_CurateApiEnvelope) _then) = __$CurateApiEnvelopeCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, CurateResponseData data
});


@override $CurateResponseDataCopyWith<$Res> get data;

}
/// @nodoc
class __$CurateApiEnvelopeCopyWithImpl<$Res>
    implements _$CurateApiEnvelopeCopyWith<$Res> {
  __$CurateApiEnvelopeCopyWithImpl(this._self, this._then);

  final _CurateApiEnvelope _self;
  final $Res Function(_CurateApiEnvelope) _then;

/// Create a copy of CurateApiEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = null,}) {
  return _then(_CurateApiEnvelope(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CurateResponseData,
  ));
}

/// Create a copy of CurateApiEnvelope
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurateResponseDataCopyWith<$Res> get data {
  
  return $CurateResponseDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
