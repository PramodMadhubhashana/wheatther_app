import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:wheatther_app/model/model.dart';
import 'package:wheatther_app/service/api_service.dart';
import 'package:wheatther_app/service/currentlocation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter weather',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherApiService apiService = WeatherApiService();
  Weather? weather;
  final Location location = Location();
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    _getlocation();
  }

  void _getlocation() async {
    try {
      final currenLocation = await location.getcurrentLocation();
      setState(() {
        _controller.text =
            "${currenLocation.latitude}, ${currenLocation.longitude}";
        _getWeather();
      });
    } catch (e) {
      print("Error getting Location ${e}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _getWeather() async {
    try {
      final fetchWeather = await apiService.fetchWeather(_controller.text);
      setState(() {
        weather = fetchWeather;
      });
    } catch (e) {
      print("Error Fetching weather: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    height: 300,
                    width: screenWidth,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 115, 176, 255),
                          Color.fromARGB(255, 98, 41, 255),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Enter location',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: _getWeather,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 6)),
                          Text(
                            '${weather?.city}, ${weather?.region}, ${weather?.country}',
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 30)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${weather?.temperature}\u00B0C",
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Image.network(
                                'https:${weather?.iconurl}',
                                width: 100,
                                height: 100,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Icon(Icons.sunny);
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 30, top: 20, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Forecast",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color.fromARGB(255, 98, 41, 255),
                          ),
                          child: const Text(
                            "Next Hour",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weather?.hourlyforcastdata.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        final data = weather?.hourlyforcastdata[index];
                        return Row(
                          children: [
                            Container(
                              height: 160,
                              width: 150,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Color.fromARGB(255, 200, 225, 255),
                              ),
                              child: Column(
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 10)),
                                  Text(
                                    '${data?.time}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 15)),
                                  Text(
                                    "${data?.temp}\u00B0C",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Image.network(
                                    'https:${data?.iconurl}',
                                    width: 50,
                                    height: 50,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return const Icon(Icons.sunny);
                                    },
                                  ),
                                  Text("${data?.humidity} %"),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 0.9,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildWeatherInfoCard(Icons.wb_sunny, "UV Index",
                                  '${weather?.uv.toString()}'),
                              _buildWeatherInfoCard(
                                  Icons.thermostat,
                                  "High & Low",
                                  '${weather?.maxtemp.toString()}\u00B0C & ${weather?.mintemp.toString()}\u00B0C'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildWeatherInfoCard(Icons.waves, "Humidity",
                                  '${weather?.humidity.toString()} %'),
                              _buildWeatherInfoCard(
                                  Icons.wind_power,
                                  "Wind Speed",
                                  '${weather?.windspeed.toString()} Kph'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildWeatherInfoCard(Icons.sunny_snowing,
                                  "Sunrise", '${weather?.sunrise}'),
                              _buildWeatherInfoCard(Icons.nights_stay, "Sunset",
                                  '${weather?.sunset}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildWeatherInfoCard(IconData icon, String label, String value) {
    return Container(
      width: 140,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.black.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon)],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ],
      ),
    );
  }
}
