import 'dart:async';
import 'package:date_reminder/screens/main_menu.dart';
import 'package:date_reminder/screens/onboarding/onboarding.dart';
import 'package:date_reminder/models/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int login;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      yonlendir();
    });
  }

  void yonlendir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = prefs.getInt("login");
    if (login == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Onboarding(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainMenu(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/app_icon_eraser.png",
          width: SizeConfig.screenWidth * 2 / 6,
        ),
      ),
    );
  }
}
