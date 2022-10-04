import 'package:flutter/material.dart';
import 'package:tot/common/component/news_detail_pie_chart.dert.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/component/news_detail_haed.dart';
import '../layout/default_layout.dart';
import 'package:tot/common/const/padding.dart';
import 'package:pie_chart/pie_chart.dart';

Map<String, double> dataMap = {
  "Flutter": 56,
  "Xamarin": 24,
  "React": 20,
};

final List<Color> colorList = [
  KEYWORD_BG_COLOR,
  Color(0xFF4099DD).withOpacity(0.3),
  HOME_BG_COLOR,
];

class NewsDetailView extends StatelessWidget {
  final String? stockName;
  final String postingDate;
  final String newsTitle;
  late List<String> tagList;

  NewsDetailView(
      {required this.tagList,
      required this.postingDate,
      required this.newsTitle,
      this.stockName,
      Key? key})
      : super(key: key);

  factory NewsDetailView.fromNewsTile(NewsTile tile) {
    return NewsDetailView(
      tagList: tile.tagList,
      postingDate: tile.postingDate,
      newsTitle: tile.newsTitle,
      stockName: tile.stockName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isExtraPage: true,
      pageName: "뉴스 상세",
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: Column(
          children: [
            NewsDetailHead.fromDetailView(this),
            Column(
              children: [

              ],
            ),
            Divider(
              thickness: 5.0,
              color: Color(0xFF9BACBC),
            ),
            Row(
              children: [
                Column(
                  children: [

                  ],
                ),
                NewsDetailPieChart(
                  colorList: colorList,
                  dataMap: dataMap,
                  centerText: "현대카드\n56%",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
