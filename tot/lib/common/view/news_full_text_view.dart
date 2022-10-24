import 'package:flutter/material.dart';
import 'package:tot/common/component/news_detail_pie_chart.dert.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/component/news_detail_haed.dart';
import 'package:tot/common/data/news_data.dart';
import 'package:tot/common/jsonParser.dart';
import 'package:tot/home/component/home_user_keywords.dart';
import '../layout/default_layout.dart';
import 'package:tot/common/const/padding.dart';
import 'package:pie_chart/pie_chart.dart';

class NewsFullTextView extends StatelessWidget {
  final NewsData news;

  const NewsFullTextView({required this.news, Key? key}) : super(key: key);

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
            NewsDetailHead.fromNewsData(news),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  HORIZONTAL_PADDING, 30, HORIZONTAL_PADDING, 0),
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
    for (var paragraph in news.body) {
      var x = 0;
      for (var line in paragraph) {
        if(x != 0)
          line = ' ' + line;
        if (news.highlight_idx.indexWhere((element) => element == cnt) >= 0) {
          temp.add(TextSpan(
              text: line.toString(),
              style: const TextStyle(
                backgroundColor: Colors.yellow,
                fontSize: 15,
              )));
        } else {
          temp.add(TextSpan(text: line.toString(), style: TextStyle(fontSize: 15)));
        }
        x++;
        cnt++;
      }
      temp.add(const TextSpan(text: '\n\n'));
    }
    return temp;
  }
}
