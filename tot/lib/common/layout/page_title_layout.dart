import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tot/common/const/colors.dart';

class PageTitleLayout extends StatelessWidget {
  final String? pageName;

  const PageTitleLayout({
    Key? key,
    this.pageName
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFF), Color(0x2A9BACBC)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
        child: Row(
          children: [
            GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 5.w, 0),
              child: Icon(Icons.arrow_back_ios, size: 25.sp,)
            )),
            Text(
              pageName!,
              style: TextStyle(fontSize: 25.sp, color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
            ),
          ],
    ),
      ),
      height: 50.h,
      width: double.infinity,
    );
  }

}