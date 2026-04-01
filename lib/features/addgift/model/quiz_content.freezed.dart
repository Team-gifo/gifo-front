// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuizContent {

@JsonKey(name: 'success_reward') QuizSuccessReward get successReward;@JsonKey(name: 'fail_reward') QuizFailReward get failReward; List<QuizItemModel> get list;
/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizContentCopyWith<QuizContent> get copyWith => _$QuizContentCopyWithImpl<QuizContent>(this as QuizContent, _$identity);

  /// Serializes this QuizContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizContent&&(identical(other.successReward, successReward) || other.successReward == successReward)&&(identical(other.failReward, failReward) || other.failReward == failReward)&&const DeepCollectionEquality().equals(other.list, list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,successReward,failReward,const DeepCollectionEquality().hash(list));

@override
String toString() {
  return 'QuizContent(successReward: $successReward, failReward: $failReward, list: $list)';
}


}

/// @nodoc
abstract mixin class $QuizContentCopyWith<$Res>  {
  factory $QuizContentCopyWith(QuizContent value, $Res Function(QuizContent) _then) = _$QuizContentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success_reward') QuizSuccessReward successReward,@JsonKey(name: 'fail_reward') QuizFailReward failReward, List<QuizItemModel> list
});


$QuizSuccessRewardCopyWith<$Res> get successReward;$QuizFailRewardCopyWith<$Res> get failReward;

}
/// @nodoc
class _$QuizContentCopyWithImpl<$Res>
    implements $QuizContentCopyWith<$Res> {
  _$QuizContentCopyWithImpl(this._self, this._then);

  final QuizContent _self;
  final $Res Function(QuizContent) _then;

/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? successReward = null,Object? failReward = null,Object? list = null,}) {
  return _then(_self.copyWith(
successReward: null == successReward ? _self.successReward : successReward // ignore: cast_nullable_to_non_nullable
as QuizSuccessReward,failReward: null == failReward ? _self.failReward : failReward // ignore: cast_nullable_to_non_nullable
as QuizFailReward,list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<QuizItemModel>,
  ));
}
/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizSuccessRewardCopyWith<$Res> get successReward {
  
  return $QuizSuccessRewardCopyWith<$Res>(_self.successReward, (value) {
    return _then(_self.copyWith(successReward: value));
  });
}/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizFailRewardCopyWith<$Res> get failReward {
  
  return $QuizFailRewardCopyWith<$Res>(_self.failReward, (value) {
    return _then(_self.copyWith(failReward: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizContent].
extension QuizContentPatterns on QuizContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizContent value)  $default,){
final _that = this;
switch (_that) {
case _QuizContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizContent value)?  $default,){
final _that = this;
switch (_that) {
case _QuizContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success_reward')  QuizSuccessReward successReward, @JsonKey(name: 'fail_reward')  QuizFailReward failReward,  List<QuizItemModel> list)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizContent() when $default != null:
return $default(_that.successReward,_that.failReward,_that.list);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success_reward')  QuizSuccessReward successReward, @JsonKey(name: 'fail_reward')  QuizFailReward failReward,  List<QuizItemModel> list)  $default,) {final _that = this;
switch (_that) {
case _QuizContent():
return $default(_that.successReward,_that.failReward,_that.list);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success_reward')  QuizSuccessReward successReward, @JsonKey(name: 'fail_reward')  QuizFailReward failReward,  List<QuizItemModel> list)?  $default,) {final _that = this;
switch (_that) {
case _QuizContent() when $default != null:
return $default(_that.successReward,_that.failReward,_that.list);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _QuizContent implements QuizContent {
  const _QuizContent({@JsonKey(name: 'success_reward') required this.successReward, @JsonKey(name: 'fail_reward') required this.failReward, final  List<QuizItemModel> list = const <QuizItemModel>[]}): _list = list;
  factory _QuizContent.fromJson(Map<String, dynamic> json) => _$QuizContentFromJson(json);

@override@JsonKey(name: 'success_reward') final  QuizSuccessReward successReward;
@override@JsonKey(name: 'fail_reward') final  QuizFailReward failReward;
 final  List<QuizItemModel> _list;
@override@JsonKey() List<QuizItemModel> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}


/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizContentCopyWith<_QuizContent> get copyWith => __$QuizContentCopyWithImpl<_QuizContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizContent&&(identical(other.successReward, successReward) || other.successReward == successReward)&&(identical(other.failReward, failReward) || other.failReward == failReward)&&const DeepCollectionEquality().equals(other._list, _list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,successReward,failReward,const DeepCollectionEquality().hash(_list));

@override
String toString() {
  return 'QuizContent(successReward: $successReward, failReward: $failReward, list: $list)';
}


}

/// @nodoc
abstract mixin class _$QuizContentCopyWith<$Res> implements $QuizContentCopyWith<$Res> {
  factory _$QuizContentCopyWith(_QuizContent value, $Res Function(_QuizContent) _then) = __$QuizContentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success_reward') QuizSuccessReward successReward,@JsonKey(name: 'fail_reward') QuizFailReward failReward, List<QuizItemModel> list
});


@override $QuizSuccessRewardCopyWith<$Res> get successReward;@override $QuizFailRewardCopyWith<$Res> get failReward;

}
/// @nodoc
class __$QuizContentCopyWithImpl<$Res>
    implements _$QuizContentCopyWith<$Res> {
  __$QuizContentCopyWithImpl(this._self, this._then);

  final _QuizContent _self;
  final $Res Function(_QuizContent) _then;

/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? successReward = null,Object? failReward = null,Object? list = null,}) {
  return _then(_QuizContent(
successReward: null == successReward ? _self.successReward : successReward // ignore: cast_nullable_to_non_nullable
as QuizSuccessReward,failReward: null == failReward ? _self.failReward : failReward // ignore: cast_nullable_to_non_nullable
as QuizFailReward,list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<QuizItemModel>,
  ));
}

/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizSuccessRewardCopyWith<$Res> get successReward {
  
  return $QuizSuccessRewardCopyWith<$Res>(_self.successReward, (value) {
    return _then(_self.copyWith(successReward: value));
  });
}/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuizFailRewardCopyWith<$Res> get failReward {
  
  return $QuizFailRewardCopyWith<$Res>(_self.failReward, (value) {
    return _then(_self.copyWith(failReward: value));
  });
}
}


/// @nodoc
mixin _$QuizSuccessReward {

@JsonKey(name: 'required_count') int get requiredCount;@JsonKey(name: 'item_name') String get itemName;@JsonKey(name: 'image_url') String get imageUrl;
/// Create a copy of QuizSuccessReward
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizSuccessRewardCopyWith<QuizSuccessReward> get copyWith => _$QuizSuccessRewardCopyWithImpl<QuizSuccessReward>(this as QuizSuccessReward, _$identity);

  /// Serializes this QuizSuccessReward to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizSuccessReward&&(identical(other.requiredCount, requiredCount) || other.requiredCount == requiredCount)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requiredCount,itemName,imageUrl);

@override
String toString() {
  return 'QuizSuccessReward(requiredCount: $requiredCount, itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $QuizSuccessRewardCopyWith<$Res>  {
  factory $QuizSuccessRewardCopyWith(QuizSuccessReward value, $Res Function(QuizSuccessReward) _then) = _$QuizSuccessRewardCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'required_count') int requiredCount,@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class _$QuizSuccessRewardCopyWithImpl<$Res>
    implements $QuizSuccessRewardCopyWith<$Res> {
  _$QuizSuccessRewardCopyWithImpl(this._self, this._then);

  final QuizSuccessReward _self;
  final $Res Function(QuizSuccessReward) _then;

/// Create a copy of QuizSuccessReward
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requiredCount = null,Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
requiredCount: null == requiredCount ? _self.requiredCount : requiredCount // ignore: cast_nullable_to_non_nullable
as int,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizSuccessReward].
extension QuizSuccessRewardPatterns on QuizSuccessReward {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizSuccessReward value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizSuccessReward() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizSuccessReward value)  $default,){
final _that = this;
switch (_that) {
case _QuizSuccessReward():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizSuccessReward value)?  $default,){
final _that = this;
switch (_that) {
case _QuizSuccessReward() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'required_count')  int requiredCount, @JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'image_url')  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizSuccessReward() when $default != null:
return $default(_that.requiredCount,_that.itemName,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'required_count')  int requiredCount, @JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'image_url')  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _QuizSuccessReward():
return $default(_that.requiredCount,_that.itemName,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'required_count')  int requiredCount, @JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'image_url')  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _QuizSuccessReward() when $default != null:
return $default(_that.requiredCount,_that.itemName,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizSuccessReward implements QuizSuccessReward {
  const _QuizSuccessReward({@JsonKey(name: 'required_count') this.requiredCount = 1, @JsonKey(name: 'item_name') this.itemName = '', @JsonKey(name: 'image_url') this.imageUrl = ''});
  factory _QuizSuccessReward.fromJson(Map<String, dynamic> json) => _$QuizSuccessRewardFromJson(json);

@override@JsonKey(name: 'required_count') final  int requiredCount;
@override@JsonKey(name: 'item_name') final  String itemName;
@override@JsonKey(name: 'image_url') final  String imageUrl;

/// Create a copy of QuizSuccessReward
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizSuccessRewardCopyWith<_QuizSuccessReward> get copyWith => __$QuizSuccessRewardCopyWithImpl<_QuizSuccessReward>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizSuccessRewardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizSuccessReward&&(identical(other.requiredCount, requiredCount) || other.requiredCount == requiredCount)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requiredCount,itemName,imageUrl);

@override
String toString() {
  return 'QuizSuccessReward(requiredCount: $requiredCount, itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$QuizSuccessRewardCopyWith<$Res> implements $QuizSuccessRewardCopyWith<$Res> {
  factory _$QuizSuccessRewardCopyWith(_QuizSuccessReward value, $Res Function(_QuizSuccessReward) _then) = __$QuizSuccessRewardCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'required_count') int requiredCount,@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class __$QuizSuccessRewardCopyWithImpl<$Res>
    implements _$QuizSuccessRewardCopyWith<$Res> {
  __$QuizSuccessRewardCopyWithImpl(this._self, this._then);

  final _QuizSuccessReward _self;
  final $Res Function(_QuizSuccessReward) _then;

/// Create a copy of QuizSuccessReward
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requiredCount = null,Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_QuizSuccessReward(
requiredCount: null == requiredCount ? _self.requiredCount : requiredCount // ignore: cast_nullable_to_non_nullable
as int,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$QuizFailReward {

@JsonKey(name: 'item_name') String get itemName;@JsonKey(name: 'image_url') String get imageUrl;
/// Create a copy of QuizFailReward
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizFailRewardCopyWith<QuizFailReward> get copyWith => _$QuizFailRewardCopyWithImpl<QuizFailReward>(this as QuizFailReward, _$identity);

  /// Serializes this QuizFailReward to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizFailReward&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl);

@override
String toString() {
  return 'QuizFailReward(itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $QuizFailRewardCopyWith<$Res>  {
  factory $QuizFailRewardCopyWith(QuizFailReward value, $Res Function(QuizFailReward) _then) = _$QuizFailRewardCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class _$QuizFailRewardCopyWithImpl<$Res>
    implements $QuizFailRewardCopyWith<$Res> {
  _$QuizFailRewardCopyWithImpl(this._self, this._then);

  final QuizFailReward _self;
  final $Res Function(QuizFailReward) _then;

/// Create a copy of QuizFailReward
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizFailReward].
extension QuizFailRewardPatterns on QuizFailReward {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizFailReward value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizFailReward() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizFailReward value)  $default,){
final _that = this;
switch (_that) {
case _QuizFailReward():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizFailReward value)?  $default,){
final _that = this;
switch (_that) {
case _QuizFailReward() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'image_url')  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizFailReward() when $default != null:
return $default(_that.itemName,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'image_url')  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _QuizFailReward():
return $default(_that.itemName,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'image_url')  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _QuizFailReward() when $default != null:
return $default(_that.itemName,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizFailReward implements QuizFailReward {
  const _QuizFailReward({@JsonKey(name: 'item_name') this.itemName = '', @JsonKey(name: 'image_url') this.imageUrl = ''});
  factory _QuizFailReward.fromJson(Map<String, dynamic> json) => _$QuizFailRewardFromJson(json);

@override@JsonKey(name: 'item_name') final  String itemName;
@override@JsonKey(name: 'image_url') final  String imageUrl;

/// Create a copy of QuizFailReward
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizFailRewardCopyWith<_QuizFailReward> get copyWith => __$QuizFailRewardCopyWithImpl<_QuizFailReward>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizFailRewardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizFailReward&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl);

@override
String toString() {
  return 'QuizFailReward(itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$QuizFailRewardCopyWith<$Res> implements $QuizFailRewardCopyWith<$Res> {
  factory _$QuizFailRewardCopyWith(_QuizFailReward value, $Res Function(_QuizFailReward) _then) = __$QuizFailRewardCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class __$QuizFailRewardCopyWithImpl<$Res>
    implements _$QuizFailRewardCopyWith<$Res> {
  __$QuizFailRewardCopyWithImpl(this._self, this._then);

  final _QuizFailReward _self;
  final $Res Function(_QuizFailReward) _then;

/// Create a copy of QuizFailReward
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_QuizFailReward(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$QuizItemModel {

@JsonKey(name: 'quiz_id') int get quizId; String get type; String get title;@JsonKey(name: 'image_url') String? get imageUrl; String? get description; String? get hint; List<String> get options; List<String> get answer;@JsonKey(name: 'play_limit') int get playLimit;
/// Create a copy of QuizItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizItemModelCopyWith<QuizItemModel> get copyWith => _$QuizItemModelCopyWithImpl<QuizItemModel>(this as QuizItemModel, _$identity);

  /// Serializes this QuizItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizItemModel&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.hint, hint) || other.hint == hint)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.answer, answer)&&(identical(other.playLimit, playLimit) || other.playLimit == playLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,type,title,imageUrl,description,hint,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(answer),playLimit);

@override
String toString() {
  return 'QuizItemModel(quizId: $quizId, type: $type, title: $title, imageUrl: $imageUrl, description: $description, hint: $hint, options: $options, answer: $answer, playLimit: $playLimit)';
}


}

/// @nodoc
abstract mixin class $QuizItemModelCopyWith<$Res>  {
  factory $QuizItemModelCopyWith(QuizItemModel value, $Res Function(QuizItemModel) _then) = _$QuizItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'quiz_id') int quizId, String type, String title,@JsonKey(name: 'image_url') String? imageUrl, String? description, String? hint, List<String> options, List<String> answer,@JsonKey(name: 'play_limit') int playLimit
});




}
/// @nodoc
class _$QuizItemModelCopyWithImpl<$Res>
    implements $QuizItemModelCopyWith<$Res> {
  _$QuizItemModelCopyWithImpl(this._self, this._then);

  final QuizItemModel _self;
  final $Res Function(QuizItemModel) _then;

/// Create a copy of QuizItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quizId = null,Object? type = null,Object? title = null,Object? imageUrl = freezed,Object? description = freezed,Object? hint = freezed,Object? options = null,Object? answer = null,Object? playLimit = null,}) {
  return _then(_self.copyWith(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as List<String>,playLimit: null == playLimit ? _self.playLimit : playLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizItemModel].
extension QuizItemModelPatterns on QuizItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizItemModel value)  $default,){
final _that = this;
switch (_that) {
case _QuizItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _QuizItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'quiz_id')  int quizId,  String type,  String title, @JsonKey(name: 'image_url')  String? imageUrl,  String? description,  String? hint,  List<String> options,  List<String> answer, @JsonKey(name: 'play_limit')  int playLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizItemModel() when $default != null:
return $default(_that.quizId,_that.type,_that.title,_that.imageUrl,_that.description,_that.hint,_that.options,_that.answer,_that.playLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'quiz_id')  int quizId,  String type,  String title, @JsonKey(name: 'image_url')  String? imageUrl,  String? description,  String? hint,  List<String> options,  List<String> answer, @JsonKey(name: 'play_limit')  int playLimit)  $default,) {final _that = this;
switch (_that) {
case _QuizItemModel():
return $default(_that.quizId,_that.type,_that.title,_that.imageUrl,_that.description,_that.hint,_that.options,_that.answer,_that.playLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'quiz_id')  int quizId,  String type,  String title, @JsonKey(name: 'image_url')  String? imageUrl,  String? description,  String? hint,  List<String> options,  List<String> answer, @JsonKey(name: 'play_limit')  int playLimit)?  $default,) {final _that = this;
switch (_that) {
case _QuizItemModel() when $default != null:
return $default(_that.quizId,_that.type,_that.title,_that.imageUrl,_that.description,_that.hint,_that.options,_that.answer,_that.playLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizItemModel implements QuizItemModel {
  const _QuizItemModel({@JsonKey(name: 'quiz_id') this.quizId = 0, this.type = 'multiple_choice', this.title = '', @JsonKey(name: 'image_url') this.imageUrl, this.description, this.hint, final  List<String> options = const <String>[], final  List<String> answer = const <String>[], @JsonKey(name: 'play_limit') this.playLimit = 1}): _options = options,_answer = answer;
  factory _QuizItemModel.fromJson(Map<String, dynamic> json) => _$QuizItemModelFromJson(json);

@override@JsonKey(name: 'quiz_id') final  int quizId;
@override@JsonKey() final  String type;
@override@JsonKey() final  String title;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override final  String? description;
@override final  String? hint;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  List<String> _answer;
@override@JsonKey() List<String> get answer {
  if (_answer is EqualUnmodifiableListView) return _answer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answer);
}

@override@JsonKey(name: 'play_limit') final  int playLimit;

/// Create a copy of QuizItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizItemModelCopyWith<_QuizItemModel> get copyWith => __$QuizItemModelCopyWithImpl<_QuizItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizItemModel&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.hint, hint) || other.hint == hint)&&const DeepCollectionEquality().equals(other._options, _options)&&const DeepCollectionEquality().equals(other._answer, _answer)&&(identical(other.playLimit, playLimit) || other.playLimit == playLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,type,title,imageUrl,description,hint,const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_answer),playLimit);

@override
String toString() {
  return 'QuizItemModel(quizId: $quizId, type: $type, title: $title, imageUrl: $imageUrl, description: $description, hint: $hint, options: $options, answer: $answer, playLimit: $playLimit)';
}


}

/// @nodoc
abstract mixin class _$QuizItemModelCopyWith<$Res> implements $QuizItemModelCopyWith<$Res> {
  factory _$QuizItemModelCopyWith(_QuizItemModel value, $Res Function(_QuizItemModel) _then) = __$QuizItemModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'quiz_id') int quizId, String type, String title,@JsonKey(name: 'image_url') String? imageUrl, String? description, String? hint, List<String> options, List<String> answer,@JsonKey(name: 'play_limit') int playLimit
});




}
/// @nodoc
class __$QuizItemModelCopyWithImpl<$Res>
    implements _$QuizItemModelCopyWith<$Res> {
  __$QuizItemModelCopyWithImpl(this._self, this._then);

  final _QuizItemModel _self;
  final $Res Function(_QuizItemModel) _then;

/// Create a copy of QuizItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quizId = null,Object? type = null,Object? title = null,Object? imageUrl = freezed,Object? description = freezed,Object? hint = freezed,Object? options = null,Object? answer = null,Object? playLimit = null,}) {
  return _then(_QuizItemModel(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,answer: null == answer ? _self._answer : answer // ignore: cast_nullable_to_non_nullable
as List<String>,playLimit: null == playLimit ? _self.playLimit : playLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
