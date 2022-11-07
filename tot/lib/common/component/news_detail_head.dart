import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/data/news_data.dart';
import '../layout/default_layout.dart';
import 'package:tot/common/const/padding.dart';
import '../view/news_detail_view.dart';

class NewsDetailHead extends StatelessWidget {
  final String? stockName;
  final String postingDate;
  final String newsTitle;
  late List<String> tagList;
  final String reporter;
  final String press;

  NewsDetailHead(
      {required this.tagList,
        required this.postingDate,
        required this.newsTitle,
        required this.reporter,
        required this.press,
        this.stockName,
        Key? key})
      : super(key: key);

  factory NewsDetailHead.fromNewsData(NewsData head) {
    return NewsDetailHead(
      tagList: head.keywords,
      postingDate: head.created_at,
      newsTitle: head.title,
      stockName: head.attention_stock,
      reporter: head.reporter,
      press: head.press,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NEWSDETAIL_TL_COLOR,
      padding: EdgeInsets.fromLTRB(HORIZONTAL_PADDING.w, 20.h, HORIZONTAL_PADDING.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(newsTitle, style: TextStyle(fontSize: 24.sp,),),
          SizedBox(height: 15.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                Row(children: [
                  Text(press, style: TextStyle(fontSize: 15.sp),),
                  SizedBox(width: 15.w,),
                  Text("$reporter", style: TextStyle(fontSize: 12.sp),),
                ],),
                SizedBox(height: 5.h,),
                Text("입력 : $postingDate", style: TextStyle(color: SMALL_FONT_COLOR, fontSize: 10.sp)),
              ],),
              Spacer(),
              Icon(Icons.share_outlined, size: 30.sp,),
              SizedBox(width: 10.w,),
              Icon(Icons.bookmark_border, size: 30.sp,),
            ],
          )
        ],
      ),
    );
  }
}
