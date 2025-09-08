
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:instanews_pro/news_models/weather_model/weather_model.dart';

class WeatherApiService{

  static final apiKey = dotenv.env['Weather_APIKEY'];

  static final String baseUrl = 'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=auto:ip&aqi=no&days=3';

  static Future<WeatherModel> fetchWeather()async{

    final response = await http.get(Uri.parse(baseUrl));

    try{
      if(response.statusCode==200){
        Map<String,dynamic> json = jsonDecode(response.body);

        return WeatherModel.fromJson(json);
      }
      else{
        throw Exception('Something went wrong');
      }
    }
    catch(e){
       throw Exception(e.toString());
    }

  }

}