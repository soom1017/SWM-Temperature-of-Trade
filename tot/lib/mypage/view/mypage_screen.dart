import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/home/component/home_hotnew_button.dart';
import 'package:tot/home/component/home_main_keyword_list.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  // 가운뎃점 쓰는 경우가 있음
  final _newsTileList = <NewsTile>[
    NewsTile(
      newsTitle: "이화전기, 위스키 브랜드 '윈저' 인수전 참여",
      stockName: "이화전기",
      tagList: ["#인수", "#코스닥", "#위스키"],
      postingDate: "2022.07.29",
      id: 10,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      Future.delayed(
          Duration.zero,
          () => showPlatformDialog(
                context: context,
                builder: (_) => PlatformAlertDialog(
                  title: Text('회원가입 후 이용 할 수 있습니다.'),
                  content: Text('비회원은 이용 할 수 없는 기능입니다.\n회원가입 하시겠습니까?'),
                  actions: <Widget>[
                    PlatformDialogAction(
                      child: PlatformText("네"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    PlatformDialogAction(
                      child: PlatformText("아니오"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      return Container();
    }
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "JH님의 TOT",
                style: TextStyle(
                    fontSize: 38,
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                    height: 1.5),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: null,
                    // onPressed: null,
                    child: Text(
                      "관심종목",
                      style: TextStyle(
                          fontSize: 26,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.w400),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.fromLTRB(17, 5, 17, 5)),
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(
                        width: 2.0,
                        color: PRIMARY_COLOR,
                      )),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(PRIMARY_COLOR),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 15.0)),
                  minimumSize:
                      MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(KEYWORD_BG_COLOR),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                onPressed: null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'JH님이 관심가질 만한',
                      style: TextStyle(fontSize: 30),
                    ),
                    // ∧∨
                    Icon(
                      Icons.expand_more_outlined,
                      size: 50,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "뉴스 모아봤어요.",
                  style: TextStyle(
                      fontSize: 30, color: PRIMARY_COLOR, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Container(
          width: double.infinity,
          height: 450,
          decoration: BoxDecoration(
            color: NEWSTAB_BG_COLOR,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                HORIZONTAL_PADDING, 20.0, HORIZONTAL_PADDING, 0.0),
            child: ListView.separated(
              itemBuilder: (context, i) {
                return _newsTileList[0];
              },
              separatorBuilder: (context, i) {
                return const Divider(
                  thickness: 1.5,
                );
              },
              itemCount: 7,
            ),
          ),
        ),
      ],
    );
  }
}
