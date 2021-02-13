import 'package:date_reminder/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/screenutil.dart';

class MoreButton extends StatelessWidget {
  final String text;
  final Widget icon;
  const MoreButton({
    Key key,
    @required this.text,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(100), vertical: ScreenUtil().setWidth(20)),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: icon,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                text,
                style: TextStyle(color: themeIsLight ? Colors.black54 : Colors.white, fontWeight: FontWeight.w400, fontSize: ScreenUtil().setSp(36)),
              ),
            ),
            Expanded(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  AntDesign.arrowright,
                  color: themeIsLight ? Colors.black54 : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
