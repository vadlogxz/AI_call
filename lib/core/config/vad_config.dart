enum VadModel { v4, v5 }

class VadConfig {
  final VadModel model;
  final double positiveSpeechThreshold;
  final double negativeSpeechThreshold;
  final int preSpeechPadFrames;
  final int redemptionFrames;
  final int frameSamples;
  final int minSpeechFrames;
  final int endSpeechPadFrames;
  final int numFramesToEmit;
  final int sampleRate;

  const VadConfig({
    required this.model,
    required this.positiveSpeechThreshold,
    required this.negativeSpeechThreshold,
    required this.preSpeechPadFrames,
    required this.redemptionFrames,
    required this.frameSamples,
    required this.minSpeechFrames,
    required this.endSpeechPadFrames,
    required this.numFramesToEmit,
    required this.sampleRate,
  });

  static VadConfig getDefault() {
    return const VadConfig(
      model: VadModel.v5,
      sampleRate: 16000,
      frameSamples: 512,

      positiveSpeechThreshold: 0.65,
      negativeSpeechThreshold: 0.35,
      minSpeechFrames: 12,
      preSpeechPadFrames: 3,
      endSpeechPadFrames: 10,
      redemptionFrames: 60,
      numFramesToEmit: 8,
    );
  }
}
