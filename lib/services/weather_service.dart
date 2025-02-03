import 'dart:convert';
import 'package:http/http.dart' as http;


class WeatherService {
  static const String _apiKey = 'aef0345ffa58725bdb74e47150fec4f9';
  static const String _baseWeatherUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String _baseForecastUrl =
      'https://api.openweathermap.org/data/2.5/forecast';

 

  static Future<Map<String, dynamic>> getWeather(String city) async {
    // Requête HTTP à l'API pour les données météo actuelles
    final response = await http.get(
      Uri.parse('$_baseWeatherUrl?q=$city&appid=$_apiKey&units=metric&lang=fr'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Échec de la récupération des données météorologiques.');
    }
  }

  static Future<Map<String, dynamic>> getForecast(String city) async {
    // Requête HTTP à l'API pour les prévisions météo
    final response = await http.get(
      Uri.parse('$_baseForecastUrl?q=$city&appid=$_apiKey&units=metric&lang=fr'),
    );

    if (response.statusCode == 200) {
      final forecastData = json.decode(response.body);
      return _extractNextHourForecast(forecastData);
    } else {
      throw Exception('Échec de la récupération des prévisions météorologiques.');
    }
  }

  static Map<String, dynamic> _extractNextHourForecast(Map<String, dynamic> forecastData) {
    final List<dynamic> forecastList = forecastData['list'];
    if (forecastList.isNotEmpty) {
      final nextHourForecast = forecastList.first;
      return {
        'windSpeed': (nextHourForecast['wind']['speed'] ?? 0.0).toDouble(),
        'windDirection': (nextHourForecast['wind']['deg'] ?? 0).toInt(),
      };
    } else {
      throw Exception('Aucune prévision disponible.');
    }
  }
}
