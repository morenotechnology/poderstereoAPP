import 'dart:convert';

import 'package:http/http.dart' as http;

class BlogPost {
  const BlogPost({
    required this.id,
    required this.title,
    required this.summary,
    required this.slug,
    this.imageUrl,
  });

  final int id;
  final String title;
  final String summary;
  final String slug;
  final String? imageUrl;
}

class BlogService {
  static const _endpoint = 'https://poderstereolivetv.com/wp-json/emisora/v1/blog';

  Future<List<BlogPost>> fetchPosts() async {
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode != 200) {
      throw Exception('No se pudo obtener el blog');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((item) {
      final map = item as Map<String, dynamic>;
      final image = map['imagen'];
      return BlogPost(
        id: map['id'] as int,
        title: (map['titulo'] as String?)?.trim() ?? '',
        summary: (map['resumen'] as String?)?.trim() ?? '',
        slug: (map['slug'] as String?)?.trim() ?? '',
        imageUrl: image is String && image.isNotEmpty ? image : null,
      );
    }).toList();
  }
}
