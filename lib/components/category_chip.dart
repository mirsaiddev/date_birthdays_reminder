import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    Key key,
    this.widget,
    this.color, this.width,
  }) : super(key: key);

  final Widget widget;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        ScreenUtil().setWidth(10),
      ),
      width: width,
      height: ScreenUtil().setHeight(70),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          ScreenUtil().setHeight(35),
        ),
      ),
      child: Center(
        child: widget,
      ),
    );
  }
}
