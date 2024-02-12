import 'package:flutter/material.dart';
import 'package:masam_flutter_task/provider/weather_provider.dart';
import 'package:masam_flutter_task/models/weather_model.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class WeatherDetailPage extends StatefulWidget {
  final Forecast forecasting;
  double temperatureCelsius;
  String dayname;
  String sunrise;
  String sunset;
  WeatherDetailPage({super.key, required this.forecasting, required this.temperatureCelsius, required this.dayname, required this.sunrise, required this.sunset});

  @override
  State<WeatherDetailPage> createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(builder: (context, weatherprovider, _) {
      return 
       Scaffold(
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                   
                    ConstantColor.darkpurple,
                    ConstantColor.lightpurple,
                    ConstantColor.balck
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: ConstantColor.whiteColor,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Image.asset("assets/Weather-sun-clouds-rain.svg.png"),
                    Text(
                      '${weatherprovider.toCelsius(widget.temperatureCelsius).toStringAsFixed(0)}°C ',
                      style: const TextStyle(fontSize: 55, color: ConstantColor.whiteColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.forecasting.weather[0].description}',
                      style: const TextStyle(fontSize: 20, color: ConstantColor.whiteColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.dayname}',
                      style: const TextStyle(fontSize: 20, color: ConstantColor.whiteColor),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.sunny,
                              color: Colors.orange.shade400,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sunrise",
                                  style: TextStyle(color: ConstantColor.whiteColor.withOpacity(0.8)),
                                ),
                                Text(
                                  "${widget.sunrise}",
                                  style: const TextStyle(color: ConstantColor.whiteColor, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.sunny_snowing,
                              color: Colors.orange.shade400,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sunset",
                                  style: TextStyle(color: ConstantColor.whiteColor.withOpacity(0.8)),
                                ),
                                Text(
                                  "${widget.sunset}",
                                  style: const TextStyle(color: ConstantColor.whiteColor, fontSize: 13),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
    });
  }
}
