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
  StreamSubscription<Duration>? _positionSub;

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
    _positionSub ??= _player
        .createPositionStream(
          minPeriod: const Duration(milliseconds: 60),
          maxPeriod: const Duration(milliseconds: 120),
        )
        .listen((position) {
      if (!_player.playing) {
        _levelController.add(0);
        return;
      }
      final t = position.inMilliseconds / 220.0;
      final waveA = (sin(t) + 1) / 2;
      final waveB = (sin(t * 1.7 + pi / 3) + 1) / 2;
      final jitter = _rng.nextDouble() * 0.12;
      var level = 0.35 + 0.65 * (waveA * 0.7 + waveB * 0.3) + jitter;
      level *= _player.volume.clamp(0.0, 1.0);
      _levelController.add(level.clamp(0.0, 1.0));
    });
  }

  void _stopLevelMonitoring() {
    _positionSub?.cancel();
    _positionSub = null;
    _levelController.add(0);
  }

  Future<void> dispose() async {
    _stopLevelMonitoring();
    await _player.dispose();
    await _levelController.close();
  }
}
