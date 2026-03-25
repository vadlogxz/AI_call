import 'package:elia/feature/call/data/services/word_lookup_api_service.dart';
import 'package:elia/feature/call/domain/models/word_lookup_result.dart';

class LookupWord {
  const LookupWord(this._wordLookupApiService);

  final WordLookupApiService _wordLookupApiService;

  Future<WordLookupResult> call({
    required String word,
    required String context,
    required String targetLanguage,
    required String nativeLanguage,
  }) {
    return _wordLookupApiService.lookup(
      word: word,
      context: context,
      targetLanguage: targetLanguage,
      nativeLanguage: nativeLanguage,
    );
  }
}
