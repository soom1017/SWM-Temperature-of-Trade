import 'package:flutter/material.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';

import '../../common/keyword_map_screen.dart';

class HomeUserKeywords extends StatelessWidget {
  final String name;

  const HomeUserKeywords({required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "$name님의 관심키워드",
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          child: HomeUserKeywordList(),
          width: double.infinity,
          decoration: BoxDecoration(
            color: HOME_BG_COLOR,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
          ),
        ),
      ],
    );
  }
}

class HomeUserKeywordList extends StatelessWidget {
  const HomeUserKeywordList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          HORIZONTAL_PADDING + 2, 5, HORIZONTAL_PADDING + 2, 5),
      child: Wrap(
        spacing: 8,
        runSpacing: -6,
        children: [
          HomeUserKeyword(keyword: "#낸드플래시"),
          HomeUserKeyword(keyword: "#ESG"),
          HomeUserKeyword(keyword: "#친환경"),
          HomeUserKeyword(keyword: "#인플레이션"),
          HomeUserKeyword(keyword: "#공매도"),
          HomeUserKeyword(keyword: "#금리"),
          HomeUserKeyword(keyword: "#블록체인"),
          HomeUserKeyword(keyword: "#에너지"),
          HomeUserKeyword(keyword: "#암호화폐"),
          HomeUserKeyword(keyword: "#NFT"),
          HomeUserKeyword(keyword: "#메타버스"),
        ],
      ),
    );
  }
}

class HomeUserKeyword extends StatelessWidget {
  final String keyword;
  final TextStyle textStyle;

  const HomeUserKeyword(
      {required this.keyword,
      Key? key,
      this.textStyle = const TextStyle(
        fontSize: 23,
        color: PRIMARY_COLOR,
      )})
      : super(key: key);

  routeToKeywordMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KeywordMapScreen(
          keyword: keyword,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        routeToKeywordMap(context);
      },
      child: Text(
        keyword,
        style: textStyle,
      ),
    );
  }
}
