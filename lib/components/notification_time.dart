import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:flutter/material.dart';

class NotificationTime extends StatelessWidget {
  const NotificationTime({
    Key key,
    @required this.notificationTime,
  }) : super(key: key);

  final TimeOfDay notificationTime;

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    return Text(
        notificationTime == null
            ? "* ${AppLocalizations.of(context).translate("Notification Hour")}"
            : "${AppLocalizations.of(context).translate("Notification Hour")} : " + "${notificationTime.hour.toString().padLeft(2, '0')}-${notificationTime.minute.toString().padLeft(2, '0')}",
        style: TextStyle(
          fontSize: 16,
          color: notificationTime == null
              ? Colors.grey
              : themeIsLight
                  ? Colors.black87
                  : Colors.white,
        ));
  }
}
