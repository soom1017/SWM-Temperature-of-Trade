import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  Future<bool> test() async {
    Dio dio = Dio(BaseOptions(
      connectTimeout: 3000,
      receiveTimeout: 3000,
    ));
    print("test 실행");
    try{
      print("response1");
      Response response = await dio.get("http://3.38.140.121:8000/news/1");
      print("response2");
      if(response.statusCode == 200){
        final jsonBody = jsonDecode(response.data);
        print(jsonBody);
      }else{
        print(response.statusCode);
      }
      return true;
    }catch (e) {
      print(e.toString());
      return false;
    }
  }

  // 가운뎃점 쓰는 경우가 있음
  final _newsTileList = <NewsTile>[
    NewsTile(
      newsTitle: "전장에 날았지만...'TV 적자전환'에 주춤한 LG전자",
      stockName: "LG전자",
      tagList: ["#소비재", "#경기침체", "#인플레"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "카드채 금리 급등...카드론 받기 어려워진다",
      tagList: ["#카드론", "#대출", "#금리"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "트윔, 에너지 산업 분야에 50억 원 규모 수주",
      stockName: "트윔",
      tagList: ["#인공지능", "#에너지 산업"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "\"성수기에 영업 방해\"... 파업 속 하이트진로, 2분기 실적은?",
      stockName: "하이트진로",
      tagList: ["#파업", "#주류", "#성수기"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "힘 못쓰던 탄소배출권ETF 연일 '신바람'",
      tagList: ["#탄소배출권", "#전쟁", "#수익률 증가"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "버핏에 이어 손정의도 30조 손실...주식 거목도 피하지 못한 하락장",
      tagList: ["#하락장", "#손정의", "#소프트뱅크"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "이화전기, 위스키 브랜드 '윈저' 인수전 참여",
      stockName: "이화전기",
      tagList: ["#인수", "#코스닥", "#위스키"],
      postingDate: "2022.07.29",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // test();
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
                  minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(KEYWORD_BG_COLOR),
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
                    Icon(Icons.expand_more_outlined, size: 50,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text("뉴스 모아봤어요.", style: TextStyle(fontSize: 30, color: PRIMARY_COLOR, height: 1.4),),
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
                return _newsTileList[i];
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
