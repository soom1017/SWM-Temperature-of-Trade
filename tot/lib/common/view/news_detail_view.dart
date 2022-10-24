import 'package:flutter/material.dart';
import 'package:tot/common/component/news_detail_pie_chart.dert.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/component/news_detail_haed.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/news_data.dart';
import 'package:tot/common/view/news_full_text_view.dart';
import 'package:tot/home/component/home_user_keywords.dart';
import '../layout/default_layout.dart';
import 'package:tot/common/const/padding.dart';

Map<String, double> dataMap = {
  "현대카드": 56,
  "삼성카드": 19,
  "토스": 16,
};

Map<String, String> legendLabels = {
  "현대카드": "현대카드 56%",
  "삼성카드": "삼성카드 19%",
  "토스": "토스 16%",
};

final List<Color> colorList = [
  KEYWORD_BG_COLOR,
  Color(0xFF4099DD).withOpacity(0.3),
  HOME_BG_COLOR,
];

class NewsDetailView extends StatefulWidget {
  final String? stockName;
  final String postingDate;
  final String newsTitle;
  final List<String> tagList;
  final int? id;

  const NewsDetailView(
      {required this.tagList,
      required this.postingDate,
      required this.newsTitle,
      this.stockName,
      this.id,
      Key? key})
      : super(key: key);

  factory NewsDetailView.fromNewsTile(NewsTile tile) {
    return NewsDetailView(
      tagList: tile.tagList,
      postingDate: tile.postingDate,
      newsTitle: tile.newsTitle,
      stockName: tile.stockName,
      id: tile.id,
    );
  }

  @override
  State<NewsDetailView> createState() => _NewsDetailViewState();
}

class _NewsDetailViewState extends State<NewsDetailView> {
  routeToNewsFullTextView(BuildContext context, NewsData news) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            NewsFullTextView(news: news,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isExtraPage: true,
      pageName: "뉴스 상세",
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: FutureBuilder(
          future: API.getNewsById(widget.id!),
          builder: (BuildContext context, AsyncSnapshot<NewsData?> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final news = snapshot.data!;
            return Column(
              children: [
                NewsDetailHead.fromNewsData(news),
                _Information(news),
                Divider(
                  thickness: 5.0,
                  color: Color(0xFF9BACBC).withOpacity(0.4),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    if (news.attention_stock != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: HORIZONTAL_PADDING),
                        child: _Sentiment(news),
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    if (news.attention_stock != null)
                      Divider(
                        thickness: 2.0,
                        color: Color(0xFF9BACBC).withOpacity(0.4),
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: HORIZONTAL_PADDING),
                      child: _Graph(news),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _Information(NewsData news) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Spacer(),
              for (String keyword in widget.tagList)
                HomeUserKeyword(
                  keyword: keyword,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            news.summary,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 27,
            child: ElevatedButton(
              onPressed: () {
                routeToNewsFullTextView(context, news);
              },
              child: Text(
                "전문 보기 〉",
                style: TextStyle(fontSize: 17),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 17)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(KEYWORD_BG_COLOR),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _Graph(NewsData news) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "관련된 종목들은 아래와 같아요",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 35,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Spacer(),
            NewsDetailPieChart(
              legendLabels: legendLabels,
              colorList: colorList,
              dataMap: dataMap,
              centerText: "현대카드\n56%",
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ],
    );
  }

  Widget _Sentiment(NewsData news) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              " 해당뉴스는",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: _SentimentStockName(news.attention_stock!),
            ),
            Text(
              "에 대해",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _SentimentButton(news.label),
            ),
            Text(
              "적인 내용을 다루고 있어요",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _SentimentButton(int val){
    String sname;
    Color color;
    if(val == 0) {
      sname = '중립';
      color = Color(0xFF9C9934);
    } else if(val == 1) {
      sname = '긍정';
      color = Color(0xFFEA4242);
    } else {
      sname = '부정';
      color = Color(0xFF375FCA);
    }
    return ElevatedButton(
      onPressed: null,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 15.0)),
        foregroundColor:
        MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor:
        MaterialStateProperty.all<Color>(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      child: Text(
        sname,
        style: TextStyle(fontSize: 25),
      ),
    );
  }

  Widget _SentimentStockName(String stockName) {
    return ElevatedButton(
      onPressed: null,
      child: Text(
        stockName,
        style: TextStyle(fontSize: 25),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 15.0)),
        foregroundColor:
        MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor:
        MaterialStateProperty.all<Color>(PRIMARY_COLOR),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
