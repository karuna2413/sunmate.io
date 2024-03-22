import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sunmate/constants/colors_contant.dart';
import 'package:sunmate/localization/localization_contants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../providers/theme_provider.dart';

class _StackChartData {
  _StackChartData(this.x, this.y1, this.y2, this.y3, this.y4);

  final String x;
  final int y1;
  final int y2;
  final int y3;
  final int y4;
}

class StackHomeChartPage extends StatefulWidget {
  StackHomeChartPage(this.data, {super.key});
  final dynamic data;

  @override
  State<StackHomeChartPage> createState() => _StackHomeChartPageState();
}

class _StackHomeChartPageState extends State<StackHomeChartPage> {
  List<_StackChartData> data2 = [];

  @override
  void initState() {
    super.initState();
    final jsonString = widget.data;
    final List<dynamic> jsonData = json.decode(jsonString);
    data2 = jsonData.map((item) {
      final dateTime = DateTime.parse(item['datetime']);
      final formattedTime = DateFormat.Hm().format(dateTime);
      return _StackChartData(
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
            // overflowMode: LegendItemOverflowMode.wrap,
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
          series: <StackedAreaSeries<_StackChartData, String>>[
            StackedAreaSeries<_StackChartData, String>(
                markerSettings: MarkerSettings(
                    color: Colors.blue,
                    isVisible: true,
                    shape: DataMarkerType.rectangle),
                borderColor: Colors.blue,
                dataSource: data2,
                color: Colors.blue.shade100,
                xValueMapper: (_StackChartData sales, _) => sales.x,
                yValueMapper: (_StackChartData sales, _) => sales.y1,
                name: getTranslated(context, 'k_home_House_Load')),
            StackedAreaSeries<_StackChartData, String>(
                borderColor: Colors.redAccent.shade200,
                // markerSettings: MarkerSettings(
                //     shape: DataMarkerType.rectangle, isVisible: true),
                // dataLabelSettings: DataLabelSettings(
                //     color: Colors.redAccent.shade200,
                //     textStyle: TextStyle(fontSize: 4),
                //     isVisible: true,
                //     showCumulativeValues: true,
                //     useSeriesColor: true),
                markerSettings: MarkerSettings(
                    color: Colors.redAccent.shade200,
                    isVisible: true,
                    shape: DataMarkerType.rectangle),
                dataSource: data2,
                color: Colors.red.shade100,
                xValueMapper: (_StackChartData sales, _) => sales.x,
                yValueMapper: (_StackChartData sales, _) => sales.y2,
                name: getTranslated(context, 'k_home_Production')),
            // StackedAreaSeries<_StackChartData, String>(
            //     borderColor: Colors.green.shade300,
            //     markerSettings: MarkerSettings(
            //         color: Colors.green.shade300,
            //         isVisible: true,
            //         shape: DataMarkerType.rectangle),
            //     // markerSettings: MarkerSettings(
            //     //     shape: DataMarkerType.rectangle, isVisible: true),
            //     // dataLabelSettings: DataLabelSettings(
            //     //     color: Colors.green.shade300,
            //     //     textStyle: TextStyle(fontSize: 4),
            //     //     isVisible: true,
            //     //     showCumulativeValues: true,
            //     //     useSeriesColor: true),
            //     dataSource: data2,
            //     color: Colors.green.shade100,
            //     xValueMapper: (_StackChartData sales, _) => sales.x,
            //     yValueMapper: (_StackChartData sales, _) => sales.y3,
            //     name: getTranslated(context, 'k_home_Grid_Load')),
            // StackedAreaSeries<_StackChartData, String>(
            //     borderColor: Colors.yellow.shade600,
            //     markerSettings: MarkerSettings(
            //         color: Colors.yellow.shade600,
            //         isVisible: true,
            //         shape: DataMarkerType.rectangle),
            //     // markerSettings: MarkerSettings(
            //     //     shape: DataMarkerType.rectangle, isVisible: true),
            //     // dataLabelSettings: DataLabelSettings(
            //     //     color: Colors.yellow.shade600,
            //     //     textStyle: TextStyle(fontSize: 4),
            //     //     isVisible: true,
            //     //     showCumulativeValues: true,
            //     //     useSeriesColor: true),
            //     dataSource: data2,
            //     color: Colors.yellow.shade100,
            //     xValueMapper: (_StackChartData sales, _) => sales.x,
            //     yValueMapper: (_StackChartData sales, _) => sales.y4,
            //     name: getTranslated(context, 'k_home_battery_load'))
          ],
          tooltipBehavior:
              TooltipBehavior(enable: true, header: '', canShowMarker: false),
        ),
      );
    });
  }
}
