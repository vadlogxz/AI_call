import 'package:elia/core/utils/timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_word.freezed.dart';
part 'user_word.g.dart';

@freezed
abstract class UserWord with _$UserWord{

  const UserWord._();

  const factory UserWord({
    required String wordId,
    @TimestampConverter() required DateTime addedAt,
    @Default([]) List<String> groupIds,
    required int repetitions,
    required double easeFactor,
    required int interval,
    @TimestampConverter() required DateTime nextReview,
  }) = _UserWord;

  bool get isDueToday =>
      nextReview.isBefore(DateTime.now().add(const Duration(days: 1)));

  bool get learned => interval >= 21;

  factory UserWord.fromJson(Map<String, dynamic> json) => _$UserWordFromJson(json);
}