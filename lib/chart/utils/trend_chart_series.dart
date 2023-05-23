import 'package:flutter/material.dart';
import 'package:pocket_lab/home/model/trend_chart_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrendChartSeries {
  LineSeries seriesBySegmentType(
      {required Color color, required List<TrendChartDataModel> chartData, required TextStyle textStyle}) {
    return LineSeries<TrendChartDataModel, String>(
      markerSettings: MarkerSettings(isVisible: true),
      dataSource: chartData,
      color: color,
      xValueMapper: (data, _) => data.label,
      yValueMapper: (data, _) => data.amount,
      initialSelectedDataIndexes: [chartData.length - 1],
      //: tooltip 선택시 header 이름
      name: chartData.last.name + " Wallet",
      // dataLabelMapper: (datum, index) => CustomNumberUtils.formatCurrency(datum.amount),
      // dataLabelSettings: DataLabelSettings(
      //   textStyle: TextStyle(color: color),
      //   isVisible: true),
      //
      dataLabelSettings: DataLabelSettings(isVisible: false, textStyle: textStyle)
    );
  }
}
