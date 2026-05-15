import 'package:elia/core/utils/timestamp_converter.dart';
import 'package:elia/feature/vocabulary/domain/models/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_group.freezed.dart';
part 'word_group.g.dart';

@freezed
abstract class WordGroup with _$WordGroup {
  const factory WordGroup({
    required String id,
    required String name,
    String? description,
    required WordGroupType type,
    @Default([]) List<String> wordIds,
    @TimestampConverter() required DateTime createdAt,
  }) = _WordGroup;

  factory WordGroup.fromJson(Map<String, dynamic> json) =>
      _$WordGroupFromJson(json);
}
