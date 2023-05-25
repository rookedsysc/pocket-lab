import 'package:flutter/material.dart';
import 'package:pocket_lab/chart/model/transaction_trend_chart_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionTrendChartSeries {
  ColumnSeries columnSeriesBySegmentType(
      {required String seriesName,required Color color, required List<TransactionTrendChartDataModel> chartData, required TextStyle textStyle}) {
    return ColumnSeries<TransactionTrendChartDataModel, String>(
      dataSource: chartData,
      color: color,
      xValueMapper: (data, _) => data.label,
      yValueMapper: (data, _) => data.amount,
      initialSelectedDataIndexes: [chartData.length - 1],
      name: seriesName,
      dataLabelSettings: DataLabelSettings(isVisible: false, textStyle: textStyle)
    );
  }
}