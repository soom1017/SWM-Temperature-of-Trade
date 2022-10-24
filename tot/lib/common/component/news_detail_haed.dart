import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.fromLTRB(HORIZONTAL_PADDING, 20, HORIZONTAL_PADDING, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(newsTitle, style: TextStyle(fontSize: 24,),),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                Row(children: [
                  Text(press, style: TextStyle(fontSize: 15),),
                  SizedBox(width: 15,),
                  Text("$reporter 기자", style: TextStyle(fontSize: 12),),
                ],),
                SizedBox(height: 5,),
                Text("입력 : " + postingDate.toString(), style: TextStyle(color: SMALL_FONT_COLOR, fontSize: 10)),
              ],),
              Spacer(),
              Icon(Icons.share_outlined, size: 30,),
              SizedBox(width: 10,),
              Icon(Icons.bookmark_border, size: 30,),
            ],
          )
        ],
      ),
    );
  }
}
