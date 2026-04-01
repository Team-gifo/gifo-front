// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GiftRequest {

 String get user;@JsonKey(name: 'sub_title') String get subTitle; String get bgm; String get password;@JsonKey(name: 'sender_name') String get senderName; List<GalleryItem> get gallery;@JsonKey(name: 'uploaded_bgm_urls') List<String> get uploadedBgmUrls;@JsonKey(name: 'expired_at', includeIfNull: false) String? get expiredAt; GiftContent get content;
/// Create a copy of GiftRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GiftRequestCopyWith<GiftRequest> get copyWith => _$GiftRequestCopyWithImpl<GiftRequest>(this as GiftRequest, _$identity);

  /// Serializes this GiftRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GiftRequest&&(identical(other.user, user) || other.user == user)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.bgm, bgm) || other.bgm == bgm)&&(identical(other.password, password) || other.password == password)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&const DeepCollectionEquality().equals(other.gallery, gallery)&&const DeepCollectionEquality().equals(other.uploadedBgmUrls, uploadedBgmUrls)&&(identical(other.expiredAt, expiredAt) || other.expiredAt == expiredAt)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,subTitle,bgm,password,senderName,const DeepCollectionEquality().hash(gallery),const DeepCollectionEquality().hash(uploadedBgmUrls),expiredAt,content);

@override
String toString() {
  return 'GiftRequest(user: $user, subTitle: $subTitle, bgm: $bgm, password: $password, senderName: $senderName, gallery: $gallery, uploadedBgmUrls: $uploadedBgmUrls, expiredAt: $expiredAt, content: $content)';
}


}

/// @nodoc
abstract mixin class $GiftRequestCopyWith<$Res>  {
  factory $GiftRequestCopyWith(GiftRequest value, $Res Function(GiftRequest) _then) = _$GiftRequestCopyWithImpl;
@useResult
$Res call({
 String user,@JsonKey(name: 'sub_title') String subTitle, String bgm, String password,@JsonKey(name: 'sender_name') String senderName, List<GalleryItem> gallery,@JsonKey(name: 'uploaded_bgm_urls') List<String> uploadedBgmUrls,@JsonKey(name: 'expired_at', includeIfNull: false) String? expiredAt, GiftContent content
});


$GiftContentCopyWith<$Res> get content;

}
/// @nodoc
class _$GiftRequestCopyWithImpl<$Res>
    implements $GiftRequestCopyWith<$Res> {
  _$GiftRequestCopyWithImpl(this._self, this._then);

  final GiftRequest _self;
  final $Res Function(GiftRequest) _then;

/// Create a copy of GiftRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? subTitle = null,Object? bgm = null,Object? password = null,Object? senderName = null,Object? gallery = null,Object? uploadedBgmUrls = null,Object? expiredAt = freezed,Object? content = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,subTitle: null == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String,bgm: null == bgm ? _self.bgm : bgm // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,gallery: null == gallery ? _self.gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<GalleryItem>,uploadedBgmUrls: null == uploadedBgmUrls ? _self.uploadedBgmUrls : uploadedBgmUrls // ignore: cast_nullable_to_non_nullable
as List<String>,expiredAt: freezed == expiredAt ? _self.expiredAt : expiredAt // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as GiftContent,
  ));
}
/// Create a copy of GiftRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GiftContentCopyWith<$Res> get content {
  
  return $GiftContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [GiftRequest].
extension GiftRequestPatterns on GiftRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GiftRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GiftRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GiftRequest value)  $default,){
final _that = this;
switch (_that) {
case _GiftRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GiftRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GiftRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String user, @JsonKey(name: 'sub_title')  String subTitle,  String bgm,  String password, @JsonKey(name: 'sender_name')  String senderName,  List<GalleryItem> gallery, @JsonKey(name: 'uploaded_bgm_urls')  List<String> uploadedBgmUrls, @JsonKey(name: 'expired_at', includeIfNull: false)  String? expiredAt,  GiftContent content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GiftRequest() when $default != null:
return $default(_that.user,_that.subTitle,_that.bgm,_that.password,_that.senderName,_that.gallery,_that.uploadedBgmUrls,_that.expiredAt,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String user, @JsonKey(name: 'sub_title')  String subTitle,  String bgm,  String password, @JsonKey(name: 'sender_name')  String senderName,  List<GalleryItem> gallery, @JsonKey(name: 'uploaded_bgm_urls')  List<String> uploadedBgmUrls, @JsonKey(name: 'expired_at', includeIfNull: false)  String? expiredAt,  GiftContent content)  $default,) {final _that = this;
switch (_that) {
case _GiftRequest():
return $default(_that.user,_that.subTitle,_that.bgm,_that.password,_that.senderName,_that.gallery,_that.uploadedBgmUrls,_that.expiredAt,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String user, @JsonKey(name: 'sub_title')  String subTitle,  String bgm,  String password, @JsonKey(name: 'sender_name')  String senderName,  List<GalleryItem> gallery, @JsonKey(name: 'uploaded_bgm_urls')  List<String> uploadedBgmUrls, @JsonKey(name: 'expired_at', includeIfNull: false)  String? expiredAt,  GiftContent content)?  $default,) {final _that = this;
switch (_that) {
case _GiftRequest() when $default != null:
return $default(_that.user,_that.subTitle,_that.bgm,_that.password,_that.senderName,_that.gallery,_that.uploadedBgmUrls,_that.expiredAt,_that.content);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GiftRequest implements GiftRequest {
  const _GiftRequest({this.user = '', @JsonKey(name: 'sub_title') this.subTitle = '', this.bgm = '', this.password = '', @JsonKey(name: 'sender_name') this.senderName = '', final  List<GalleryItem> gallery = const <GalleryItem>[], @JsonKey(name: 'uploaded_bgm_urls') final  List<String> uploadedBgmUrls = const <String>[], @JsonKey(name: 'expired_at', includeIfNull: false) this.expiredAt, required this.content}): _gallery = gallery,_uploadedBgmUrls = uploadedBgmUrls;
  factory _GiftRequest.fromJson(Map<String, dynamic> json) => _$GiftRequestFromJson(json);

@override@JsonKey() final  String user;
@override@JsonKey(name: 'sub_title') final  String subTitle;
@override@JsonKey() final  String bgm;
@override@JsonKey() final  String password;
@override@JsonKey(name: 'sender_name') final  String senderName;
 final  List<GalleryItem> _gallery;
@override@JsonKey() List<GalleryItem> get gallery {
  if (_gallery is EqualUnmodifiableListView) return _gallery;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gallery);
}

 final  List<String> _uploadedBgmUrls;
@override@JsonKey(name: 'uploaded_bgm_urls') List<String> get uploadedBgmUrls {
  if (_uploadedBgmUrls is EqualUnmodifiableListView) return _uploadedBgmUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uploadedBgmUrls);
}

@override@JsonKey(name: 'expired_at', includeIfNull: false) final  String? expiredAt;
@override final  GiftContent content;

/// Create a copy of GiftRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GiftRequestCopyWith<_GiftRequest> get copyWith => __$GiftRequestCopyWithImpl<_GiftRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GiftRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GiftRequest&&(identical(other.user, user) || other.user == user)&&(identical(other.subTitle, subTitle) || other.subTitle == subTitle)&&(identical(other.bgm, bgm) || other.bgm == bgm)&&(identical(other.password, password) || other.password == password)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&const DeepCollectionEquality().equals(other._gallery, _gallery)&&const DeepCollectionEquality().equals(other._uploadedBgmUrls, _uploadedBgmUrls)&&(identical(other.expiredAt, expiredAt) || other.expiredAt == expiredAt)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,subTitle,bgm,password,senderName,const DeepCollectionEquality().hash(_gallery),const DeepCollectionEquality().hash(_uploadedBgmUrls),expiredAt,content);

@override
String toString() {
  return 'GiftRequest(user: $user, subTitle: $subTitle, bgm: $bgm, password: $password, senderName: $senderName, gallery: $gallery, uploadedBgmUrls: $uploadedBgmUrls, expiredAt: $expiredAt, content: $content)';
}


}

/// @nodoc
abstract mixin class _$GiftRequestCopyWith<$Res> implements $GiftRequestCopyWith<$Res> {
  factory _$GiftRequestCopyWith(_GiftRequest value, $Res Function(_GiftRequest) _then) = __$GiftRequestCopyWithImpl;
@override @useResult
$Res call({
 String user,@JsonKey(name: 'sub_title') String subTitle, String bgm, String password,@JsonKey(name: 'sender_name') String senderName, List<GalleryItem> gallery,@JsonKey(name: 'uploaded_bgm_urls') List<String> uploadedBgmUrls,@JsonKey(name: 'expired_at', includeIfNull: false) String? expiredAt, GiftContent content
});


@override $GiftContentCopyWith<$Res> get content;

}
/// @nodoc
class __$GiftRequestCopyWithImpl<$Res>
    implements _$GiftRequestCopyWith<$Res> {
  __$GiftRequestCopyWithImpl(this._self, this._then);

  final _GiftRequest _self;
  final $Res Function(_GiftRequest) _then;

/// Create a copy of GiftRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? subTitle = null,Object? bgm = null,Object? password = null,Object? senderName = null,Object? gallery = null,Object? uploadedBgmUrls = null,Object? expiredAt = freezed,Object? content = null,}) {
  return _then(_GiftRequest(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,subTitle: null == subTitle ? _self.subTitle : subTitle // ignore: cast_nullable_to_non_nullable
as String,bgm: null == bgm ? _self.bgm : bgm // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,gallery: null == gallery ? _self._gallery : gallery // ignore: cast_nullable_to_non_nullable
as List<GalleryItem>,uploadedBgmUrls: null == uploadedBgmUrls ? _self._uploadedBgmUrls : uploadedBgmUrls // ignore: cast_nullable_to_non_nullable
as List<String>,expiredAt: freezed == expiredAt ? _self.expiredAt : expiredAt // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as GiftContent,
  ));
}

/// Create a copy of GiftRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GiftContentCopyWith<$Res> get content {
  
  return $GiftContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
