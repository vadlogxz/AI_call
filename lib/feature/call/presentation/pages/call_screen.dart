import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

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
  final List<double> _waveHeights = List.filled(32, 0.04);
  Timer? _waveTimer;
  final _random = math.Random();

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

  @override
  void dispose() {
    _pulseController.dispose();
    _waveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordingNotifierProvider);
    final notifier = ref.read(recordingNotifierProvider.notifier);
    final isRecording = state.recordState == RecordState.record;

    ref.listen<RecordingState>(recordingNotifierProvider, (prev, next) {
      final wasRecording = prev?.recordState == RecordState.record;
      final nowRecording = next.recordState == RecordState.record;
      if (wasRecording == nowRecording) return;
      if (nowRecording) {
        _pulseController.repeat();
      } else {
        _pulseController.stop();
        _pulseController.value = 0;
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF020817),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isRecording),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTranscription(state.lastTranscription),
                  const SizedBox(height: 48),
                  _buildMicButton(isRecording, state, notifier),
                  const SizedBox(height: 32),
                  _buildTimer(state),
                ],
              ),
            ),
            _buildWaveform(isRecording),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(bool isRecording) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
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
          const Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isRecording
                  ? const Color(0xFF14532D).withValues(alpha: 0.5)
                  : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isRecording
                    ? const Color(0xFF22C55E).withValues(alpha: 0.5)
                    : const Color(0xFF334155),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isRecording ? 'LIVE' : 'IDLE',
                  style: TextStyle(
                    color: isRecording
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF64748B),
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

  // ── Transcription ─────────────────────────────────────────────────────────

  Widget _buildTranscription(String? text) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: text == null || text.isEmpty
          ? const SizedBox(height: 64, key: ValueKey('empty'))
          : Container(
              key: ValueKey(text),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    color: Color(0xFF3B82F6),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
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

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final pulse = _pulseController.value;

        return GestureDetector(
          onTap: () => isRecording ? notifier.stop() : notifier.start(),
          child: SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer expanding ring
                if (isRecording)
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

                // Inner ring
                if (isRecording)
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

                // Static ring when idle
                if (!isRecording)
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1E293B),
                        width: 1.5,
                      ),
                    ),
                  ),

                // Core button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording
                        ? const Color(0xFF15803D)
                        : const Color(0xFF0F172A),
                    border: Border.all(
                      color: isRecording
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF334155),
                      width: 2,
                    ),
                    boxShadow: isRecording
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
                    isRecording ? Icons.mic : Icons.mic_none,
                    size: 36,
                    color: isRecording
                        ? Colors.white
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Timer & stats ─────────────────────────────────────────────────────────

  Widget _buildTimer(RecordingState state) {
    final dur = state.recordDuration;
    final mm = dur.inMinutes.toString().padLeft(2, '0');
    final ss = (dur.inSeconds % 60).toString().padLeft(2, '0');
    final kb = (state.bytesSent / 1024).toStringAsFixed(1);

    return Column(
      children: [
        Text(
          '$mm:$ss',
          style: const TextStyle(
            color: Color(0xFFF8FAFC),
            fontSize: 42,
            fontWeight: FontWeight.w200,
            fontFamily: 'monospace',
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$kb KB',
          style: const TextStyle(color: Color(0xFF334155), fontSize: 12),
        ),
      ],
    );
  }

  // ── Waveform ──────────────────────────────────────────────────────────────

  Widget _buildWaveform(bool isRecording) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 44,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _waveHeights.asMap().entries.map((e) {
            final h = e.value;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 70),
                  height: (h * 44).clamp(2.0, 44.0),
                  decoration: BoxDecoration(
                    color: isRecording
                        ? Color.lerp(
                            const Color(0xFF14532D),
                            const Color(0xFF22C55E),
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
    );
  }
}
