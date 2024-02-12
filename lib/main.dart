import 'package:flutter/material.dart';
import 'package:masam_flutter_task/View/screens/splash_screen.dart';
import 'package:masam_flutter_task/View/screens/weather_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masam_flutter_task/provider/setting_provider.dart';
import 'package:masam_flutter_task/provider/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  final String languageCode = sp.getString("language_code") ?? "";
  runApp(MyApp(
    locale: languageCode,
  ));
}

class MyApp extends StatelessWidget {
  final String locale;
  MyApp({super.key, required this.locale});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => WeatherProvider()),
          ChangeNotifierProvider(create: (context) => SettingProvider()),
        ],
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            if (locale.isEmpty) {
              provider.changeLanguage(Locale("en"));
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: locale == ""
                  ? Locale("en")
                  : provider.applocale == null
                      ? Locale("en")
                      : provider.applocale,
              localizationsDelegates: const [AppLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
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
