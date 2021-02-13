import 'package:date_reminder/components/default_button2.dart';
import 'package:date_reminder/components/title_reminder.dart';
import 'package:date_reminder/models/advert_services.dart';
import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/models/database_helper.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:date_reminder/models/reminders_database.dart';
import 'package:date_reminder/screens/edit_reminder_page.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_screenutil/screenutil.dart';

int adsCounter = 2;

class ReminderDetails extends StatefulWidget {
  final String dateInfoText, monthText;
  final int age, daysLeft;
  final Color color;
  final Reminders reminders;

  const ReminderDetails({
    Key key,
    @required this.age,
    @required this.color,
    @required this.daysLeft,
    @required this.reminders,
    @required this.dateInfoText,
    @required this.monthText,
  }) : super(key: key);
  @override
  _ReminderDetailsState createState() => _ReminderDetailsState();
}

class _ReminderDetailsState extends State<ReminderDetails> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>["TEST DEVICE ID"],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );
  DatabaseHelper databaseHelper = DatabaseHelper();
  // ignore: unused_field
  String _platformVersion = 'Unknown';


  AdvertService _advertService = AdvertService();


  bool canLeaveThePage = false;
  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "YOUR AD ID",
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          canLeaveThePage = true;
        } else if (event == MobileAdEvent.failedToLoad) {
          canLeaveThePage = true;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: "YOUR ID");
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    difference = timeOfEndOfDay.difference(timeOfNow).inSeconds;
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * difference;
    initPlatformState();
    databaseHelper = DatabaseHelper();

    if (adsCounter % 3 == 0) {
      _advertService.showInterstitial();
    }
    adsCounter++;
  }

  void disposeAd() {
    print("Calling disposeAd");
    try {
      _bannerAd?.dispose();
      _bannerAd = null;
    } catch (ex) {
      print("banner dispose error : $ex");
    }
  }

  @override
  void dispose() {
    disposeAd();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  DateTime timeOfNow = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
    DateTime.now().second,
  );

  DateTime timeOfEndOfDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    23,
    59,
    59,
  );
  int difference;
  int endTime;
  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;

    String dateInfoText = widget.dateInfoText;
    int age = widget.age;
    int daysLeft = widget.daysLeft;
    Color color = themeIsLight ? widget.color : kBlackBackground;
    Color categoryColor = widget.color;
    Reminders reminders = widget.reminders;
    String monthText = widget.monthText;

    bool todayIsBirthday = false;

    DateTime birthdayInThatYear = DateTime(
      DateTime.now().year,
      reminders.reminderDateMonth,
      reminders.reminderDateDay,
    );

    DateTime dateOfNow = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (dateOfNow == birthdayInThatYear) {
      todayIsBirthday = true;
    } else {
      todayIsBirthday = false;
    }

    void _launchWhatsapp() async {
      String phone = reminders.phoneNumber;
      String message = "";
      FlutterOpenWhatsapp.sendSingleMessage(phone, message);
    }

    void goEdit() {
      _bannerAd.dispose();
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) => EditReminderPage(
            reminders: reminders,
            nameFirst: reminders.reminderName,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: ScreenUtil().setHeight(200),
        title: Text(
          AppLocalizations.of(context).translate("Reminder Details"),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            canLeaveThePage ? Navigator.pop(context) : print("hopp nereye");
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(5)),
            child: IconButton(
              onPressed: () {
                canLeaveThePage ? goEdit() : print("edite gidemezsin");
              },
              tooltip: "Edit",
              iconSize: ScreenUtil().setHeight(35),
              icon: Icon(
                Icons.edit_rounded,
              ),
            ),
          ),
        ],
      ),
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          canLeaveThePage ? Navigator.pop(context) : print("hopp nereye");
        },
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                color: color,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TitleReminder(
                        color: color,
                        categoryColor: categoryColor,
                        category: reminders.reminderCategory,
                        name: reminders.reminderName,
                        text: Text(
                          dateInfoText,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: ScreenUtil().setSp(26),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeIsLight ? kBackground : Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().setHeight(10),
                            ),
                            reminders.reminderCategory == "brt"
                                ? Column(
                                    children: [
                                      Info(
                                        text: AppLocalizations.of(context).translate("Birthday"),
                                        info: "$monthText ${reminders.reminderDateDay}, ${reminders.reminderDateYear}",
                                      ),
                                      Info(
                                        text: AppLocalizations.of(context).translate("Age"),
                                        info: "$age",
                                      ),
                                    ],
                                  )
                                : Info(
                                    text: AppLocalizations.of(context).translate("Date"),
                                    info: "$monthText ${reminders.reminderDateDay}, ${reminders.reminderDateYear}",
                                  ),
                            Info(
                              text: AppLocalizations.of(context).translate("Phone Number"),
                              info: reminders.phoneNumber == null ? "-" : reminders.phoneNumber,
                            ),
                            Info(
                                text: AppLocalizations.of(context).translate("Notifications"),
                                info: reminders.getNotifications == "true"
                                    ? AppLocalizations.of(context).translate("On")
                                    : AppLocalizations.of(context).translate("Off")),
                            reminders.reminderCategory == "brt"
                                ? reminders.giftIdeas.characters.length > 15
                                    ? GiftIdeasDialog(reminders: reminders, themeIsLight: themeIsLight)
                                    : Info(
                                        text: AppLocalizations.of(context).translate("Gift Ideas"),
                                        info: reminders.giftIdeas == "" ? "-" : reminders.giftIdeas,
                                      )
                                : SizedBox(),
                            Spacer(),
                            CountdownTimer(
                              endTime: endTime,
                              emptyWidget: Text("Birthday"),
                              onEnd: () {
                                print("bitti");
                              },
                              widgetBuilder: (BuildContext context, CurrentRemainingTime time) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(30),
                                    ScreenUtil().setWidth(0),
                                    ScreenUtil().setWidth(30),
                                    ScreenUtil().setWidth(25),
                                  ),
                                  height: ScreenUtil().setHeight(270),
                                  decoration: BoxDecoration(
                                    color: themeIsLight ? Colors.grey[200] : kDefaulDarkBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              daysLeft == 0 ? "0" : "$daysLeft",
                                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              AppLocalizations.of(context).translate("days"),
                                              style: TextStyle(color: themeIsLight ? Colors.black54 : Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              time.hours == null || time.hours == 0 ? "0" : time.hours.toString(),
                                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              AppLocalizations.of(context).translate("hours"),
                                              style: TextStyle(color: themeIsLight ? Colors.black54 : Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              time.min == null ? "0" : time.min.toString(),
                                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              AppLocalizations.of(context).translate("min"),
                                              style: TextStyle(color: themeIsLight ? Colors.black54 : Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              time.sec == null ? "0" : time.sec.toString(),
                                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              AppLocalizations.of(context).translate("seconds"),
                                              style: TextStyle(color: themeIsLight ? Colors.black54 : Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            todayIsBirthday
                                ? reminders.phoneNumber == null || reminders.phoneNumber == ""
                                    ? SizedBox()
                                    : DefaultButton2(
                                        buttonColor: themeIsLight ? whatsapp : kDefaulDarkBackground,
                                        func: _launchWhatsapp,
                                        text: reminders.reminderCategory == "fun"
                                            ? AppLocalizations.of(context).translate("Send message from WhatsApp")
                                            : AppLocalizations.of(context).translate("Celebrate from Whatsapp"),
                                        textColor: Colors.white,
                                      )
                                : SizedBox(),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setWidth(30),
                                ScreenUtil().setWidth(00),
                                ScreenUtil().setWidth(30),
                                ScreenUtil().setWidth(20),
                              ),
                              child: SizedBox(height: ScreenUtil().setHeight(150)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GiftIdeasDialog extends StatelessWidget {
  const GiftIdeasDialog({
    Key key,
    @required this.reminders,
    @required this.themeIsLight,
  }) : super(key: key);

  final Reminders reminders;
  final bool themeIsLight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text(
            AppLocalizations.of(context).translate("Gift Ideas"),
          ),
          content: Text(reminders.giftIdeas),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(50),
              ),
              child: Text(
                "${AppLocalizations.of(context).translate("Gift Ideas")} :",
                style: TextStyle(
                  color: themeIsLight ? Colors.black54 : Colors.white54,
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(50),
              ),
              child: Text(
                reminders.giftIdeas == "" || reminders.giftIdeas == null ? "-" : AppLocalizations.of(context).translate("tap for see"),
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    Key key,
    @required this.text,
    @required this.info,
  }) : super(key: key);

  final String text, info;

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(50),
            ),
            child: Text(
              "$text :",
              style: TextStyle(
                color: themeIsLight ? Colors.black54 : Colors.white54,
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(50),
            ),
            child: Text(
              info,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
