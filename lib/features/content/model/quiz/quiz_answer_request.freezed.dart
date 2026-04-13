// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_answer_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizAnswerRequest {

 int get quizId; String get selectedAnswer;
/// Create a copy of QuizAnswerRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizAnswerRequestCopyWith<QuizAnswerRequest> get copyWith => _$QuizAnswerRequestCopyWithImpl<QuizAnswerRequest>(this as QuizAnswerRequest, _$identity);

  /// Serializes this QuizAnswerRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizAnswerRequest&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.selectedAnswer, selectedAnswer) || other.selectedAnswer == selectedAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,selectedAnswer);

@override
String toString() {
  return 'QuizAnswerRequest(quizId: $quizId, selectedAnswer: $selectedAnswer)';
}


}

/// @nodoc
abstract mixin class $QuizAnswerRequestCopyWith<$Res>  {
  factory $QuizAnswerRequestCopyWith(QuizAnswerRequest value, $Res Function(QuizAnswerRequest) _then) = _$QuizAnswerRequestCopyWithImpl;
@useResult
$Res call({
 int quizId, String selectedAnswer
});




}
/// @nodoc
class _$QuizAnswerRequestCopyWithImpl<$Res>
    implements $QuizAnswerRequestCopyWith<$Res> {
  _$QuizAnswerRequestCopyWithImpl(this._self, this._then);

  final QuizAnswerRequest _self;
  final $Res Function(QuizAnswerRequest) _then;

/// Create a copy of QuizAnswerRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quizId = null,Object? selectedAnswer = null,}) {
  return _then(_self.copyWith(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,selectedAnswer: null == selectedAnswer ? _self.selectedAnswer : selectedAnswer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizAnswerRequest].
extension QuizAnswerRequestPatterns on QuizAnswerRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizAnswerRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizAnswerRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizAnswerRequest value)  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizAnswerRequest value)?  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int quizId,  String selectedAnswer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizAnswerRequest() when $default != null:
return $default(_that.quizId,_that.selectedAnswer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int quizId,  String selectedAnswer)  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerRequest():
return $default(_that.quizId,_that.selectedAnswer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int quizId,  String selectedAnswer)?  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerRequest() when $default != null:
return $default(_that.quizId,_that.selectedAnswer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizAnswerRequest implements QuizAnswerRequest {
  const _QuizAnswerRequest({required this.quizId, required this.selectedAnswer});
  factory _QuizAnswerRequest.fromJson(Map<String, dynamic> json) => _$QuizAnswerRequestFromJson(json);

@override final  int quizId;
@override final  String selectedAnswer;

/// Create a copy of QuizAnswerRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizAnswerRequestCopyWith<_QuizAnswerRequest> get copyWith => __$QuizAnswerRequestCopyWithImpl<_QuizAnswerRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizAnswerRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizAnswerRequest&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.selectedAnswer, selectedAnswer) || other.selectedAnswer == selectedAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,selectedAnswer);

@override
String toString() {
  return 'QuizAnswerRequest(quizId: $quizId, selectedAnswer: $selectedAnswer)';
}


}

/// @nodoc
abstract mixin class _$QuizAnswerRequestCopyWith<$Res> implements $QuizAnswerRequestCopyWith<$Res> {
  factory _$QuizAnswerRequestCopyWith(_QuizAnswerRequest value, $Res Function(_QuizAnswerRequest) _then) = __$QuizAnswerRequestCopyWithImpl;
@override @useResult
$Res call({
 int quizId, String selectedAnswer
});




}
/// @nodoc
class __$QuizAnswerRequestCopyWithImpl<$Res>
    implements _$QuizAnswerRequestCopyWith<$Res> {
  __$QuizAnswerRequestCopyWithImpl(this._self, this._then);

  final _QuizAnswerRequest _self;
  final $Res Function(_QuizAnswerRequest) _then;

/// Create a copy of QuizAnswerRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quizId = null,Object? selectedAnswer = null,}) {
  return _then(_QuizAnswerRequest(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,selectedAnswer: null == selectedAnswer ? _self.selectedAnswer : selectedAnswer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
