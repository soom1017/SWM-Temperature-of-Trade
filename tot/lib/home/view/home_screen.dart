import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/home/component/home_hotnew_button.dart';
import 'package:tot/home/component/home_user_keywords.dart';
import '../../home/component/home_main_keyword_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 65,
            child: Row(
              children: [
                SizedBox(
                  width: HORIZONTAL_PADDING,
                ),
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
            )),
            child: HomeMainKeywordList(),
            height: 300,
          ),
          //HomeUserKeywords(name: "JH"),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _WeeklyGraph(),
          ),
        ],
      ),
    );
  }
}

class _WeeklyGraph extends StatefulWidget {
  const _WeeklyGraph({Key? key}) : super(key: key);

  @override
  State<_WeeklyGraph> createState() => _WeeklyGraphState();
}

class _WeeklyGraphState extends State<_WeeklyGraph> {
  late TrackballBehavior _trackballBehavior;
  final List<ChartData> data = <ChartData>[
    ChartData('Jan', 15, 39, 60),
    ChartData('Feb', 20, 30, 55),
    ChartData('Mar', 25, 28, 48),
    ChartData('Apr', 21, 35, 57),
    ChartData('May', 13, 39, 62),
    ChartData('Jun', 18, 41, 64),
    ChartData('Jul', 24, 45, 57),
    ChartData('Aug', 23, 48, 53),
    ChartData('Sep', 19, 54, 63),
    ChartData('Oct', 31, 55, 50),
    ChartData('Nov', 39, 57, 66),
    ChartData('Dec', 50, 60, 65),
  ];

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      enable: true,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      markerSettings: TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.visible,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      trackballBehavior: _trackballBehavior,
      series: <LineSeries<ChartData, String>>[
        LineSeries<ChartData, String>(
          dataSource: data,
          name: 'United States of America',
          xValueMapper: (ChartData sales, _) => sales.month,
          yValueMapper: (ChartData sales, _) => sales.firstSale,
        ),
        LineSeries<ChartData, String>(
          dataSource: data,
          name: 'Germany',
          xValueMapper: (ChartData sales, _) => sales.month,
          yValueMapper: (ChartData sales, _) => sales.secondSale,
        ),
        LineSeries<ChartData, String>(
          dataSource: data,
          name: 'United Kingdom',
          xValueMapper: (ChartData sales, _) => sales.month,
          yValueMapper: (ChartData sales, _) => sales.thirdSale,
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.month, this.firstSale, this.secondSale, this.thirdSale);

  final String month;
  final double firstSale;
  final double secondSale;
  final double thirdSale;
}
