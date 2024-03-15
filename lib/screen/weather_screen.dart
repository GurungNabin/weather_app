import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  //api key
  final _weatherService =
      WeatherService(apiKey: 'e3e6f201a0259af1f85074b4b5fb61db');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    //any errors
    catch (e) {
      print(e);
    }
  }

  //weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/json/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/json/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/json/rain.json';
      case 'thunderstrom':
        return 'assets/json/thunder.json';
      case 'clear':
        return 'assets/json/sunny.json';
      default:
        return 'assets/json/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? 'Loading city...'),

            //animation
            Lottie.asset(
              getWeatherAnimation(_weather?.mainCondition),
            ),

            //temperature
            Text('${_weather?.temperature.round()}*c'),

            //weather condition
            Text(_weather?.mainCondition ?? ""),
          ],
        ),
      ),
    );
  }
}
