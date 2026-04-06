import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:elia/feature/agents/presentation/state/agent_config.dart';
import 'package:elia/feature/call/di/recorder_providers.dart';
import 'package:elia/feature/call/domain/models/word_lookup_result.dart';
import 'package:elia/feature/call/presentation/state/recording_state.dart';
import 'package:elia/feature/call/presentation/widgets/word_lookup_sheet.dart';
import 'package:elia/feature/dictionary/domain/models/vocabulary_word.dart';
import 'package:elia/feature/dictionary/presentation/state/vocabulary_notifier.dart';
import 'package:elia/feature/settings/presentation/state/settings_notifier.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationList extends ConsumerWidget {
  const ConversationList({
    super.key,
    required this.messages,
    required this.selectedAgent,
    required this.scrollController,
  });

  final List<ConversationMessage> messages;
  final BotAgent? selectedAgent;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return _MessageBubble(msg: msg, agent: selectedAgent);
      },
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({required this.msg, required this.agent});

  final ConversationMessage msg;
  final BotAgent? agent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.eliaColors;

    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: colors.userBubble,
                borderRadius: BorderRadius.circular(
                  14,
                ).copyWith(bottomRight: const Radius.circular(4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'You',
                    style: TextStyle(color: colors.textMuted, fontSize: 9),
                  ),
                  const SizedBox(height: 2),
                  _LookupableMessageText(
                    text: msg.text,
                    agent: agent,
                    textStyle: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            if (msg.corrected != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: colors.warning, width: 2),
                  ),
                  color: colors.surfaceWarning.withValues(alpha: 0.55),
                ),
                child: Text(
                  'Correction: ${msg.corrected}',
                  style: TextStyle(
                    color: colors.warning,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(right: 8, top: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: agent?.avatarColor ?? colors.accentPrimary,
            ),
            child: Center(
              child: Text(
                agent?.initials ?? 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: colors.assistantBubble,
                borderRadius: BorderRadius.circular(
                  14,
                ).copyWith(bottomLeft: const Radius.circular(4)),
                border: Border.all(color: colors.borderPrimary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent?.name ?? 'Elia',
                    style: TextStyle(color: colors.textMuted, fontSize: 9),
                  ),
                  const SizedBox(height: 2),
                  _LookupableMessageText(
                    text: msg.text,
                    agent: agent,
                    textStyle: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LookupableMessageText extends ConsumerWidget {
  const _LookupableMessageText({
    required this.text,
    required this.agent,
    required this.textStyle,
  });

  final String text;
  final BotAgent? agent;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = _tokenize(text);

    return RichText(
      text: TextSpan(
        children: [
          for (final token in words)
            if (_isLookupable(token))
              TextSpan(
                text: token,
                style: textStyle.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: textStyle.color?.withValues(alpha: 0.45),
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () => _lookupWord(context, ref, token),
              )
            else
              TextSpan(text: token, style: textStyle),
        ],
      ),
    );
  }

  Future<void> _lookupWord(
    BuildContext context,
    WidgetRef ref,
    String rawToken,
  ) async {
    final word = _normalizeWord(rawToken);
    if (word.isEmpty) return;

    final lookupWord = ref.read(lookupWordProvider);
    final nativeLanguage = ref.read(settingsProvider).speakingLanguage;
    final targetLanguage = agent?.languageCode ?? 'en';

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return FutureBuilder<WordLookupResult>(
          future: lookupWord(
            word: word,
            context: text,
            targetLanguage: targetLanguage,
            nativeLanguage: nativeLanguage,
          ),
          builder: (context, snapshot) {
            final colors = context.eliaColors;

            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      word,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load translation for this word.',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            final result = snapshot.data!;
            final savedWords = ref.read(vocabularyProvider);
            final isSaved = _containsWord(savedWords, result.word);

            return WordLookupSheet(
              result: result,
              isSaved: isSaved,
              onSave: () {
                ref
                    .read(vocabularyProvider.notifier)
                    .addWord(
                      VocabularyWord(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        word: result.word,
                        translation: result.translation,
                        partOfSpeech: result.partOfSpeech,
                        example: result.example,
                        addedAt: DateTime.now(),
                      ),
                    );
              },
            );
          },
        );
      },
    );
  }

  static List<String> _tokenize(String value) {
    final matches = RegExp(r"[A-Za-zÀ-ÿ']+|[^A-Za-zÀ-ÿ']+").allMatches(value);
    return matches.map((m) => m.group(0)!).toList(growable: false);
  }

  static bool _isLookupable(String token) {
    return RegExp(r"[A-Za-zÀ-ÿ]").hasMatch(token);
  }

  static String _normalizeWord(String token) {
    return token.replaceAll(RegExp(r"^[^A-Za-zÀ-ÿ']+|[^A-Za-zÀ-ÿ']+$"), '');
  }

  static bool _containsWord(List<VocabularyWord> words, String lookupWord) {
    final normalized = lookupWord.toLowerCase();
    return words.any((word) => word.word.toLowerCase() == normalized);
  }
}
