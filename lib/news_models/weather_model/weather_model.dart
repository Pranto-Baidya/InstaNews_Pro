

import 'package:intl/intl.dart';

class WeatherModel {
  final String name;
  final String country;
  final double tempC;
  final String condition;
  final String lastUpdatedAt;
  final String icon;
  final Forecast? forecast;

  WeatherModel({
    required this.name,
    required this.country,
    required this.tempC,
    required this.condition,
    required this.lastUpdatedAt,
    required this.icon,
    this.forecast
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {

    final epoch = json['current']['last_updated_epoch'] as int;

    final dateUTC = DateTime.fromMillisecondsSinceEpoch(epoch*1000, isUtc: true);

    final asianTime = dateUTC.add(Duration(hours: 6));

    final formatted = DateFormat('dd/MM/yyyy, hh:mm a').format(asianTime);

    return WeatherModel(
      name: json['location']['name'] as String,
      country: json['location']['country'] as String,
      tempC: (json['current']['temp_c'] as num).toDouble(),
      condition: json['current']['condition']['text'] as String,
      lastUpdatedAt: formatted,
      icon: "https:${json['current']['condition']['icon']}",
      forecast: json['forecast']!=null? Forecast.fromJson(json['forecast']) : null,
    );
  }
}

class Forecast {
  final List<ForecastDay> forecastDay;

  Forecast({required this.forecastDay});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      forecastDay: (json['forecastday'] as List).asMap().entries
          .where((i)=>i.key!=0)
          .map((i) => ForecastDay.fromJson(i.value)).toList(),
    );
  }
}

class ForecastDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final double totalPrecip;
  final int dailyChanceOfRain;
  final String condition;
  final String icon;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.totalPrecip,
    required this.dailyChanceOfRain,
    required this.condition,
    required this.icon,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    final day = json['day'];
    return ForecastDay(
      date: json['date'] as String,
      maxTemp: (day['maxtemp_c'] as num).toDouble(),
      minTemp: (day['mintemp_c'] as num).toDouble(),
      totalPrecip: (day['totalprecip_mm'] as num).toDouble(),
      dailyChanceOfRain: (day['daily_chance_of_rain'] as num).toInt(),
      condition: day['condition']['text'] as String,
      icon: "https:${day['condition']['icon']}",
    );
  }
}
