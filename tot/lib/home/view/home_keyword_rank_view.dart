import 'package:flutter/material.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/view/keyword_screen.dart';
import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';

// 몇시 기준으로 선정한 키워드인지,
// 키워드 순위 변동도 표시

class KeywordRankTile extends StatelessWidget {
  final String keyword;
  final int rank;

  const KeywordRankTile({
    Key? key,
    required this.keyword,
    required this.rank,
  }) : super(key: key);

  routeToKeywordMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KeywordMapScreen(keyword: keyword),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        routeToKeywordMap(context);
      },
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  "$rank",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.right,
                ),
                width: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "#$keyword",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

class HomeKeywordRankView extends StatelessWidget {
  const HomeKeywordRankView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isExtraPage: true,
      pageName: "키워드 순위",
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              HORIZONTAL_PADDING, 20, HORIZONTAL_PADDING, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "키워드 순위",
                style: TextStyle(
                    fontSize: 25,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              for (var i = 0; i < keywordList.length; i++)
                KeywordRankTile(keyword: keywordList[i], rank: i+1),
            ],
          ),
        ),
      ),
    );
  }
}
