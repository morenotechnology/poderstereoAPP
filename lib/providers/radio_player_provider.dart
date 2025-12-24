import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../services/radio_player_service.dart';

class RadioPlayerProvider extends ChangeNotifier {
  RadioPlayerProvider(this._service) {
    _init();
  }

  final RadioPlayerService _service;
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<double>? _levelSub;
  bool _isBuffering = true;
  bool _isPlaying = false;
  String? _errorMessage;
  double _currentLevel = 0;

  bool get isBuffering => _isBuffering;
  bool get isPlaying => _isPlaying;
  String? get errorMessage => _errorMessage;
  double get level => _currentLevel;

  Future<void> _init() async {
    try {
      await _service.init();
      _playerStateSub = _service.player.playerStateStream.listen((state) {
        _isPlaying = state.playing;
        _isBuffering = state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering;
        notifyListeners();
      });
      _levelSub = _service.levelStream.listen((value) {
        _currentLevel = value;
        notifyListeners();
      });
      _errorMessage = null;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'No pudimos conectar con la señal. Intenta de nuevo.';
      debugPrint('Radio init error: $error');
      notifyListeners();
    }
  }

  Future<void> togglePlayback() async {
    if (_isPlaying) {
      await _service.pause();
    } else {
      _isBuffering = true;
      notifyListeners();
      try {
        await _service.playLive();
        _errorMessage = null;
      } catch (error) {
        _errorMessage = 'No pudimos reproducir la señal.';
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _levelSub?.cancel();
    _service.dispose();
    super.dispose();
  }
}
