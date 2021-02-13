import 'package:flutter/material.dart';
import '../../models/constants.dart';
import '../../models/size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({Key key, this.text, this.image}) : super(key: key);

  final String text, image;

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;

    return Column(
      children: [
        Spacer(),
        Text(
          date,
          style: TextStyle(
            fontSize: 30,
            color: kPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeIsLight ? Colors.black54 : Colors.white,
              ),
            )),
        Spacer(),
        Image.asset(image, height: getProporionateScreenHeight(265)),
      ],
    );
  }
}
