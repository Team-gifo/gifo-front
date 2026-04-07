// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capsule_draw_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CapsuleDrawResponse {

 String get code; String get message; CapsuleDrawData? get data;
/// Create a copy of CapsuleDrawResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CapsuleDrawResponseCopyWith<CapsuleDrawResponse> get copyWith => _$CapsuleDrawResponseCopyWithImpl<CapsuleDrawResponse>(this as CapsuleDrawResponse, _$identity);

  /// Serializes this CapsuleDrawResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CapsuleDrawResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'CapsuleDrawResponse(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $CapsuleDrawResponseCopyWith<$Res>  {
  factory $CapsuleDrawResponseCopyWith(CapsuleDrawResponse value, $Res Function(CapsuleDrawResponse) _then) = _$CapsuleDrawResponseCopyWithImpl;
@useResult
$Res call({
 String code, String message, CapsuleDrawData? data
});


$CapsuleDrawDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$CapsuleDrawResponseCopyWithImpl<$Res>
    implements $CapsuleDrawResponseCopyWith<$Res> {
  _$CapsuleDrawResponseCopyWithImpl(this._self, this._then);

  final CapsuleDrawResponse _self;
  final $Res Function(CapsuleDrawResponse) _then;

/// Create a copy of CapsuleDrawResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CapsuleDrawData?,
  ));
}
/// Create a copy of CapsuleDrawResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CapsuleDrawDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $CapsuleDrawDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CapsuleDrawResponse].
extension CapsuleDrawResponsePatterns on CapsuleDrawResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CapsuleDrawResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CapsuleDrawResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CapsuleDrawResponse value)  $default,){
final _that = this;
switch (_that) {
case _CapsuleDrawResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CapsuleDrawResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CapsuleDrawResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  CapsuleDrawData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CapsuleDrawResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  CapsuleDrawData? data)  $default,) {final _that = this;
switch (_that) {
case _CapsuleDrawResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  CapsuleDrawData? data)?  $default,) {final _that = this;
switch (_that) {
case _CapsuleDrawResponse() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CapsuleDrawResponse implements CapsuleDrawResponse {
  const _CapsuleDrawResponse({required this.code, required this.message, this.data});
  factory _CapsuleDrawResponse.fromJson(Map<String, dynamic> json) => _$CapsuleDrawResponseFromJson(json);

@override final  String code;
@override final  String message;
@override final  CapsuleDrawData? data;

/// Create a copy of CapsuleDrawResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CapsuleDrawResponseCopyWith<_CapsuleDrawResponse> get copyWith => __$CapsuleDrawResponseCopyWithImpl<_CapsuleDrawResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CapsuleDrawResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CapsuleDrawResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'CapsuleDrawResponse(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$CapsuleDrawResponseCopyWith<$Res> implements $CapsuleDrawResponseCopyWith<$Res> {
  factory _$CapsuleDrawResponseCopyWith(_CapsuleDrawResponse value, $Res Function(_CapsuleDrawResponse) _then) = __$CapsuleDrawResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, CapsuleDrawData? data
});


@override $CapsuleDrawDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$CapsuleDrawResponseCopyWithImpl<$Res>
    implements _$CapsuleDrawResponseCopyWith<$Res> {
  __$CapsuleDrawResponseCopyWithImpl(this._self, this._then);

  final _CapsuleDrawResponse _self;
  final $Res Function(_CapsuleDrawResponse) _then;

/// Create a copy of CapsuleDrawResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = freezed,}) {
  return _then(_CapsuleDrawResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CapsuleDrawData?,
  ));
}

/// Create a copy of CapsuleDrawResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CapsuleDrawDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $CapsuleDrawDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$CapsuleDrawData {

 int get capsuleId; String get giftName; String get giftImageUrl; String get description;
/// Create a copy of CapsuleDrawData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CapsuleDrawDataCopyWith<CapsuleDrawData> get copyWith => _$CapsuleDrawDataCopyWithImpl<CapsuleDrawData>(this as CapsuleDrawData, _$identity);

  /// Serializes this CapsuleDrawData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CapsuleDrawData&&(identical(other.capsuleId, capsuleId) || other.capsuleId == capsuleId)&&(identical(other.giftName, giftName) || other.giftName == giftName)&&(identical(other.giftImageUrl, giftImageUrl) || other.giftImageUrl == giftImageUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,capsuleId,giftName,giftImageUrl,description);

@override
String toString() {
  return 'CapsuleDrawData(capsuleId: $capsuleId, giftName: $giftName, giftImageUrl: $giftImageUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class $CapsuleDrawDataCopyWith<$Res>  {
  factory $CapsuleDrawDataCopyWith(CapsuleDrawData value, $Res Function(CapsuleDrawData) _then) = _$CapsuleDrawDataCopyWithImpl;
@useResult
$Res call({
 int capsuleId, String giftName, String giftImageUrl, String description
});




}
/// @nodoc
class _$CapsuleDrawDataCopyWithImpl<$Res>
    implements $CapsuleDrawDataCopyWith<$Res> {
  _$CapsuleDrawDataCopyWithImpl(this._self, this._then);

  final CapsuleDrawData _self;
  final $Res Function(CapsuleDrawData) _then;

/// Create a copy of CapsuleDrawData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? capsuleId = null,Object? giftName = null,Object? giftImageUrl = null,Object? description = null,}) {
  return _then(_self.copyWith(
capsuleId: null == capsuleId ? _self.capsuleId : capsuleId // ignore: cast_nullable_to_non_nullable
as int,giftName: null == giftName ? _self.giftName : giftName // ignore: cast_nullable_to_non_nullable
as String,giftImageUrl: null == giftImageUrl ? _self.giftImageUrl : giftImageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CapsuleDrawData].
extension CapsuleDrawDataPatterns on CapsuleDrawData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CapsuleDrawData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CapsuleDrawData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CapsuleDrawData value)  $default,){
final _that = this;
switch (_that) {
case _CapsuleDrawData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CapsuleDrawData value)?  $default,){
final _that = this;
switch (_that) {
case _CapsuleDrawData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int capsuleId,  String giftName,  String giftImageUrl,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CapsuleDrawData() when $default != null:
return $default(_that.capsuleId,_that.giftName,_that.giftImageUrl,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int capsuleId,  String giftName,  String giftImageUrl,  String description)  $default,) {final _that = this;
switch (_that) {
case _CapsuleDrawData():
return $default(_that.capsuleId,_that.giftName,_that.giftImageUrl,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int capsuleId,  String giftName,  String giftImageUrl,  String description)?  $default,) {final _that = this;
switch (_that) {
case _CapsuleDrawData() when $default != null:
return $default(_that.capsuleId,_that.giftName,_that.giftImageUrl,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CapsuleDrawData implements CapsuleDrawData {
  const _CapsuleDrawData({required this.capsuleId, required this.giftName, required this.giftImageUrl, required this.description});
  factory _CapsuleDrawData.fromJson(Map<String, dynamic> json) => _$CapsuleDrawDataFromJson(json);

@override final  int capsuleId;
@override final  String giftName;
@override final  String giftImageUrl;
@override final  String description;

/// Create a copy of CapsuleDrawData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CapsuleDrawDataCopyWith<_CapsuleDrawData> get copyWith => __$CapsuleDrawDataCopyWithImpl<_CapsuleDrawData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CapsuleDrawDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CapsuleDrawData&&(identical(other.capsuleId, capsuleId) || other.capsuleId == capsuleId)&&(identical(other.giftName, giftName) || other.giftName == giftName)&&(identical(other.giftImageUrl, giftImageUrl) || other.giftImageUrl == giftImageUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,capsuleId,giftName,giftImageUrl,description);

@override
String toString() {
  return 'CapsuleDrawData(capsuleId: $capsuleId, giftName: $giftName, giftImageUrl: $giftImageUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CapsuleDrawDataCopyWith<$Res> implements $CapsuleDrawDataCopyWith<$Res> {
  factory _$CapsuleDrawDataCopyWith(_CapsuleDrawData value, $Res Function(_CapsuleDrawData) _then) = __$CapsuleDrawDataCopyWithImpl;
@override @useResult
$Res call({
 int capsuleId, String giftName, String giftImageUrl, String description
});




}
/// @nodoc
class __$CapsuleDrawDataCopyWithImpl<$Res>
    implements _$CapsuleDrawDataCopyWith<$Res> {
  __$CapsuleDrawDataCopyWithImpl(this._self, this._then);

  final _CapsuleDrawData _self;
  final $Res Function(_CapsuleDrawData) _then;

/// Create a copy of CapsuleDrawData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? capsuleId = null,Object? giftName = null,Object? giftImageUrl = null,Object? description = null,}) {
  return _then(_CapsuleDrawData(
capsuleId: null == capsuleId ? _self.capsuleId : capsuleId // ignore: cast_nullable_to_non_nullable
as int,giftName: null == giftName ? _self.giftName : giftName // ignore: cast_nullable_to_non_nullable
as String,giftImageUrl: null == giftImageUrl ? _self.giftImageUrl : giftImageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
