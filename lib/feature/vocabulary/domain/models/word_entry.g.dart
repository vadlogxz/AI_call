// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WordEntry _$WordEntryFromJson(Map<String, dynamic> json) => _WordEntry(
  id: json['id'] as String,
  word: json['word'] as String,
  type: $enumDecode(_$WordTypeEnumMap, json['type']),
  level: $enumDecode(_$CefrLevelEnumMap, json['level']),
  register: $enumDecode(_$RegisterEnumMap, json['register']),
  translations: (json['translations'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  noun: json['noun'] == null
      ? null
      : NounData.fromJson(json['noun'] as Map<String, dynamic>),
  verb: json['verb'] == null
      ? null
      : VerbData.fromJson(json['verb'] as Map<String, dynamic>),
  adjective: json['adjective'] == null
      ? null
      : AdjectiveData.fromJson(json['adjective'] as Map<String, dynamic>),
  examples: (json['examples'] as List<dynamic>)
      .map((e) => ExampleSentence.fromJson(e as Map<String, dynamic>))
      .toList(),
  mnemonic: json['mnemonic'] as String?,
  relatedWords: (json['relatedWords'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  cachedAt: const TimestampConverter().fromJson(json['cachedAt'] as Object),
);

Map<String, dynamic> _$WordEntryToJson(_WordEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'type': _$WordTypeEnumMap[instance.type]!,
      'level': _$CefrLevelEnumMap[instance.level]!,
      'register': _$RegisterEnumMap[instance.register]!,
      'translations': instance.translations,
      'noun': instance.noun,
      'verb': instance.verb,
      'adjective': instance.adjective,
      'examples': instance.examples,
      'mnemonic': instance.mnemonic,
      'relatedWords': instance.relatedWords,
      'cachedAt': const TimestampConverter().toJson(instance.cachedAt),
    };

const _$WordTypeEnumMap = {
  WordType.noun: 'noun',
  WordType.verb: 'verb',
  WordType.adjective: 'adjective',
  WordType.adverb: 'adverb',
  WordType.phrase: 'phrase',
  WordType.other: 'other',
};

const _$CefrLevelEnumMap = {
  CefrLevel.a1: 'a1',
  CefrLevel.a2: 'a2',
  CefrLevel.b1: 'b1',
  CefrLevel.b2: 'b2',
  CefrLevel.c1: 'c1',
  CefrLevel.c2: 'c2',
};

const _$RegisterEnumMap = {
  Register.neutral: 'neutral',
  Register.formal: 'formal',
  Register.informal: 'informal',
  Register.colloquial: 'colloquial',
};
