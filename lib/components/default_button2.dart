import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class DefaultButton2 extends StatelessWidget {
  const DefaultButton2({
    Key key,
    this.func,
    this.text,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  final VoidCallback func;
  final String text;
  final Color buttonColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(30),
        ScreenUtil().setWidth(00),
        ScreenUtil().setWidth(30),
        ScreenUtil().setWidth(20),
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
        color: buttonColor,
        onPressed: func,
        height: ScreenUtil().setHeight(100),
      ),
    );
  }
}
