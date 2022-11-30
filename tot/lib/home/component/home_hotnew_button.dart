import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/home/view/home_hotnew_screen.dart';

class HomeHotNewButton extends StatelessWidget {
  final String text;

  const HomeHotNewButton({required this.text, Key? key}) : super(key: key);

  routeToHotNew() {
    if (text.compareTo("HOT") == 0) {
      Get.to(() => HomeHotNewScreen(isHot: true));
    } else if (text.compareTo("NEW") == 0) {
      Get.to(() => HomeHotNewScreen(isHot: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {routeToHotNew();},
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.fromLTRB(20.w, 3.h, 20.w, 3.h)),
        side: MaterialStateProperty.all<BorderSide>(const BorderSide(
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
      // onPressed: null,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 30.sp, color: PRIMARY_COLOR, fontWeight: FontWeight.w400),
      ),
    );
  }
}
