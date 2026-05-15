// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WordEntry {

 String get id; String get word; WordType get type; CefrLevel get level; Register get register; List<String> get translations; NounData? get noun; VerbData? get verb; AdjectiveData? get adjective; List<ExampleSentence> get examples; String? get mnemonic; List<String> get relatedWords;@TimestampConverter() DateTime get cachedAt;
/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordEntryCopyWith<WordEntry> get copyWith => _$WordEntryCopyWithImpl<WordEntry>(this as WordEntry, _$identity);

  /// Serializes this WordEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WordEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&(identical(other.type, type) || other.type == type)&&(identical(other.level, level) || other.level == level)&&(identical(other.register, register) || other.register == register)&&const DeepCollectionEquality().equals(other.translations, translations)&&(identical(other.noun, noun) || other.noun == noun)&&(identical(other.verb, verb) || other.verb == verb)&&(identical(other.adjective, adjective) || other.adjective == adjective)&&const DeepCollectionEquality().equals(other.examples, examples)&&(identical(other.mnemonic, mnemonic) || other.mnemonic == mnemonic)&&const DeepCollectionEquality().equals(other.relatedWords, relatedWords)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,word,type,level,register,const DeepCollectionEquality().hash(translations),noun,verb,adjective,const DeepCollectionEquality().hash(examples),mnemonic,const DeepCollectionEquality().hash(relatedWords),cachedAt);

@override
String toString() {
  return 'WordEntry(id: $id, word: $word, type: $type, level: $level, register: $register, translations: $translations, noun: $noun, verb: $verb, adjective: $adjective, examples: $examples, mnemonic: $mnemonic, relatedWords: $relatedWords, cachedAt: $cachedAt)';
}


}

/// @nodoc
abstract mixin class $WordEntryCopyWith<$Res>  {
  factory $WordEntryCopyWith(WordEntry value, $Res Function(WordEntry) _then) = _$WordEntryCopyWithImpl;
@useResult
$Res call({
 String id, String word, WordType type, CefrLevel level, Register register, List<String> translations, NounData? noun, VerbData? verb, AdjectiveData? adjective, List<ExampleSentence> examples, String? mnemonic, List<String> relatedWords,@TimestampConverter() DateTime cachedAt
});


$NounDataCopyWith<$Res>? get noun;$VerbDataCopyWith<$Res>? get verb;$AdjectiveDataCopyWith<$Res>? get adjective;

}
/// @nodoc
class _$WordEntryCopyWithImpl<$Res>
    implements $WordEntryCopyWith<$Res> {
  _$WordEntryCopyWithImpl(this._self, this._then);

  final WordEntry _self;
  final $Res Function(WordEntry) _then;

/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? word = null,Object? type = null,Object? level = null,Object? register = null,Object? translations = null,Object? noun = freezed,Object? verb = freezed,Object? adjective = freezed,Object? examples = null,Object? mnemonic = freezed,Object? relatedWords = null,Object? cachedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WordType,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CefrLevel,register: null == register ? _self.register : register // ignore: cast_nullable_to_non_nullable
as Register,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as List<String>,noun: freezed == noun ? _self.noun : noun // ignore: cast_nullable_to_non_nullable
as NounData?,verb: freezed == verb ? _self.verb : verb // ignore: cast_nullable_to_non_nullable
as VerbData?,adjective: freezed == adjective ? _self.adjective : adjective // ignore: cast_nullable_to_non_nullable
as AdjectiveData?,examples: null == examples ? _self.examples : examples // ignore: cast_nullable_to_non_nullable
as List<ExampleSentence>,mnemonic: freezed == mnemonic ? _self.mnemonic : mnemonic // ignore: cast_nullable_to_non_nullable
as String?,relatedWords: null == relatedWords ? _self.relatedWords : relatedWords // ignore: cast_nullable_to_non_nullable
as List<String>,cachedAt: null == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NounDataCopyWith<$Res>? get noun {
    if (_self.noun == null) {
    return null;
  }

  return $NounDataCopyWith<$Res>(_self.noun!, (value) {
    return _then(_self.copyWith(noun: value));
  });
}/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerbDataCopyWith<$Res>? get verb {
    if (_self.verb == null) {
    return null;
  }

  return $VerbDataCopyWith<$Res>(_self.verb!, (value) {
    return _then(_self.copyWith(verb: value));
  });
}/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdjectiveDataCopyWith<$Res>? get adjective {
    if (_self.adjective == null) {
    return null;
  }

  return $AdjectiveDataCopyWith<$Res>(_self.adjective!, (value) {
    return _then(_self.copyWith(adjective: value));
  });
}
}


/// Adds pattern-matching-related methods to [WordEntry].
extension WordEntryPatterns on WordEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WordEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WordEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WordEntry value)  $default,){
final _that = this;
switch (_that) {
case _WordEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WordEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WordEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String word,  WordType type,  CefrLevel level,  Register register,  List<String> translations,  NounData? noun,  VerbData? verb,  AdjectiveData? adjective,  List<ExampleSentence> examples,  String? mnemonic,  List<String> relatedWords, @TimestampConverter()  DateTime cachedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WordEntry() when $default != null:
return $default(_that.id,_that.word,_that.type,_that.level,_that.register,_that.translations,_that.noun,_that.verb,_that.adjective,_that.examples,_that.mnemonic,_that.relatedWords,_that.cachedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String word,  WordType type,  CefrLevel level,  Register register,  List<String> translations,  NounData? noun,  VerbData? verb,  AdjectiveData? adjective,  List<ExampleSentence> examples,  String? mnemonic,  List<String> relatedWords, @TimestampConverter()  DateTime cachedAt)  $default,) {final _that = this;
switch (_that) {
case _WordEntry():
return $default(_that.id,_that.word,_that.type,_that.level,_that.register,_that.translations,_that.noun,_that.verb,_that.adjective,_that.examples,_that.mnemonic,_that.relatedWords,_that.cachedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String word,  WordType type,  CefrLevel level,  Register register,  List<String> translations,  NounData? noun,  VerbData? verb,  AdjectiveData? adjective,  List<ExampleSentence> examples,  String? mnemonic,  List<String> relatedWords, @TimestampConverter()  DateTime cachedAt)?  $default,) {final _that = this;
switch (_that) {
case _WordEntry() when $default != null:
return $default(_that.id,_that.word,_that.type,_that.level,_that.register,_that.translations,_that.noun,_that.verb,_that.adjective,_that.examples,_that.mnemonic,_that.relatedWords,_that.cachedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WordEntry implements WordEntry {
  const _WordEntry({required this.id, required this.word, required this.type, required this.level, required this.register, required final  List<String> translations, this.noun, this.verb, this.adjective, required final  List<ExampleSentence> examples, this.mnemonic, required final  List<String> relatedWords, @TimestampConverter() required this.cachedAt}): _translations = translations,_examples = examples,_relatedWords = relatedWords;
  factory _WordEntry.fromJson(Map<String, dynamic> json) => _$WordEntryFromJson(json);

@override final  String id;
@override final  String word;
@override final  WordType type;
@override final  CefrLevel level;
@override final  Register register;
 final  List<String> _translations;
@override List<String> get translations {
  if (_translations is EqualUnmodifiableListView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_translations);
}

@override final  NounData? noun;
@override final  VerbData? verb;
@override final  AdjectiveData? adjective;
 final  List<ExampleSentence> _examples;
@override List<ExampleSentence> get examples {
  if (_examples is EqualUnmodifiableListView) return _examples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_examples);
}

@override final  String? mnemonic;
 final  List<String> _relatedWords;
@override List<String> get relatedWords {
  if (_relatedWords is EqualUnmodifiableListView) return _relatedWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedWords);
}

@override@TimestampConverter() final  DateTime cachedAt;

/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WordEntryCopyWith<_WordEntry> get copyWith => __$WordEntryCopyWithImpl<_WordEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WordEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WordEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&(identical(other.type, type) || other.type == type)&&(identical(other.level, level) || other.level == level)&&(identical(other.register, register) || other.register == register)&&const DeepCollectionEquality().equals(other._translations, _translations)&&(identical(other.noun, noun) || other.noun == noun)&&(identical(other.verb, verb) || other.verb == verb)&&(identical(other.adjective, adjective) || other.adjective == adjective)&&const DeepCollectionEquality().equals(other._examples, _examples)&&(identical(other.mnemonic, mnemonic) || other.mnemonic == mnemonic)&&const DeepCollectionEquality().equals(other._relatedWords, _relatedWords)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,word,type,level,register,const DeepCollectionEquality().hash(_translations),noun,verb,adjective,const DeepCollectionEquality().hash(_examples),mnemonic,const DeepCollectionEquality().hash(_relatedWords),cachedAt);

@override
String toString() {
  return 'WordEntry(id: $id, word: $word, type: $type, level: $level, register: $register, translations: $translations, noun: $noun, verb: $verb, adjective: $adjective, examples: $examples, mnemonic: $mnemonic, relatedWords: $relatedWords, cachedAt: $cachedAt)';
}


}

/// @nodoc
abstract mixin class _$WordEntryCopyWith<$Res> implements $WordEntryCopyWith<$Res> {
  factory _$WordEntryCopyWith(_WordEntry value, $Res Function(_WordEntry) _then) = __$WordEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String word, WordType type, CefrLevel level, Register register, List<String> translations, NounData? noun, VerbData? verb, AdjectiveData? adjective, List<ExampleSentence> examples, String? mnemonic, List<String> relatedWords,@TimestampConverter() DateTime cachedAt
});


@override $NounDataCopyWith<$Res>? get noun;@override $VerbDataCopyWith<$Res>? get verb;@override $AdjectiveDataCopyWith<$Res>? get adjective;

}
/// @nodoc
class __$WordEntryCopyWithImpl<$Res>
    implements _$WordEntryCopyWith<$Res> {
  __$WordEntryCopyWithImpl(this._self, this._then);

  final _WordEntry _self;
  final $Res Function(_WordEntry) _then;

/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? word = null,Object? type = null,Object? level = null,Object? register = null,Object? translations = null,Object? noun = freezed,Object? verb = freezed,Object? adjective = freezed,Object? examples = null,Object? mnemonic = freezed,Object? relatedWords = null,Object? cachedAt = null,}) {
  return _then(_WordEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WordType,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CefrLevel,register: null == register ? _self.register : register // ignore: cast_nullable_to_non_nullable
as Register,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as List<String>,noun: freezed == noun ? _self.noun : noun // ignore: cast_nullable_to_non_nullable
as NounData?,verb: freezed == verb ? _self.verb : verb // ignore: cast_nullable_to_non_nullable
as VerbData?,adjective: freezed == adjective ? _self.adjective : adjective // ignore: cast_nullable_to_non_nullable
as AdjectiveData?,examples: null == examples ? _self._examples : examples // ignore: cast_nullable_to_non_nullable
as List<ExampleSentence>,mnemonic: freezed == mnemonic ? _self.mnemonic : mnemonic // ignore: cast_nullable_to_non_nullable
as String?,relatedWords: null == relatedWords ? _self._relatedWords : relatedWords // ignore: cast_nullable_to_non_nullable
as List<String>,cachedAt: null == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NounDataCopyWith<$Res>? get noun {
    if (_self.noun == null) {
    return null;
  }

  return $NounDataCopyWith<$Res>(_self.noun!, (value) {
    return _then(_self.copyWith(noun: value));
  });
}/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerbDataCopyWith<$Res>? get verb {
    if (_self.verb == null) {
    return null;
  }

  return $VerbDataCopyWith<$Res>(_self.verb!, (value) {
    return _then(_self.copyWith(verb: value));
  });
}/// Create a copy of WordEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdjectiveDataCopyWith<$Res>? get adjective {
    if (_self.adjective == null) {
    return null;
  }

  return $AdjectiveDataCopyWith<$Res>(_self.adjective!, (value) {
    return _then(_self.copyWith(adjective: value));
  });
}
}

// dart format on
