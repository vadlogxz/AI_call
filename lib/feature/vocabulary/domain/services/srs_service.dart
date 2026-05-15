import 'package:elia/feature/vocabulary/domain/models/user_word.dart';

const _learningSteps = [
  Duration(minutes: 5),
  Duration(minutes: 20),
  Duration(hours: 1),
  Duration(hours: 4),
  Duration(days: 1),
];

class SrsService {
  UserWord call(UserWord word, bool isCorrect) {
    if (!isCorrect) {
      return word.copyWith(
        repetitions: 0,
        interval: 0,
        nextReview: DateTime.now().add(_learningSteps[0]),
      );
    }

    if (word.repetitions < _learningSteps.length) {
      return word.copyWith(
        repetitions: word.repetitions + 1,
        nextReview: DateTime.now().add(_learningSteps[word.repetitions]),
      );
    }

    final newEF = (word.easeFactor + 0.1).clamp(1.3, 2.5);
    final newInterval = (word.interval * newEF).round().clamp(1, 365);

    return word.copyWith(
      repetitions: word.repetitions + 1,
      easeFactor: newEF,
      interval: newInterval,
      nextReview: DateTime.now().add(Duration(days: newInterval)),
    );
  }
}
