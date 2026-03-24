// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gacha_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GachaContent {

@JsonKey(name: 'play_count') int get playCount; List<GachaItem> get list;
/// Create a copy of GachaContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GachaContentCopyWith<GachaContent> get copyWith => _$GachaContentCopyWithImpl<GachaContent>(this as GachaContent, _$identity);

  /// Serializes this GachaContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GachaContent&&(identical(other.playCount, playCount) || other.playCount == playCount)&&const DeepCollectionEquality().equals(other.list, list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playCount,const DeepCollectionEquality().hash(list));

@override
String toString() {
  return 'GachaContent(playCount: $playCount, list: $list)';
}


}

/// @nodoc
abstract mixin class $GachaContentCopyWith<$Res>  {
  factory $GachaContentCopyWith(GachaContent value, $Res Function(GachaContent) _then) = _$GachaContentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'play_count') int playCount, List<GachaItem> list
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
@pragma('vm:prefer-inline') @override $Res call({Object? playCount = null,Object? list = null,}) {
  return _then(_self.copyWith(
playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<GachaItem>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'play_count')  int playCount,  List<GachaItem> list)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GachaContent() when $default != null:
return $default(_that.playCount,_that.list);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'play_count')  int playCount,  List<GachaItem> list)  $default,) {final _that = this;
switch (_that) {
case _GachaContent():
return $default(_that.playCount,_that.list);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'play_count')  int playCount,  List<GachaItem> list)?  $default,) {final _that = this;
switch (_that) {
case _GachaContent() when $default != null:
return $default(_that.playCount,_that.list);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GachaContent implements GachaContent {
  const _GachaContent({@JsonKey(name: 'play_count') this.playCount = 3, final  List<GachaItem> list = const <GachaItem>[]}): _list = list;
  factory _GachaContent.fromJson(Map<String, dynamic> json) => _$GachaContentFromJson(json);

@override@JsonKey(name: 'play_count') final  int playCount;
 final  List<GachaItem> _list;
@override@JsonKey() List<GachaItem> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GachaContent&&(identical(other.playCount, playCount) || other.playCount == playCount)&&const DeepCollectionEquality().equals(other._list, _list));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playCount,const DeepCollectionEquality().hash(_list));

@override
String toString() {
  return 'GachaContent(playCount: $playCount, list: $list)';
}


}

/// @nodoc
abstract mixin class _$GachaContentCopyWith<$Res> implements $GachaContentCopyWith<$Res> {
  factory _$GachaContentCopyWith(_GachaContent value, $Res Function(_GachaContent) _then) = __$GachaContentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'play_count') int playCount, List<GachaItem> list
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
@override @pragma('vm:prefer-inline') $Res call({Object? playCount = null,Object? list = null,}) {
  return _then(_GachaContent(
playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<GachaItem>,
  ));
}


}


/// @nodoc
mixin _$GachaItem {

@JsonKey(name: 'item_name') String get itemName;@JsonKey(name: 'image_url') String get imageUrl; double get percent;@JsonKey(name: 'percent_open') bool get percentOpen;
/// Create a copy of GachaItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GachaItemCopyWith<GachaItem> get copyWith => _$GachaItemCopyWithImpl<GachaItem>(this as GachaItem, _$identity);

  /// Serializes this GachaItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GachaItem&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.percentOpen, percentOpen) || other.percentOpen == percentOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl,percent,percentOpen);

@override
String toString() {
  return 'GachaItem(itemName: $itemName, imageUrl: $imageUrl, percent: $percent, percentOpen: $percentOpen)';
}


}

/// @nodoc
abstract mixin class $GachaItemCopyWith<$Res>  {
  factory $GachaItemCopyWith(GachaItem value, $Res Function(GachaItem) _then) = _$GachaItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'image_url') String imageUrl, double percent,@JsonKey(name: 'percent_open') bool percentOpen
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
@pragma('vm:prefer-inline') @override $Res call({Object? itemName = null,Object? imageUrl = null,Object? percent = null,Object? percentOpen = null,}) {
  return _then(_self.copyWith(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,percentOpen: null == percentOpen ? _self.percentOpen : percentOpen // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'image_url')  String imageUrl,  double percent, @JsonKey(name: 'percent_open')  bool percentOpen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GachaItem() when $default != null:
return $default(_that.itemName,_that.imageUrl,_that.percent,_that.percentOpen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'image_url')  String imageUrl,  double percent, @JsonKey(name: 'percent_open')  bool percentOpen)  $default,) {final _that = this;
switch (_that) {
case _GachaItem():
return $default(_that.itemName,_that.imageUrl,_that.percent,_that.percentOpen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'item_name')  String itemName, @JsonKey(name: 'image_url')  String imageUrl,  double percent, @JsonKey(name: 'percent_open')  bool percentOpen)?  $default,) {final _that = this;
switch (_that) {
case _GachaItem() when $default != null:
return $default(_that.itemName,_that.imageUrl,_that.percent,_that.percentOpen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GachaItem implements GachaItem {
  const _GachaItem({@JsonKey(name: 'item_name') this.itemName = '', @JsonKey(name: 'image_url') this.imageUrl = '', this.percent = 0.0, @JsonKey(name: 'percent_open') this.percentOpen = false});
  factory _GachaItem.fromJson(Map<String, dynamic> json) => _$GachaItemFromJson(json);

@override@JsonKey(name: 'item_name') final  String itemName;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey() final  double percent;
@override@JsonKey(name: 'percent_open') final  bool percentOpen;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GachaItem&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.percentOpen, percentOpen) || other.percentOpen == percentOpen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl,percent,percentOpen);

@override
String toString() {
  return 'GachaItem(itemName: $itemName, imageUrl: $imageUrl, percent: $percent, percentOpen: $percentOpen)';
}


}

/// @nodoc
abstract mixin class _$GachaItemCopyWith<$Res> implements $GachaItemCopyWith<$Res> {
  factory _$GachaItemCopyWith(_GachaItem value, $Res Function(_GachaItem) _then) = __$GachaItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'image_url') String imageUrl, double percent,@JsonKey(name: 'percent_open') bool percentOpen
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
@override @pragma('vm:prefer-inline') $Res call({Object? itemName = null,Object? imageUrl = null,Object? percent = null,Object? percentOpen = null,}) {
  return _then(_GachaItem(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double,percentOpen: null == percentOpen ? _self.percentOpen : percentOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
