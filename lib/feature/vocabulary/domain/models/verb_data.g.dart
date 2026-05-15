// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verb_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerbData _$VerbDataFromJson(Map<String, dynamic> json) => _VerbData(
  auxiliary: $enumDecode(_$VerbAuxiliaryEnumMap, json['auxiliary']),
  partizip2: json['partizip2'] as String,
  isSeparable: json['isSeparable'] as bool,
  separablePrefix: json['separablePrefix'] as String?,
  conjugation: Map<String, String>.from(json['conjugation'] as Map),
  governs: $enumDecodeNullable(_$GovernsCaseEnumMap, json['governs']),
);

Map<String, dynamic> _$VerbDataToJson(_VerbData instance) => <String, dynamic>{
  'auxiliary': _$VerbAuxiliaryEnumMap[instance.auxiliary]!,
  'partizip2': instance.partizip2,
  'isSeparable': instance.isSeparable,
  'separablePrefix': instance.separablePrefix,
  'conjugation': instance.conjugation,
  'governs': _$GovernsCaseEnumMap[instance.governs],
};

const _$VerbAuxiliaryEnumMap = {
  VerbAuxiliary.haben: 'haben',
  VerbAuxiliary.sein: 'sein',
};

const _$GovernsCaseEnumMap = {
  GovernsCase.akkusativ: 'Akkusativ',
  GovernsCase.dativ: 'Dativ',
  GovernsCase.genitiv: 'Genitiv',
};
