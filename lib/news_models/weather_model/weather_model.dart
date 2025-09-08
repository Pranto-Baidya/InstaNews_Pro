

class WeatherModel {
  final String name;
  final String country;
  final double tempC;
  final String condition;
  final String icon;
  final Forecast? forecast;

  WeatherModel({
    required this.name,
    required this.country,
    required this.tempC,
    required this.condition,
    required this.icon,
    this.forecast
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['location']['name'] as String,
      country: json['location']['country'] as String,
      tempC: (json['current']['temp_c'] as num).toDouble(),
      condition: json['current']['condition']['text'] as String,
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
      forecastDay: (json['forecastday'] as List).map((i) => ForecastDay.fromJson(i)).toList(),
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
