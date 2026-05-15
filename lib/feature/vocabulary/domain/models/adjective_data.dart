import 'package:freezed_annotation/freezed_annotation.dart';

part 'adjective_data.freezed.dart';
part 'adjective_data.g.dart';

@freezed
abstract class AdjectiveData with _$AdjectiveData {
  const factory AdjectiveData({
    required String comparative,
    required String superlative,
  }) = _AdjectiveData;

  factory AdjectiveData.fromJson(Map<String, dynamic> json) =>
      _$AdjectiveDataFromJson(json);
}
