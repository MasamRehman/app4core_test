import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masam_flutter_task/View/screens/splash_screen.dart';

import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/weather_provider.dart';
import '../../provider/setting_provider.dart';
import 'package:masam_flutter_task/View/screens/setting_screen.dart';
import 'package:masam_flutter_task/View/screens/weather_detail_page.dart';
import '../../utils/colors.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

enum Language { english, arabic }

class _WeatherScreenState extends State<WeatherScreen> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = (connectivityResult != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (context, provider, child) {
      return Consumer<WeatherProvider>(
        builder: (context, weatherProvider, _) {
          return Scaffold(
            appBar: AppBar(actions: [
              Consumer<WeatherProvider>(builder: (context, provider, child) {
                return PopupMenuButton(
                    onSelected: (Language item) {
                      if (Language.english.name == item.name) {
                        provider.changeLanguage(Locale("en"));
                      } else {
                        provider.changeLanguage(Locale("ar"));
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<Language>>[
                          PopupMenuItem(
                            value: Language.english,
                            child: Text("English"),
                          ),
                          PopupMenuItem(
                            value: Language.arabic,
                            child: Text("Arabic"),
                          )
                        ]);
              })
            ], title: Text("${AppLocalizations.of(context)!.appbarr}")),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ConstantColor.darkpurple, ConstantColor.lightpurple, ConstantColor.balck],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: ConstantColor.whiteColor,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Text(
                            AppLocalizations.of(context)!.thisweek,
                            style: const TextStyle(color: ConstantColor.whiteColor, fontSize: 25),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${weatherProvider.weatherData!.city.name}(${weatherProvider.weatherData!.city.country})",
                            style: const TextStyle(color: ConstantColor.whiteColor, fontSize: 20),
                          )
                        ],
                      )
                    ],
                  ),
                  !_isConnected
                      ? Center(
                          child: AlertDialog(
                            title: Text('No Internet'),
                            content: Text('Please check your internet connection.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => WeatherSplashScreen()));
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        )
                      : weatherProvider.weatherData.list.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, index) {
                                final forecast = weatherProvider.weatherData!.list[index];
                                final dayName = weatherProvider.getWeekDays()[index];
                                double temperatureCelsius = forecast.main.temp;
                                final city_data = weatherProvider.weatherData!.city;
                                DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(city_data.sunrise * 1000);
                                DateTime sunset = DateTime.fromMillisecondsSinceEpoch(city_data.sunset * 1000);
                                DateFormat timeFormat = DateFormat('hh:mm a');
                                String formattedSunrise = timeFormat.format(sunrise);
                                String formattedSunset = timeFormat.format(sunset);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WeatherDetailPage(
                                          sunrise: formattedSunrise,
                                          sunset: formattedSunset,
                                          forecasting: forecast,
                                          temperatureCelsius: temperatureCelsius,
                                          dayname: dayName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dayName,
                                            style: const TextStyle(fontSize: 15, color: ConstantColor.whiteColor),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.network(
                                            'https://openweathermap.org/img/wn/${forecast.weather[0].icon}.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            '${forecast.weather[0].main}',
                                            style: const TextStyle(fontSize: 15, color: ConstantColor.whiteColor),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${provider.convertToPreferredUnit(temperatureCelsius).toStringAsFixed(0)}°${provider.unit == Unit.metric ? "C" : "F"}',
                                            style: const TextStyle(fontSize: 15, color: ConstantColor.whiteColor),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Divider(
                                      height: 0.1,
                                      color: ConstantColor.whiteColor.withOpacity(0.2),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                );
                              },
                              itemCount: weatherProvider.weatherData!.list.length > 5 ? 5 : weatherProvider.weatherData!.list.length,
                            ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 200,
                        child: Center(
                            child: Text(
                          "${AppLocalizations.of(context)!.setting}",
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
