import 'package:date_reminder/models/localizations.dart';
import 'package:date_reminder/models/reminders_database.dart';
import 'package:date_reminder/screens/reminder_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import '../models/constants.dart';

class ReminderCard extends StatefulWidget {
  const ReminderCard({
    Key key,
    @required this.color,
    @required this.reminders,
    @required this.myLocale,
  }) : super(key: key);

  final Color color;
  final Reminders reminders;
  final Locale myLocale;

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    String monthText = AppLocalizations.of(context).translate("${months["${widget.reminders.reminderDateMonth}"]}");
    int age;
    bool birthdayPassedThisYear = false;
    bool todayIsBirthday = false;
    String dateInfoText = "";

    // ignore: unused_local_variable
    DateTime birthdayTime = DateTime.parse(
      "${widget.reminders.reminderDateYear.toString()}-${widget.reminders.reminderDateMonth.toString().padLeft(2, '0')}-${widget.reminders.reminderDateDay.toString().padLeft(2, '0')}",
    );

    //! Bu yılki doğum günü, örn; 15 Ekim 2020
    DateTime birthdayInThatYear = DateTime(
      DateTime.now().year,
      widget.reminders.reminderDateMonth,
      widget.reminders.reminderDateDay,
    );

    //! Sonraki yılki doğum günü, örn; 15 Ekim 2021
    DateTime birthdayInNextYear = DateTime(
      DateTime.now().year + 1,
      widget.reminders.reminderDateMonth,
      widget.reminders.reminderDateDay,
    );

    //! Bugünün tarihi, örn; 11 Aralık 2020
    DateTime dateOfToday = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    //! check of birthday is passed or not
    if (birthdayInThatYear.isAfter(DateTime.now())) {
      birthdayPassedThisYear = false;
    } else {
      birthdayPassedThisYear = true;
    }

    //! check of how should be age
    if (birthdayPassedThisYear || todayIsBirthday) {
      age = DateTime.now().year - widget.reminders.reminderDateYear;
    } else {
      age = DateTime.now().year - widget.reminders.reminderDateYear - 1;
    }

    //! check of is today birthday
    if (dateOfToday == birthdayInThatYear) {
      todayIsBirthday = true;
    }

    if (todayIsBirthday) {
      if (widget.reminders.reminderCategory == "brt") {
        if (widget.myLocale.languageCode == "en") {
          dateInfoText = "Turned $age today";
        } else if (widget.myLocale.languageCode == "ru") {
          dateInfoText = "исполнилось $age сегодня";
        } else if (widget.myLocale.languageCode == "tr") {
          dateInfoText = "bugün $age yaşına girdi";
        }
      } else if (widget.reminders.reminderCategory == "wed") {
        dateInfoText = "${AppLocalizations.of(context).translate("Categories Wedding")} ${AppLocalizations.of(context).translate("is today")}";
      } else if (widget.reminders.reminderCategory == "fun") {
        dateInfoText =
            "${AppLocalizations.of(context).translate("Categories Death anniversary")} ${AppLocalizations.of(context).translate("is today")}";
      } else if (widget.reminders.reminderCategory == "lov") {
        dateInfoText = "${AppLocalizations.of(context).translate("Categories Love")} ${AppLocalizations.of(context).translate("is today")}";
      }else if (widget.reminders.reminderCategory == "oth") {
        dateInfoText = AppLocalizations.of(context).translate("The date is today");
      }
    } else {
      if (widget.reminders.reminderCategory == "brt") {
        if (birthdayPassedThisYear) {
          if (widget.myLocale.languageCode == "en") {
            dateInfoText = "Turns ${DateTime.now().year - widget.reminders.reminderDateYear + 1} on $monthText ${widget.reminders.reminderDateDay}";
          } else if (widget.myLocale.languageCode == "ru") {
            dateInfoText =
                "${widget.reminders.reminderDateDay} $monthText исполняется ${DateTime.now().year - widget.reminders.reminderDateYear + 1} лет";
          } else if (widget.myLocale.languageCode == "tr") {
            dateInfoText =
                "${widget.reminders.reminderDateDay} $monthText'da ${DateTime.now().year - widget.reminders.reminderDateYear + 1} yaşına giriyor";
          }
        } else {
          if (widget.myLocale.languageCode == "en") {
            dateInfoText = "Turns ${DateTime.now().year - widget.reminders.reminderDateYear} on $monthText ${widget.reminders.reminderDateDay}";
          } else if (widget.myLocale.languageCode == "ru") {
            dateInfoText =
                "${widget.reminders.reminderDateDay} $monthText исполняется ${DateTime.now().year - widget.reminders.reminderDateYear} лет";
          } else if (widget.myLocale.languageCode == "tr") {
            dateInfoText =
                "${widget.reminders.reminderDateDay} $monthText'da ${DateTime.now().year - widget.reminders.reminderDateYear} yaşına giriyor";
          }
        }
      } else if (widget.reminders.reminderCategory == "wed") {
        if (widget.myLocale.languageCode == "en") {
          dateInfoText = "Wedding is on $monthText ${widget.reminders.reminderDateDay}";
        } else if (widget.myLocale.languageCode == "ru") {
          dateInfoText = "Свадьба ${widget.reminders.reminderDateDay} $monthText";
        } else if (widget.myLocale.languageCode == "tr") {
          dateInfoText = "Düğün ${widget.reminders.reminderDateDay} $monthText'da";
        }
      } else if (widget.reminders.reminderCategory == "fun") {
        if (widget.myLocale.languageCode == "en") {
          dateInfoText = "D. anniversary is on $monthText ${widget.reminders.reminderDateDay}";
        } else if (widget.myLocale.languageCode == "ru") {
          dateInfoText = "Годовщина смерти ${widget.reminders.reminderDateDay} $monthText";
        } else if (widget.myLocale.languageCode == "tr") {
          dateInfoText = "Ölüm Yıldönümü ${widget.reminders.reminderDateDay} $monthText'da";
        }
      } else if (widget.reminders.reminderCategory == "lov") {
        if (widget.myLocale.languageCode == "en") {
          dateInfoText = "Anniversary is on $monthText ${widget.reminders.reminderDateDay}";
        } else if (widget.myLocale.languageCode == "ru") {
          dateInfoText = "Годовщина ${widget.reminders.reminderDateDay} $monthText";
        } else if (widget.myLocale.languageCode == "tr") {
          dateInfoText = "Yıldönümü ${widget.reminders.reminderDateDay} $monthText'da";
        }
      } else if (widget.reminders.reminderCategory == "oth") {
        if (widget.myLocale.languageCode == "en") {
          dateInfoText = "The date is on $monthText ${widget.reminders.reminderDateDay}";
        } else if (widget.myLocale.languageCode == "ru") {
          dateInfoText = "Дата ${widget.reminders.reminderDateDay} $monthText";
        } else if (widget.myLocale.languageCode == "tr") {
          dateInfoText = "Tarih ${widget.reminders.reminderDateDay} $monthText'da";
        }
      } 
    }


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ReminderDetails(
                    dateInfoText: dateInfoText,
                    age: age,
                    color: widget.color,
                    monthText: monthText,
                    daysLeft: birthdayPassedThisYear
                        ? birthdayInNextYear.difference(DateTime.now()).inDays
                        : birthdayInThatYear.difference(DateTime.now()).inDays,
                    reminders: widget.reminders,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(35),
          vertical: 10,
        ),
        padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
        width: double.infinity,
        decoration: BoxDecoration(
          color: todayIsBirthday
              ? kPrimaryColor
              : themeIsLight
                  ? Colors.white
                  : Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only( left: ScreenUtil().setWidth(10)),
                      child: CircleAvatar(
                        backgroundColor: widget.color,
                        radius: ScreenUtil().setWidth(50),
                        child: Center(
                          child: Image.asset(
                            "assets/images/${widget.reminders.reminderCategory}.png",
                            height: ScreenUtil().setWidth(35),
                          ),
                        ),
                      ),
                    ),
                ),
              ),
              Expanded(
                flex: 7,//6
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                     Text(
                        widget.reminders.reminderName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: widget.reminders.reminderName.characters.length < 20
                              ? ScreenUtil().setSp(30)
                              : widget.reminders.reminderName.characters.length < 22
                                  ? ScreenUtil().setSp(27)
                                  : ScreenUtil().setSp(27),
                          color: todayIsBirthday
                              ? Colors.white
                              : themeIsLight
                                  ? Colors.black
                                  : Colors.white,
                        ),
                      ),
                     Text(
                        dateInfoText,
                        style: TextStyle(color: todayIsBirthday ? Colors.white : kGreyLight, fontSize: ScreenUtil().setSp(22)),
                      ),
                    
                    Text(
                      todayIsBirthday
                          ? AppLocalizations.of(context).translate("today")
                          : birthdayPassedThisYear
                              ? "${birthdayInNextYear.difference(DateTime.now()).inDays + 1} ${AppLocalizations.of(context).translate("days left")}"
                              : "${birthdayInThatYear.difference(DateTime.now()).inDays + 1} ${AppLocalizations.of(context).translate("days left")}",
                      style: TextStyle(color: todayIsBirthday ? Colors.white : kPrimaryColor, fontSize: ScreenUtil().setSp(22)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
