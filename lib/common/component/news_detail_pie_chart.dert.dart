import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class NewsDetailPieChart extends StatelessWidget {
  final colorList;
  final dataMap;
  final centerText;
  final legendLabels;

  NewsDetailPieChart({
    Key? key,
    required this.colorList,
    required this.dataMap,
    required this.centerText,
    required this.legendLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartRadius: MediaQuery.of(context).size.width / 2.6,
      initialAngleInDegree: 270,
      chartType: ChartType.ring,
      colorList: colorList,
      ringStrokeWidth: 32,
      centerText: centerText,
      legendLabels: legendLabels,
      chartLegendSpacing: 25,
      centerTextStyle: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.left,
        showLegends: true,
        legendShape: BoxShape.rectangle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        legendLabels: legendLabels,
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: false,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }
}
