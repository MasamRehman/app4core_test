import 'package:flutter/material.dart';

enum Unit { metric, imperial }

class SettingProvider extends ChangeNotifier {
  Unit _unit = Unit.metric; // Default unit is metric

  Unit get unit => _unit;

  void changeUnit(Unit newUnit) {
    _unit = newUnit;
    notifyListeners();
  }

  // Add methods to convert temperature based on the selected unit
  double convertToPreferredUnit(double temperature) {
    if (_unit == Unit.metric) {
      // Convert temperature to Celsius if metric unit is selected
      return temperature - 273.15; // Subtract 273.15 to convert from Kelvin to Celsius
    } else {
      // Convert temperature to Fahrenheit if imperial unit is selected
      return (temperature - 273.15) * 9 / 5 + 32; // Subtract 273.15 to convert from Kelvin to Celsius, then apply Fahrenheit conversion
    }
  }
}
