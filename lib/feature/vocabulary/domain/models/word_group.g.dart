// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WordGroup _$WordGroupFromJson(Map<String, dynamic> json) => _WordGroup(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  type: $enumDecode(_$WordGroupTypeEnumMap, json['type']),
  wordIds:
      (json['wordIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
);

Map<String, dynamic> _$WordGroupToJson(_WordGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$WordGroupTypeEnumMap[instance.type]!,
      'wordIds': instance.wordIds,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$WordGroupTypeEnumMap = {
  WordGroupType.user: 'user',
  WordGroupType.aiRecommended: 'aiRecommended',
};
