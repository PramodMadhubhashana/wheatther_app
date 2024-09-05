import 'package:wheatther_app/model/forcast_data.dart';
import 'package:intl/intl.dart';

class Weather {
  String city;
  String region;
  String country;
  double temperature;
  String dateTime;
  double uv;
  int humidity;
  String sunrise;
  double maxtemp;
  double mintemp;
  double windspeed;
  String sunset;
  String iconurl;
  List<HourlyForcast> hourlyforcastdata;

  Weather({
    this.city = 'Loading...',
    this.region = 'Loading...',
    this.country = 'Loading...',
    this.temperature = 0.0,
    this.dateTime = '',
    this.uv = 0.0,
    this.humidity = 0,
    this.sunrise = 'Loading...',
    this.maxtemp = 0.0,
    this.mintemp = 0.0,
    this.windspeed = 0.0,
    this.sunset = 'Loading...',
    this.iconurl = '',
    this.hourlyforcastdata = const [],
  });

  static String formatEpochTime(int epochtime) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochtime * 1000);
    String formatedTime = DateFormat('hh:mm a').format(dateTime);
    return formatedTime;
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    final hourlistjson = json['forecast']['forecastday'][0]['hour'] as List;
    List<HourlyForcast> hourlyforcastlist = hourlistjson.map((hour) {
      return HourlyForcast(
        time: formatEpochTime(hour['time_epoch']),
        temp: hour['temp_c'],
        iconurl: hour['condition']['icon'],
        humidity: hour['humidity'],
      );
    }).toList();

    return Weather(
      city: json['location']['name'],
      region: json['location']['region'],
      country: json['location']['country'],
      dateTime: json['location']['localtime'],
      temperature: json['current']['temp_c'],
      uv: json['current']['uv'],
      humidity: json['current']['humidity'],
      sunrise: json['forecast']['forecastday'][0]['astro']['sunrise'],
      maxtemp: json['forecast']['forecastday'][0]['day']['maxtemp_c'],
      mintemp: json['forecast']['forecastday'][0]['day']['mintemp_c'],
      windspeed: json['current']['wind_kph'],
      sunset: json['forecast']['forecastday'][0]['astro']['sunset'],
      iconurl: json['current']['condition']['icon'],
      hourlyforcastdata: hourlyforcastlist,
    );
  }
}
