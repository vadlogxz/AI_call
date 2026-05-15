import 'package:json_annotation/json_annotation.dart';

enum WordType { noun, verb, adjective, adverb, phrase, other }

enum CefrLevel { a1, a2, b1, b2, c1, c2 }

enum Register {
  neutral,
  formal,
  informal,
  colloquial,
}

enum VerbAuxiliary { haben, sein }

enum GovernsCase {
  @JsonValue('Akkusativ') akkusativ,
  @JsonValue('Dativ') dativ,
  @JsonValue('Genitiv') genitiv,
}

enum WordGroupType { user, aiRecommended }
