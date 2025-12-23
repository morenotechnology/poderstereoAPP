import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import '../core/constants/app_constants.dart';

class RadioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  bool _configured = false;

  AudioPlayer get player => _player;

  Future<void> _configureSession() async {
    if (_configured) return;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    _configured = true;
  }

  Future<void> init() async {
    await _configureSession();
  }

  Future<void> playLive() async {
    await _configureSession();
    await _player.stop();
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(AppConstants.streamUrl)),
    );
    await _player.play();
  }

  Future<void> pause() => _player.pause();

  Future<void> dispose() => _player.dispose();
}
