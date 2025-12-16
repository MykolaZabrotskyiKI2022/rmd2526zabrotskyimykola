class WeatherInfo {
  const WeatherInfo({
    required this.city,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.updatedAt,
  });

  final String city;
  final double temp;
  final double feelsLike;
  final int humidity;
  final String description;
  final String icon;
  final double windSpeed;
  final DateTime updatedAt;

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final weather0 = (json['weather'] as List).first as Map<String, dynamic>;
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;

    return WeatherInfo(
      city: (json['name'] ?? '').toString(),
      temp: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: (main['humidity'] as num).toInt(),
      description: (weather0['description'] ?? '').toString(),
      icon: (weather0['icon'] ?? '').toString(),
      windSpeed: (wind['speed'] as num).toDouble(),
      updatedAt: DateTime.now(),
    );
  }
}
