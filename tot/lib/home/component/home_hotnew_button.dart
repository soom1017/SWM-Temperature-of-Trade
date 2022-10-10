import 'package:flutter/material.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/home/view/home_hotnew_screen.dart';

class HomeHotNewButton extends StatelessWidget {
  final String text;

  const HomeHotNewButton({required this.text, Key? key}) : super(key: key);

  routeToHotNew(BuildContext context) {
    if (text.compareTo("HOT") == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeHotNewScreen(isHot: true),
        ),
      );
    } else if (text.compareTo("NEW") == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeHotNewScreen(isHot: false),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {routeToHotNew(context);},
      // onPressed: null,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 30, color: PRIMARY_COLOR, fontWeight: FontWeight.w400),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.fromLTRB(20, 3, 20, 3)),
        side: MaterialStateProperty.all<BorderSide>(BorderSide(
          width: 2.0,
          color: PRIMARY_COLOR,
        )),
        foregroundColor: MaterialStateProperty.all<Color>(PRIMARY_COLOR),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.5),
          ),
        ),
      ),
    );
  }
}
