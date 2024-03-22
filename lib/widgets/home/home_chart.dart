import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sunmate/constants/colors_contant.dart';
import 'package:sunmate/localization/localization_contants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../providers/theme_provider.dart';

class _ChartData {
  _ChartData(this.x, this.y1, this.y2, this.y3, this.y4);

  final String x;
  final int y1;
  final int y2;
  final int y3;
  final int y4;
}

class HomeChartPage extends StatefulWidget {
  HomeChartPage(this.data, {super.key});
  final dynamic data;

  @override
  State<HomeChartPage> createState() => _HomeChartPageState();
}

class _HomeChartPageState extends State<HomeChartPage> {
  List<_ChartData> data2 = [];

  @override
  void initState() {
    super.initState();
    final jsonString = widget.data;
    final List<dynamic> jsonData = json.decode(jsonString);
    data2 = jsonData.map((item) {
      final dateTime = DateTime.parse(item['datetime']);
      final formattedTime = DateFormat.Hm().format(dateTime);
      return _ChartData(
        formattedTime,
        int.parse(item['houseload_usage_watt']),
        int.parse(item['production_usage_watt']),
        int.parse(item['grid_usage_watt']),
        int.parse(item['battery_usage_watt']),
      );
    }).toList();

    data2 = data2.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Container(
        height: 250,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          legend: Legend(
            alignment: ChartAlignment.near,
            textStyle: TextStyle(
              color: getColors(themeNotifier.isDark, 'GreyTextColor'),
              fontWeight: FontWeight.w600,
              fontSize: 9,
            ),
            isVisible: true,
          ),
          primaryXAxis: const CategoryAxis(
            axisLine: AxisLine(width: 0),
            majorGridLines: MajorGridLines(
              width: 0,
            ),
            majorTickLines: MajorTickLines(size: 0, width: 0),
          ),
          primaryYAxis: NumericAxis(
            axisLine: AxisLine(width: 0),
            labelFormat: '{value}K',
            majorGridLines: MajorGridLines(
                width: 1,
                color: getColors(themeNotifier.isDark, 'GreyTextColor'),
                dashArray: <double>[1, 1]),
            majorTickLines: MajorTickLines(size: 0, width: 0),
          ),
          series: <StackedColumnSeries<_ChartData, String>>[
            StackedColumnSeries<_ChartData, String>(
                dataSource: data2,
                color: getColors(themeNotifier.isDark, 'houseLoad'),
                xValueMapper: (_ChartData sales, _) => sales.x,
                yValueMapper: (_ChartData sales, _) => sales.y1,
                name: getTranslated(context, 'k_home_House_Load')),
            StackedColumnSeries<_ChartData, String>(
                dataSource: data2,
                color: getColors(themeNotifier.isDark, 'production'),
                xValueMapper: (_ChartData sales, _) => sales.x,
                yValueMapper: (_ChartData sales, _) => sales.y2,
                name: getTranslated(context, 'k_home_Production')),
            StackedColumnSeries<_ChartData, String>(
                dataSource: data2,
                color: getColors(themeNotifier.isDark, 'gridLoad'),
                xValueMapper: (_ChartData sales, _) => sales.x,
                yValueMapper: (_ChartData sales, _) => sales.y3,
                name: getTranslated(context, 'k_home_Grid_Load')),
            StackedColumnSeries<_ChartData, String>(
                dataSource: data2,
                color: getColors(themeNotifier.isDark, 'battaryLoad'),
                xValueMapper: (_ChartData sales, _) => sales.x,
                yValueMapper: (_ChartData sales, _) => sales.y4,
                name: getTranslated(context, 'k_home_battery_load'))
          ],
          tooltipBehavior:
              TooltipBehavior(enable: true, header: '', canShowMarker: false),
        ),
      );
    });
  }
}
