import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../services/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  BlogProvider(this._service) {
    loadPosts();
  }

  final BlogService _service;
  final Completer<void> _readyCompleter = Completer<void>();
  final Random _random = Random();

  List<BlogPost> _posts = const [];
  bool _isLoading = false;
  String? _error;

  List<BlogPost> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Future<void> get ready => _readyCompleter.future;

  Future<void> loadPosts() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      final posts = await _service.fetchPosts();
      posts.shuffle(_random);
      _posts = posts;
      _error = null;
    } catch (e) {
      _error = 'No pudimos cargar el blog.';
    } finally {
      _isLoading = false;
      if (!_readyCompleter.isCompleted) {
        _readyCompleter.complete();
      }
      notifyListeners();
    }
  }
}
