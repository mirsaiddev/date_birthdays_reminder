import 'dart:convert';

import 'package:date_reminder/models/advert_services.dart';
import 'package:date_reminder/models/calendar_data.dart';
import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/models/database_helper.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:date_reminder/models/reminder_with_sort.dart';
import 'package:date_reminder/models/reminders_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

int adsCounter = 2;

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<ReminderWithSort> reminderWithSortList;
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool birthdayPassedThisYear = false;
  bool todayIsBirthday = false;
  bool loading = true;
  final AdvertService _advertService = AdvertService();
  @override
  initState() {
    super.initState();
    reminderWithSortList = List<ReminderWithSort>();
    databaseHelper = DatabaseHelper();
    getTheList();
    if (adsCounter % 3 == 0) {
      _advertService.showInterstitial();
    }
    adsCounter++;
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

  List<Meeting> getDataSource(BuildContext context, var mydata) {
    String myLocale = Localizations.localeOf(context).languageCode;

    var meetings = <Meeting>[];

    Map<String, Color> colors = Map();
    colors.putIfAbsent("brt", () => brt);
    colors.putIfAbsent("wed", () => wed);
    colors.putIfAbsent("fun", () => fun);
    colors.putIfAbsent("lov", () => lov);
    colors.putIfAbsent("oth", () => oth);

    for (var i = 0; i < 52; i++) {
      DateTime date = DateTime(
        DateTime.now().year,
        int.parse(mydata["$i"]["date_month"]),
        int.parse(mydata["$i"]["date_day"]),
      );
      DateTime nextDate = DateTime(
        DateTime.now().year + 1,
        int.parse(mydata["$i"]["date_month"]),
        int.parse(mydata["$i"]["date_day"]),
      );
      meetings.add(
        Meeting(
          mydata["$i"]["name"],
          date,
          date,
          colors["oth"],
          true,
        ),
      );
      meetings.add(
        Meeting(
          mydata["$i"]["name"],
          nextDate,
          date,
          colors["oth"],
          true,
        ),
      );
    }

    reminderWithSortList.forEach((element) {
      DateTime oneDaysAfterbirthdayInThatYear = DateTime(
        DateTime.now().year,
        element.reminders.reminderDateMonth,
        element.reminders.reminderDateDay,
      );

      //Todo Bu yılki doğum günü, örn; 15 Ekim 2020
      DateTime birthdayInThatYear = DateTime(
        DateTime.now().year,
        element.reminders.reminderDateMonth,
        element.reminders.reminderDateDay,
      );

      //Todo Sonraki yılki doğum günü, örn; 15 Ekim 2021
      DateTime birthdayInNextYear = DateTime(
        DateTime.now().year + 1,
        element.reminders.reminderDateMonth,
        element.reminders.reminderDateDay,
      );

      reminderWithSortList.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));

      if (birthdayInThatYear.isAfter(DateTime.now())) {
        //Todo Eğer bu yılki doğum günü şimdiden sonra ise
        birthdayPassedThisYear = false;
      } else {
        //Todo Eğer bu yılki doğum günü şimdi'den sonra değil ise
        birthdayPassedThisYear = true;
      }
      int age;
      String text;
      String passedText;

      if (birthdayPassedThisYear || todayIsBirthday) {
        age = DateTime.now().year - element.reminders.reminderDateYear;
      } else {
        age = DateTime.now().year - element.reminders.reminderDateYear - 1;
      }

      if (element.reminders.reminderCategory == "brt") {
        if (myLocale == "en") {
          text = "${element.reminders.reminderName} turns ${age + 1}";
          passedText = "${element.reminders.reminderName} was turned $age";
        } else if (myLocale == "tr") {
          text = "${element.reminders.reminderName} ${age + 1} yaşına girecek";
          passedText = "${element.reminders.reminderName} $age yaşına girmişti";
        } else if (myLocale == "ru") {
          text = "${element.reminders.reminderName} исполняется ${age + 1} лет";
          passedText = "${element.reminders.reminderName} исполнилось $age лет";
        }
      } else if (element.reminders.reminderCategory == "fun") {
        text = "${AppLocalizations.of(context).translate("Categories Death anniversary")}, ${element.reminders.reminderName}";
        passedText = "${AppLocalizations.of(context).translate("Categories Death anniversary")}, ${element.reminders.reminderName}";
      } else if (element.reminders.reminderCategory == "wed") {
        text = "${AppLocalizations.of(context).translate("Categories Wedding")}, ${element.reminders.reminderName}";
        passedText = "${AppLocalizations.of(context).translate("Categories Wedding")}, ${element.reminders.reminderName}";
      } else if (element.reminders.reminderCategory == "lov") {
        text = "${AppLocalizations.of(context).translate("Categories Love")}, ${element.reminders.reminderName}";
        passedText = "${AppLocalizations.of(context).translate("Categories Love")}, ${element.reminders.reminderName}";
      } else if (element.reminders.reminderCategory == "oth") {
        text = "${element.reminders.reminderName}";
        passedText = "${element.reminders.reminderName}";
      }

      if (birthdayPassedThisYear) {
        meetings.add(Meeting(
          passedText,
          birthdayInThatYear,
          oneDaysAfterbirthdayInThatYear,
          colors[element.reminders.reminderCategory],
          true,
        ));
        meetings.add(
          Meeting(
            text,
            birthdayInNextYear,
            oneDaysAfterbirthdayInThatYear,
            colors[element.reminders.reminderCategory],
            true,
          ),
        );
      } else {
        meetings.add(
          Meeting(
            text,
            birthdayInThatYear,
            oneDaysAfterbirthdayInThatYear,
            colors[element.reminders.reminderCategory],
            true,
          ),
        );
      }
    });
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    String myLocale = Localizations.localeOf(context).languageCode;
    String jsonString;
    if (myLocale == "en") {
      jsonString = "json/international_days.json";
    } else if (myLocale == "tr") {
      jsonString = "json/international_tr.json";
    } else if (myLocale == "ru") {
      jsonString = "json/international_ru.json";
    }
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString(jsonString),
        builder: (context, snapshot) {
          var mydata = json.decode(snapshot.data.toString());
          if (mydata == null) {
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(kPrimaryColor),
            ));
          } else {
            return Container(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 80),
              child: SfCalendar(
                view: CalendarView.month,
                firstDayOfWeek: 1,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  numberOfWeeksInView: 6,
                  showTrailingAndLeadingDates: true,
                  monthCellStyle: MonthCellStyle(
                    trailingDatesTextStyle: TextStyle(color: themeIsLight ? Colors.grey[300] : Colors.grey[800]),
                    leadingDatesTextStyle: TextStyle(color: themeIsLight ? Colors.grey[300] : Colors.grey[800]),
                  ),
                ),
                headerHeight: 50,
                cellBorderColor: Colors.grey[400],
                maxDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day),
                todayHighlightColor: kPrimaryColor,
                viewHeaderHeight: 20,
                dataSource: MeetingDataSource(getDataSource(context, mydata)),
                showNavigationArrow: true,
              ),
            );
          }
        },
      ),
    );
  }
}
