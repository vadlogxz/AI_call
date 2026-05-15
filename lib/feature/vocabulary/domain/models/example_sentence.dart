import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_sentence.freezed.dart';
part 'example_sentence.g.dart';

@freezed
abstract class ExampleSentence with _$ExampleSentence {
  const factory ExampleSentence({required String de, required String uk}) =
      _ExampleSentence;

  factory ExampleSentence.fromJson(Map<String, dynamic> json) =>
      _$ExampleSentenceFromJson(json);
}
