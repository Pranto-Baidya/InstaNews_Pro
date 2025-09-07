

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final showWeatherProvider = StateNotifierProvider<SettingsNotifier,bool>((ref)=>SettingsNotifier());

class SettingsNotifier extends StateNotifier<bool>{

  SettingsNotifier() : super(true){
   loadWeather();
  }

 static const String key = 'show_weather';

  Future<void> loadWeather()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    state = preferences.getBool(key) ?? true;
  }

  Future<void> saveWeather(bool value)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
    state = value;
  }

}