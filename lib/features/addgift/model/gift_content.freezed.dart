// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GiftContent {

 GachaContent? get gacha; QuizContent? get quiz; UnboxingContent? get unboxing;
/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GiftContentCopyWith<GiftContent> get copyWith => _$GiftContentCopyWithImpl<GiftContent>(this as GiftContent, _$identity);

  /// Serializes this GiftContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GiftContent&&(identical(other.gacha, gacha) || other.gacha == gacha)&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.unboxing, unboxing) || other.unboxing == unboxing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gacha,quiz,unboxing);

@override
String toString() {
  return 'GiftContent(gacha: $gacha, quiz: $quiz, unboxing: $unboxing)';
}


}

/// @nodoc
abstract mixin class $GiftContentCopyWith<$Res>  {
  factory $GiftContentCopyWith(GiftContent value, $Res Function(GiftContent) _then) = _$GiftContentCopyWithImpl;
@useResult
$Res call({
 GachaContent? gacha, QuizContent? quiz, UnboxingContent? unboxing
});


$GachaContentCopyWith<$Res>? get gacha;$QuizContentCopyWith<$Res>? get quiz;$UnboxingContentCopyWith<$Res>? get unboxing;

}
/// @nodoc
class _$GiftContentCopyWithImpl<$Res>
    implements $GiftContentCopyWith<$Res> {
  _$GiftContentCopyWithImpl(this._self, this._then);

  final GiftContent _self;
  final $Res Function(GiftContent) _then;

/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gacha = freezed,Object? quiz = freezed,Object? unboxing = freezed,}) {
  return _then(_self.copyWith(
gacha: freezed == gacha ? _self.gacha : gacha // ignore: cast_nullable_to_non_nullable
as GachaContent?,quiz: freezed == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as QuizContent?,unboxing: freezed == unboxing ? _self.unboxing : unboxing // ignore: cast_nullable_to_non_nullable
as UnboxingContent?,
  ));
}
/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GachaContentCopyWith<$Res>? get gacha {
    if (_self.gacha == null) {
    return null;
  }

  return $GachaContentCopyWith<$Res>(_self.gacha!, (value) {
    return _then(_self.copyWith(gacha: value));
  });
}/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizContentCopyWith<$Res>? get quiz {
    if (_self.quiz == null) {
    return null;
  }

  return $QuizContentCopyWith<$Res>(_self.quiz!, (value) {
    return _then(_self.copyWith(quiz: value));
  });
}/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnboxingContentCopyWith<$Res>? get unboxing {
    if (_self.unboxing == null) {
    return null;
  }

  return $UnboxingContentCopyWith<$Res>(_self.unboxing!, (value) {
    return _then(_self.copyWith(unboxing: value));
  });
}
}


/// Adds pattern-matching-related methods to [GiftContent].
extension GiftContentPatterns on GiftContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GiftContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GiftContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GiftContent value)  $default,){
final _that = this;
switch (_that) {
case _GiftContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GiftContent value)?  $default,){
final _that = this;
switch (_that) {
case _GiftContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GachaContent? gacha,  QuizContent? quiz,  UnboxingContent? unboxing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GiftContent() when $default != null:
return $default(_that.gacha,_that.quiz,_that.unboxing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GachaContent? gacha,  QuizContent? quiz,  UnboxingContent? unboxing)  $default,) {final _that = this;
switch (_that) {
case _GiftContent():
return $default(_that.gacha,_that.quiz,_that.unboxing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GachaContent? gacha,  QuizContent? quiz,  UnboxingContent? unboxing)?  $default,) {final _that = this;
switch (_that) {
case _GiftContent() when $default != null:
return $default(_that.gacha,_that.quiz,_that.unboxing);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GiftContent implements GiftContent {
  const _GiftContent({this.gacha, this.quiz, this.unboxing});
  factory _GiftContent.fromJson(Map<String, dynamic> json) => _$GiftContentFromJson(json);

@override final  GachaContent? gacha;
@override final  QuizContent? quiz;
@override final  UnboxingContent? unboxing;

/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GiftContentCopyWith<_GiftContent> get copyWith => __$GiftContentCopyWithImpl<_GiftContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GiftContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GiftContent&&(identical(other.gacha, gacha) || other.gacha == gacha)&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.unboxing, unboxing) || other.unboxing == unboxing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gacha,quiz,unboxing);

@override
String toString() {
  return 'GiftContent(gacha: $gacha, quiz: $quiz, unboxing: $unboxing)';
}


}

/// @nodoc
abstract mixin class _$GiftContentCopyWith<$Res> implements $GiftContentCopyWith<$Res> {
  factory _$GiftContentCopyWith(_GiftContent value, $Res Function(_GiftContent) _then) = __$GiftContentCopyWithImpl;
@override @useResult
$Res call({
 GachaContent? gacha, QuizContent? quiz, UnboxingContent? unboxing
});


@override $GachaContentCopyWith<$Res>? get gacha;@override $QuizContentCopyWith<$Res>? get quiz;@override $UnboxingContentCopyWith<$Res>? get unboxing;

}
/// @nodoc
class __$GiftContentCopyWithImpl<$Res>
    implements _$GiftContentCopyWith<$Res> {
  __$GiftContentCopyWithImpl(this._self, this._then);

  final _GiftContent _self;
  final $Res Function(_GiftContent) _then;

/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gacha = freezed,Object? quiz = freezed,Object? unboxing = freezed,}) {
  return _then(_GiftContent(
gacha: freezed == gacha ? _self.gacha : gacha // ignore: cast_nullable_to_non_nullable
as GachaContent?,quiz: freezed == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as QuizContent?,unboxing: freezed == unboxing ? _self.unboxing : unboxing // ignore: cast_nullable_to_non_nullable
as UnboxingContent?,
  ));
}

/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GachaContentCopyWith<$Res>? get gacha {
    if (_self.gacha == null) {
    return null;
  }

  return $GachaContentCopyWith<$Res>(_self.gacha!, (value) {
    return _then(_self.copyWith(gacha: value));
  });
}/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizContentCopyWith<$Res>? get quiz {
    if (_self.quiz == null) {
    return null;
  }

  return $QuizContentCopyWith<$Res>(_self.quiz!, (value) {
    return _then(_self.copyWith(quiz: value));
  });
}/// Create a copy of GiftContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnboxingContentCopyWith<$Res>? get unboxing {
    if (_self.unboxing == null) {
    return null;
  }

  return $UnboxingContentCopyWith<$Res>(_self.unboxing!, (value) {
    return _then(_self.copyWith(unboxing: value));
  });
}
}

// dart format on
