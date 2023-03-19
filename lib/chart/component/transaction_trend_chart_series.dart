import 'package:flutter/material.dart';
import 'package:pocket_lab/common/model/trend_multiple_chart_model.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionTrendChartSeries {
  ColumnSeries columnSeriesBySegmentType(
      {required String seriesName,required Color color, required List<TransactionTrendChartDataModel> chartData}) {
    return ColumnSeries<TransactionTrendChartDataModel, String>(
      dataSource: chartData,
      color: color,
      xValueMapper: (data, _) => data.label,
      yValueMapper: (data, _) => data.amount,
      initialSelectedDataIndexes: [chartData.length - 1],
      name: seriesName,
    );
  }
}