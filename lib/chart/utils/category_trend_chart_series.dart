import 'package:flutter/material.dart';
import 'package:pocket_lab/chart/model/category_trend_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryTrendChartSeries {
  LineSeries seriseBySegmentType({
    required Color color,
    required List<CategoryTrendChartDataModel> chartData,
    //: 마지막 데이터 표시안함
    required bool isFirst,
    required TextStyle labelTextStyle,
  }) {
    return LineSeries<CategoryTrendChartDataModel, String>(
      dataLabelSettings: DataLabelSettings(textStyle: labelTextStyle),
      markerSettings: MarkerSettings(
        isVisible: true,
      ),
      dataSource: chartData,
      color: color,
      xValueMapper: (data, _) => data.label,
      yValueMapper: (data, _) => data.amount,
      name: chartData.last.categoryName,
      isVisible: !isFirst,
    );
  }
}
