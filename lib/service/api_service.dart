import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wheatther_app/model/model.dart';

class WeatherApiService {
  final String _apiKey =
      'http://api.weatherapi.com/v1/current.json?key=&q=srilanka&aqi=yes';
  final String _baseUrl = 'http://api.weatherapi.com/v1';

  Future<Weather> fetchWeather(String location) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/current.json?key=$_apiKey&q=$location'),
    );

    if (response.statusCode == 403) {
      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception(
          'Failed to load weather data. Status code: ${response.statusCode}');
    }
  }
}
