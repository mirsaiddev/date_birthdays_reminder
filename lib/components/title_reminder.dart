import 'package:date_reminder/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class TitleReminder extends StatelessWidget {
  const TitleReminder({
    Key key,
    @required this.color,
    @required this.categoryColor,
    @required this.category,
    @required this.name,
    @required this.text,
  }) : super(key: key);

  final Color color;
  final Color categoryColor;
  final String category;
  final String name;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    return Container(
      decoration: BoxDecoration(
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(50),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: themeIsLight ? Colors.white : categoryColor,
                  radius: ScreenUtil().setWidth(60),
                  child: Center(
                    child: Image.asset(
                      "assets/images/$category.png",
                      height: ScreenUtil().setWidth(50),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(2),
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: name.characters.length < 16 ? ScreenUtil().setSp(47) : name.characters.length < 18 ? ScreenUtil().setSp(42) : name.characters.length < 20 ? ScreenUtil().setSp(37) : ScreenUtil().setSp(35),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(2),
                    ),
                    child: text,
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
