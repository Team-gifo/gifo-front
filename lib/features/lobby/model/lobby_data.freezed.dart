// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LobbyData {

 String get user; String get subTitle; String get bgm; List<GalleryItem> get gallery; LobbyContent? get content;
/// Create a copy of LobbyData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LobbyDataCopyWith<LobbyData> get copyWith => _$LobbyDataCopyWithImpl<LobbyData>(this as LobbyData, _$identity);

  /// Serializes this LobbyData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LobbyData&&(identical(other.user, user) || other.user == user)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.bgm, bgm) || other.bgm == bgm)&&const DeepCollectionEquality().equals(other.gallery, gallery)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,subTitle,bgm,const DeepCollectionEquality().hash(gallery),content);

@override
String toString() {
  return 'LobbyData(user: $user, subTitle: $subTitle, bgm: $bgm, gallery: $gallery, content: $content)';
}


}

/// @nodoc
abstract mixin class $LobbyDataCopyWith<$Res>  {
  factory $LobbyDataCopyWith(LobbyData value, $Res Function(LobbyData) _then) = _$LobbyDataCopyWithImpl;
@useResult
$Res call({
 String user, String subTitle, String bgm, List<GalleryItem> gallery, LobbyContent? content
});


$LobbyContentCopyWith<$Res>? get content;

}
/// @nodoc
class _$LobbyDataCopyWithImpl<$Res>
    implements $LobbyDataCopyWith<$Res> {
  _$LobbyDataCopyWithImpl(this._self, this._then);

  final LobbyData _self;
  final $Res Function(LobbyData) _then;

/// Create a copy of LobbyData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? subTitle = null,Object? bgm = null,Object? gallery = null,Object? content = freezed,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,subTitle: null == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String,bgm: null == bgm ? _self.bgm : bgm // ignore: cast_nullable_to_non_nullable
as String,gallery: null == gallery ? _self.gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<GalleryItem>,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as LobbyContent?,
  ));
}
/// Create a copy of LobbyData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LobbyContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $LobbyContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [LobbyData].
extension LobbyDataPatterns on LobbyData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LobbyData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LobbyData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LobbyData value)  $default,){
final _that = this;
switch (_that) {
case _LobbyData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LobbyData value)?  $default,){
final _that = this;
switch (_that) {
case _LobbyData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String user,  String subTitle,  String bgm,  List<GalleryItem> gallery,  LobbyContent? content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LobbyData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String user,  String subTitle,  String bgm,  List<GalleryItem> gallery,  LobbyContent? content)  $default,) {final _that = this;
switch (_that) {
case _LobbyData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String user,  String subTitle,  String bgm,  List<GalleryItem> gallery,  LobbyContent? content)?  $default,) {final _that = this;
switch (_that) {
case _LobbyData() when $default != null:
return $default(_that.user,_that.subTitle,_that.bgm,_that.gallery,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LobbyData implements LobbyData {
  const _LobbyData({required this.user, required this.subTitle, required this.bgm, final  List<GalleryItem> gallery = const <GalleryItem>[], this.content}): _gallery = gallery;
  factory _LobbyData.fromJson(Map<String, dynamic> json) => _$LobbyDataFromJson(json);

@override final  String user;
@override final  String subTitle;
@override final  String bgm;
 final  List<GalleryItem> _gallery;
@override@JsonKey() List<GalleryItem> get gallery {
  if (_gallery is EqualUnmodifiableListView) return _gallery;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gallery);
}

@override final  LobbyContent? content;

/// Create a copy of LobbyData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LobbyDataCopyWith<_LobbyData> get copyWith => __$LobbyDataCopyWithImpl<_LobbyData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LobbyDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LobbyData&&(identical(other.user, user) || other.user == user)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.bgm, bgm) || other.bgm == bgm)&&const DeepCollectionEquality().equals(other._gallery, _gallery)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,subTitle,bgm,const DeepCollectionEquality().hash(_gallery),content);

@override
String toString() {
  return 'LobbyData(user: $user, subTitle: $subTitle, bgm: $bgm, gallery: $gallery, content: $content)';
}


}

/// @nodoc
abstract mixin class _$LobbyDataCopyWith<$Res> implements $LobbyDataCopyWith<$Res> {
  factory _$LobbyDataCopyWith(_LobbyData value, $Res Function(_LobbyData) _then) = __$LobbyDataCopyWithImpl;
@override @useResult
$Res call({
 String user, String subTitle, String bgm, List<GalleryItem> gallery, LobbyContent? content
});


@override $LobbyContentCopyWith<$Res>? get content;

}
/// @nodoc
class __$LobbyDataCopyWithImpl<$Res>
    implements _$LobbyDataCopyWith<$Res> {
  __$LobbyDataCopyWithImpl(this._self, this._then);

  final _LobbyData _self;
  final $Res Function(_LobbyData) _then;

/// Create a copy of LobbyData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? subTitle = null,Object? bgm = null,Object? gallery = null,Object? content = freezed,}) {
  return _then(_LobbyData(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,subTitle: null == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String,bgm: null == bgm ? _self.bgm : bgm // ignore: cast_nullable_to_non_nullable
as String,gallery: null == gallery ? _self._gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<GalleryItem>,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as LobbyContent?,
  ));
}

/// Create a copy of LobbyData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LobbyContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $LobbyContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// @nodoc
mixin _$GalleryItem {

 String get title; String get imageUrl; String get description;
/// Create a copy of GalleryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GalleryItemCopyWith<GalleryItem> get copyWith => _$GalleryItemCopyWithImpl<GalleryItem>(this as GalleryItem, _$identity);

  /// Serializes this GalleryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GalleryItem&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,imageUrl,description);

@override
String toString() {
  return 'GalleryItem(title: $title, imageUrl: $imageUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class $GalleryItemCopyWith<$Res>  {
  factory $GalleryItemCopyWith(GalleryItem value, $Res Function(GalleryItem) _then) = _$GalleryItemCopyWithImpl;
@useResult
$Res call({
 String title, String imageUrl, String description
});




}
/// @nodoc
class _$GalleryItemCopyWithImpl<$Res>
    implements $GalleryItemCopyWith<$Res> {
  _$GalleryItemCopyWithImpl(this._self, this._then);

  final GalleryItem _self;
  final $Res Function(GalleryItem) _then;

/// Create a copy of GalleryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? imageUrl = null,Object? description = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GalleryItem].
extension GalleryItemPatterns on GalleryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GalleryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GalleryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GalleryItem value)  $default,){
final _that = this;
switch (_that) {
case _GalleryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GalleryItem value)?  $default,){
final _that = this;
switch (_that) {
case _GalleryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String imageUrl,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GalleryItem() when $default != null:
return $default(_that.title,_that.imageUrl,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String imageUrl,  String description)  $default,) {final _that = this;
switch (_that) {
case _GalleryItem():
return $default(_that.title,_that.imageUrl,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String imageUrl,  String description)?  $default,) {final _that = this;
switch (_that) {
case _GalleryItem() when $default != null:
return $default(_that.title,_that.imageUrl,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GalleryItem implements GalleryItem {
  const _GalleryItem({required this.title, required this.imageUrl, required this.description});
  factory _GalleryItem.fromJson(Map<String, dynamic> json) => _$GalleryItemFromJson(json);

@override final  String title;
@override final  String imageUrl;
@override final  String description;

/// Create a copy of GalleryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GalleryItemCopyWith<_GalleryItem> get copyWith => __$GalleryItemCopyWithImpl<_GalleryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GalleryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GalleryItem&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,imageUrl,description);

@override
String toString() {
  return 'GalleryItem(title: $title, imageUrl: $imageUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class _$GalleryItemCopyWith<$Res> implements $GalleryItemCopyWith<$Res> {
  factory _$GalleryItemCopyWith(_GalleryItem value, $Res Function(_GalleryItem) _then) = __$GalleryItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String imageUrl, String description
});




}
/// @nodoc
class __$GalleryItemCopyWithImpl<$Res>
    implements _$GalleryItemCopyWith<$Res> {
  __$GalleryItemCopyWithImpl(this._self, this._then);

  final _GalleryItem _self;
  final $Res Function(_GalleryItem) _then;

/// Create a copy of GalleryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? imageUrl = null,Object? description = null,}) {
  return _then(_GalleryItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LobbyContent {

 GachaContent? get gacha; QuizContent? get quiz; UnboxingContent? get unboxing;
/// Create a copy of LobbyContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LobbyContentCopyWith<LobbyContent> get copyWith => _$LobbyContentCopyWithImpl<LobbyContent>(this as LobbyContent, _$identity);

  /// Serializes this LobbyContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LobbyContent&&(identical(other.gacha, gacha) || other.gacha == gacha)&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.unboxing, unboxing) || other.unboxing == unboxing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gacha,quiz,unboxing);

@override
String toString() {
  return 'LobbyContent(gacha: $gacha, quiz: $quiz, unboxing: $unboxing)';
}


}

/// @nodoc
abstract mixin class $LobbyContentCopyWith<$Res>  {
  factory $LobbyContentCopyWith(LobbyContent value, $Res Function(LobbyContent) _then) = _$LobbyContentCopyWithImpl;
@useResult
$Res call({
 GachaContent? gacha, QuizContent? quiz, UnboxingContent? unboxing
});


$GachaContentCopyWith<$Res>? get gacha;$QuizContentCopyWith<$Res>? get quiz;$UnboxingContentCopyWith<$Res>? get unboxing;

}
/// @nodoc
class _$LobbyContentCopyWithImpl<$Res>
    implements $LobbyContentCopyWith<$Res> {
  _$LobbyContentCopyWithImpl(this._self, this._then);

  final LobbyContent _self;
  final $Res Function(LobbyContent) _then;

/// Create a copy of LobbyContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gacha = freezed,Object? quiz = freezed,Object? unboxing = freezed,}) {
  return _then(_self.copyWith(
gacha: freezed == gacha ? _self.gacha : gacha // ignore: cast_nullable_to_non_nullable
as GachaContent?,quiz: freezed == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as QuizContent?,unboxing: freezed == unboxing ? _self.unboxing : unboxing // ignore: cast_nullable_to_non_nullable
as UnboxingContent?,
  ));
}
/// Create a copy of LobbyContent
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
}/// Create a copy of LobbyContent
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
}/// Create a copy of LobbyContent
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


/// Adds pattern-matching-related methods to [LobbyContent].
extension LobbyContentPatterns on LobbyContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LobbyContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LobbyContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LobbyContent value)  $default,){
final _that = this;
switch (_that) {
case _LobbyContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LobbyContent value)?  $default,){
final _that = this;
switch (_that) {
case _LobbyContent() when $default != null:
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
case _LobbyContent() when $default != null:
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
case _LobbyContent():
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
case _LobbyContent() when $default != null:
return $default(_that.gacha,_that.quiz,_that.unboxing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LobbyContent implements LobbyContent {
  const _LobbyContent({this.gacha, this.quiz, this.unboxing});
  factory _LobbyContent.fromJson(Map<String, dynamic> json) => _$LobbyContentFromJson(json);

@override final  GachaContent? gacha;
@override final  QuizContent? quiz;
@override final  UnboxingContent? unboxing;

/// Create a copy of LobbyContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LobbyContentCopyWith<_LobbyContent> get copyWith => __$LobbyContentCopyWithImpl<_LobbyContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LobbyContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LobbyContent&&(identical(other.gacha, gacha) || other.gacha == gacha)&&(identical(other.quiz, quiz) || other.quiz == quiz)&&(identical(other.unboxing, unboxing) || other.unboxing == unboxing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gacha,quiz,unboxing);

@override
String toString() {
  return 'LobbyContent(gacha: $gacha, quiz: $quiz, unboxing: $unboxing)';
}


}

/// @nodoc
abstract mixin class _$LobbyContentCopyWith<$Res> implements $LobbyContentCopyWith<$Res> {
  factory _$LobbyContentCopyWith(_LobbyContent value, $Res Function(_LobbyContent) _then) = __$LobbyContentCopyWithImpl;
@override @useResult
$Res call({
 GachaContent? gacha, QuizContent? quiz, UnboxingContent? unboxing
});


@override $GachaContentCopyWith<$Res>? get gacha;@override $QuizContentCopyWith<$Res>? get quiz;@override $UnboxingContentCopyWith<$Res>? get unboxing;

}
/// @nodoc
class __$LobbyContentCopyWithImpl<$Res>
    implements _$LobbyContentCopyWith<$Res> {
  __$LobbyContentCopyWithImpl(this._self, this._then);

  final _LobbyContent _self;
  final $Res Function(_LobbyContent) _then;

/// Create a copy of LobbyContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gacha = freezed,Object? quiz = freezed,Object? unboxing = freezed,}) {
  return _then(_LobbyContent(
gacha: freezed == gacha ? _self.gacha : gacha // ignore: cast_nullable_to_non_nullable
as GachaContent?,quiz: freezed == quiz ? _self.quiz : quiz // ignore: cast_nullable_to_non_nullable
as QuizContent?,unboxing: freezed == unboxing ? _self.unboxing : unboxing // ignore: cast_nullable_to_non_nullable
as UnboxingContent?,
  ));
}

/// Create a copy of LobbyContent
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
}/// Create a copy of LobbyContent
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
}/// Create a copy of LobbyContent
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


/// @nodoc
mixin _$GachaContent {

 int get playCount; int get remainingDrawCount; bool get selected; List<GachaItem> get list; List<GachaDrawHistory> get drawHistory;
/// Create a copy of GachaContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GachaContentCopyWith<GachaContent> get copyWith => _$GachaContentCopyWithImpl<GachaContent>(this as GachaContent, _$identity);

  /// Serializes this GachaContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GachaContent&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.remainingDrawCount, remainingDrawCount) || other.remainingDrawCount == remainingDrawCount)&&(identical(other.selected, selected) || other.selected == selected)&&const DeepCollectionEquality().equals(other.list, list)&&const DeepCollectionEquality().equals(other.drawHistory, drawHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playCount,remainingDrawCount,selected,const DeepCollectionEquality().hash(list),const DeepCollectionEquality().hash(drawHistory));

@override
String toString() {
  return 'GachaContent(playCount: $playCount, remainingDrawCount: $remainingDrawCount, selected: $selected, list: $list, drawHistory: $drawHistory)';
}


}

/// @nodoc
abstract mixin class $GachaContentCopyWith<$Res>  {
  factory $GachaContentCopyWith(GachaContent value, $Res Function(GachaContent) _then) = _$GachaContentCopyWithImpl;
@useResult
$Res call({
 int playCount, int remainingDrawCount, bool selected, List<GachaItem> list, List<GachaDrawHistory> drawHistory
});




}
/// @nodoc
class _$GachaContentCopyWithImpl<$Res>
    implements $GachaContentCopyWith<$Res> {
  _$GachaContentCopyWithImpl(this._self, this._then);

  final GachaContent _self;
  final $Res Function(GachaContent) _then;

/// Create a copy of GachaContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playCount = null,Object? remainingDrawCount = null,Object? selected = null,Object? list = null,Object? drawHistory = null,}) {
  return _then(_self.copyWith(
playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,remainingDrawCount: null == remainingDrawCount ? _self.remainingDrawCount : remainingDrawCount // ignore: cast_nullable_to_non_nullable
as int,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool,list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<GachaItem>,drawHistory: null == drawHistory ? _self.drawHistory : drawHistory // ignore: cast_nullable_to_non_nullable
as List<GachaDrawHistory>,
  ));
}

}


/// Adds pattern-matching-related methods to [GachaContent].
extension GachaContentPatterns on GachaContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GachaContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GachaContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GachaContent value)  $default,){
final _that = this;
switch (_that) {
case _GachaContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GachaContent value)?  $default,){
final _that = this;
switch (_that) {
case _GachaContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int playCount,  int remainingDrawCount,  bool selected,  List<GachaItem> list,  List<GachaDrawHistory> drawHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GachaContent() when $default != null:
return $default(_that.playCount,_that.remainingDrawCount,_that.selected,_that.list,_that.drawHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int playCount,  int remainingDrawCount,  bool selected,  List<GachaItem> list,  List<GachaDrawHistory> drawHistory)  $default,) {final _that = this;
switch (_that) {
case _GachaContent():
return $default(_that.playCount,_that.remainingDrawCount,_that.selected,_that.list,_that.drawHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int playCount,  int remainingDrawCount,  bool selected,  List<GachaItem> list,  List<GachaDrawHistory> drawHistory)?  $default,) {final _that = this;
switch (_that) {
case _GachaContent() when $default != null:
return $default(_that.playCount,_that.remainingDrawCount,_that.selected,_that.list,_that.drawHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GachaContent implements GachaContent {
  const _GachaContent({required this.playCount, this.remainingDrawCount = 0, this.selected = false, final  List<GachaItem> list = const <GachaItem>[], final  List<GachaDrawHistory> drawHistory = const <GachaDrawHistory>[]}): _list = list,_drawHistory = drawHistory;
  factory _GachaContent.fromJson(Map<String, dynamic> json) => _$GachaContentFromJson(json);

@override final  int playCount;
@override@JsonKey() final  int remainingDrawCount;
@override@JsonKey() final  bool selected;
 final  List<GachaItem> _list;
@override@JsonKey() List<GachaItem> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

 final  List<GachaDrawHistory> _drawHistory;
@override@JsonKey() List<GachaDrawHistory> get drawHistory {
  if (_drawHistory is EqualUnmodifiableListView) return _drawHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drawHistory);
}


/// Create a copy of GachaContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GachaContentCopyWith<_GachaContent> get copyWith => __$GachaContentCopyWithImpl<_GachaContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GachaContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GachaContent&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.remainingDrawCount, remainingDrawCount) || other.remainingDrawCount == remainingDrawCount)&&(identical(other.selected, selected) || other.selected == selected)&&const DeepCollectionEquality().equals(other._list, _list)&&const DeepCollectionEquality().equals(other._drawHistory, _drawHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playCount,remainingDrawCount,selected,const DeepCollectionEquality().hash(_list),const DeepCollectionEquality().hash(_drawHistory));

@override
String toString() {
  return 'GachaContent(playCount: $playCount, remainingDrawCount: $remainingDrawCount, selected: $selected, list: $list, drawHistory: $drawHistory)';
}


}

/// @nodoc
abstract mixin class _$GachaContentCopyWith<$Res> implements $GachaContentCopyWith<$Res> {
  factory _$GachaContentCopyWith(_GachaContent value, $Res Function(_GachaContent) _then) = __$GachaContentCopyWithImpl;
@override @useResult
$Res call({
 int playCount, int remainingDrawCount, bool selected, List<GachaItem> list, List<GachaDrawHistory> drawHistory
});




}
/// @nodoc
class __$GachaContentCopyWithImpl<$Res>
    implements _$GachaContentCopyWith<$Res> {
  __$GachaContentCopyWithImpl(this._self, this._then);

  final _GachaContent _self;
  final $Res Function(_GachaContent) _then;

/// Create a copy of GachaContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playCount = null,Object? remainingDrawCount = null,Object? selected = null,Object? list = null,Object? drawHistory = null,}) {
  return _then(_GachaContent(
playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,remainingDrawCount: null == remainingDrawCount ? _self.remainingDrawCount : remainingDrawCount // ignore: cast_nullable_to_non_nullable
as int,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool,list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<GachaItem>,drawHistory: null == drawHistory ? _self._drawHistory : drawHistory // ignore: cast_nullable_to_non_nullable
as List<GachaDrawHistory>,
  ));
}


}


/// @nodoc
mixin _$GachaItem {

 String get itemName; String get imageUrl; double get percent; bool get percentOpen; int? get capsuleId; String? get description;
/// Create a copy of GachaItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GachaItemCopyWith<GachaItem> get copyWith => _$GachaItemCopyWithImpl<GachaItem>(this as GachaItem, _$identity);

  /// Serializes this GachaItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GachaItem&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.percentOpen, percentOpen) || other.percentOpen == percentOpen)&&(identical(other.capsuleId, capsuleId) || other.capsuleId == capsuleId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl,percent,percentOpen,capsuleId,description);

@override
String toString() {
  return 'GachaItem(itemName: $itemName, imageUrl: $imageUrl, percent: $percent, percentOpen: $percentOpen, capsuleId: $capsuleId, description: $description)';
}


}

/// @nodoc
abstract mixin class $GachaItemCopyWith<$Res>  {
  factory $GachaItemCopyWith(GachaItem value, $Res Function(GachaItem) _then) = _$GachaItemCopyWithImpl;
@useResult
$Res call({
 String itemName, String imageUrl, double percent, bool percentOpen, int? capsuleId, String? description
});




}
/// @nodoc
class _$GachaItemCopyWithImpl<$Res>
    implements $GachaItemCopyWith<$Res> {
  _$GachaItemCopyWithImpl(this._self, this._then);

  final GachaItem _self;
  final $Res Function(GachaItem) _then;

/// Create a copy of GachaItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemName = null,Object? imageUrl = null,Object? percent = null,Object? percentOpen = null,Object? capsuleId = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,percentOpen: null == percentOpen ? _self.percentOpen : percentOpen // ignore: cast_nullable_to_non_nullable
as bool,capsuleId: freezed == capsuleId ? _self.capsuleId : capsuleId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GachaItem].
extension GachaItemPatterns on GachaItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GachaItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GachaItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GachaItem value)  $default,){
final _that = this;
switch (_that) {
case _GachaItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GachaItem value)?  $default,){
final _that = this;
switch (_that) {
case _GachaItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemName,  String imageUrl,  double percent,  bool percentOpen,  int? capsuleId,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GachaItem() when $default != null:
return $default(_that.itemName,_that.imageUrl,_that.percent,_that.percentOpen,_that.capsuleId,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemName,  String imageUrl,  double percent,  bool percentOpen,  int? capsuleId,  String? description)  $default,) {final _that = this;
switch (_that) {
case _GachaItem():
return $default(_that.itemName,_that.imageUrl,_that.percent,_that.percentOpen,_that.capsuleId,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemName,  String imageUrl,  double percent,  bool percentOpen,  int? capsuleId,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _GachaItem() when $default != null:
return $default(_that.itemName,_that.imageUrl,_that.percent,_that.percentOpen,_that.capsuleId,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GachaItem implements GachaItem {
  const _GachaItem({required this.itemName, required this.imageUrl, required this.percent, required this.percentOpen, this.capsuleId, this.description});
  factory _GachaItem.fromJson(Map<String, dynamic> json) => _$GachaItemFromJson(json);

@override final  String itemName;
@override final  String imageUrl;
@override final  double percent;
@override final  bool percentOpen;
@override final  int? capsuleId;
@override final  String? description;

/// Create a copy of GachaItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GachaItemCopyWith<_GachaItem> get copyWith => __$GachaItemCopyWithImpl<_GachaItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GachaItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GachaItem&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.percentOpen, percentOpen) || other.percentOpen == percentOpen)&&(identical(other.capsuleId, capsuleId) || other.capsuleId == capsuleId)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl,percent,percentOpen,capsuleId,description);

@override
String toString() {
  return 'GachaItem(itemName: $itemName, imageUrl: $imageUrl, percent: $percent, percentOpen: $percentOpen, capsuleId: $capsuleId, description: $description)';
}


}

/// @nodoc
abstract mixin class _$GachaItemCopyWith<$Res> implements $GachaItemCopyWith<$Res> {
  factory _$GachaItemCopyWith(_GachaItem value, $Res Function(_GachaItem) _then) = __$GachaItemCopyWithImpl;
@override @useResult
$Res call({
 String itemName, String imageUrl, double percent, bool percentOpen, int? capsuleId, String? description
});




}
/// @nodoc
class __$GachaItemCopyWithImpl<$Res>
    implements _$GachaItemCopyWith<$Res> {
  __$GachaItemCopyWithImpl(this._self, this._then);

  final _GachaItem _self;
  final $Res Function(_GachaItem) _then;

/// Create a copy of GachaItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemName = null,Object? imageUrl = null,Object? percent = null,Object? percentOpen = null,Object? capsuleId = freezed,Object? description = freezed,}) {
  return _then(_GachaItem(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,percentOpen: null == percentOpen ? _self.percentOpen : percentOpen // ignore: cast_nullable_to_non_nullable
as bool,capsuleId: freezed == capsuleId ? _self.capsuleId : capsuleId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GachaDrawHistory {

 int get capsuleId; String get giftName; String get giftImageUrl; String get description; bool get selected;
/// Create a copy of GachaDrawHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GachaDrawHistoryCopyWith<GachaDrawHistory> get copyWith => _$GachaDrawHistoryCopyWithImpl<GachaDrawHistory>(this as GachaDrawHistory, _$identity);

  /// Serializes this GachaDrawHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GachaDrawHistory&&(identical(other.capsuleId, capsuleId) || other.capsuleId == capsuleId)&&(identical(other.giftName, giftName) || other.giftName == giftName)&&(identical(other.giftImageUrl, giftImageUrl) || other.giftImageUrl == giftImageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.selected, selected) || other.selected == selected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,capsuleId,giftName,giftImageUrl,description,selected);

@override
String toString() {
  return 'GachaDrawHistory(capsuleId: $capsuleId, giftName: $giftName, giftImageUrl: $giftImageUrl, description: $description, selected: $selected)';
}


}

/// @nodoc
abstract mixin class $GachaDrawHistoryCopyWith<$Res>  {
  factory $GachaDrawHistoryCopyWith(GachaDrawHistory value, $Res Function(GachaDrawHistory) _then) = _$GachaDrawHistoryCopyWithImpl;
@useResult
$Res call({
 int capsuleId, String giftName, String giftImageUrl, String description, bool selected
});




}
/// @nodoc
class _$GachaDrawHistoryCopyWithImpl<$Res>
    implements $GachaDrawHistoryCopyWith<$Res> {
  _$GachaDrawHistoryCopyWithImpl(this._self, this._then);

  final GachaDrawHistory _self;
  final $Res Function(GachaDrawHistory) _then;

/// Create a copy of GachaDrawHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? capsuleId = null,Object? giftName = null,Object? giftImageUrl = null,Object? description = null,Object? selected = null,}) {
  return _then(_self.copyWith(
capsuleId: null == capsuleId ? _self.capsuleId : capsuleId // ignore: cast_nullable_to_non_nullable
as int,giftName: null == giftName ? _self.giftName : giftName // ignore: cast_nullable_to_non_nullable
as String,giftImageUrl: null == giftImageUrl ? _self.giftImageUrl : giftImageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GachaDrawHistory].
extension GachaDrawHistoryPatterns on GachaDrawHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GachaDrawHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GachaDrawHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GachaDrawHistory value)  $default,){
final _that = this;
switch (_that) {
case _GachaDrawHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GachaDrawHistory value)?  $default,){
final _that = this;
switch (_that) {
case _GachaDrawHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int capsuleId,  String giftName,  String giftImageUrl,  String description,  bool selected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GachaDrawHistory() when $default != null:
return $default(_that.capsuleId,_that.giftName,_that.giftImageUrl,_that.description,_that.selected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int capsuleId,  String giftName,  String giftImageUrl,  String description,  bool selected)  $default,) {final _that = this;
switch (_that) {
case _GachaDrawHistory():
return $default(_that.capsuleId,_that.giftName,_that.giftImageUrl,_that.description,_that.selected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int capsuleId,  String giftName,  String giftImageUrl,  String description,  bool selected)?  $default,) {final _that = this;
switch (_that) {
case _GachaDrawHistory() when $default != null:
return $default(_that.capsuleId,_that.giftName,_that.giftImageUrl,_that.description,_that.selected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GachaDrawHistory implements GachaDrawHistory {
  const _GachaDrawHistory({required this.capsuleId, required this.giftName, required this.giftImageUrl, required this.description, required this.selected});
  factory _GachaDrawHistory.fromJson(Map<String, dynamic> json) => _$GachaDrawHistoryFromJson(json);

@override final  int capsuleId;
@override final  String giftName;
@override final  String giftImageUrl;
@override final  String description;
@override final  bool selected;

/// Create a copy of GachaDrawHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GachaDrawHistoryCopyWith<_GachaDrawHistory> get copyWith => __$GachaDrawHistoryCopyWithImpl<_GachaDrawHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GachaDrawHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GachaDrawHistory&&(identical(other.capsuleId, capsuleId) || other.capsuleId == capsuleId)&&(identical(other.giftName, giftName) || other.giftName == giftName)&&(identical(other.giftImageUrl, giftImageUrl) || other.giftImageUrl == giftImageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.selected, selected) || other.selected == selected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,capsuleId,giftName,giftImageUrl,description,selected);

@override
String toString() {
  return 'GachaDrawHistory(capsuleId: $capsuleId, giftName: $giftName, giftImageUrl: $giftImageUrl, description: $description, selected: $selected)';
}


}

/// @nodoc
abstract mixin class _$GachaDrawHistoryCopyWith<$Res> implements $GachaDrawHistoryCopyWith<$Res> {
  factory _$GachaDrawHistoryCopyWith(_GachaDrawHistory value, $Res Function(_GachaDrawHistory) _then) = __$GachaDrawHistoryCopyWithImpl;
@override @useResult
$Res call({
 int capsuleId, String giftName, String giftImageUrl, String description, bool selected
});




}
/// @nodoc
class __$GachaDrawHistoryCopyWithImpl<$Res>
    implements _$GachaDrawHistoryCopyWith<$Res> {
  __$GachaDrawHistoryCopyWithImpl(this._self, this._then);

  final _GachaDrawHistory _self;
  final $Res Function(_GachaDrawHistory) _then;

/// Create a copy of GachaDrawHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? capsuleId = null,Object? giftName = null,Object? giftImageUrl = null,Object? description = null,Object? selected = null,}) {
  return _then(_GachaDrawHistory(
capsuleId: null == capsuleId ? _self.capsuleId : capsuleId // ignore: cast_nullable_to_non_nullable
as int,giftName: null == giftName ? _self.giftName : giftName // ignore: cast_nullable_to_non_nullable
as String,giftImageUrl: null == giftImageUrl ? _self.giftImageUrl : giftImageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$QuizContent {

 int get currentQuizIndex; int get remainingAttempts; RewardItem get successReward; RewardItem get failReward; List<QuizItem> get list; List<QuizAnswerHistory> get answerHistory;
/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizContentCopyWith<QuizContent> get copyWith => _$QuizContentCopyWithImpl<QuizContent>(this as QuizContent, _$identity);

  /// Serializes this QuizContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizContent&&(identical(other.currentQuizIndex, currentQuizIndex) || other.currentQuizIndex == currentQuizIndex)&&(identical(other.remainingAttempts, remainingAttempts) || other.remainingAttempts == remainingAttempts)&&(identical(other.successReward, successReward) || other.successReward == successReward)&&(identical(other.failReward, failReward) || other.failReward == failReward)&&const DeepCollectionEquality().equals(other.list, list)&&const DeepCollectionEquality().equals(other.answerHistory, answerHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentQuizIndex,remainingAttempts,successReward,failReward,const DeepCollectionEquality().hash(list),const DeepCollectionEquality().hash(answerHistory));

@override
String toString() {
  return 'QuizContent(currentQuizIndex: $currentQuizIndex, remainingAttempts: $remainingAttempts, successReward: $successReward, failReward: $failReward, list: $list, answerHistory: $answerHistory)';
}


}

/// @nodoc
abstract mixin class $QuizContentCopyWith<$Res>  {
  factory $QuizContentCopyWith(QuizContent value, $Res Function(QuizContent) _then) = _$QuizContentCopyWithImpl;
@useResult
$Res call({
 int currentQuizIndex, int remainingAttempts, RewardItem successReward, RewardItem failReward, List<QuizItem> list, List<QuizAnswerHistory> answerHistory
});


$RewardItemCopyWith<$Res> get successReward;$RewardItemCopyWith<$Res> get failReward;

}
/// @nodoc
class _$QuizContentCopyWithImpl<$Res>
    implements $QuizContentCopyWith<$Res> {
  _$QuizContentCopyWithImpl(this._self, this._then);

  final QuizContent _self;
  final $Res Function(QuizContent) _then;

/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentQuizIndex = null,Object? remainingAttempts = null,Object? successReward = null,Object? failReward = null,Object? list = null,Object? answerHistory = null,}) {
  return _then(_self.copyWith(
currentQuizIndex: null == currentQuizIndex ? _self.currentQuizIndex : currentQuizIndex // ignore: cast_nullable_to_non_nullable
as int,remainingAttempts: null == remainingAttempts ? _self.remainingAttempts : remainingAttempts // ignore: cast_nullable_to_non_nullable
as int,successReward: null == successReward ? _self.successReward : successReward // ignore: cast_nullable_to_non_nullable
as RewardItem,failReward: null == failReward ? _self.failReward : failReward // ignore: cast_nullable_to_non_nullable
as RewardItem,list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<QuizItem>,answerHistory: null == answerHistory ? _self.answerHistory : answerHistory // ignore: cast_nullable_to_non_nullable
as List<QuizAnswerHistory>,
  ));
}
/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardItemCopyWith<$Res> get successReward {
  
  return $RewardItemCopyWith<$Res>(_self.successReward, (value) {
    return _then(_self.copyWith(successReward: value));
  });
}/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardItemCopyWith<$Res> get failReward {
  
  return $RewardItemCopyWith<$Res>(_self.failReward, (value) {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentQuizIndex,  int remainingAttempts,  RewardItem successReward,  RewardItem failReward,  List<QuizItem> list,  List<QuizAnswerHistory> answerHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizContent() when $default != null:
return $default(_that.currentQuizIndex,_that.remainingAttempts,_that.successReward,_that.failReward,_that.list,_that.answerHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentQuizIndex,  int remainingAttempts,  RewardItem successReward,  RewardItem failReward,  List<QuizItem> list,  List<QuizAnswerHistory> answerHistory)  $default,) {final _that = this;
switch (_that) {
case _QuizContent():
return $default(_that.currentQuizIndex,_that.remainingAttempts,_that.successReward,_that.failReward,_that.list,_that.answerHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentQuizIndex,  int remainingAttempts,  RewardItem successReward,  RewardItem failReward,  List<QuizItem> list,  List<QuizAnswerHistory> answerHistory)?  $default,) {final _that = this;
switch (_that) {
case _QuizContent() when $default != null:
return $default(_that.currentQuizIndex,_that.remainingAttempts,_that.successReward,_that.failReward,_that.list,_that.answerHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizContent implements QuizContent {
  const _QuizContent({this.currentQuizIndex = 0, this.remainingAttempts = 0, required this.successReward, required this.failReward, final  List<QuizItem> list = const <QuizItem>[], final  List<QuizAnswerHistory> answerHistory = const <QuizAnswerHistory>[]}): _list = list,_answerHistory = answerHistory;
  factory _QuizContent.fromJson(Map<String, dynamic> json) => _$QuizContentFromJson(json);

@override@JsonKey() final  int currentQuizIndex;
@override@JsonKey() final  int remainingAttempts;
@override final  RewardItem successReward;
@override final  RewardItem failReward;
 final  List<QuizItem> _list;
@override@JsonKey() List<QuizItem> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

 final  List<QuizAnswerHistory> _answerHistory;
@override@JsonKey() List<QuizAnswerHistory> get answerHistory {
  if (_answerHistory is EqualUnmodifiableListView) return _answerHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answerHistory);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizContent&&(identical(other.currentQuizIndex, currentQuizIndex) || other.currentQuizIndex == currentQuizIndex)&&(identical(other.remainingAttempts, remainingAttempts) || other.remainingAttempts == remainingAttempts)&&(identical(other.successReward, successReward) || other.successReward == successReward)&&(identical(other.failReward, failReward) || other.failReward == failReward)&&const DeepCollectionEquality().equals(other._list, _list)&&const DeepCollectionEquality().equals(other._answerHistory, _answerHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentQuizIndex,remainingAttempts,successReward,failReward,const DeepCollectionEquality().hash(_list),const DeepCollectionEquality().hash(_answerHistory));

@override
String toString() {
  return 'QuizContent(currentQuizIndex: $currentQuizIndex, remainingAttempts: $remainingAttempts, successReward: $successReward, failReward: $failReward, list: $list, answerHistory: $answerHistory)';
}


}

/// @nodoc
abstract mixin class _$QuizContentCopyWith<$Res> implements $QuizContentCopyWith<$Res> {
  factory _$QuizContentCopyWith(_QuizContent value, $Res Function(_QuizContent) _then) = __$QuizContentCopyWithImpl;
@override @useResult
$Res call({
 int currentQuizIndex, int remainingAttempts, RewardItem successReward, RewardItem failReward, List<QuizItem> list, List<QuizAnswerHistory> answerHistory
});


@override $RewardItemCopyWith<$Res> get successReward;@override $RewardItemCopyWith<$Res> get failReward;

}
/// @nodoc
class __$QuizContentCopyWithImpl<$Res>
    implements _$QuizContentCopyWith<$Res> {
  __$QuizContentCopyWithImpl(this._self, this._then);

  final _QuizContent _self;
  final $Res Function(_QuizContent) _then;

/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentQuizIndex = null,Object? remainingAttempts = null,Object? successReward = null,Object? failReward = null,Object? list = null,Object? answerHistory = null,}) {
  return _then(_QuizContent(
currentQuizIndex: null == currentQuizIndex ? _self.currentQuizIndex : currentQuizIndex // ignore: cast_nullable_to_non_nullable
as int,remainingAttempts: null == remainingAttempts ? _self.remainingAttempts : remainingAttempts // ignore: cast_nullable_to_non_nullable
as int,successReward: null == successReward ? _self.successReward : successReward // ignore: cast_nullable_to_non_nullable
as RewardItem,failReward: null == failReward ? _self.failReward : failReward // ignore: cast_nullable_to_non_nullable
as RewardItem,list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<QuizItem>,answerHistory: null == answerHistory ? _self._answerHistory : answerHistory // ignore: cast_nullable_to_non_nullable
as List<QuizAnswerHistory>,
  ));
}

/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardItemCopyWith<$Res> get successReward {
  
  return $RewardItemCopyWith<$Res>(_self.successReward, (value) {
    return _then(_self.copyWith(successReward: value));
  });
}/// Create a copy of QuizContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardItemCopyWith<$Res> get failReward {
  
  return $RewardItemCopyWith<$Res>(_self.failReward, (value) {
    return _then(_self.copyWith(failReward: value));
  });
}
}


/// @nodoc
mixin _$RewardItem {

 int? get requiredCount; String get itemName; String get imageUrl;
/// Create a copy of RewardItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardItemCopyWith<RewardItem> get copyWith => _$RewardItemCopyWithImpl<RewardItem>(this as RewardItem, _$identity);

  /// Serializes this RewardItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardItem&&(identical(other.requiredCount, requiredCount) || other.requiredCount == requiredCount)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requiredCount,itemName,imageUrl);

@override
String toString() {
  return 'RewardItem(requiredCount: $requiredCount, itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $RewardItemCopyWith<$Res>  {
  factory $RewardItemCopyWith(RewardItem value, $Res Function(RewardItem) _then) = _$RewardItemCopyWithImpl;
@useResult
$Res call({
 int? requiredCount, String itemName, String imageUrl
});




}
/// @nodoc
class _$RewardItemCopyWithImpl<$Res>
    implements $RewardItemCopyWith<$Res> {
  _$RewardItemCopyWithImpl(this._self, this._then);

  final RewardItem _self;
  final $Res Function(RewardItem) _then;

/// Create a copy of RewardItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requiredCount = freezed,Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
requiredCount: freezed == requiredCount ? _self.requiredCount : requiredCount // ignore: cast_nullable_to_non_nullable
as int?,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RewardItem].
extension RewardItemPatterns on RewardItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewardItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewardItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewardItem value)  $default,){
final _that = this;
switch (_that) {
case _RewardItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewardItem value)?  $default,){
final _that = this;
switch (_that) {
case _RewardItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? requiredCount,  String itemName,  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RewardItem() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? requiredCount,  String itemName,  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _RewardItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? requiredCount,  String itemName,  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _RewardItem() when $default != null:
return $default(_that.requiredCount,_that.itemName,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RewardItem implements RewardItem {
  const _RewardItem({this.requiredCount, required this.itemName, required this.imageUrl});
  factory _RewardItem.fromJson(Map<String, dynamic> json) => _$RewardItemFromJson(json);

@override final  int? requiredCount;
@override final  String itemName;
@override final  String imageUrl;

/// Create a copy of RewardItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardItemCopyWith<_RewardItem> get copyWith => __$RewardItemCopyWithImpl<_RewardItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewardItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewardItem&&(identical(other.requiredCount, requiredCount) || other.requiredCount == requiredCount)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requiredCount,itemName,imageUrl);

@override
String toString() {
  return 'RewardItem(requiredCount: $requiredCount, itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$RewardItemCopyWith<$Res> implements $RewardItemCopyWith<$Res> {
  factory _$RewardItemCopyWith(_RewardItem value, $Res Function(_RewardItem) _then) = __$RewardItemCopyWithImpl;
@override @useResult
$Res call({
 int? requiredCount, String itemName, String imageUrl
});




}
/// @nodoc
class __$RewardItemCopyWithImpl<$Res>
    implements _$RewardItemCopyWith<$Res> {
  __$RewardItemCopyWithImpl(this._self, this._then);

  final _RewardItem _self;
  final $Res Function(_RewardItem) _then;

/// Create a copy of RewardItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requiredCount = freezed,Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_RewardItem(
requiredCount: freezed == requiredCount ? _self.requiredCount : requiredCount // ignore: cast_nullable_to_non_nullable
as int?,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$QuizItem {

 int get quizId; String get type; String get title; String get imageUrl; String get description; String get hint; List<String> get options;// 정답 목록 (채점 시 대소문자 무관 비교)
 List<String> get answer; int get playLimit;
/// Create a copy of QuizItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizItemCopyWith<QuizItem> get copyWith => _$QuizItemCopyWithImpl<QuizItem>(this as QuizItem, _$identity);

  /// Serializes this QuizItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizItem&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.hint, hint) || other.hint == hint)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.answer, answer)&&(identical(other.playLimit, playLimit) || other.playLimit == playLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,type,title,imageUrl,description,hint,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(answer),playLimit);

@override
String toString() {
  return 'QuizItem(quizId: $quizId, type: $type, title: $title, imageUrl: $imageUrl, description: $description, hint: $hint, options: $options, answer: $answer, playLimit: $playLimit)';
}


}

/// @nodoc
abstract mixin class $QuizItemCopyWith<$Res>  {
  factory $QuizItemCopyWith(QuizItem value, $Res Function(QuizItem) _then) = _$QuizItemCopyWithImpl;
@useResult
$Res call({
 int quizId, String type, String title, String imageUrl, String description, String hint, List<String> options, List<String> answer, int playLimit
});




}
/// @nodoc
class _$QuizItemCopyWithImpl<$Res>
    implements $QuizItemCopyWith<$Res> {
  _$QuizItemCopyWithImpl(this._self, this._then);

  final QuizItem _self;
  final $Res Function(QuizItem) _then;

/// Create a copy of QuizItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quizId = null,Object? type = null,Object? title = null,Object? imageUrl = null,Object? description = null,Object? hint = null,Object? options = null,Object? answer = null,Object? playLimit = null,}) {
  return _then(_self.copyWith(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as List<String>,playLimit: null == playLimit ? _self.playLimit : playLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizItem].
extension QuizItemPatterns on QuizItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizItem value)  $default,){
final _that = this;
switch (_that) {
case _QuizItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizItem value)?  $default,){
final _that = this;
switch (_that) {
case _QuizItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int quizId,  String type,  String title,  String imageUrl,  String description,  String hint,  List<String> options,  List<String> answer,  int playLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizItem() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int quizId,  String type,  String title,  String imageUrl,  String description,  String hint,  List<String> options,  List<String> answer,  int playLimit)  $default,) {final _that = this;
switch (_that) {
case _QuizItem():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int quizId,  String type,  String title,  String imageUrl,  String description,  String hint,  List<String> options,  List<String> answer,  int playLimit)?  $default,) {final _that = this;
switch (_that) {
case _QuizItem() when $default != null:
return $default(_that.quizId,_that.type,_that.title,_that.imageUrl,_that.description,_that.hint,_that.options,_that.answer,_that.playLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizItem implements QuizItem {
  const _QuizItem({required this.quizId, required this.type, required this.title, this.imageUrl = '', this.description = '', this.hint = '', final  List<String> options = const <String>[], final  List<String> answer = const <String>[], this.playLimit = 1}): _options = options,_answer = answer;
  factory _QuizItem.fromJson(Map<String, dynamic> json) => _$QuizItemFromJson(json);

@override final  int quizId;
@override final  String type;
@override final  String title;
@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  String description;
@override@JsonKey() final  String hint;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

// 정답 목록 (채점 시 대소문자 무관 비교)
 final  List<String> _answer;
// 정답 목록 (채점 시 대소문자 무관 비교)
@override@JsonKey() List<String> get answer {
  if (_answer is EqualUnmodifiableListView) return _answer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answer);
}

@override@JsonKey() final  int playLimit;

/// Create a copy of QuizItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizItemCopyWith<_QuizItem> get copyWith => __$QuizItemCopyWithImpl<_QuizItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizItem&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.hint, hint) || other.hint == hint)&&const DeepCollectionEquality().equals(other._options, _options)&&const DeepCollectionEquality().equals(other._answer, _answer)&&(identical(other.playLimit, playLimit) || other.playLimit == playLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,type,title,imageUrl,description,hint,const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_answer),playLimit);

@override
String toString() {
  return 'QuizItem(quizId: $quizId, type: $type, title: $title, imageUrl: $imageUrl, description: $description, hint: $hint, options: $options, answer: $answer, playLimit: $playLimit)';
}


}

/// @nodoc
abstract mixin class _$QuizItemCopyWith<$Res> implements $QuizItemCopyWith<$Res> {
  factory _$QuizItemCopyWith(_QuizItem value, $Res Function(_QuizItem) _then) = __$QuizItemCopyWithImpl;
@override @useResult
$Res call({
 int quizId, String type, String title, String imageUrl, String description, String hint, List<String> options, List<String> answer, int playLimit
});




}
/// @nodoc
class __$QuizItemCopyWithImpl<$Res>
    implements _$QuizItemCopyWith<$Res> {
  __$QuizItemCopyWithImpl(this._self, this._then);

  final _QuizItem _self;
  final $Res Function(_QuizItem) _then;

/// Create a copy of QuizItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quizId = null,Object? type = null,Object? title = null,Object? imageUrl = null,Object? description = null,Object? hint = null,Object? options = null,Object? answer = null,Object? playLimit = null,}) {
  return _then(_QuizItem(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,hint: null == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,answer: null == answer ? _self._answer : answer // ignore: cast_nullable_to_non_nullable
as List<String>,playLimit: null == playLimit ? _self.playLimit : playLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$QuizAnswerHistory {

 int get quizId; bool get correct;
/// Create a copy of QuizAnswerHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizAnswerHistoryCopyWith<QuizAnswerHistory> get copyWith => _$QuizAnswerHistoryCopyWithImpl<QuizAnswerHistory>(this as QuizAnswerHistory, _$identity);

  /// Serializes this QuizAnswerHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizAnswerHistory&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,correct);

@override
String toString() {
  return 'QuizAnswerHistory(quizId: $quizId, correct: $correct)';
}


}

/// @nodoc
abstract mixin class $QuizAnswerHistoryCopyWith<$Res>  {
  factory $QuizAnswerHistoryCopyWith(QuizAnswerHistory value, $Res Function(QuizAnswerHistory) _then) = _$QuizAnswerHistoryCopyWithImpl;
@useResult
$Res call({
 int quizId, bool correct
});




}
/// @nodoc
class _$QuizAnswerHistoryCopyWithImpl<$Res>
    implements $QuizAnswerHistoryCopyWith<$Res> {
  _$QuizAnswerHistoryCopyWithImpl(this._self, this._then);

  final QuizAnswerHistory _self;
  final $Res Function(QuizAnswerHistory) _then;

/// Create a copy of QuizAnswerHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quizId = null,Object? correct = null,}) {
  return _then(_self.copyWith(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuizAnswerHistory].
extension QuizAnswerHistoryPatterns on QuizAnswerHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizAnswerHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizAnswerHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizAnswerHistory value)  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizAnswerHistory value)?  $default,){
final _that = this;
switch (_that) {
case _QuizAnswerHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int quizId,  bool correct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizAnswerHistory() when $default != null:
return $default(_that.quizId,_that.correct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int quizId,  bool correct)  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerHistory():
return $default(_that.quizId,_that.correct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int quizId,  bool correct)?  $default,) {final _that = this;
switch (_that) {
case _QuizAnswerHistory() when $default != null:
return $default(_that.quizId,_that.correct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuizAnswerHistory implements QuizAnswerHistory {
  const _QuizAnswerHistory({required this.quizId, required this.correct});
  factory _QuizAnswerHistory.fromJson(Map<String, dynamic> json) => _$QuizAnswerHistoryFromJson(json);

@override final  int quizId;
@override final  bool correct;

/// Create a copy of QuizAnswerHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizAnswerHistoryCopyWith<_QuizAnswerHistory> get copyWith => __$QuizAnswerHistoryCopyWithImpl<_QuizAnswerHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizAnswerHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizAnswerHistory&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quizId,correct);

@override
String toString() {
  return 'QuizAnswerHistory(quizId: $quizId, correct: $correct)';
}


}

/// @nodoc
abstract mixin class _$QuizAnswerHistoryCopyWith<$Res> implements $QuizAnswerHistoryCopyWith<$Res> {
  factory _$QuizAnswerHistoryCopyWith(_QuizAnswerHistory value, $Res Function(_QuizAnswerHistory) _then) = __$QuizAnswerHistoryCopyWithImpl;
@override @useResult
$Res call({
 int quizId, bool correct
});




}
/// @nodoc
class __$QuizAnswerHistoryCopyWithImpl<$Res>
    implements _$QuizAnswerHistoryCopyWith<$Res> {
  __$QuizAnswerHistoryCopyWithImpl(this._self, this._then);

  final _QuizAnswerHistory _self;
  final $Res Function(_QuizAnswerHistory) _then;

/// Create a copy of QuizAnswerHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quizId = null,Object? correct = null,}) {
  return _then(_QuizAnswerHistory(
quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UnboxingContent {

 UnboxingBefore get beforeOpen; UnboxingAfter get afterOpen;
/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnboxingContentCopyWith<UnboxingContent> get copyWith => _$UnboxingContentCopyWithImpl<UnboxingContent>(this as UnboxingContent, _$identity);

  /// Serializes this UnboxingContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnboxingContent&&(identical(other.beforeOpen, beforeOpen) || other.beforeOpen == beforeOpen)&&(identical(other.afterOpen, afterOpen) || other.afterOpen == afterOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeOpen,afterOpen);

@override
String toString() {
  return 'UnboxingContent(beforeOpen: $beforeOpen, afterOpen: $afterOpen)';
}


}

/// @nodoc
abstract mixin class $UnboxingContentCopyWith<$Res>  {
  factory $UnboxingContentCopyWith(UnboxingContent value, $Res Function(UnboxingContent) _then) = _$UnboxingContentCopyWithImpl;
@useResult
$Res call({
 UnboxingBefore beforeOpen, UnboxingAfter afterOpen
});


$UnboxingBeforeCopyWith<$Res> get beforeOpen;$UnboxingAfterCopyWith<$Res> get afterOpen;

}
/// @nodoc
class _$UnboxingContentCopyWithImpl<$Res>
    implements $UnboxingContentCopyWith<$Res> {
  _$UnboxingContentCopyWithImpl(this._self, this._then);

  final UnboxingContent _self;
  final $Res Function(UnboxingContent) _then;

/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? beforeOpen = null,Object? afterOpen = null,}) {
  return _then(_self.copyWith(
beforeOpen: null == beforeOpen ? _self.beforeOpen : beforeOpen // ignore: cast_nullable_to_non_nullable
as UnboxingBefore,afterOpen: null == afterOpen ? _self.afterOpen : afterOpen // ignore: cast_nullable_to_non_nullable
as UnboxingAfter,
  ));
}
/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnboxingBeforeCopyWith<$Res> get beforeOpen {
  
  return $UnboxingBeforeCopyWith<$Res>(_self.beforeOpen, (value) {
    return _then(_self.copyWith(beforeOpen: value));
  });
}/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnboxingAfterCopyWith<$Res> get afterOpen {
  
  return $UnboxingAfterCopyWith<$Res>(_self.afterOpen, (value) {
    return _then(_self.copyWith(afterOpen: value));
  });
}
}


/// Adds pattern-matching-related methods to [UnboxingContent].
extension UnboxingContentPatterns on UnboxingContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnboxingContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnboxingContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnboxingContent value)  $default,){
final _that = this;
switch (_that) {
case _UnboxingContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnboxingContent value)?  $default,){
final _that = this;
switch (_that) {
case _UnboxingContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UnboxingBefore beforeOpen,  UnboxingAfter afterOpen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnboxingContent() when $default != null:
return $default(_that.beforeOpen,_that.afterOpen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UnboxingBefore beforeOpen,  UnboxingAfter afterOpen)  $default,) {final _that = this;
switch (_that) {
case _UnboxingContent():
return $default(_that.beforeOpen,_that.afterOpen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UnboxingBefore beforeOpen,  UnboxingAfter afterOpen)?  $default,) {final _that = this;
switch (_that) {
case _UnboxingContent() when $default != null:
return $default(_that.beforeOpen,_that.afterOpen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnboxingContent implements UnboxingContent {
  const _UnboxingContent({required this.beforeOpen, required this.afterOpen});
  factory _UnboxingContent.fromJson(Map<String, dynamic> json) => _$UnboxingContentFromJson(json);

@override final  UnboxingBefore beforeOpen;
@override final  UnboxingAfter afterOpen;

/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnboxingContentCopyWith<_UnboxingContent> get copyWith => __$UnboxingContentCopyWithImpl<_UnboxingContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnboxingContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnboxingContent&&(identical(other.beforeOpen, beforeOpen) || other.beforeOpen == beforeOpen)&&(identical(other.afterOpen, afterOpen) || other.afterOpen == afterOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,beforeOpen,afterOpen);

@override
String toString() {
  return 'UnboxingContent(beforeOpen: $beforeOpen, afterOpen: $afterOpen)';
}


}

/// @nodoc
abstract mixin class _$UnboxingContentCopyWith<$Res> implements $UnboxingContentCopyWith<$Res> {
  factory _$UnboxingContentCopyWith(_UnboxingContent value, $Res Function(_UnboxingContent) _then) = __$UnboxingContentCopyWithImpl;
@override @useResult
$Res call({
 UnboxingBefore beforeOpen, UnboxingAfter afterOpen
});


@override $UnboxingBeforeCopyWith<$Res> get beforeOpen;@override $UnboxingAfterCopyWith<$Res> get afterOpen;

}
/// @nodoc
class __$UnboxingContentCopyWithImpl<$Res>
    implements _$UnboxingContentCopyWith<$Res> {
  __$UnboxingContentCopyWithImpl(this._self, this._then);

  final _UnboxingContent _self;
  final $Res Function(_UnboxingContent) _then;

/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? beforeOpen = null,Object? afterOpen = null,}) {
  return _then(_UnboxingContent(
beforeOpen: null == beforeOpen ? _self.beforeOpen : beforeOpen // ignore: cast_nullable_to_non_nullable
as UnboxingBefore,afterOpen: null == afterOpen ? _self.afterOpen : afterOpen // ignore: cast_nullable_to_non_nullable
as UnboxingAfter,
  ));
}

/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnboxingBeforeCopyWith<$Res> get beforeOpen {
  
  return $UnboxingBeforeCopyWith<$Res>(_self.beforeOpen, (value) {
    return _then(_self.copyWith(beforeOpen: value));
  });
}/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnboxingAfterCopyWith<$Res> get afterOpen {
  
  return $UnboxingAfterCopyWith<$Res>(_self.afterOpen, (value) {
    return _then(_self.copyWith(afterOpen: value));
  });
}
}


/// @nodoc
mixin _$UnboxingBefore {

 String get imageUrl; String get description;
/// Create a copy of UnboxingBefore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnboxingBeforeCopyWith<UnboxingBefore> get copyWith => _$UnboxingBeforeCopyWithImpl<UnboxingBefore>(this as UnboxingBefore, _$identity);

  /// Serializes this UnboxingBefore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnboxingBefore&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,description);

@override
String toString() {
  return 'UnboxingBefore(imageUrl: $imageUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class $UnboxingBeforeCopyWith<$Res>  {
  factory $UnboxingBeforeCopyWith(UnboxingBefore value, $Res Function(UnboxingBefore) _then) = _$UnboxingBeforeCopyWithImpl;
@useResult
$Res call({
 String imageUrl, String description
});




}
/// @nodoc
class _$UnboxingBeforeCopyWithImpl<$Res>
    implements $UnboxingBeforeCopyWith<$Res> {
  _$UnboxingBeforeCopyWithImpl(this._self, this._then);

  final UnboxingBefore _self;
  final $Res Function(UnboxingBefore) _then;

/// Create a copy of UnboxingBefore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = null,Object? description = null,}) {
  return _then(_self.copyWith(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UnboxingBefore].
extension UnboxingBeforePatterns on UnboxingBefore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnboxingBefore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnboxingBefore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnboxingBefore value)  $default,){
final _that = this;
switch (_that) {
case _UnboxingBefore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnboxingBefore value)?  $default,){
final _that = this;
switch (_that) {
case _UnboxingBefore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String imageUrl,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnboxingBefore() when $default != null:
return $default(_that.imageUrl,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String imageUrl,  String description)  $default,) {final _that = this;
switch (_that) {
case _UnboxingBefore():
return $default(_that.imageUrl,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String imageUrl,  String description)?  $default,) {final _that = this;
switch (_that) {
case _UnboxingBefore() when $default != null:
return $default(_that.imageUrl,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnboxingBefore implements UnboxingBefore {
  const _UnboxingBefore({required this.imageUrl, required this.description});
  factory _UnboxingBefore.fromJson(Map<String, dynamic> json) => _$UnboxingBeforeFromJson(json);

@override final  String imageUrl;
@override final  String description;

/// Create a copy of UnboxingBefore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnboxingBeforeCopyWith<_UnboxingBefore> get copyWith => __$UnboxingBeforeCopyWithImpl<_UnboxingBefore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnboxingBeforeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnboxingBefore&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,description);

@override
String toString() {
  return 'UnboxingBefore(imageUrl: $imageUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class _$UnboxingBeforeCopyWith<$Res> implements $UnboxingBeforeCopyWith<$Res> {
  factory _$UnboxingBeforeCopyWith(_UnboxingBefore value, $Res Function(_UnboxingBefore) _then) = __$UnboxingBeforeCopyWithImpl;
@override @useResult
$Res call({
 String imageUrl, String description
});




}
/// @nodoc
class __$UnboxingBeforeCopyWithImpl<$Res>
    implements _$UnboxingBeforeCopyWith<$Res> {
  __$UnboxingBeforeCopyWithImpl(this._self, this._then);

  final _UnboxingBefore _self;
  final $Res Function(_UnboxingBefore) _then;

/// Create a copy of UnboxingBefore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageUrl = null,Object? description = null,}) {
  return _then(_UnboxingBefore(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UnboxingAfter {

 String get itemName; String get imageUrl;
/// Create a copy of UnboxingAfter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnboxingAfterCopyWith<UnboxingAfter> get copyWith => _$UnboxingAfterCopyWithImpl<UnboxingAfter>(this as UnboxingAfter, _$identity);

  /// Serializes this UnboxingAfter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnboxingAfter&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl);

@override
String toString() {
  return 'UnboxingAfter(itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $UnboxingAfterCopyWith<$Res>  {
  factory $UnboxingAfterCopyWith(UnboxingAfter value, $Res Function(UnboxingAfter) _then) = _$UnboxingAfterCopyWithImpl;
@useResult
$Res call({
 String itemName, String imageUrl
});




}
/// @nodoc
class _$UnboxingAfterCopyWithImpl<$Res>
    implements $UnboxingAfterCopyWith<$Res> {
  _$UnboxingAfterCopyWithImpl(this._self, this._then);

  final UnboxingAfter _self;
  final $Res Function(UnboxingAfter) _then;

/// Create a copy of UnboxingAfter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UnboxingAfter].
extension UnboxingAfterPatterns on UnboxingAfter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnboxingAfter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnboxingAfter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnboxingAfter value)  $default,){
final _that = this;
switch (_that) {
case _UnboxingAfter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnboxingAfter value)?  $default,){
final _that = this;
switch (_that) {
case _UnboxingAfter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemName,  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnboxingAfter() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemName,  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _UnboxingAfter():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemName,  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _UnboxingAfter() when $default != null:
return $default(_that.itemName,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnboxingAfter implements UnboxingAfter {
  const _UnboxingAfter({required this.itemName, required this.imageUrl});
  factory _UnboxingAfter.fromJson(Map<String, dynamic> json) => _$UnboxingAfterFromJson(json);

@override final  String itemName;
@override final  String imageUrl;

/// Create a copy of UnboxingAfter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnboxingAfterCopyWith<_UnboxingAfter> get copyWith => __$UnboxingAfterCopyWithImpl<_UnboxingAfter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnboxingAfterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnboxingAfter&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl);

@override
String toString() {
  return 'UnboxingAfter(itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$UnboxingAfterCopyWith<$Res> implements $UnboxingAfterCopyWith<$Res> {
  factory _$UnboxingAfterCopyWith(_UnboxingAfter value, $Res Function(_UnboxingAfter) _then) = __$UnboxingAfterCopyWithImpl;
@override @useResult
$Res call({
 String itemName, String imageUrl
});




}
/// @nodoc
class __$UnboxingAfterCopyWithImpl<$Res>
    implements _$UnboxingAfterCopyWith<$Res> {
  __$UnboxingAfterCopyWithImpl(this._self, this._then);

  final _UnboxingAfter _self;
  final $Res Function(_UnboxingAfter) _then;

/// Create a copy of UnboxingAfter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_UnboxingAfter(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
