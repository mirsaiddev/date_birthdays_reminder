import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import '../models/size_config.dart';

AppBar reminderPageAppBar(BuildContext context) {
  bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: Text(
      AppLocalizations.of(context).translate("Add Reminder"),
      style: Theme.of(context).textTheme.headline6,
    ),
    leading: Padding(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: themeIsLight ? Colors.black : Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    toolbarHeight: SizeConfig.screenHeight / 8,
  );
}
