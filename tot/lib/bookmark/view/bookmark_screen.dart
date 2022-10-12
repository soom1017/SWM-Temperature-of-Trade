import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tot/common/component/news_tile.dart';
import 'package:tot/common/const/colors.dart';
import 'package:tot/common/const/padding.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
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
      tagList: ["#위스키", "#브랜드", "#인수"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "현대홈쇼핑, 송출료 증가에 발목...2분기 이익 17% 감소",
      stockName: "현대홈쇼핑",
      tagList: ["#송출료", "#홈쇼핑", "#성장성"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "같은 편의점 뭐가 다르길래…CU는 웃고 GS25는 울었다",
      stockName: "CU",
      tagList: ["#편의점", "#상품", "#스티커"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "요격미사일 '천궁'의 힘…LIG넥스원, 신고가 요격",
      stockName: "LIG넥스원",
      tagList: ["#미사일", "#방산", "#안보"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "셀트리온 20만원 회복…헬스케어는 코스닥 대장주 탈환",
      stockName: "셀트리온",
      tagList: ["#코스닥", "#헬스케어", "#매출달성"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "한국 딜로이트 ESG전문가 위어 영입",
      tagList: ["#영국", "#지속가능경영", "#환경"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "재차 꿈틀대는 리오프닝주...숏커버링 기대감도",
      tagList: ["#리오프닝", "#경제활동"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "엠로, 2분기 영업이익 전기대비 188.7% 증가",
      stockName: "엠로",
      tagList: ["#소프트웨어", "#AI", "#공급망"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "서울 종로 '타워8' 매물로 나와",
      tagList: ["#신한카드", "#부동산"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "[표]코스피·코스닥 투자주체별 매매동향( 8월 4일-최종치)",
      tagList: ["#코스피", "#코스닥"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "“지누스, 최악을 지나는 중… 미국 물류난 해소 기대”",
      stockName: "지누스",
      tagList: ["#미국물류난", "#운송", "#과잉재고"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "코윈테크 종속회사 탑머티리얼, 코스닥 상장 추진",
      stockName: "코윈테크",
      tagList: ["#2차전지", "#코스닥 상장"],
      postingDate: "2022.07.29",
    ),
    NewsTile(
      newsTitle: "'美 고용시장 기지개' 미국 또 0.75%p 금리인상 가능성↑",
      tagList: ["#금리", "#고용시장", "#미국정세"],
      postingDate: "2022.07.29",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
      child: SlidableAutoCloseBehavior(
        child: ListView.separated(
          itemBuilder: (context, i) {
            if(i == 0){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(height: 25,),
                Text(
                  "북마크 한 뉴스",
                  style: TextStyle(
                      fontSize: 30,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20,),
              ],);
            }
            return _newsTileList[i-1];
          },
          separatorBuilder: (context, i) {
            if(i == 0) return SizedBox.shrink();
            return const Divider(
              thickness: 1.5,
            );
          },
          itemCount: _newsTileList.length,
        ),
      ),
    );
  }
}
