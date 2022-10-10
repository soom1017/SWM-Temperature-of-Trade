import 'package:flutter/material.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/home/component/home_hotnew_button.dart';
import 'package:tot/home/component/home_user_keywords.dart';
import '../../home/component/home_main_keyword_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          height: 65,
          child: Row(
            children: [
              SizedBox(width: HORIZONTAL_PADDING,),
              HomeHotNewButton(text: "NEW"),
              SizedBox(
                width: 12.0,
              ),
              HomeHotNewButton(text: "HOT"),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFF), Color(0x2E9BACBC)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )
          ),
          child: HomeMainKeywordList(),
          height: 300,
        ),
        HomeUserKeywords(name: "JH"),
      ]),
    );
  }
}
