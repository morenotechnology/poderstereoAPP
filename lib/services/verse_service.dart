import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

class BibleVerse {
  const BibleVerse({required this.reference, required this.text});

  final String reference;
  final String text;
}

class VerseService {
  static const _endpoint =
      'https://www.biblegateway.com/votd/get/?format=json&version=RVR1960';

  final HtmlUnescape _unescape = HtmlUnescape();

  Future<BibleVerse> fetchVerseOfDay() async {
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode != 200) {
      throw Exception('No se pudo obtener el versículo');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['votd'] as Map<String, dynamic>;
    final rawText = data['text'] as String? ?? data['content'] as String? ?? '';
    final reference = data['display_ref'] as String? ?? data['reference'] as String? ?? '';
    return BibleVerse(
      reference: reference,
      text: _unescape.convert(rawText.replaceAll(RegExp(r'<[^>]+>'), '')),
    );
  }
}
