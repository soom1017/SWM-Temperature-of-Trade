import 'package:flutter/material.dart';
import 'package:tot/common/view/news_detail_view.dart';

import '../const/colors.dart';

class NewsTile extends StatelessWidget {
  final String? stockName;
  final String postingDate;
  final String newsTitle;
  late List<String> tagList;

  NewsTile(
      {required this.tagList,
      required this.postingDate,
      required this.newsTitle,
      this.stockName,
      Key? key})
      : super(key: key);

  routeToNewsDetailPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewsDetailView.fromNewsTile(this),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        routeToNewsDetailPage(context);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsTitle,
              style: TextStyle(fontSize: 19),
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              height: 25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (stockName == null) SizedBox.shrink() else stockTag(),
                  ...keywordTags(),
                  Spacer(),
                  Text(
                    postingDate,
                    style: TextStyle(
                        fontSize: 11,
                        color: SMALL_FONT_COLOR,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stockTag() {
    return Container(
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.fromLTRB(0, 0, 7, 0),
      width: 70,
      height: 18,
      child: ElevatedButton(
        onPressed: null,
        child: Text(
          stockName!,
          style: TextStyle(fontSize: 13),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 5)),
          // minimumSize: MaterialStateProperty.all<Size>(Size(66, 16)),
          // maximumSize: MaterialStateProperty.all<Size>(Size(66, 16)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(KEYWORD_BG_COLOR),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> keywordTags() {
    return List.from(tagList.map((keyword) => KeywordTag(
          keywordName: keyword,
        )));
  }
}

class KeywordTag extends StatelessWidget {
  final String keywordName;

  const KeywordTag({required this.keywordName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      keywordName + " ",
      style: TextStyle(
        fontSize: 13,
        color: SMALL_FONT_COLOR,
      ),
    );
  }
}
