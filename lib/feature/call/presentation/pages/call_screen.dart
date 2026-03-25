import 'dart:async';
import 'dart:math' as math;

import 'package:elia/core/presentation/widgets/elia_mascot.dart';
import 'package:elia/feature/call/domain/models/conversation_result.dart';
import 'package:elia/feature/call/domain/models/recording_status.dart';
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
  Timer? _waveTimer;
  final _random = math.Random();
  final ScrollController _scrollController = ScrollController();
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

    return Scaffold(
      backgroundColor: const Color(0xFF0a0d14),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(state, selectedAgent, streak),
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
                      ? _buildEmptyState(state)
                      : _buildConversationList(state, selectedAgent),
            ),
            _buildBottomBar(state, isRecording, notifier),
          ],
        ),
      ),
    );
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

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(
    RecordingState state,
    BotAgent? selectedAgent,
    int streak,
  ) {
    final phase = state.phase;
    final isRecording = state.recordingStatus == RecordingStatus.recording;

    final (statusLabel, statusColor) = switch (phase) {
      ConversationPhase.processing => ('thinking', const Color(0xFF5b78d4)),
      ConversationPhase.playing => ('speaking', const Color(0xFF5bd47b)),
      ConversationPhase.listening when isRecording => (
        'live',
        const Color(0xFF5bd47b),
      ),
      _ => ('idle', const Color(0xFF4a5680)),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Text(
            'elia',
            style: TextStyle(
              color: Color(0xFFe8eaf5),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF12192b),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (streak > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1200),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF3a2800)),
              ),
              child: Text(
                '🔥 $streak',
                style: const TextStyle(
                  color: Color(0xFFe8a030),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Empty state (with mascot) ──────────────────────────────────────────────

  Widget _buildEmptyState(RecordingState state) {
    final phase = state.phase;
    final isRecording = state.recordingStatus == RecordingStatus.recording;

    final mascotState = switch (phase) {
      ConversationPhase.processing => MascotState.thinking,
      ConversationPhase.playing => MascotState.speaking,
      ConversationPhase.listening when isRecording => MascotState.speaking,
      _ => MascotState.idle,
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EliaMascot(
            state: mascotState,
            size: 110,
            showRings: isRecording || phase == ConversationPhase.playing,
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey(phase),
              switch (phase) {
                ConversationPhase.processing => 'Thinking...',
                ConversationPhase.playing => 'Speaking...',
                ConversationPhase.listening when isRecording => 'Listening...',
                _ => 'Tap the mic to start',
              },
              style: TextStyle(
                color:
                    isRecording || phase != ConversationPhase.idle
                        ? const Color(0xFF5bd47b)
                        : const Color(0xFF4a5680),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (phase == ConversationPhase.idle) ...[
            const SizedBox(height: 6),
            const Text(
              'Your conversation will appear here',
              style: TextStyle(color: Color(0xFF2e3858), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  // ── Conversation list ──────────────────────────────────────────────────────

  Widget _buildConversationList(RecordingState state, BotAgent? selectedAgent) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final msg = state.messages[index];
        return _buildMessageBubble(msg, selectedAgent);
      },
    );
  }

  Widget _buildMessageBubble(ConversationMessage msg, BotAgent? agent) {
    if (msg.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1a2550),
                borderRadius: BorderRadius.circular(
                  14,
                ).copyWith(bottomRight: const Radius.circular(4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ти',
                    style: const TextStyle(
                      color: Color(0xFF4a5680),
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    msg.text,
                    style: const TextStyle(
                      color: Color(0xFFd8e0f5),
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
                  border: const Border(
                    left: BorderSide(color: Color(0xFFF59E0B), width: 2),
                  ),
                  color: const Color(0xFF451A03).withValues(alpha: 0.3),
                ),
                child: Text(
                  '→ ${msg.corrected}',
                  style: const TextStyle(
                    color: Color(0xFFFBBF24),
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

    // AI message
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
              color: agent?.avatarColor ?? const Color(0xFF3a4f8a),
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
                color: const Color(0xFF13192e),
                borderRadius: BorderRadius.circular(
                  14,
                ).copyWith(bottomLeft: const Radius.circular(4)),
                border: Border.all(color: const Color(0xFF1e2a4a)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent?.name ?? 'elia',
                    style: const TextStyle(
                      color: Color(0xFF4a5680),
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    msg.text,
                    style: const TextStyle(
                      color: Color(0xFFc8d0e8),
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

  // ── Vocabulary sheet ───────────────────────────────────────────────────────

  void _showVocabSheet(List<ConversationVocabulary> vocab) {
    if (!mounted) return;
    final selected = <int>{...List.generate(vocab.length, (i) => i)};

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0c1020),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New words from conversation',
                    style: TextStyle(
                      color: Color(0xFFe8eaf5),
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
                        style: const TextStyle(
                          color: Color(0xFFe8eaf5),
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        w.translation,
                        style: const TextStyle(
                          color: Color(0xFF4a5680),
                          fontSize: 12,
                        ),
                      ),
                      activeColor: const Color(0xFF3cb56a),
                      checkColor: Colors.black,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF3cb56a),
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

  // ── Session summary ────────────────────────────────────────────────────────

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

  // ── Bottom bar ─────────────────────────────────────────────────────────────

  Widget _buildBottomBar(
    RecordingState state,
    bool isRecording,
    RecordingNotifier notifier,
  ) {
    final dur = state.recordDuration;
    final mm = dur.inMinutes.toString().padLeft(2, '0');
    final ss = (dur.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Waveform
          SizedBox(
            height: 28,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                        _waveHeights.map((h) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 70),
                                height: (h * 28).clamp(2.0, 28.0),
                                decoration: BoxDecoration(
                                  color:
                                      isRecording
                                          ? Color.lerp(
                                            const Color(0xFF1a3a28),
                                            const Color(0xFF4ade80),
                                            h,
                                          )
                                          : const Color(0xFF1e2a50),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0a0d14),
                          const Color(0xFF0a0d14).withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0a0d14).withValues(alpha: 0),
                          const Color(0xFF0a0d14),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Timer
          Text(
            '$mm:$ss',
            style: const TextStyle(
              color: Color(0xFF4a5680),
              fontSize: 12,
              fontFamily: 'monospace',
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          _buildMicButton(isRecording, state, notifier),
        ],
      ),
    );
  }

  // ── Mic button ─────────────────────────────────────────────────────────────

  Widget _buildMicButton(
    bool isRecording,
    RecordingState state,
    RecordingNotifier notifier,
  ) {
    final amp = (state.amplitude?.current ?? 0.0).clamp(0.0, 1.0);
    final isPlayingTts = state.isPlayingTts;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final pulse = _pulseController.value;

        return GestureDetector(
          onTap: () {
            if (isPlayingTts) {
              notifier.stopPlayback();
            } else if (isRecording) {
              notifier.stop();
            } else {
              notifier.start();
            }
          },
          child: Opacity(
            opacity: isPlayingTts ? 0.5 : 1.0,
            child: SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isRecording && !isPlayingTts)
                    Opacity(
                      opacity: (1.0 - pulse) * 0.22,
                      child: Container(
                        width: 100 + pulse * 50 + amp * 18,
                        height: 100 + pulse * 50 + amp * 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF3cb56a),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  if (isRecording && !isPlayingTts)
                    Opacity(
                      opacity: (1.0 - pulse) * 0.4,
                      child: Container(
                        width: 98 + pulse * 25 + amp * 10,
                        height: 98 + pulse * 25 + amp * 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF3cb56a),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  if (!isRecording || isPlayingTts)
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isPlayingTts
                                  ? const Color(
                                    0xFF8b78e4,
                                  ).withValues(alpha: 0.4)
                                  : const Color(0xFF1e2a50),
                          width: 1.5,
                        ),
                      ),
                    ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isPlayingTts
                              ? const Color(0xFF1a1535)
                              : isRecording
                              ? const Color(0xFF0d2018)
                              : const Color(0xFF111827),
                      border: Border.all(
                        color:
                            isPlayingTts
                                ? const Color(0xFF8b78e4)
                                : isRecording
                                ? const Color(0xFF3cb56a)
                                : const Color(0xFF2a3a6a),
                        width: 1.5,
                      ),
                      boxShadow:
                          isRecording && !isPlayingTts
                              ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF3cb56a,
                                  ).withValues(alpha: 0.22),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ]
                              : null,
                    ),
                    child: Icon(
                      isPlayingTts
                          ? Icons.stop_rounded
                          : isRecording
                          ? Icons.mic
                          : Icons.mic_none,
                      size: 30,
                      color:
                          isPlayingTts
                              ? const Color(0xFF8b78e4)
                              : isRecording
                              ? const Color(0xFF3cb56a)
                              : const Color(0xFF4a5680),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
