import 'package:elia/core/theme/elia_theme_extension.dart';
import 'package:elia/feature/call/presentation/state/recording_notifier.dart';
import 'package:elia/feature/call/presentation/state/recording_state.dart';
import 'package:flutter/material.dart';

class CallBottomBar extends StatelessWidget {
  const CallBottomBar({
    super.key,
    required this.state,
    required this.isRecording,
    required this.notifier,
    required this.waveHeights,
    required this.pulseController,
  });

  final RecordingState state;
  final bool isRecording;
  final RecordingNotifier notifier;
  final List<double> waveHeights;
  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    final colors = context.eliaColors;
    final dur = state.recordDuration;
    final mm = dur.inMinutes.toString().padLeft(2, '0');
    final ss = (dur.inSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 28,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                        waveHeights.map((h) {
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
                                            colors.surfaceSuccess,
                                            colors.success,
                                            h,
                                          )
                                          : colors.borderAccent,
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
                          colors.surfacePrimary,
                          colors.surfacePrimary.withValues(alpha: 0),
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
                          colors.surfacePrimary.withValues(alpha: 0),
                          colors.surfacePrimary,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$mm:$ss',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 12,
              fontFamily: 'monospace',
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          _MicButton(
            isRecording: isRecording,
            state: state,
            notifier: notifier,
            pulseController: pulseController,
          ),
        ],
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  const _MicButton({
    required this.isRecording,
    required this.state,
    required this.notifier,
    required this.pulseController,
  });

  final bool isRecording;
  final RecordingState state;
  final RecordingNotifier notifier;
  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    final colors = context.eliaColors;
    final amp = (state.amplitude?.current ?? 0.0).clamp(0.0, 1.0);
    final isPlayingTts = state.isPlayingTts;

    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, _) {
        final pulse = pulseController.value;

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
                          border: Border.all(color: colors.success, width: 1),
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
                          border: Border.all(color: colors.success, width: 1.5),
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
                                    0xFF8B78E4,
                                  ).withValues(alpha: 0.4)
                                  : colors.borderAccent,
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
                              ? const Color(0xFF1A1535)
                              : isRecording
                              ? colors.surfaceSuccess
                              : colors.surfaceSecondary,
                      border: Border.all(
                        color:
                            isPlayingTts
                                ? const Color(0xFF8B78E4)
                                : isRecording
                                ? colors.success
                                : colors.borderAccent,
                        width: 1.5,
                      ),
                      boxShadow:
                          isRecording && !isPlayingTts
                              ? [
                                BoxShadow(
                                  color: colors.success.withValues(alpha: 0.22),
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
                              ? const Color(0xFF8B78E4)
                              : isRecording
                              ? colors.success
                              : colors.textMuted,
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
