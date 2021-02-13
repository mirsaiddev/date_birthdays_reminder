import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/screens/add_reminder_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainMenuFloatingActionButton extends StatelessWidget {
  const MainMenuFloatingActionButton({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add_rounded, size: ScreenUtil().setWidth(50), color: Colors.white),
      splashColor: Colors.white,
      backgroundColor: kPrimaryColor,
      tooltip: "Add Reminder",
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => AddReminderPage()),
        );
      },
    );
  }
}
