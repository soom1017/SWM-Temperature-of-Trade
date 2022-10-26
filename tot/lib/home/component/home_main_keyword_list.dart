import 'package:flutter/material.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/keyword_map_screen.dart';
import 'package:tot/home/view/home_keyword_rank_view.dart';

import '../../common/const/colors.dart';

class HomeMainKeywordList extends StatelessWidget {
  const HomeMainKeywordList({Key? key}) : super(key: key);

  routeToKeywordRank(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HomeKeywordRankView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: -2,
              children: [
                Text("지금 뜨는 키워드는                       ",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        height: 2.0)),
                HomeMainKeywordButton(keyword: "#코로나19"),
                HomeMainKeywordButton(keyword: "#금리"),
                HomeMainKeywordButton(keyword: "#대출"),
                HomeMainKeywordButton(keyword: "#전기차"),
                Text(
                  "입니다.",
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w500, height: 1.36),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  routeToKeywordRank(context);
                },
                child: Text(
                  "키워드 더보기 〉",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeMainKeywordButton extends StatelessWidget {
  final String keyword;

  const HomeMainKeywordButton({required this.keyword, Key? key})
      : super(key: key);

  routeToKeywordMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KeywordMapScreen(keyword: keyword),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        routeToKeywordMap(context);
      },
      child: Text(
        keyword,
        style: TextStyle(fontSize: 24),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 10.0)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(KEYWORD_BG_COLOR),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.5),
          ),
        ),
      ),
    );
  }
}
