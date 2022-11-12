import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/layout/default_layout.dart';
import 'package:tot/common/view/keyword_screen.dart';
import 'package:tot/common/layout/page_title_layout.dart';

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

  routeToKeywordMap() {
    Get.to(() => KeywordMapScreen(keyword: keyword));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        routeToKeywordMap();
      },
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Text(
                  "$rank",
                  style: TextStyle(fontSize: 20.sp),
                  textAlign: TextAlign.right,
                ),
                width: 30.w,
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                "#$keyword",
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
        ],
      ),
    );
  }
}

class HomeKeywordRankView extends StatelessWidget {
  const HomeKeywordRankView({Key? key}) : super(key: key);

  List<Widget> func(){
    List<Widget> temp = [];
    for(var i = 0; i<keywordListRank["data"].length;i++){
      if(i % 5 == 0 && i != 0){
        temp.add(Divider(thickness: 1.5,));
      }
      temp.add(KeywordRankTile(keyword: keywordListRank["data"][i], rank: i+1));
    }
    temp.add(SizedBox(height: 30.h,));
    return temp;
  }
  
  @override
  Widget build(BuildContext context) {
    List<Widget> _list = func();
    return DefaultLayout(
      // isExtraPage: true,
      pageName: "키워드 순위",
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFF), Color(0x2A9BACBC)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),),
          padding: EdgeInsets.fromLTRB(
              HORIZONTAL_PADDING.w, 0.h, HORIZONTAL_PADDING.w, 0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitleLayout(pageName: "키워드 순위", update_time: DateTime.parse(keywordListRank["update_time"].toString()),),
              SizedBox(
                height: 20.h,
              ),
              ..._list,
            ],
          ),
        ),
      ),
    );
  }
}
