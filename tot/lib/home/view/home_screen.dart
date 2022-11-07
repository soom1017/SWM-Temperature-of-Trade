import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tot/common/const/padding.dart';
import 'package:tot/common/data/API.dart';
import 'package:tot/common/data/chart_data.dart';
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
            height: 65.h,
            child: Row(
              children: [
                SizedBox(
                  width: HORIZONTAL_PADDING.w,
                ),
                HomeHotNewButton(text: "NEW"),
                SizedBox(
                  width: 12.0.w,
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
            height: 300.h,
          ),
          //HomeUserKeywords(name: "JH"),
          // Text('기사로 보는'),
          // Text('경제시장 흐름'),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0.w,10.h,10.w,10.h),
            child: FutureBuilder(
              future: API.getSentimentStats(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ChartData>?> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return _WeeklyGraph(
                  data: snapshot.data!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyGraph extends StatefulWidget {
  final List<ChartData> data;

  const _WeeklyGraph({Key? key, required this.data}) : super(key: key);

  @override
  State<_WeeklyGraph> createState() => _WeeklyGraphState();
}

class _WeeklyGraphState extends State<_WeeklyGraph> {
  late TrackballBehavior _trackballBehavior;

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
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.onTicks,
        placeLabelsNearAxisLine: false,
        crossesAt: 0,
      ),
      primaryYAxis: NumericAxis(
        minimum: -1,
        maximum: 1,
        crossesAt: 0,
        interval: 0.2,
        placeLabelsNearAxisLine: false,
        plotBands: [
          PlotBand(
            start: 0,
            end: 0,
            borderColor: Colors.red,
            borderWidth: 2,
          ),
        ],
      ),
      trackballBehavior: _trackballBehavior,
      series: <LineSeries<ChartData, String>>[
        LineSeries<ChartData, String>(
          dataSource: widget.data,
          name: '긍부정 비율',
          color: Colors.blue,
          xValueMapper: (ChartData sales, _) =>
              '${sales.date.month}/${sales.date.day}',
          yValueMapper: (ChartData sales, _) => sales.t,
        ),
      ],
    );
  }
}
