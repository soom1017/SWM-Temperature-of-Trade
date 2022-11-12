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
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
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
                colors: [Color(0xFFFFFF), Color(0x2CCFE0F5)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: HomeMainKeywordList(),
            height: 220.h,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFF), Color(0x2A9BACBC)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                25.w,
                20.h,
                20.w,
                20.h,
              ),
              child: Text(
                '뉴스 온도로 보는\n경제 시장 분위기',
                style: TextStyle(
                    color: Color(0xFF1A63D9),
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600, height: 1.2),
              ),
            ),
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0.w, 10.h, 10.w, 10.h),
            child: FutureBuilder(
              future: tokenCheck(() => API.getSentimentStats()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
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
      builder: (BuildContext context, TrackballDetails trackballDetails) {
        return Container(
          height: 50.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 8, 22, 0.75),
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  '긍정 : ${widget.data[trackballDetails.pointIndex!].positive.toInt()}건',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Color.fromRGBO(255, 255, 255, 1))),
              Text(
                  '부정 : ${widget.data[trackballDetails.pointIndex!].negative.toInt()}건',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Color.fromRGBO(255, 255, 255, 1))),
            ],
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.h,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 15.w, 0),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
            placeLabelsNearAxisLine: true,
            crossesAt: 0,
          ),
          primaryYAxis: NumericAxis(
            minimum: -1,
            maximum: 1,
            crossesAt: 0,
            interval: 0.5,
            placeLabelsNearAxisLine: false,
            plotBands: [
              PlotBand(
                start: 0,
                end: 0,
              ),
            ],
          ),
          trackballBehavior: _trackballBehavior,
          series: <LineSeries<ChartData, String>>[
            LineSeries<ChartData, String>(
              dataSource: widget.data,
              color: Color(0xFF5E82E5),
              xValueMapper: (ChartData sales, _) =>
                  '${sales.date.month}/${sales.date.day}',
              yValueMapper: (ChartData sales, _) => sales.t,
            ),
          ],
        ),
      ),
    );
  }
}
