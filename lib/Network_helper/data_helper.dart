import 'network_helper.dart';

class DataHelper {
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
    return await NetworkHelper().getQuoteData();
  }

  Future<String?> fetchImage(List<dynamic> tags) async {
    if (tags.isNotEmpty) {
      String apiUrl = 'https://random.imagecdn'
          '.app/v1/image?width=500&height=550&category=type&format=json';
      apiUrl = apiUrl.replaceAll('type', tags[0].toString());
      return await NetworkHelper().getImage(apiUrl);
    }
    return null;
  }
}
