import 'package:record/record.dart';

const RecordConfig recordConfig = RecordConfig(
  encoder: AudioEncoder.pcm16bits,
  numChannels: 1,
  sampleRate: 16000,
  autoGain: false,
  noiseSuppress: false,
  echoCancel: false,
  androidConfig: AndroidRecordConfig(
    // Use voiceCommunication for call-like scenarios to avoid
    // aggressive processing / possible muting of the mic.
    audioSource: AndroidAudioSource.voiceCommunication,
  ),
);