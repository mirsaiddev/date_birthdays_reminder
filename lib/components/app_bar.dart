import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

Widget myAppBar(String title, BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: false,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: Theme.of(context).textTheme.headline6,
    ),
    toolbarHeight: ScreenUtil().setHeight(200),
  );
}
