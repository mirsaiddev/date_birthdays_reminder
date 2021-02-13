import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class SelectDateWidget extends StatelessWidget {
  const SelectDateWidget({
    Key key,
    @required this.datePicked,
    @required this.method,
    @required this.category,
  }) : super(key: key);

  final String datePicked;
  final VoidCallback method;
  final String category;

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    return InkWell(
      onTap: () => method(),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
          vertical: ScreenUtil().setWidth(30),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          datePicked == null
              ? category == "brt"
                  ? AppLocalizations.of(context).translate("Select Birthday")
                  : AppLocalizations.of(context).translate("Select Date")
              : "${AppLocalizations.of(context).translate("Select Date")} : $datePicked",
          style: TextStyle(
            fontSize: 16,
            color: datePicked == null
                ? Colors.grey
                : themeIsLight
                    ? Colors.black87
                    : Colors.white,
          ),
        ),
      ),
    );
  }
}
