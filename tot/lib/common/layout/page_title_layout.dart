import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tot/common/const/colors.dart';

class PageTitleLayout extends StatelessWidget {
  final String? pageName;
  final DateTime update_time;

  const PageTitleLayout({Key? key, this.pageName, required this.update_time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = update_time;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 5.w, 0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 25.sp,
                      ))),
              Text(
                pageName!,
                style: TextStyle(
                  fontSize: 25.sp,
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h,),
          Text(
            "${t.year}.${t.month.toString().padLeft(2, '0')}.${t.day.toString().padLeft(2, '0')} ${t.hour.toString().padLeft(2, '0')}:${t.minute} 에 업데이트 되었습니다.",
            style: TextStyle(
              fontSize: 13.sp,
              color: SMALL_FONT_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}
