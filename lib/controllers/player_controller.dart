import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class PlayerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Rx<Duration?> totalDuration = Rx<Duration?>(null); // Total duration of the audio
  Rx<Duration> currentPosition = Duration.zero.obs; // Current playback position
  RxBool isPlaying = false.obs; // Whether the audio is playing

  Future<void> initAudio(String audioPath) async {
    try {
      await _audioPlayer.setAsset(audioPath);

      // Listen for total duration
      _audioPlayer.durationStream.listen((duration) {
        totalDuration.value = duration;
      });

      // Listen for current position
      _audioPlayer.positionStream.listen((position) {
        currentPosition.value = position;
      });

      // Listen for player state to update the play/pause icon
      _audioPlayer.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          isPlaying.value = false; // Update icon when playback ends
          _audioPlayer.stop();
          _audioPlayer.seek(Duration.zero); // Reset playback position to the start
        } else if (playerState.playing) {
          isPlaying.value = true;
        } else {
          isPlaying.value = false;
        }
      });

      // Automatically play the audio when initialized
      _audioPlayer.play();
      isPlaying.value = true;
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void playPauseAudio() {
    if (isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    isPlaying.value = !isPlaying.value;
  }

  void seekAudio(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
