// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gallery_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GalleryItem {

 String get title;@JsonKey(name: 'image_url') String get imageUrl; String get description;
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
 String title,@JsonKey(name: 'image_url') String imageUrl, String description
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'image_url')  String imageUrl,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @JsonKey(name: 'image_url')  String imageUrl,  String description)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @JsonKey(name: 'image_url')  String imageUrl,  String description)?  $default,) {final _that = this;
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
  const _GalleryItem({this.title = '', @JsonKey(name: 'image_url') this.imageUrl = '', this.description = ''});
  factory _GalleryItem.fromJson(Map<String, dynamic> json) => _$GalleryItemFromJson(json);

@override@JsonKey() final  String title;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey() final  String description;

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
 String title,@JsonKey(name: 'image_url') String imageUrl, String description
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

// dart format on
