import 'package:date_reminder/components/default_button.dart';
import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:date_reminder/screens/main_menu.dart';
import 'package:date_reminder/screens/onboarding/splash_content.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  PageController _pageController;

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [
      SplashContent(
        text:
            AppLocalizations.of(context).translate('onboarding_1'),
        image: "assets/onboarding_assets/forget.png",
      ), //If you forget the birthdays of your friends, this application is for you !
      SplashContent(
        text: AppLocalizations.of(context).translate('onboarding_2'),
        image: "assets/onboarding_assets/gift.png",
      ),
      SplashContent(
        text: AppLocalizations.of(context).translate('onboarding_3'),
        image: "assets/onboarding_assets/calendar.png",
      ),
    ];
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView(
                physics: BouncingScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                controller: _pageController,
                children: contents,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    DefaultButton(
                      text: AppLocalizations.of(context).translate('Continue'),
                      press: () {
                        currentPage != 2
                            ? _pageController.nextPage(duration: _kDuration, curve: _kCurve)
                            : Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainMenu(),
                                ),
                              );
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
