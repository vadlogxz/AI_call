import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

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

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _waveTimer = Timer.periodic(
      const Duration(milliseconds: 75),
      _tickWave,
    );
  }

  void _tickWave(Timer _) {
    if (!mounted) return;
    final state = ref.read(recordingNotifierProvider);
    final amp = state.amplitude?.current ?? 0.0;
    final isRecording = state.recordState == RecordState.record;

    setState(() {
      _waveHeights.removeAt(0);
      if (isRecording && amp > 0.01) {
        _waveHeights
            .add((amp * 0.85 + _random.nextDouble() * 0.2).clamp(0.05, 1.0));
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
    _pulseController.dispose();
    _waveTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordingNotifierProvider);
    final notifier = ref.read(recordingNotifierProvider.notifier);
    final isRecording = state.recordState == RecordState.record;
    final selectedAgent = ref.watch(agentProvider).selectedAgent;

    ref.listen<RecordingState>(recordingNotifierProvider, (prev, next) {
      // Pulse animation on recording state
      final wasRecording = prev?.recordState == RecordState.record;
      final nowRecording = next.recordState == RecordState.record;
      if (wasRecording != nowRecording) {
        if (nowRecording) {
          _pulseController.repeat();
        } else {
          _pulseController.stop();
          _pulseController.value = 0;
        }
      }

      // Auto-scroll on new messages
      if ((prev?.messages.length ?? 0) != next.messages.length) {
        _scrollToBottom();
      }

      // Vocabulary suggestion sheet
      if ((prev?.pendingVocabulary.isEmpty ?? true) &&
          next.pendingVocabulary.isNotEmpty) {
        _showVocabSheet(context, next.pendingVocabulary, notifier);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(state, selectedAgent),
            // Grammar banner
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: state.currentGrammarCorrection != null
                  ? _buildGrammarBanner(
                      state.currentGrammarCorrection!,
                      state.lastTranscription,
                      notifier,
                    )
                  : const SizedBox.shrink(),
            ),
            // Conversation list
            Expanded(
              child: state.messages.isEmpty
                  ? _buildEmptyState(state)
                  : _buildConversationList(state, selectedAgent),
            ),
            _buildBottomBar(state, isRecording, notifier),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(RecordingState state, BotAgent? selectedAgent) {
    final phase = state.phase;
    final isRecording = state.recordState == RecordState.record;

    final (dotColor, label, bgColor, borderColor) = switch (phase) {
      ConversationPhase.processing => (
          const Color(0xFF3B82F6),
          'THINKING',
          const Color(0xFF1E3A5F),
          const Color(0xFF3B82F6),
        ),
      ConversationPhase.playing => (
          const Color(0xFFA855F7),
          'PLAYING',
          const Color(0xFF2E1B47),
          const Color(0xFFA855F7),
        ),
      ConversationPhase.listening when isRecording => (
          const Color(0xFF22C55E),
          'LIVE',
          const Color(0xFF14532D),
          const Color(0xFF22C55E),
        ),
      _ => (
          const Color(0xFF475569),
          'IDLE',
          const Color(0xFF1E293B),
          const Color(0xFF334155),
        ),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'elia',
                style: TextStyle(
                  color: Color(0xFFF8FAFC),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              if (selectedAgent != null)
                Text(
                  '${selectedAgent.flag} ${selectedAgent.name}',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: dotColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Grammar banner ────────────────────────────────────────────────────────

  Widget _buildGrammarBanner(
    String corrected,
    String? original,
    RecordingNotifier notifier,
  ) {
    return Container(
      key: const ValueKey('grammar-banner'),
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF451A03).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.edit_note_rounded,
              color: Color(0xFFF59E0B), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grammar note',
                  style: TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                if (original != null && original.isNotEmpty)
                  Text(
                    'You said: "$original"',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  '→ $corrected',
                  style: const TextStyle(
                    color: Color(0xFFFBBF24),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: notifier.clearGrammarFeedback,
            child: const Icon(Icons.close_rounded,
                color: Color(0xFF64748B), size: 18),
          ),
        ],
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(RecordingState state) {
    final isRecording = state.recordState == RecordState.record;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRecording
                  ? const Color(0xFF22C55E).withValues(alpha: 0.08)
                  : const Color(0xFF1E293B).withValues(alpha: 0.5),
              border: Border.all(
                color: isRecording
                    ? const Color(0xFF22C55E).withValues(alpha: 0.2)
                    : const Color(0xFF1E293B),
              ),
            ),
            child: Icon(
              isRecording
                  ? Icons.graphic_eq_rounded
                  : Icons.record_voice_over_outlined,
              color: isRecording
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF334155),
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isRecording ? 'Listening...' : 'Tap the mic to start',
            style: TextStyle(
              color: isRecording
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF475569),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!isRecording) ...[
            const SizedBox(height: 6),
            const Text(
              'Your conversation will appear here',
              style: TextStyle(
                color: Color(0xFF334155),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Conversation list ─────────────────────────────────────────────────────

  Widget _buildConversationList(
    RecordingState state,
    BotAgent? selectedAgent,
  ) {
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: const Radius.circular(4),
                ),
              ),
              child: Text(
                msg.text,
                style: const TextStyle(
                  color: Color(0xFFF1F5F9),
                  fontSize: 14,
                  height: 1.5,
                ),
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
                    left: BorderSide(
                      color: Color(0xFFF59E0B),
                      width: 2,
                    ),
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
          // Agent avatar
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8, top: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: agent?.avatarColor ?? const Color(0xFF6366F1),
            ),
            child: Center(
              child: Text(
                agent?.initials ?? 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: const Radius.circular(4),
                ),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Text(
                msg.text,
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Vocabulary suggestion sheet ───────────────────────────────────────────

  void _showVocabSheet(
    BuildContext context,
    List<dynamic> vocab,
    RecordingNotifier notifier,
  ) {
    final selected = <int>{...List.generate(vocab.length, (i) => i)};

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                      color: Color(0xFFF8FAFC),
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
                          color: Color(0xFFF1F5F9),
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        w.translation,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                      activeColor: const Color(0xFF22C55E),
                      checkColor: Colors.black,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        final vocabNotifier =
                            ref.read(vocabularyProvider.notifier);
                        for (final i in selected) {
                          vocabNotifier.addFromVocabWord(vocab[i]);
                        }
                        notifier.clearPendingVocabulary();
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

  // ── Bottom bar (waveform + stats + mic) ──────────────────────────────────

  Widget _buildBottomBar(
    RecordingState state,
    bool isRecording,
    RecordingNotifier notifier,
  ) {
    final dur = state.recordDuration;
    final mm = dur.inMinutes.toString().padLeft(2, '0');
    final ss = (dur.inSeconds % 60).toString().padLeft(2, '0');
    final kb = (state.bytesSent / 1024).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Waveform with edge fades
          SizedBox(
            height: 32,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _waveHeights.map((h) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 70),
                            height: (h * 32).clamp(2.0, 32.0),
                            decoration: BoxDecoration(
                              color: isRecording
                                  ? Color.lerp(
                                      const Color(0xFF166534),
                                      const Color(0xFF4ADE80),
                                      h,
                                    )
                                  : const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Left fade
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF020817),
                          const Color(0xFF020817).withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                // Right fade
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF020817).withValues(alpha: 0),
                          const Color(0xFF020817),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$mm:$ss',
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 12,
                  fontFamily: 'monospace',
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$kb KB',
                style: const TextStyle(
                  color: Color(0xFF334155),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Mic button (compact)
          _buildMicButton(isRecording, state, notifier),
        ],
      ),
    );
  }

  // ── Mic button ────────────────────────────────────────────────────────────

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
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isRecording && !isPlayingTts)
                    Opacity(
                      opacity: (1.0 - pulse) * 0.25,
                      child: Container(
                        width: 110 + pulse * 60 + amp * 20,
                        height: 110 + pulse * 60 + amp * 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF22C55E),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  if (isRecording && !isPlayingTts)
                    Opacity(
                      opacity: (1.0 - pulse) * 0.45,
                      child: Container(
                        width: 110 + pulse * 30 + amp * 12,
                        height: 110 + pulse * 30 + amp * 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF22C55E),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  if (!isRecording || isPlayingTts)
                    Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isPlayingTts
                              ? const Color(0xFFA855F7).withValues(alpha: 0.4)
                              : const Color(0xFF1E293B),
                          width: 1.5,
                        ),
                      ),
                    ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPlayingTts
                          ? const Color(0xFF2E1B47)
                          : isRecording
                              ? const Color(0xFF15803D)
                              : const Color(0xFF0F172A),
                      border: Border.all(
                        color: isPlayingTts
                            ? const Color(0xFFA855F7)
                            : isRecording
                                ? const Color(0xFF22C55E)
                                : const Color(0xFF334155),
                        width: 2,
                      ),
                      boxShadow: isRecording && !isPlayingTts
                          ? [
                              BoxShadow(
                                color: const Color(0xFF22C55E)
                                    .withValues(alpha: 0.28),
                                blurRadius: 24,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      isPlayingTts
                          ? Icons.stop_rounded
                          : isRecording
                              ? Icons.mic
                              : Icons.mic_none,
                      size: 36,
                      color: isPlayingTts
                          ? const Color(0xFFA855F7)
                          : isRecording
                              ? Colors.white
                              : const Color(0xFF94A3B8),
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
