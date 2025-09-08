
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:instanews_pro/news_models/article_model/article_model.dart';

class ApiService {

  static final apiKey = dotenv.env['News_APIKEY'];

  static final String baseUrl = 'https://newsdata.io/api/1/latest?apikey=$apiKey&size=5&removeduplicate=1';

  static Future<Map<String,dynamic>> fetchAllNews(String? nextPage, bool isSearching,String query)async{
    String url = baseUrl;

    if(isSearching){
      url = '$url&q=$query';

      if(nextPage!=null){
        url = '$url&page=$nextPage';
      }
    }
    else {
      if (nextPage != null) {
        url = '$url&page=$nextPage';
      }
    }

    try {

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {

        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> data = json['results'];
        List<ArticleModel> articles = data.map((i) => ArticleModel.fromJson(i)).toList();

        Map<String, dynamic> result = {
          'articles': articles,
          'nextPage': json['nextPage'],
        };
        return result;
      }
      else {
        throw Exception('Failed to fetch data');
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }

    static Future<Map<String,dynamic>> fetchNewsByCategory(String category,String? nextPage)async{
      String url = '$baseUrl&category=$category';

      if(nextPage!=null){
        url = '$url&page=$nextPage';
      }

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);
          List<dynamic> data = json['results'];
          List<ArticleModel> articles = data.map((i) =>
              ArticleModel.fromJson(i)).toList();
          return {
            'articles': articles,
            'nextPage': json['nextPage']
          };
        }
        else {
          throw Exception('Failed to fetch data');
        }
      }catch(e){
        throw Exception(e.toString());
      }
    }

  static Future<Map<String, dynamic>> fetchNewsByCountryAndLanguage(String? nextPage, List<String> countries, List<String> languages) async {

    String country = countries.join(',');
    String language = languages.join(',');

    String url = '$baseUrl&language=$language&country=$country';

    if (nextPage != null) {
      url = '$url&page=$nextPage';
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['results'] ?? [];
        final List<ArticleModel> articles =
        data.map((item) => ArticleModel.fromJson(item)).toList();

        return {
          'articles': articles,
          'nextPage': json['nextPage'],
        };
      } else {
        throw Exception('Failed to fetch data, \n${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
  }
