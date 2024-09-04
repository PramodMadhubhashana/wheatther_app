import 'package:flutter/material.dart';
import 'package:wheatther_app/model/model.dart';
import 'package:wheatther_app/service/api_service.dart';

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
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  void _getWeather() async {
    setState(() {
      isLoading = true;
    });

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
      body: SingleChildScrollView(
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
                    const Text(
                      "Galle, Southern Province, Sri Lanka",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "18\u00B0C",
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.sunny,
                          size: 80,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Forecast",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 98, 41, 255),
                    ),
                    child: const Text(
                      "Next Hour",
                      style: TextStyle(color: Colors.white),
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
                itemCount: 24,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
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
                        child: const Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Text(
                              "10AM-11AM",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 15)),
                            Text(
                              "18\u00B0C",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            Icon(
                              Icons.cloud,
                              size: 40,
                            ),
                            Text("25%"),
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
                        _buildWeatherInfoCard(Icons.wb_sunny, "UV Index"),
                        _buildWeatherInfoCard(Icons.thermostat, "High & Low"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherInfoCard(Icons.waves, "Humidity"),
                        _buildWeatherInfoCard(Icons.wind_power, "Wind Speed"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildWeatherInfoCard(Icons.sunny_snowing, "Sunrise"),
                        _buildWeatherInfoCard(Icons.nights_stay, "Sunset"),
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

  Widget _buildWeatherInfoCard(IconData icon, String label) {
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
          Icon(icon),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
