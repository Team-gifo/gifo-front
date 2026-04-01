// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unboxing_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnboxingContent {

@JsonKey(name: 'before_open') BeforeOpen get beforeOpen;@JsonKey(name: 'after_open') AfterOpen get afterOpen;
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
@JsonKey(name: 'before_open') BeforeOpen beforeOpen,@JsonKey(name: 'after_open') AfterOpen afterOpen
});


$BeforeOpenCopyWith<$Res> get beforeOpen;$AfterOpenCopyWith<$Res> get afterOpen;

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
as BeforeOpen,afterOpen: null == afterOpen ? _self.afterOpen : afterOpen // ignore: cast_nullable_to_non_nullable
as AfterOpen,
  ));
}
/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeforeOpenCopyWith<$Res> get beforeOpen {
  
  return $BeforeOpenCopyWith<$Res>(_self.beforeOpen, (value) {
    return _then(_self.copyWith(beforeOpen: value));
  });
}/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AfterOpenCopyWith<$Res> get afterOpen {
  
  return $AfterOpenCopyWith<$Res>(_self.afterOpen, (value) {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'before_open')  BeforeOpen beforeOpen, @JsonKey(name: 'after_open')  AfterOpen afterOpen)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'before_open')  BeforeOpen beforeOpen, @JsonKey(name: 'after_open')  AfterOpen afterOpen)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'before_open')  BeforeOpen beforeOpen, @JsonKey(name: 'after_open')  AfterOpen afterOpen)?  $default,) {final _that = this;
switch (_that) {
case _UnboxingContent() when $default != null:
return $default(_that.beforeOpen,_that.afterOpen);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UnboxingContent implements UnboxingContent {
  const _UnboxingContent({@JsonKey(name: 'before_open') required this.beforeOpen, @JsonKey(name: 'after_open') required this.afterOpen});
  factory _UnboxingContent.fromJson(Map<String, dynamic> json) => _$UnboxingContentFromJson(json);

@override@JsonKey(name: 'before_open') final  BeforeOpen beforeOpen;
@override@JsonKey(name: 'after_open') final  AfterOpen afterOpen;

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
@JsonKey(name: 'before_open') BeforeOpen beforeOpen,@JsonKey(name: 'after_open') AfterOpen afterOpen
});


@override $BeforeOpenCopyWith<$Res> get beforeOpen;@override $AfterOpenCopyWith<$Res> get afterOpen;

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
as BeforeOpen,afterOpen: null == afterOpen ? _self.afterOpen : afterOpen // ignore: cast_nullable_to_non_nullable
as AfterOpen,
  ));
}

/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BeforeOpenCopyWith<$Res> get beforeOpen {
  
  return $BeforeOpenCopyWith<$Res>(_self.beforeOpen, (value) {
    return _then(_self.copyWith(beforeOpen: value));
  });
}/// Create a copy of UnboxingContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AfterOpenCopyWith<$Res> get afterOpen {
  
  return $AfterOpenCopyWith<$Res>(_self.afterOpen, (value) {
    return _then(_self.copyWith(afterOpen: value));
  });
}
}


/// @nodoc
mixin _$BeforeOpen {

@JsonKey(name: 'image_url') String get imageUrl; String get description;
/// Create a copy of BeforeOpen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeforeOpenCopyWith<BeforeOpen> get copyWith => _$BeforeOpenCopyWithImpl<BeforeOpen>(this as BeforeOpen, _$identity);

  /// Serializes this BeforeOpen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeforeOpen&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,description);

@override
String toString() {
  return 'BeforeOpen(imageUrl: $imageUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class $BeforeOpenCopyWith<$Res>  {
  factory $BeforeOpenCopyWith(BeforeOpen value, $Res Function(BeforeOpen) _then) = _$BeforeOpenCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'image_url') String imageUrl, String description
});




}
/// @nodoc
class _$BeforeOpenCopyWithImpl<$Res>
    implements $BeforeOpenCopyWith<$Res> {
  _$BeforeOpenCopyWithImpl(this._self, this._then);

  final BeforeOpen _self;
  final $Res Function(BeforeOpen) _then;

/// Create a copy of BeforeOpen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = null,Object? description = null,}) {
  return _then(_self.copyWith(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BeforeOpen].
extension BeforeOpenPatterns on BeforeOpen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeforeOpen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeforeOpen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeforeOpen value)  $default,){
final _that = this;
switch (_that) {
case _BeforeOpen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeforeOpen value)?  $default,){
final _that = this;
switch (_that) {
case _BeforeOpen() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'image_url')  String imageUrl,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeforeOpen() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'image_url')  String imageUrl,  String description)  $default,) {final _that = this;
switch (_that) {
case _BeforeOpen():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'image_url')  String imageUrl,  String description)?  $default,) {final _that = this;
switch (_that) {
case _BeforeOpen() when $default != null:
return $default(_that.imageUrl,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BeforeOpen implements BeforeOpen {
  const _BeforeOpen({@JsonKey(name: 'image_url') this.imageUrl = '', this.description = ''});
  factory _BeforeOpen.fromJson(Map<String, dynamic> json) => _$BeforeOpenFromJson(json);

@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey() final  String description;

/// Create a copy of BeforeOpen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeforeOpenCopyWith<_BeforeOpen> get copyWith => __$BeforeOpenCopyWithImpl<_BeforeOpen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeforeOpenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeforeOpen&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,description);

@override
String toString() {
  return 'BeforeOpen(imageUrl: $imageUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class _$BeforeOpenCopyWith<$Res> implements $BeforeOpenCopyWith<$Res> {
  factory _$BeforeOpenCopyWith(_BeforeOpen value, $Res Function(_BeforeOpen) _then) = __$BeforeOpenCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'image_url') String imageUrl, String description
});




}
/// @nodoc
class __$BeforeOpenCopyWithImpl<$Res>
    implements _$BeforeOpenCopyWith<$Res> {
  __$BeforeOpenCopyWithImpl(this._self, this._then);

  final _BeforeOpen _self;
  final $Res Function(_BeforeOpen) _then;

/// Create a copy of BeforeOpen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageUrl = null,Object? description = null,}) {
  return _then(_BeforeOpen(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AfterOpen {

@JsonKey(name: 'item_name') String get itemName;@JsonKey(name: 'image_url') String get imageUrl;
/// Create a copy of AfterOpen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AfterOpenCopyWith<AfterOpen> get copyWith => _$AfterOpenCopyWithImpl<AfterOpen>(this as AfterOpen, _$identity);

  /// Serializes this AfterOpen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AfterOpen&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl);

@override
String toString() {
  return 'AfterOpen(itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $AfterOpenCopyWith<$Res>  {
  factory $AfterOpenCopyWith(AfterOpen value, $Res Function(AfterOpen) _then) = _$AfterOpenCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class _$AfterOpenCopyWithImpl<$Res>
    implements $AfterOpenCopyWith<$Res> {
  _$AfterOpenCopyWithImpl(this._self, this._then);

  final AfterOpen _self;
  final $Res Function(AfterOpen) _then;

/// Create a copy of AfterOpen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AfterOpen].
extension AfterOpenPatterns on AfterOpen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AfterOpen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AfterOpen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AfterOpen value)  $default,){
final _that = this;
switch (_that) {
case _AfterOpen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AfterOpen value)?  $default,){
final _that = this;
switch (_that) {
case _AfterOpen() when $default != null:
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
case _AfterOpen() when $default != null:
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
case _AfterOpen():
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
case _AfterOpen() when $default != null:
return $default(_that.itemName,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AfterOpen implements AfterOpen {
  const _AfterOpen({@JsonKey(name: 'item_name') this.itemName = '', @JsonKey(name: 'image_url') this.imageUrl = ''});
  factory _AfterOpen.fromJson(Map<String, dynamic> json) => _$AfterOpenFromJson(json);

@override@JsonKey(name: 'item_name') final  String itemName;
@override@JsonKey(name: 'image_url') final  String imageUrl;

/// Create a copy of AfterOpen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AfterOpenCopyWith<_AfterOpen> get copyWith => __$AfterOpenCopyWithImpl<_AfterOpen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AfterOpenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AfterOpen&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemName,imageUrl);

@override
String toString() {
  return 'AfterOpen(itemName: $itemName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$AfterOpenCopyWith<$Res> implements $AfterOpenCopyWith<$Res> {
  factory _$AfterOpenCopyWith(_AfterOpen value, $Res Function(_AfterOpen) _then) = __$AfterOpenCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'item_name') String itemName,@JsonKey(name: 'image_url') String imageUrl
});




}
/// @nodoc
class __$AfterOpenCopyWithImpl<$Res>
    implements _$AfterOpenCopyWith<$Res> {
  __$AfterOpenCopyWithImpl(this._self, this._then);

  final _AfterOpen _self;
  final $Res Function(_AfterOpen) _then;

/// Create a copy of AfterOpen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemName = null,Object? imageUrl = null,}) {
  return _then(_AfterOpen(
itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
