import 'package:elia/core/utils/timestamp_converter.dart';
import 'package:elia/feature/vocabulary/domain/models/adjective_data.dart';
import 'package:elia/feature/vocabulary/domain/models/enums.dart';
import 'package:elia/feature/vocabulary/domain/models/example_sentence.dart';
import 'package:elia/feature/vocabulary/domain/models/noun_data.dart';
import 'package:elia/feature/vocabulary/domain/models/verb_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'word_entry.freezed.dart';
part 'word_entry.g.dart';

@freezed
abstract class WordEntry with _$WordEntry {
  const factory WordEntry({
    required String id,
    required String word,
    required WordType type,
    required CefrLevel level,
    required Register register,
    required List<String> translations,
    NounData? noun,
    VerbData? verb,
    AdjectiveData? adjective,
    required List<ExampleSentence> examples,
    String? mnemonic,
    required List<String> relatedWords,
    @TimestampConverter() required DateTime cachedAt,
  }) = _WordEntry;

  factory WordEntry.fromJson(Map<String, dynamic> json) =>
      _$WordEntryFromJson(json);
}
