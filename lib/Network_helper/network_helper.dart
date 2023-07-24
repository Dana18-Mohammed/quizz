import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_gsg/utilies/constants.dart';

class NetworkHelper {
  Future<Map<String, dynamic>> getQuoteData() async {
    try {
      final response = await http.get(Uri.parse(quoteLink));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        if (data.isNotEmpty) {
          final Map<String, dynamic> firstItem = data[0];
          final String content = firstItem['content'];
          final String author = firstItem['author'];
          final List<dynamic> tags = firstItem['tags'];
          return {'content': content, 'tags': tags, 'author': author};
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching data from API: $e');
    }

    return {'content': null, 'tags': null};
  }

  Future<Map<String, dynamic>> fetchDataQuoteAndImage() async {
    final data = await fetchDataQuote();
    final imageUrl = await fetchImage(data['tags']);
    return {
      'content': data['content'] ?? 'Failed to fetch content.',
      'author': data['author'] ?? 'Failed to fetch author name.',
      'tags': data['tags'] ?? [],
      'imageUrl': imageUrl ?? '',
    };
  }

  Future<Map<String, dynamic>> fetchDataQuote() async {
    return getQuoteData();
  }

  Future<String?> fetchImage(List<dynamic> tags) async {
    if (tags.isNotEmpty) {
      String apiUrl = 'https://random.imagecdn'
          '.app/v1/image?width=500&height=550&category=type&format=json';
      apiUrl = apiUrl.replaceAll('type', tags[0].toString());
      return getImage(apiUrl);
    }
    return null;
  }

  Future<String> getImage(apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String imageUrl = data['url'];
        return imageUrl;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching data from API: $e');
    }
    return '';
  }
}
