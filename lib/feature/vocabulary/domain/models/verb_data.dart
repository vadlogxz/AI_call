import 'package:elia/feature/vocabulary/domain/models/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'verb_data.freezed.dart';
part 'verb_data.g.dart';

@freezed
abstract class VerbData with _$VerbData {
  const factory VerbData({
    required VerbAuxiliary auxiliary,
    required String partizip2,
    required bool isSeparable,
    String? separablePrefix,
    required Map<String, String> conjugation,
    GovernsCase? governs,
  }) = _VerbData;

  factory VerbData.fromJson(Map<String, dynamic> json) =>
      _$VerbDataFromJson(json);
}
