// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_result_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizResultResponse {

 String get code; String get message; QuizResultData? get data;
/// Create a copy of QuizResultResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizResultResponseCopyWith<QuizResultResponse> get copyWith => _$QuizResultResponseCopyWithImpl<QuizResultResponse>(this as QuizResultResponse, _$identity);

  /// Serializes this QuizResultResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizResultResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'QuizResultResponse(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $QuizResultResponseCopyWith<$Res>  {
  factory $QuizResultResponseCopyWith(QuizResultResponse value, $Res Function(QuizResultResponse) _then) = _$QuizResultResponseCopyWithImpl;
@useResult
$Res call({
 String code, String message, QuizResultData? data
});


$QuizResultDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$QuizResultResponseCopyWithImpl<$Res>
    implements $QuizResultResponseCopyWith<$Res> {
  _$QuizResultResponseCopyWithImpl(this._self, this._then);

  final QuizResultResponse _self;
  final $Res Function(QuizResultResponse) _then;

/// Create a copy of QuizResultResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as QuizResultData?,
  ));
}
/// Create a copy of QuizResultResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizResultDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $QuizResultDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizResultResponse].
extension QuizResultResponsePatterns on QuizResultResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizResultResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizResultResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizResultResponse value)  $default,){
final _that = this;
switch (_that) {
case _QuizResultResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizResultResponse value)?  $default,){
final _that = this;
switch (_that) {
case _QuizResultResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  QuizResultData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizResultResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  QuizResultData? data)  $default,) {final _that = this;
switch (_that) {
case _QuizResultResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  QuizResultData? data)?  $default,) {final _that = this;
switch (_that) {
case _QuizResultResponse() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizResultResponse implements QuizResultResponse {
  const _QuizResultResponse({required this.code, required this.message, this.data});
  factory _QuizResultResponse.fromJson(Map<String, dynamic> json) => _$QuizResultResponseFromJson(json);

@override final  String code;
@override final  String message;
@override final  QuizResultData? data;

/// Create a copy of QuizResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizResultResponseCopyWith<_QuizResultResponse> get copyWith => __$QuizResultResponseCopyWithImpl<_QuizResultResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizResultResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizResultResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'QuizResultResponse(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$QuizResultResponseCopyWith<$Res> implements $QuizResultResponseCopyWith<$Res> {
  factory _$QuizResultResponseCopyWith(_QuizResultResponse value, $Res Function(_QuizResultResponse) _then) = __$QuizResultResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, QuizResultData? data
});


@override $QuizResultDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$QuizResultResponseCopyWithImpl<$Res>
    implements _$QuizResultResponseCopyWith<$Res> {
  __$QuizResultResponseCopyWithImpl(this._self, this._then);

  final _QuizResultResponse _self;
  final $Res Function(_QuizResultResponse) _then;

/// Create a copy of QuizResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = freezed,}) {
  return _then(_QuizResultResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as QuizResultData?,
  ));
}

/// Create a copy of QuizResultResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizResultDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $QuizResultDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$QuizResultData {

 int get correctCount; bool get success;
/// Create a copy of QuizResultData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizResultDataCopyWith<QuizResultData> get copyWith => _$QuizResultDataCopyWithImpl<QuizResultData>(this as QuizResultData, _$identity);

  /// Serializes this QuizResultData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizResultData&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correctCount,success);

@override
String toString() {
  return 'QuizResultData(correctCount: $correctCount, success: $success)';
}


}

/// @nodoc
abstract mixin class $QuizResultDataCopyWith<$Res>  {
  factory $QuizResultDataCopyWith(QuizResultData value, $Res Function(QuizResultData) _then) = _$QuizResultDataCopyWithImpl;
@useResult
$Res call({
 int correctCount, bool success
});




}
/// @nodoc
class _$QuizResultDataCopyWithImpl<$Res>
    implements $QuizResultDataCopyWith<$Res> {
  _$QuizResultDataCopyWithImpl(this._self, this._then);

  final QuizResultData _self;
  final $Res Function(QuizResultData) _then;

/// Create a copy of QuizResultData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correctCount = null,Object? success = null,}) {
  return _then(_self.copyWith(
correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizResultData].
extension QuizResultDataPatterns on QuizResultData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizResultData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizResultData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizResultData value)  $default,){
final _that = this;
switch (_that) {
case _QuizResultData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizResultData value)?  $default,){
final _that = this;
switch (_that) {
case _QuizResultData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int correctCount,  bool success)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizResultData() when $default != null:
return $default(_that.correctCount,_that.success);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int correctCount,  bool success)  $default,) {final _that = this;
switch (_that) {
case _QuizResultData():
return $default(_that.correctCount,_that.success);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int correctCount,  bool success)?  $default,) {final _that = this;
switch (_that) {
case _QuizResultData() when $default != null:
return $default(_that.correctCount,_that.success);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizResultData implements QuizResultData {
  const _QuizResultData({required this.correctCount, required this.success});
  factory _QuizResultData.fromJson(Map<String, dynamic> json) => _$QuizResultDataFromJson(json);

@override final  int correctCount;
@override final  bool success;

/// Create a copy of QuizResultData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizResultDataCopyWith<_QuizResultData> get copyWith => __$QuizResultDataCopyWithImpl<_QuizResultData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizResultDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizResultData&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.success, success) || other.success == success));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correctCount,success);

@override
String toString() {
  return 'QuizResultData(correctCount: $correctCount, success: $success)';
}


}

/// @nodoc
abstract mixin class _$QuizResultDataCopyWith<$Res> implements $QuizResultDataCopyWith<$Res> {
  factory _$QuizResultDataCopyWith(_QuizResultData value, $Res Function(_QuizResultData) _then) = __$QuizResultDataCopyWithImpl;
@override @useResult
$Res call({
 int correctCount, bool success
});




}
/// @nodoc
class __$QuizResultDataCopyWithImpl<$Res>
    implements _$QuizResultDataCopyWith<$Res> {
  __$QuizResultDataCopyWithImpl(this._self, this._then);

  final _QuizResultData _self;
  final $Res Function(_QuizResultData) _then;

/// Create a copy of QuizResultData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correctCount = null,Object? success = null,}) {
  return _then(_QuizResultData(
correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
