import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wheatther_app/model/model.dart';

class WeatherApiService {
  Future<Weather> fetchWeather(String location) async {
    final response = await http.get(
      Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=6c9e014a13794e2894f183803240409&q=$location&days=1&aqi=no&alerts=no'),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception(
          'Failed to load weather data. Status code: ${response.toString()}');
    }
  }
}
