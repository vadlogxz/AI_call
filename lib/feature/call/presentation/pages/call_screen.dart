import 'dart:async';
import 'dart:math' as math;

import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:elia/feature/call/domain/models/conversation_result.dart';
import 'package:elia/feature/call/domain/models/recording_status.dart';
import 'package:elia/feature/call/presentation/widgets/call_bottom_bar.dart';
import 'package:elia/feature/call/presentation/widgets/call_empty_state.dart';
import 'package:elia/feature/call/presentation/widgets/call_header.dart';
import 'package:elia/feature/call/presentation/widgets/conversation_list.dart';
import 'package:elia/feature/call/presentation/widgets/grammar_banner.dart';
import 'package:elia/feature/call/presentation/widgets/session_summary_sheet.dart';
import 'package:elia/feature/settings/presentation/state/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../agents/presentation/state/agent_config.dart';
import '../../../dictionary/presentation/state/vocabulary_notifier.dart';
import '../state/recording_notifier.dart';
import '../state/recording_state.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  final List<double> _waveHeights = List.filled(32, 0.04, growable: true);
  final ScrollController _scrollController = ScrollController();
  final _random = math.Random();
  Timer? _waveTimer;
  late final ProviderSubscription<RecordingState> _recordingSubscription;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _waveTimer = Timer.periodic(const Duration(milliseconds: 75), _tickWave);
    _recordingSubscription = ref.listenManual<RecordingState>(
      recordingNotifierProvider,
      _handleRecordingStateChanged,
    );
  }

  @override
  void dispose() {
    _recordingSubscription.close();
    _pulseController.dispose();
    _waveTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordingNotifierProvider);
    final notifier = ref.read(recordingNotifierProvider.notifier);
    final isRecording = state.recordingStatus == RecordingStatus.recording;
    final selectedAgent = ref.watch(agentProvider).selectedAgent;
    final streak = ref.watch(settingsProvider).streak;
    final colors = context.eliaColors;

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      body: SafeArea(
        child: Column(
          children: [
            CallHeader(
              state: state,
              selectedAgent: selectedAgent,
              streak: streak,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child:
                  state.currentGrammarCorrection != null
                      ? GrammarBanner(
                        corrected: state.currentGrammarCorrection!,
                        original: state.lastTranscription,
                        notifier: notifier,
                      )
                      : const SizedBox.shrink(),
            ),
            Expanded(
              child:
                  state.messages.isEmpty
                      ? CallEmptyState(state: state)
                      : ConversationList(
                        messages: state.messages,
                        selectedAgent: selectedAgent,
                        scrollController: _scrollController,
                      ),
            ),
            CallBottomBar(
              state: state,
              isRecording: isRecording,
              notifier: notifier,
              waveHeights: _waveHeights,
              pulseController: _pulseController,
            ),
          ],
        ),
      ),
    );
  }

  void _tickWave(Timer _) {
    if (!mounted) return;
    final state = ref.read(recordingNotifierProvider);
    final amp = state.amplitude?.current ?? 0.0;
    final isRecording = state.recordingStatus == RecordingStatus.recording;

    setState(() {
      _waveHeights.removeAt(0);
      if (isRecording && amp > 0.01) {
        _waveHeights.add(
          (amp * 0.85 + _random.nextDouble() * 0.2).clamp(0.05, 1.0),
        );
      } else {
        _waveHeights.add(0.03 + _random.nextDouble() * 0.03);
      }
    });
  }

  void _handleRecordingStateChanged(RecordingState? prev, RecordingState next) {
    final wasRecording = prev?.recordingStatus == RecordingStatus.recording;
    final nowRecording = next.recordingStatus == RecordingStatus.recording;
    if (wasRecording != nowRecording) {
      if (nowRecording) {
        _pulseController.repeat();
      } else {
        _pulseController.stop();
        _pulseController.value = 0;
      }
    }

    if ((prev?.messages.length ?? 0) != next.messages.length) {
      _scrollToBottom();
    }

    if ((prev?.pendingVocabulary.isEmpty ?? true) &&
        next.pendingVocabulary.isNotEmpty) {
      _showVocabSheet(next.pendingVocabulary);
    }

    final justStopped =
        prev?.recordingStatus == RecordingStatus.recording &&
        next.recordingStatus == RecordingStatus.stopped &&
        next.phase == ConversationPhase.idle;
    if (justStopped && next.messages.length >= 2) {
      _showSessionSummary(next);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showVocabSheet(List<ConversationVocabulary> vocab) {
    if (!mounted) return;
    final selected = <int>{...List.generate(vocab.length, (i) => i)};

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final colors = ctx.eliaColors;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New words from conversation',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...vocab.asMap().entries.map((entry) {
                    final i = entry.key;
                    final w = entry.value;
                    return CheckboxListTile(
                      value: selected.contains(i),
                      onChanged: (v) {
                        setSheetState(() {
                          v == true ? selected.add(i) : selected.remove(i);
                        });
                      },
                      title: Text(
                        w.word,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        w.translation,
                        style: TextStyle(color: colors.textMuted, fontSize: 12),
                      ),
                      activeColor: colors.success,
                      checkColor: Colors.black,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.success,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        final vocabNotifier = ref.read(
                          vocabularyProvider.notifier,
                        );
                        final recordingNotifier = ref.read(
                          recordingNotifierProvider.notifier,
                        );
                        for (final i in selected) {
                          vocabNotifier.addFromVocabWord(vocab[i]);
                        }
                        recordingNotifier.savePendingVocabulary(selected);
                      },
                      child: const Text('Save selected'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSessionSummary(RecordingState state) {
    final duration = state.recordDuration;
    final savedWords = List<String>.from(state.sessionSavedWords);
    final messageCount = state.messages.length;
    final grammarErrors =
        state.messages.where((m) => m.isUser && m.hasError).length;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await ref.read(settingsProvider.notifier).recordSession();
      if (!mounted) return;
      final updatedStreak = ref.read(settingsProvider).streak;

      if (!context.mounted) return;
      await SessionSummarySheet.show(
        context: context,
        duration: duration,
        newWords: savedWords,
        grammarCorrections: grammarErrors,
        messageCount: messageCount,
        streak: updatedStreak,
        onContinue: () {},
      );
    });
  }
}
