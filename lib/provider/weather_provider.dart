import 'dart:convert';



import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';



import '../models/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  Locale? _appLocale;
  Locale? get applocale => _appLocale;
  void changeLanguage(Locale type) async {
    
    _appLocale = type;
    
    notifyListeners();
  }

  String apikey = "fc8d7048351e691809fdc416f294b8cc";
  // late WeatherData _weatherData;
  WeatherData _weatherData = WeatherData(
    cod: '',
    message: 0,
    cnt: 0,
    list: [],
    city: City(
      id: 0,
      name: '',
      coord: Coord(lat: 0.0, lon: 0.0),
      country: '',
      population: 0,
      timezone: 0,
      sunrise: 0,
      sunset: 0,
    ),
  );

  Position? _currentPosition;
  String _currentCityName = '';

  WeatherData get weatherData => _weatherData;
  Position? get currentPosition => _currentPosition;
  String get currentCityName => _currentCityName;

  WeatherProvider() {
    _getLocationPermissionAndGetCurrentLocation();
  }

  Future<void> _getLocationPermissionAndGetCurrentLocation() async {
    PermissionStatus status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      await _getCurrentLocation();
    } else {
      if (await Permission.location.request().isGranted) {
        await _getCurrentLocation();
      } else {
        print('Location permission denied by user.');
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = position;
      notifyListeners();
      await fetchWeatherData();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> fetchWeatherData() async {
    try {
      String apiUrl;

      if (_currentPosition != null) {
        print("latitude${_currentPosition!.latitude}");
        print("latitude${_currentPosition!.longitude}");

        apiUrl = 'https://api.openweathermap.org/data/2.5/forecast?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&appid=$apikey';
      } else {
        print('Error: No location available.');
        return;
      }

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _weatherData = WeatherData.fromJson(data);
        String currentCityName = _weatherData.city.name;
        String countryName = _weatherData.city.country;
        print("City: $currentCityName, Country: $countryName");
        print("data${_weatherData}");
      } else if (response.statusCode == 401) {
        // Unauthorized - Incorrect or expired API key
        throw Exception('Unauthorized: Incorrect or expired API key');
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      notifyListeners();
    }
  }
  

  void onLanguageChanged(String selectedLanguage) {
    selectedLanguage = selectedLanguage;
    notifyListeners();
  }

  List<String> getWeekDays() {
    List<String> days = [];

    if (_currentPosition != null) {
      DateTime currentDate = DateTime.now();
      for (int i = 0; i < 7; i++) {
        DateTime nextDate = currentDate.add(Duration(days: i));
        String dayName = _getDayName(nextDate.weekday);
        days.add('$dayName, ${nextDate.day}/${nextDate.month}');
      }
    }

    return days;
  }

  double toCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  double toFahrenheit(double kelvin) {
    return (toCelsius(kelvin) * 9 / 5) + 32;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
