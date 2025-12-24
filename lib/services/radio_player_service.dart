import 'dart:async';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import '../core/constants/app_constants.dart';

class RadioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  bool _configured = false;
  final StreamController<double> _levelController = StreamController<double>.broadcast();
  final Random _rng = Random();
  Timer? _levelTimer;

  AudioPlayer get player => _player;
  Stream<double> get levelStream => _levelController.stream;

  Future<void> _configureSession() async {
    if (_configured) return;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    _configured = true;
  }

  Future<void> init() async {
    await _configureSession();
    _levelController.add(0);
  }

  Future<void> playLive() async {
    await _configureSession();
    _stopLevelMonitoring();
    await _player.stop();
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(AppConstants.streamUrl)),
    );
    await _player.play();
    _startLevelMonitoring();
  }

  Future<void> pause() async {
    await _player.pause();
    _stopLevelMonitoring();
  }

  void _startLevelMonitoring() {
    _levelTimer ??= Timer.periodic(const Duration(milliseconds: 120), (_) {
      final base = _player.playing ? 0.35 + _rng.nextDouble() * 0.65 : 0.05;
      final level = (_player.volume.clamp(0.0, 1.0)) * base;
      _levelController.add(level);
    });
  }

  void _stopLevelMonitoring() {
    _levelTimer?.cancel();
    _levelTimer = null;
    _levelController.add(0);
  }

  Future<void> dispose() async {
    _stopLevelMonitoring();
    await _player.dispose();
    await _levelController.close();
  }
}
