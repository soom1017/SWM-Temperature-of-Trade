import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tot/common/component/news_detail_pie_chart.dert.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/component/news_detail_head.dart';
import 'package:tot/common/data/BookmarkCache.dart';
import 'package:tot/common/data/news_data.dart';
import 'package:tot/common/jsonParser.dart';
import 'package:tot/home/component/home_user_keywords.dart';
import '../layout/default_layout.dart';
import 'package:tot/common/const/padding.dart';
import 'package:pie_chart/pie_chart.dart';

class NewsFullTextView extends StatefulWidget {
  final NewsData news;

  const NewsFullTextView({required this.news, Key? key}) : super(key: key);

  @override
  State<NewsFullTextView> createState() => _NewsFullTextViewState();
}

class _NewsFullTextViewState extends State<NewsFullTextView> {
  @override
  Widget build(BuildContext context) {
    final BookmarkCache c = BookmarkCache.to;
    return DefaultLayout(
      isExtraPage: true,
      isDetailPage: true,
      pageName: "뉴스 전문",
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Obx((){
              if(c.bookmarks.where((p0) => p0.id == widget.news.id) == false){
                return NewsDetailHead.fromNewsData(widget.news);
              }else{
                return NewsDetailHead.fromNewsData(widget.news);
              }
            }),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  HORIZONTAL_PADDING.w, 30.h, HORIZONTAL_PADDING.w, 0.h),
              child: Text.rich(
                TextSpan(
                  children: _getHighlighting(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _getHighlighting() {
    final List<TextSpan> temp = [];
    var cnt = 0;
    for (var paragraph in widget.news.body) {
      var x = 0;
      for (var line in paragraph) {
        if(x != 0) {
          line = ' $line';
        }
        if (widget.news.highlight_idx.indexWhere((element) => element == cnt) >= 0) {
          temp.add(TextSpan(
              text: line.toString(),
              style: TextStyle(
                backgroundColor: Color(0xFFF8E606),
                fontSize: 17.sp,
              )));
        } else {
          temp.add(TextSpan(text: line.toString(), style: TextStyle(fontSize: 17.sp)));
        }
        x++;
        cnt++;
      }
      temp.add(const TextSpan(text: '\n\n'));
    }
    return temp;
  }
}
