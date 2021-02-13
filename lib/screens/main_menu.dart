import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:date_reminder/components/app_bar.dart';
import 'package:date_reminder/components/main_menu_floating.dart';
import 'package:date_reminder/components/reminder_card.dart';
import 'package:date_reminder/models/database_helper.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:date_reminder/models/reminder_with_sort.dart';
import 'package:date_reminder/models/reminders_database.dart';
import 'package:date_reminder/models/size_config.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/screenutil.dart';
import '../models/constants.dart';
import 'calendar.dart';
import 'international_days.dart';
import 'more_page.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<ReminderWithSort> reminderWithSortList;
  DatabaseHelper databaseHelper = DatabaseHelper();
  int _currentIndex = 0;
  List<Widget> _children = [];
  bool birthdayPassedThisYear = false;
  bool todayIsBirthday = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  bool loading = true;

  
  @override
  initState() {
    super.initState();
    reminderWithSortList = List<ReminderWithSort>();
    databaseHelper = DatabaseHelper();
    _initAdMob();
    getTheList();
  }

  Future<void> getTheList() async {
    var allRemindersList = await databaseHelper.takeAllReminders();
    for (Map map in allRemindersList) {
      //Todo Bu yılki doğum günü, örn; 15 Ekim 2020
      DateTime birthdayInThatYear = DateTime(
        DateTime.now().year,
        Reminders.fromMap(map).reminderDateMonth,
        Reminders.fromMap(map).reminderDateDay,
      );

      //Todo Sonraki yılki doğum günü, örn; 15 Ekim 2021
      DateTime birthdayInNextYear = DateTime(
        DateTime.now().year + 1,
        Reminders.fromMap(map).reminderDateMonth,
        Reminders.fromMap(map).reminderDateDay,
      );

      //Todo Bugünün tarihi, örn; 11 Aralık 2020
      DateTime dateOfToday = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      if (birthdayInThatYear.isAfter(DateTime.now())) {
        //Todo Eğer bu yılki doğum günü şimdiden sonra ise
        birthdayPassedThisYear = false;
      } else {
        //Todo Eğer bu yılki doğum günü şimdi'den sonra değil ise
        birthdayPassedThisYear = true;
      }

      if (dateOfToday == birthdayInThatYear) {
        //Todo Eğer Bugünün tarihi bu yılki doğum gününe eşitse
        todayIsBirthday = true;
      } else {
        todayIsBirthday = false;
      }

      reminderWithSortList.add(
        ReminderWithSort(
          reminders: Reminders.fromMap(map),
          daysLeft: todayIsBirthday
              ? -1
              : birthdayPassedThisYear
                  ? birthdayInNextYear.difference(DateTime.now()).inDays
                  : birthdayInThatYear.difference(DateTime.now()).inDays,
        ),
      );
    }

    reminderWithSortList.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
    loading = false;
    setState(() {});
  }

  Future<void> _initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: "YOUR ID");
  }

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    ScreenUtil.init(context, designSize: Size(720, 1520));
    SizeConfig().init(context);
    Map<String, Color> colors = Map();
    setState(() {
      colors.putIfAbsent("brt", () => brt);
      colors.putIfAbsent("wed", () => wed);
      colors.putIfAbsent("fun", () => fun);
      colors.putIfAbsent("lov", () => lov);
      colors.putIfAbsent("oth", () => oth);
      reminderWithSortList.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
    });
    List<String> namesList = [
      AppLocalizations.of(context).translate('All Reminders'),
      AppLocalizations.of(context).translate('Calendar'),
      AppLocalizations.of(context).translate('International Days'),
      AppLocalizations.of(context).translate('More'),
    ];
    _children = [
      RemindersPage(reminderWithSortList: reminderWithSortList, colors: colors, loading: loading),
      CalendarPage(),
      InternationalDaysPage(),
      MorePage(),
    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: myAppBar(namesList[_currentIndex], context),
      floatingActionButton: MainMenuFloatingActionButton(),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        activeIndex: _currentIndex,
        icons: [
          Icons.notifications_none_outlined,
          MaterialCommunityIcons.calendar_blank_outline,
          MaterialCommunityIcons.calendar_star,
          Icons.more_horiz,
        ],
        backgroundColor: Theme.of(context).bottomAppBarColor,
        activeColor: kPrimaryColor,
        inactiveColor: Colors.grey,
        splashColor: themeIsLight ? Colors.white : Colors.black,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
      ),
      body: _children[_currentIndex],
    );
  }
}

class RemindersPage extends StatelessWidget {
  const RemindersPage({
    Key key,
    @required this.reminderWithSortList,
    @required this.colors,
    @required this.loading,
  }) : super(key: key);

  final List<ReminderWithSort> reminderWithSortList;
  final Map<String, Color> colors;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    return SafeArea(
      bottom: false,
      child: Container(
        child: reminderWithSortList.length != 0
            ? WillPopScope(
                onWillPop: () => SystemNavigator.pop(),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => ReminderCard(
                    color: colors[reminderWithSortList[index].reminders.reminderCategory],
                    reminders: reminderWithSortList[index].reminders,
                    myLocale: myLocale,
                  ),
                  itemCount: reminderWithSortList.length,
                ),
              )
            : loading
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black45),
                  ))
                : Center(
                    child: Text(AppLocalizations.of(context).translate('Add your first reminder'),
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline5),
                  ),
      ),
    );
  }
}
