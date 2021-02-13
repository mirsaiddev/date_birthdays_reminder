import 'package:flutter/material.dart';
import '../models/constants.dart';
import '../models/size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({Key key, this.text, this.press}) : super(key: key);

  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.screenHeight / 15,
      child: FlatButton(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
