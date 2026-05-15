// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserWord _$UserWordFromJson(Map<String, dynamic> json) => _UserWord(
  wordId: json['wordId'] as String,
  addedAt: const TimestampConverter().fromJson(json['addedAt'] as Object),
  groupIds:
      (json['groupIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  repetitions: (json['repetitions'] as num).toInt(),
  easeFactor: (json['easeFactor'] as num).toDouble(),
  interval: (json['interval'] as num).toInt(),
  nextReview: const TimestampConverter().fromJson(json['nextReview'] as Object),
);

Map<String, dynamic> _$UserWordToJson(_UserWord instance) => <String, dynamic>{
  'wordId': instance.wordId,
  'addedAt': const TimestampConverter().toJson(instance.addedAt),
  'groupIds': instance.groupIds,
  'repetitions': instance.repetitions,
  'easeFactor': instance.easeFactor,
  'interval': instance.interval,
  'nextReview': const TimestampConverter().toJson(instance.nextReview),
};
