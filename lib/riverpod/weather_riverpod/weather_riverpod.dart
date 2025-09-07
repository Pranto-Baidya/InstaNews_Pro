

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instanews_pro/api_service/weather_api_service.dart';
import 'package:instanews_pro/news_models/weather_model/weather_model.dart';

final weatherProvider = StateNotifierProvider<WeatherNotifier,WeatherState>((ref)=>WeatherNotifier());

class WeatherState {
  final WeatherModel? weather;
  final bool isLoading;
  final String? error;

  WeatherState({
    this.weather,
    this.isLoading = false,
    this.error
  });

  WeatherState copyWith({WeatherModel? weather,bool? isLoading, String? error}) {
    return WeatherState(
        weather: weather ?? this.weather,
        isLoading:  isLoading ?? this.isLoading,
        error: error ?? this.error
    );
  }
}


class WeatherNotifier extends StateNotifier<WeatherState>{

   WeatherNotifier() : super(WeatherState());

   Future<void> fetchCurrentWeather()async{
     state = state.copyWith(isLoading: true, error: null,weather: null);

     try {
       final data = await WeatherApiService.fetchWeather();

       state = state.copyWith(
           weather: data,
           error: null,
           isLoading: false
       );
     }
     catch(e){
       state =state.copyWith(isLoading: false, error: e.toString());
     }
   }


}

