import 'package:flutter/material.dart';
import 'package:masam_flutter_task/View/screens/weather_screen.dart';


import '../../utils/colors.dart';

class WeatherSplashScreen extends StatefulWidget {
  const WeatherSplashScreen({super.key});

  @override
  State<WeatherSplashScreen> createState() => _WeatherSplashScreenState();
}

class _WeatherSplashScreenState extends State<WeatherSplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => WeatherScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color(0xff5725e4).withOpacity(0.6),
            Color(0xff523370),
            Color(0xff040305),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Weather-sun-clouds-rain.svg.png"),
              Text(
                "My Weather App",
                style: TextStyle(fontSize: 30, color: ConstantColor.whiteColor),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
