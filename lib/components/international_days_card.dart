import 'package:date_reminder/models/constants.dart';
import 'package:date_reminder/models/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class InternationalDayCard extends StatelessWidget {
  const InternationalDayCard({
    Key key,
    @required this.name,
    @required this.color,
    @required this.imageUrl,
    @required this.dateText,
    @required this.daysLeft,
  }) : super(key: key);

  final String name, color, imageUrl, dateText;
  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    bool themeIsLight = Theme.of(context).scaffoldBackgroundColor == kBackground ? true : false;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(35),
          vertical: 10,
        ),
        padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
        width: double.infinity,
        decoration: BoxDecoration(
          color: themeIsLight ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundColor: Color(int.parse(color)),
                    radius: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Image.network(
                        imageUrl,
                        height: ScreenUtil().setWidth(45),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(2),
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: name.characters.length < 25
                            ? ScreenUtil().setSp(27)
                            : name.characters.length < 28
                                ? ScreenUtil().setSp(24)
                                : ScreenUtil().setSp(24),
                        color: themeIsLight ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(2),
                    ),
                    child: Text(
                      dateText,
                      style: TextStyle(color: kGreyLight, fontSize: ScreenUtil().setSp(22)),
                    ),
                  ),
                  Text(
                    "$daysLeft ${AppLocalizations.of(context).translate("days left")}",
                    style: TextStyle(color: kPrimaryColor, fontSize: ScreenUtil().setSp(22)),
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
