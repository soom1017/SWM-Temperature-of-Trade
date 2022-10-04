import 'package:flutter/material.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import '../layout/default_layout.dart';
import 'package:tot/common/const/padding.dart';

import '../view/news_detail_view.dart';

class NewsDetailHead extends StatelessWidget {
  final String? stockName;
  final String postingDate;
  final String newsTitle;
  late List<String> tagList;

  NewsDetailHead(
      {required this.tagList,
        required this.postingDate,
        required this.newsTitle,
        this.stockName,
        Key? key})
      : super(key: key);

  factory NewsDetailHead.fromDetailView(NewsDetailView head) {
    return NewsDetailHead(
      tagList: head.tagList,
      postingDate: head.postingDate,
      newsTitle: head.newsTitle,
      stockName: head.stockName,
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
          SizedBox(height: 10,),
          Row(
            children: [
              Text("매일경제"),
              SizedBox(width: 25,),
              Text("입력 : " + postingDate.toString(), style: TextStyle(color: SMALL_FONT_COLOR, fontSize: 10)),
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
