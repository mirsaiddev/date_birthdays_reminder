import 'dart:io';

import 'package:date_reminder/models/background_process_tr.dart';
import 'package:date_reminder/screens/splash.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/background_procces.dart';
import 'models/background_process_ru.dart';
import 'models/constants.dart';
import 'models/localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon_eraser');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  });

  _initAdMob();
  runApp(
    /*DevicePreview(
      enabled: true,
      builder: (context) => */MyApp(), // Wrap your app
    //),
  );
}

Future<void> _initAdMob() {
  return FirebaseAdMob.instance.initialize(appId: "ca-app-pub-4933632708961711~8628365688");
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int themeNumber;
  String langName;
  SharedPreferences prefs;
  Locale defaultLocale;

  String localeName;
  String localLower;
  String localUpper;

  findLocale() {
    localeName = Platform.localeName;
    localLower = '${localeName[0]}${localeName[1]}';
    localUpper = '${localeName[2]}${localeName[3]}';
  }

  Future<void> checkSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    themeNumber = prefs.getInt("themeNumber");
    langName = prefs.getString("lang");
    if (langName == null) {
      defaultLocale = Locale(localLower, localUpper);
    } else if (langName == "en") {
      defaultLocale = Locale('en', 'US');
    } else if (langName == "tr") {
      defaultLocale = Locale("tr", "TR");
    } else if (langName == "ru") {
      defaultLocale = Locale("ru", "RU");
    }

    if (themeNumber == null || themeNumber == 0) {
      themeNumber = 0;
    } else {
      themeNumber = themeNumber;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkSharedPrefs();
    findLocale();
  }

  @override
  Widget build(BuildContext context) {
    checkSharedPrefs();
    //print(defaultLocale);
    if (defaultLocale != null) {
      if (defaultLocale.languageCode == "en") {
        // ignore: unused_local_variable
        BackGroundProcesses _backGroundProcesses = BackGroundProcesses();
      } else if (defaultLocale.languageCode == "tr") {
        // ignore: unused_local_variable
        BackGroundProcessesTr _backGroundProcessesTr = BackGroundProcessesTr();
      } else if (defaultLocale.languageCode == "ru") {
        // ignore: unused_local_variable
        BackGroundProcessesRu _backGroundProcesses = BackGroundProcessesRu();
      }
    }

    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
        Locale('ru', 'RU'),
      ],
      //builder: DevicePreview.appBuilder,
      locale: defaultLocale,
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return Locale(localLower, localUpper);
      },
      title: 'date',
      themeMode: themeNumber == 0
          ? ThemeMode.system
          : themeNumber == 1
              ? ThemeMode.dark
              : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackground,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Poppins",
        textTheme: TextTheme(
          headline5: TextStyle(color: Colors.black, fontSize: 16),
          headline6: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        bottomAppBarColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.grey),
        timePickerTheme: TimePickerThemeData(
          dayPeriodColor: Colors.blue,
          dayPeriodTextColor: Colors.cyan,
          dialHandColor: kPrimaryColor,
          hourMinuteTextColor: kPrimaryColor,
        ),
      ),
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(),
        primaryColor: kPrimaryColor,
        colorScheme: ColorScheme(
          primary: kPrimaryColor,
          primaryVariant: Colors.white,
          secondary: brt,
          secondaryVariant: fun,
          surface: Colors.black,
          background: wed,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: kBlackBackground,
        fontFamily: "Poppins",
        textTheme: TextTheme(
          headline5: TextStyle(color: Colors.white, fontSize: 16),
          headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        bottomAppBarColor: Colors.black,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.grey),
        timePickerTheme: TimePickerThemeData(
          dayPeriodColor: Colors.blue,
          dayPeriodTextColor: Colors.cyan,
          dialHandColor: kPrimaryColor,
          hourMinuteTextColor: kPrimaryColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
