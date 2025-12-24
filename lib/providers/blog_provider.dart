import 'package:flutter/foundation.dart';

import '../services/blog_service.dart';

class BlogProvider extends ChangeNotifier {
  BlogProvider(this._service) {
    loadPosts();
  }

  final BlogService _service;

  List<BlogPost> _posts = const [];
  bool _isLoading = false;
  String? _error;

  List<BlogPost> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPosts() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      _posts = await _service.fetchPosts();
      _error = null;
    } catch (e) {
      _error = 'No pudimos cargar el blog.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
