import 'dart:io';

import 'package:date_reminder/models/advert_services.dart';
import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

int adsCounter = 2;

class MorePage extends StatefulWidget {
  const MorePage({
    Key key,
  }) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final AdvertService _advertService = AdvertService();
  bool useSystemTheme = false;
  bool darkTheme = false;
  bool lightTheme = false;

  bool systemLang = false;
  bool english = false;
  bool russian = false;
  bool turkish = false;

  SharedPreferences sharedprefs;

  int themeNumber;
  String langName;
  String locale;

  Future<void> checkSharedPrefs() async {
    sharedprefs = await SharedPreferences.getInstance();
    themeNumber = sharedprefs.getInt("themeNumber");
    langName = sharedprefs.getString("lang");

    if (langName == null) {
      systemLang = true;
      english = false;
      russian = false;
      turkish = false;
    } else if (langName == "en") {
      systemLang = false;
      english = true;
      russian = false;
      turkish = false;
    } else if (langName == "tr") {
      systemLang = false;
      english = false;
      russian = false;
      turkish = true;
    } else if (langName == "ru") {
      systemLang = false;
      english = false;
      russian = true;
      turkish = false;
    }

    if (themeNumber == null) {
      sharedprefs.setInt("themeNumber", 0);
      useSystemTheme = true;
      darkTheme = false;
      lightTheme = false;
    } else if (themeNumber == 0) {
      useSystemTheme = true;
      darkTheme = false;
      lightTheme = false;
    } else if (themeNumber == 1) {
      useSystemTheme = false;
      darkTheme = true;
      lightTheme = false;
    } else if (themeNumber == 2) {
      useSystemTheme = false;
      darkTheme = false;
      lightTheme = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkSharedPrefs();
    if (adsCounter % 3 == 0) {
      _advertService.showInterstitial();
    }
    adsCounter++;
    findLocale();
  }

  findLocale() async {
    String localeName = Platform.localeName;
    locale = '${localeName[0]}${localeName[1]}';
  }

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Container(
        child: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Container(
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(70)),
                child: Column(
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(600),
                      height: ScreenUtil().setHeight(100),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Icon(Icons.color_lens, color: Colors.white),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              AppLocalizations.of(context).translate('Theme'),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(30),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(600),
                      decoration: BoxDecoration(
                        color: themeIsLight ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              setState(() {
                                sharedprefs.setInt("themeNumber", 0);
                                useSystemTheme = true;
                                darkTheme = false;
                                lightTheme = false;
                              });
                            },
                            leading: Icon(Feather.settings),
                            title: Text(
                              AppLocalizations.of(context).translate('System'),
                            ),
                            trailing: Radio(
                              activeColor: kPrimaryColor,
                              value: useSystemTheme,
                              groupValue: true,
                              onChanged: (value) {
                                setState(() {
                                  sharedprefs.setInt("themeNumber", 0);
                                  useSystemTheme = true;
                                  darkTheme = false;
                                  lightTheme = false;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                sharedprefs.setInt("themeNumber", 1);
                                useSystemTheme = false;
                                darkTheme = true;
                                lightTheme = false;
                              });
                            },
                            leading: Icon(Icons.brightness_2),
                            title: Text(
                              AppLocalizations.of(context).translate('Dark'),
                            ),
                            trailing: Radio(
                              activeColor: kPrimaryColor,
                              value: darkTheme,
                              groupValue: true,
                              onChanged: (value) {
                                setState(() {
                                  sharedprefs.setInt("themeNumber", 1);
                                  useSystemTheme = false;
                                  darkTheme = true;
                                  lightTheme = false;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                sharedprefs.setInt("themeNumber", 2);
                                useSystemTheme = false;
                                darkTheme = false;
                                lightTheme = true;
                              });
                            },
                            leading: Icon(Icons.brightness_5),
                            title: Text(
                              AppLocalizations.of(context).translate('Light'),
                            ),
                            trailing: Radio(
                              activeColor: kPrimaryColor,
                              value: lightTheme,
                              groupValue: true,
                              onChanged: (value) {
                                setState(() {
                                  sharedprefs.setInt("themeNumber", 2);
                                  useSystemTheme = false;
                                  darkTheme = false;
                                  lightTheme = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(70)),
                child: Column(
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(600),
                      height: ScreenUtil().setHeight(100),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Icon(Entypo.language, color: Colors.white),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              AppLocalizations.of(context).translate("Language"),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(30),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(600),
                      decoration: BoxDecoration(
                        color: themeIsLight ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              setState(() {
                                sharedprefs.setString("lang", "$locale");
                                systemLang = true;
                                english = false;
                                russian = false;
                                turkish = false;
                              });
                            },
                            title: Text(AppLocalizations.of(context).translate("Use System Language")),
                            leading: Icon(Feather.settings),
                            trailing: Radio(
                              activeColor: kPrimaryColor,
                              value: systemLang,
                              groupValue: true,
                              onChanged: (value) {
                                setState(() {
                                  sharedprefs.setString("lang", "$locale");
                                  systemLang = true;
                                  english = false;
                                  russian = false;
                                  turkish = false;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                sharedprefs.setString("lang", "en");
                                systemLang = false;
                                english = true;
                                russian = false;
                                turkish = false;
                              });
                            },
                            title: Text(AppLocalizations.of(context).translate("English")),
                            leading: Image.network(
                              "https://i.hizliresim.com/tPTHPo.png",
                              scale: ScreenUtil().setSp(4),
                            ),
                            trailing: Radio(
                              activeColor: kPrimaryColor,
                              value: english,
                              groupValue: true,
                              onChanged: (value) {
                                setState(() {
                                  sharedprefs.setString("lang", "en");
                                  systemLang = false;
                                  english = true;
                                  russian = false;
                                  turkish = false;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                sharedprefs.setString("lang", "ru");
                                systemLang = false;
                                english = false;
                                russian = true;
                                turkish = false;
                              });
                            },
                            title: Text(AppLocalizations.of(context).translate("Russian")),
                            leading: Image.network(
                              "https://i.hizliresim.com/azhSbA.png",
                              scale: ScreenUtil().setSp(4),
                            ),
                            trailing: Radio(
                              activeColor: kPrimaryColor,
                              value: russian,
                              groupValue: true,
                              onChanged: (value) {
                                setState(() {
                                  sharedprefs.setString("lang", "ru");
                                  systemLang = false;
                                  english = false;
                                  russian = true;
                                  turkish = false;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              setState(() {
                                sharedprefs.setString("lang", "tr");
                                systemLang = false;
                                english = false;
                                russian = false;
                                turkish = true;
                              });
                            },
                            leading: Image.network(
                              "https://i.hizliresim.com/cMrvBe.png",
                              scale: ScreenUtil().setSp(4),
                            ),
                            title: Text(AppLocalizations.of(context).translate("Turkish")),
                            trailing: Radio(
                              activeColor: kPrimaryColor,
                              value: turkish,
                              groupValue: true,
                              onChanged: (value) {
                                setState(() {
                                  sharedprefs.setString("lang", "tr");
                                  systemLang = false;
                                  english = false;
                                  russian = false;
                                  turkish = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InstagramInfo(),
              AboutThisApp(),
              ContactUs(),
              SizedBox(height: ScreenUtil().setHeight(200))
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ContactUs extends StatelessWidget {
  ContactUs({
    Key key,
  }) : super(key: key);

  _launchURL() async {
    const url = 'https://www.instagram.com/mirsaiddev/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'mirsaidefendi@example.com',
  );

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    return Container(
      child: Column(
        children: [
          Container(
            width: ScreenUtil().setWidth(600),
            height: ScreenUtil().setHeight(100),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Icon(Icons.help, color: Colors.white),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    AppLocalizations.of(context).translate("Contact Us"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(600),
            decoration: BoxDecoration(
              color: themeIsLight ? Colors.white : Colors.black,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: ListTile(
                    title: Text("Instagram"),
                    trailing: Text("@mirsaiddev"),
                    onTap: () {
                      _launchURL();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: ListTile(
                    title: Text("E-mail"),
                    trailing: Text("mirsaidefendi@gmail.com"),
                    onTap: () {
                      launch(_emailLaunchUri.toString());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutThisApp extends StatelessWidget {
  const AboutThisApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;

    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(70)),
      child: Column(
        children: [
          Container(
            width: ScreenUtil().setWidth(600),
            height: ScreenUtil().setHeight(100),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Icon(Icons.info_outline, color: Colors.white),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    AppLocalizations.of(context).translate("About"),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(600),
            decoration: BoxDecoration(
              color: themeIsLight ? Colors.white : Colors.black,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).translate("InfoText"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InstagramInfo extends StatelessWidget {
  const InstagramInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;

    _launchURL() async {
      const url = 'https://www.instagram.com/datebirthdays/';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(70)),
      child: Column(
        children: [
          Container(
            width: ScreenUtil().setWidth(600),
            height: ScreenUtil().setHeight(100),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Icon(AntDesign.instagram, color: Colors.white),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    "Instagram",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(600),
            decoration: BoxDecoration(
              color: themeIsLight ? Colors.white : Colors.black,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(AppLocalizations.of(context).translate("tap for follow")),
                    trailing: Text("@datebirthdays"),
                    onTap: () {
                      _launchURL();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
