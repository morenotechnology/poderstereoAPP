import 'package:flutter/foundation.dart';

import '../services/verse_service.dart';

class VerseProvider extends ChangeNotifier {
  VerseProvider(this._service) {
    loadVerse();
  }

  final VerseService _service;

  BibleVerse? _verse;
  bool _isLoading = false;
  String? _error;

  BibleVerse? get verse => _verse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadVerse() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      _verse = await _service.fetchVerseOfDay();
      _error = null;
    } catch (e) {
      _error = 'No pudimos obtener el versículo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
