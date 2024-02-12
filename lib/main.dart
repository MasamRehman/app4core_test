import 'package:flutter/material.dart';
import 'package:masam_flutter_task/View/screens/splash_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masam_flutter_task/provider/setting_provider.dart';
import 'package:masam_flutter_task/provider/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  runApp(MyApp(
   
  ));
}

class MyApp extends StatelessWidget {
 
  MyApp({super.key,});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => WeatherProvider()),
          ChangeNotifierProvider(create: (context) => SettingProvider()),
        ],
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
         
            return MaterialApp(
              debugShowCheckedModeBanner: false,
           
              locale: provider.applocale,
              localizationsDelegates: [AppLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
              supportedLocales: [
                Locale('en'),
                Locale('ar'),
              ],
              home: WeatherSplashScreen(),
            );
          },
        ));
  }
}
