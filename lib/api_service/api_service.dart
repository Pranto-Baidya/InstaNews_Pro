import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:instanews_pro/news_models/article_model/article_model.dart';

class ApiService {
  static final apiKey = dotenv.env['News_APIKEY'];
  static final String baseUrl = 'https://newsdata.io/api/1/latest?apikey=$apiKey&size=5&removeduplicate=1';

  static Future<Map<String, dynamic>> fetchNewsByCountryAndLanguage(String? nextPage, List<String> countries, List<String> languages, bool isSearching, String query) async {

    String url = baseUrl;


    if (languages.isNotEmpty) {
      url = "$url&language=${languages.join(',')}";
    }

    if (countries.isNotEmpty) {
      url = "$url&country=${countries.join(',')}";
    }

    if (isSearching && query.isNotEmpty) {
      url = '$url&q=${Uri.encodeComponent(query)}';
    }


    if (nextPage != null && nextPage.isNotEmpty) {
      url = "$url&page=$nextPage";
    }

    print('Fetching URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['results'] ?? [];
        final List<ArticleModel> articles = data.map((item) => ArticleModel.fromJson(item)).where((article) => article.title.isNotEmpty).toList();

        return {
          'articles': articles,
          'nextPage': json['nextPage'],
        };
      }
      else {
        print('API Error: ${response.body}');
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching news: $e');
      throw Exception('Error fetching news: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchNewsByCategory(String category, String? nextPage, List<String> languages, List<String> countries) async {

    String url = '$baseUrl&category=$category';

    if (languages.isNotEmpty) {
      url = '$url&language=${languages.join(',')}';
    }

    if (countries.isNotEmpty) {
      url = '$url&country=${countries.join(',')}';
    }

    if (nextPage != null && nextPage.isNotEmpty) {
      url = '$url&page=$nextPage';
    }

    print('Fetching Category URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> data = json['results'] ?? [];
        List<ArticleModel> articles = data.map((i) => ArticleModel.fromJson(i)).where((article) => article.title.isNotEmpty).toList();

        return {
          'articles': articles,
          'nextPage': json['nextPage']
        };
      } else {
        print('Category API Error: ${response.statusCode}');
        throw Exception('Failed to fetch category data');
      }
    } catch(e) {
      print('Error fetching category news: $e');
      throw Exception(e.toString());
    }
  }
}