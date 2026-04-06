// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_answer_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizAnswerResponse {

 String get code; String get message; QuizAnswerData? get data;
/// Create a copy of QuizAnswerResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizAnswerResponseCopyWith<QuizAnswerResponse> get copyWith => _$QuizAnswerResponseCopyWithImpl<QuizAnswerResponse>(this as QuizAnswerResponse, _$identity);

  /// Serializes this QuizAnswerResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizAnswerResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'QuizAnswerResponse(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $QuizAnswerResponseCopyWith<$Res>  {
  factory $QuizAnswerResponseCopyWith(QuizAnswerResponse value, $Res Function(QuizAnswerResponse) _then) = _$QuizAnswerResponseCopyWithImpl;
@useResult
$Res call({
 String code, String message, QuizAnswerData? data
});


$QuizAnswerDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$QuizAnswerResponseCopyWithImpl<$Res>
    implements $QuizAnswerResponseCopyWith<$Res> {
  _$QuizAnswerResponseCopyWithImpl(this._self, this._then);

  final QuizAnswerResponse _self;
  final $Res Function(QuizAnswerResponse) _then;

/// Create a copy of QuizAnswerResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as QuizAnswerData?,
  ));
}
/// Create a copy of QuizAnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizAnswerDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $QuizAnswerDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizAnswerResponse].
extension QuizAnswerResponsePatterns on QuizAnswerResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizAnswerResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizAnswerResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizAnswerResponse value)  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizAnswerResponse value)?  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  QuizAnswerData? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizAnswerResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  QuizAnswerData? data)  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  QuizAnswerData? data)?  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerResponse() when $default != null:
return $default(_that.code,_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizAnswerResponse implements QuizAnswerResponse {
  const _QuizAnswerResponse({required this.code, required this.message, this.data});
  factory _QuizAnswerResponse.fromJson(Map<String, dynamic> json) => _$QuizAnswerResponseFromJson(json);

@override final  String code;
@override final  String message;
@override final  QuizAnswerData? data;

/// Create a copy of QuizAnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizAnswerResponseCopyWith<_QuizAnswerResponse> get copyWith => __$QuizAnswerResponseCopyWithImpl<_QuizAnswerResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizAnswerResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizAnswerResponse&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,data);

@override
String toString() {
  return 'QuizAnswerResponse(code: $code, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$QuizAnswerResponseCopyWith<$Res> implements $QuizAnswerResponseCopyWith<$Res> {
  factory _$QuizAnswerResponseCopyWith(_QuizAnswerResponse value, $Res Function(_QuizAnswerResponse) _then) = __$QuizAnswerResponseCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, QuizAnswerData? data
});


@override $QuizAnswerDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$QuizAnswerResponseCopyWithImpl<$Res>
    implements _$QuizAnswerResponseCopyWith<$Res> {
  __$QuizAnswerResponseCopyWithImpl(this._self, this._then);

  final _QuizAnswerResponse _self;
  final $Res Function(_QuizAnswerResponse) _then;

/// Create a copy of QuizAnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? data = freezed,}) {
  return _then(_QuizAnswerResponse(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as QuizAnswerData?,
  ));
}

/// Create a copy of QuizAnswerResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizAnswerDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $QuizAnswerDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$QuizAnswerData {

 int get quizId; bool get correct; int get remainingAttempts; int get currentQuizIndex;
/// Create a copy of QuizAnswerData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizAnswerDataCopyWith<QuizAnswerData> get copyWith => _$QuizAnswerDataCopyWithImpl<QuizAnswerData>(this as QuizAnswerData, _$identity);

  /// Serializes this QuizAnswerData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizAnswerData&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.remainingAttempts, remainingAttempts) || other.remainingAttempts == remainingAttempts)&&(identical(other.currentQuizIndex, currentQuizIndex) || other.currentQuizIndex == currentQuizIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,correct,remainingAttempts,currentQuizIndex);

@override
String toString() {
  return 'QuizAnswerData(quizId: $quizId, correct: $correct, remainingAttempts: $remainingAttempts, currentQuizIndex: $currentQuizIndex)';
}


}

/// @nodoc
abstract mixin class $QuizAnswerDataCopyWith<$Res>  {
  factory $QuizAnswerDataCopyWith(QuizAnswerData value, $Res Function(QuizAnswerData) _then) = _$QuizAnswerDataCopyWithImpl;
@useResult
$Res call({
 int quizId, bool correct, int remainingAttempts, int currentQuizIndex
});




}
/// @nodoc
class _$QuizAnswerDataCopyWithImpl<$Res>
    implements $QuizAnswerDataCopyWith<$Res> {
  _$QuizAnswerDataCopyWithImpl(this._self, this._then);

  final QuizAnswerData _self;
  final $Res Function(QuizAnswerData) _then;

/// Create a copy of QuizAnswerData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quizId = null,Object? correct = null,Object? remainingAttempts = null,Object? currentQuizIndex = null,}) {
  return _then(_self.copyWith(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,remainingAttempts: null == remainingAttempts ? _self.remainingAttempts : remainingAttempts // ignore: cast_nullable_to_non_nullable
as int,currentQuizIndex: null == currentQuizIndex ? _self.currentQuizIndex : currentQuizIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizAnswerData].
extension QuizAnswerDataPatterns on QuizAnswerData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizAnswerData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizAnswerData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizAnswerData value)  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizAnswerData value)?  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int quizId,  bool correct,  int remainingAttempts,  int currentQuizIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizAnswerData() when $default != null:
return $default(_that.quizId,_that.correct,_that.remainingAttempts,_that.currentQuizIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int quizId,  bool correct,  int remainingAttempts,  int currentQuizIndex)  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerData():
return $default(_that.quizId,_that.correct,_that.remainingAttempts,_that.currentQuizIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int quizId,  bool correct,  int remainingAttempts,  int currentQuizIndex)?  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerData() when $default != null:
return $default(_that.quizId,_that.correct,_that.remainingAttempts,_that.currentQuizIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizAnswerData implements QuizAnswerData {
  const _QuizAnswerData({required this.quizId, required this.correct, required this.remainingAttempts, required this.currentQuizIndex});
  factory _QuizAnswerData.fromJson(Map<String, dynamic> json) => _$QuizAnswerDataFromJson(json);

@override final  int quizId;
@override final  bool correct;
@override final  int remainingAttempts;
@override final  int currentQuizIndex;

/// Create a copy of QuizAnswerData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizAnswerDataCopyWith<_QuizAnswerData> get copyWith => __$QuizAnswerDataCopyWithImpl<_QuizAnswerData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizAnswerDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizAnswerData&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.remainingAttempts, remainingAttempts) || other.remainingAttempts == remainingAttempts)&&(identical(other.currentQuizIndex, currentQuizIndex) || other.currentQuizIndex == currentQuizIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,correct,remainingAttempts,currentQuizIndex);

@override
String toString() {
  return 'QuizAnswerData(quizId: $quizId, correct: $correct, remainingAttempts: $remainingAttempts, currentQuizIndex: $currentQuizIndex)';
}


}

/// @nodoc
abstract mixin class _$QuizAnswerDataCopyWith<$Res> implements $QuizAnswerDataCopyWith<$Res> {
  factory _$QuizAnswerDataCopyWith(_QuizAnswerData value, $Res Function(_QuizAnswerData) _then) = __$QuizAnswerDataCopyWithImpl;
@override @useResult
$Res call({
 int quizId, bool correct, int remainingAttempts, int currentQuizIndex
});




}
/// @nodoc
class __$QuizAnswerDataCopyWithImpl<$Res>
    implements _$QuizAnswerDataCopyWith<$Res> {
  __$QuizAnswerDataCopyWithImpl(this._self, this._then);

  final _QuizAnswerData _self;
  final $Res Function(_QuizAnswerData) _then;

/// Create a copy of QuizAnswerData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quizId = null,Object? correct = null,Object? remainingAttempts = null,Object? currentQuizIndex = null,}) {
  return _then(_QuizAnswerData(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,remainingAttempts: null == remainingAttempts ? _self.remainingAttempts : remainingAttempts // ignore: cast_nullable_to_non_nullable
as int,currentQuizIndex: null == currentQuizIndex ? _self.currentQuizIndex : currentQuizIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
