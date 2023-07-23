import 'dart:convert';
import 'package:flutter/material.dart';
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
          final List<dynamic> tags = firstItem['tags'];
          return {'content': content, 'tags': tags};
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching data from API: $e');
    }

    return {'content': null, 'tags': null};
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
//
