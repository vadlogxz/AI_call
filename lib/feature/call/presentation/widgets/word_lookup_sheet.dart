import 'package:elia/feature/call/domain/models/word_lookup_result.dart';
import 'package:flutter/material.dart';

class WordLookupSheet extends StatelessWidget {
  const WordLookupSheet({
    super.key,
    required this.result,
    required this.isSaved,
    required this.onSave,
  });

  final WordLookupResult result;
  final bool isSaved;
  final VoidCallback onSave;

  static Future<void> show({
    required BuildContext context,
    required WordLookupResult result,
    required bool isSaved,
    required VoidCallback onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0c1020),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) =>
              WordLookupSheet(result: result, isSaved: isSaved, onSave: onSave),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.word,
            style: const TextStyle(
              color: Color(0xFFe8eaf5),
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (result.partOfSpeech.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              result.partOfSpeech,
              style: const TextStyle(
                color: Color(0xFF8aaaf5),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 14),
          const Text(
            'Translation',
            style: TextStyle(
              color: Color(0xFF4a5680),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            result.translation.isEmpty
                ? 'No translation available'
                : result.translation,
            style: const TextStyle(
              color: Color(0xFFe8eaf5),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (result.example.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Example',
              style: TextStyle(
                color: Color(0xFF4a5680),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '"${result.example}"',
              style: const TextStyle(
                color: Color(0xFFc8d0e8),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    isSaved ? const Color(0xFF1e2a50) : const Color(0xFF3cb56a),
                foregroundColor:
                    isSaved ? const Color(0xFF8aaaf5) : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed:
                  isSaved
                      ? null
                      : () {
                        onSave();
                        Navigator.of(context).pop();
                      },
              child: Text(isSaved ? 'Already saved' : 'Add to dictionary'),
            ),
          ),
        ],
      ),
    );
  }
}
