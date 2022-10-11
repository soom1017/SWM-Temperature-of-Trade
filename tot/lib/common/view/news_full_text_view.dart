import 'package:flutter/material.dart';
import 'package:tot/common/component/news_detail_pie_chart.dert.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/component/news_detail_haed.dart';
import 'package:tot/common/jsonParser.dart';
import 'package:tot/home/component/home_user_keywords.dart';
import '../layout/default_layout.dart';
import 'package:tot/common/const/padding.dart';
import 'package:pie_chart/pie_chart.dart';

class NewsFullTextView extends StatelessWidget {
  final NewsDetailHead newsDetailHead;

  const NewsFullTextView({required this.newsDetailHead, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isExtraPage: true,
      pageName: "뉴스 전문",
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            newsDetailHead,
            for (var x = 0; x < 10; x++)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    HORIZONTAL_PADDING, 30, HORIZONTAL_PADDING, 0),
                child: JsonNews(
                  number: x,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
