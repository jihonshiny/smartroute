class WeatherService {
  Future<WeatherData?> getCurrentWeather(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return WeatherData(
      temperature: 18,
      condition: 'Cloudy',
      humidity: 65,
      windSpeed: 3.5,
      icon: '☁️',
    );
  }

  Future<List<HourlyForecast>> getHourlyForecast(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.generate(24, (i) => HourlyForecast(
      time: DateTime.now().add(Duration(hours: i)),
      temperature: 15 + (i % 10),
      condition: i % 3 == 0 ? 'Rain' : 'Clear',
      precipitation: i % 5 == 0 ? 0.5 : 0.0,
    ));
  }
}

class WeatherData {
  final int temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final String icon;

  const WeatherData({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });
}

class HourlyForecast {
  final DateTime time;
  final int temperature;
  final String condition;
  final double precipitation;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.precipitation,
  });
}
