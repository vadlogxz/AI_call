// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserWord {

 String get wordId;@TimestampConverter() DateTime get addedAt; List<String> get groupIds; int get repetitions; double get easeFactor; int get interval;@TimestampConverter() DateTime get nextReview;
/// Create a copy of UserWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserWordCopyWith<UserWord> get copyWith => _$UserWordCopyWithImpl<UserWord>(this as UserWord, _$identity);

  /// Serializes this UserWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserWord&&(identical(other.wordId, wordId) || other.wordId == wordId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&const DeepCollectionEquality().equals(other.groupIds, groupIds)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.easeFactor, easeFactor) || other.easeFactor == easeFactor)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.nextReview, nextReview) || other.nextReview == nextReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wordId,addedAt,const DeepCollectionEquality().hash(groupIds),repetitions,easeFactor,interval,nextReview);

@override
String toString() {
  return 'UserWord(wordId: $wordId, addedAt: $addedAt, groupIds: $groupIds, repetitions: $repetitions, easeFactor: $easeFactor, interval: $interval, nextReview: $nextReview)';
}


}

/// @nodoc
abstract mixin class $UserWordCopyWith<$Res>  {
  factory $UserWordCopyWith(UserWord value, $Res Function(UserWord) _then) = _$UserWordCopyWithImpl;
@useResult
$Res call({
 String wordId,@TimestampConverter() DateTime addedAt, List<String> groupIds, int repetitions, double easeFactor, int interval,@TimestampConverter() DateTime nextReview
});




}
/// @nodoc
class _$UserWordCopyWithImpl<$Res>
    implements $UserWordCopyWith<$Res> {
  _$UserWordCopyWithImpl(this._self, this._then);

  final UserWord _self;
  final $Res Function(UserWord) _then;

/// Create a copy of UserWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wordId = null,Object? addedAt = null,Object? groupIds = null,Object? repetitions = null,Object? easeFactor = null,Object? interval = null,Object? nextReview = null,}) {
  return _then(_self.copyWith(
wordId: null == wordId ? _self.wordId : wordId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,groupIds: null == groupIds ? _self.groupIds : groupIds // ignore: cast_nullable_to_non_nullable
as List<String>,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as int,easeFactor: null == easeFactor ? _self.easeFactor : easeFactor // ignore: cast_nullable_to_non_nullable
as double,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,nextReview: null == nextReview ? _self.nextReview : nextReview // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserWord].
extension UserWordPatterns on UserWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserWord value)  $default,){
final _that = this;
switch (_that) {
case _UserWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserWord value)?  $default,){
final _that = this;
switch (_that) {
case _UserWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String wordId, @TimestampConverter()  DateTime addedAt,  List<String> groupIds,  int repetitions,  double easeFactor,  int interval, @TimestampConverter()  DateTime nextReview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserWord() when $default != null:
return $default(_that.wordId,_that.addedAt,_that.groupIds,_that.repetitions,_that.easeFactor,_that.interval,_that.nextReview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String wordId, @TimestampConverter()  DateTime addedAt,  List<String> groupIds,  int repetitions,  double easeFactor,  int interval, @TimestampConverter()  DateTime nextReview)  $default,) {final _that = this;
switch (_that) {
case _UserWord():
return $default(_that.wordId,_that.addedAt,_that.groupIds,_that.repetitions,_that.easeFactor,_that.interval,_that.nextReview);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String wordId, @TimestampConverter()  DateTime addedAt,  List<String> groupIds,  int repetitions,  double easeFactor,  int interval, @TimestampConverter()  DateTime nextReview)?  $default,) {final _that = this;
switch (_that) {
case _UserWord() when $default != null:
return $default(_that.wordId,_that.addedAt,_that.groupIds,_that.repetitions,_that.easeFactor,_that.interval,_that.nextReview);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserWord extends UserWord {
  const _UserWord({required this.wordId, @TimestampConverter() required this.addedAt, final  List<String> groupIds = const [], required this.repetitions, required this.easeFactor, required this.interval, @TimestampConverter() required this.nextReview}): _groupIds = groupIds,super._();
  factory _UserWord.fromJson(Map<String, dynamic> json) => _$UserWordFromJson(json);

@override final  String wordId;
@override@TimestampConverter() final  DateTime addedAt;
 final  List<String> _groupIds;
@override@JsonKey() List<String> get groupIds {
  if (_groupIds is EqualUnmodifiableListView) return _groupIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupIds);
}

@override final  int repetitions;
@override final  double easeFactor;
@override final  int interval;
@override@TimestampConverter() final  DateTime nextReview;

/// Create a copy of UserWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserWordCopyWith<_UserWord> get copyWith => __$UserWordCopyWithImpl<_UserWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserWord&&(identical(other.wordId, wordId) || other.wordId == wordId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&const DeepCollectionEquality().equals(other._groupIds, _groupIds)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.easeFactor, easeFactor) || other.easeFactor == easeFactor)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.nextReview, nextReview) || other.nextReview == nextReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wordId,addedAt,const DeepCollectionEquality().hash(_groupIds),repetitions,easeFactor,interval,nextReview);

@override
String toString() {
  return 'UserWord(wordId: $wordId, addedAt: $addedAt, groupIds: $groupIds, repetitions: $repetitions, easeFactor: $easeFactor, interval: $interval, nextReview: $nextReview)';
}


}

/// @nodoc
abstract mixin class _$UserWordCopyWith<$Res> implements $UserWordCopyWith<$Res> {
  factory _$UserWordCopyWith(_UserWord value, $Res Function(_UserWord) _then) = __$UserWordCopyWithImpl;
@override @useResult
$Res call({
 String wordId,@TimestampConverter() DateTime addedAt, List<String> groupIds, int repetitions, double easeFactor, int interval,@TimestampConverter() DateTime nextReview
});




}
/// @nodoc
class __$UserWordCopyWithImpl<$Res>
    implements _$UserWordCopyWith<$Res> {
  __$UserWordCopyWithImpl(this._self, this._then);

  final _UserWord _self;
  final $Res Function(_UserWord) _then;

/// Create a copy of UserWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wordId = null,Object? addedAt = null,Object? groupIds = null,Object? repetitions = null,Object? easeFactor = null,Object? interval = null,Object? nextReview = null,}) {
  return _then(_UserWord(
wordId: null == wordId ? _self.wordId : wordId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,groupIds: null == groupIds ? _self._groupIds : groupIds // ignore: cast_nullable_to_non_nullable
as List<String>,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as int,easeFactor: null == easeFactor ? _self.easeFactor : easeFactor // ignore: cast_nullable_to_non_nullable
as double,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,nextReview: null == nextReview ? _self.nextReview : nextReview // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
