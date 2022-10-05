import 'package:flutter/material.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/keyword_map_screen.dart';
import '../../common/const/colors.dart';
import '../../common/layout/default_layout.dart';

// 몇시 기준으로 선정한 키워드인지,
// 키워드 순위 변동도 표시

class HomeKeywordRankView extends StatelessWidget {
  const HomeKeywordRankView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isExtraPage: true,
      pageName: "뉴스 상세",
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            HORIZONTAL_PADDING, 20, HORIZONTAL_PADDING, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "키워드 순위",
              style: TextStyle(fontSize: 25, color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "1",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#IT",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "2",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#코로나19",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "3",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#금리",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "4",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#환율",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "5",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#수출",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "6",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#인공지능",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "7",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#부동산",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "8",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#소비재",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "9",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#환율",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "10",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#수출",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "11",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#IT",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "12",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#코로나19",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "13",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#금리",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "14",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#환율",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    "15",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  width: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "#수출",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
