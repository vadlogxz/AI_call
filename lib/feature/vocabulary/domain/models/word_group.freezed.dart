// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WordGroup {

 String get id; String get name; String? get description; WordGroupType get type; List<String> get wordIds;@TimestampConverter() DateTime get createdAt;
/// Create a copy of WordGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordGroupCopyWith<WordGroup> get copyWith => _$WordGroupCopyWithImpl<WordGroup>(this as WordGroup, _$identity);

  /// Serializes this WordGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WordGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.wordIds, wordIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,type,const DeepCollectionEquality().hash(wordIds),createdAt);

@override
String toString() {
  return 'WordGroup(id: $id, name: $name, description: $description, type: $type, wordIds: $wordIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WordGroupCopyWith<$Res>  {
  factory $WordGroupCopyWith(WordGroup value, $Res Function(WordGroup) _then) = _$WordGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, WordGroupType type, List<String> wordIds,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class _$WordGroupCopyWithImpl<$Res>
    implements $WordGroupCopyWith<$Res> {
  _$WordGroupCopyWithImpl(this._self, this._then);

  final WordGroup _self;
  final $Res Function(WordGroup) _then;

/// Create a copy of WordGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? type = null,Object? wordIds = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WordGroupType,wordIds: null == wordIds ? _self.wordIds : wordIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WordGroup].
extension WordGroupPatterns on WordGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WordGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WordGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WordGroup value)  $default,){
final _that = this;
switch (_that) {
case _WordGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WordGroup value)?  $default,){
final _that = this;
switch (_that) {
case _WordGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  WordGroupType type,  List<String> wordIds, @TimestampConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WordGroup() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.type,_that.wordIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  WordGroupType type,  List<String> wordIds, @TimestampConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _WordGroup():
return $default(_that.id,_that.name,_that.description,_that.type,_that.wordIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  WordGroupType type,  List<String> wordIds, @TimestampConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WordGroup() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.type,_that.wordIds,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WordGroup implements WordGroup {
  const _WordGroup({required this.id, required this.name, this.description, required this.type, final  List<String> wordIds = const [], @TimestampConverter() required this.createdAt}): _wordIds = wordIds;
  factory _WordGroup.fromJson(Map<String, dynamic> json) => _$WordGroupFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  WordGroupType type;
 final  List<String> _wordIds;
@override@JsonKey() List<String> get wordIds {
  if (_wordIds is EqualUnmodifiableListView) return _wordIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wordIds);
}

@override@TimestampConverter() final  DateTime createdAt;

/// Create a copy of WordGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WordGroupCopyWith<_WordGroup> get copyWith => __$WordGroupCopyWithImpl<_WordGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WordGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WordGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._wordIds, _wordIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,type,const DeepCollectionEquality().hash(_wordIds),createdAt);

@override
String toString() {
  return 'WordGroup(id: $id, name: $name, description: $description, type: $type, wordIds: $wordIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WordGroupCopyWith<$Res> implements $WordGroupCopyWith<$Res> {
  factory _$WordGroupCopyWith(_WordGroup value, $Res Function(_WordGroup) _then) = __$WordGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, WordGroupType type, List<String> wordIds,@TimestampConverter() DateTime createdAt
});




}
/// @nodoc
class __$WordGroupCopyWithImpl<$Res>
    implements _$WordGroupCopyWith<$Res> {
  __$WordGroupCopyWithImpl(this._self, this._then);

  final _WordGroup _self;
  final $Res Function(_WordGroup) _then;

/// Create a copy of WordGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? type = null,Object? wordIds = null,Object? createdAt = null,}) {
  return _then(_WordGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WordGroupType,wordIds: null == wordIds ? _self._wordIds : wordIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
