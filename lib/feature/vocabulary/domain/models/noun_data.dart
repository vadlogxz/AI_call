import 'package:freezed_annotation/freezed_annotation.dart';

part 'noun_data.freezed.dart';
part 'noun_data.g.dart';

@freezed
abstract class NounData with _$NounData {
  const factory NounData({
    required String article,
    required String plural,
    required String genitive,
  }) = _NounData;

  factory NounData.fromJson(Map<String, dynamic> json) => _$NounDataFromJson(json);
}
