
class WeatherModel {
  final String name;
  final String country;
  final double tempC;
  final String condition;
  final String icon;

  WeatherModel({
    required this.name,
    required this.country,
    required this.tempC,
    required this.condition,
    required this.icon
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['location']['name'] as String,
      country: json['location']['country'] as String,
      tempC: (json['current']['temp_c'] as num).toDouble(),
      condition: json['current']['condition']['text'] as String,
        icon: "https:${json['current']['condition']['icon']}"
    );
  }
}
