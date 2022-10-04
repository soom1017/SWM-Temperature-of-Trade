import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class NewsDetailPieChart extends StatelessWidget {
  final colorList;
  final dataMap;
  final centerText;

  NewsDetailPieChart({
    Key? key,
    required this.colorList,
    required this.dataMap,
    required this.centerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      initialAngleInDegree: 270,
      chartType: ChartType.ring,
      colorList: colorList,
      ringStrokeWidth: 32,
      centerText: centerText,
      centerTextStyle: TextStyle(fontSize: 20, color: Colors.black),
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: false,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
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
