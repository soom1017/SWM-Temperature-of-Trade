import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/view/keyword_screen.dart';
import 'package:tot/home/view/home_keyword_rank_view.dart';

import '../../common/const/colors.dart';

class HomeMainKeywordList extends StatelessWidget {
  const HomeMainKeywordList({Key? key}) : super(key: key);

  routeToKeywordRank() {
    Get.to(() => HomeKeywordRankView());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING.w),
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
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w500,
                        height: 2.0)),
                for(var i=0;i<4;i++)
                  HomeMainKeywordButton(keyword: keywordListRank["data"][i]),
                Text(
                  "입니다.",
                  style: TextStyle(
                      fontSize: 32.sp, fontWeight: FontWeight.w500, height: 1.36),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  routeToKeywordRank();
                },
                child: Text(
                  "키워드 순위 보기 〉",
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
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

  routeToKeywordMap() {
    Get.to(() => KeywordMapScreen(keyword: keyword));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        routeToKeywordMap();
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 10.0.w)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(KEYWORD_BG_COLOR),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.5),
          ),
        ),
      ),
      child: Text(
        "#$keyword",
        style: TextStyle(fontSize: 24.sp),
      ),
    );
  }
}
