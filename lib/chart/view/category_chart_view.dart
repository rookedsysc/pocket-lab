import 'package:flutter/material.dart';
import 'package:pocket_lab/calendar/component/month_pickcer.dart';
import 'package:pocket_lab/chart/component/category_chart.dart';
import 'package:pocket_lab/chart/component/category_trend_chart.dart';
import 'package:pocket_lab/chart/component/chart_range_segement.dart';
import 'package:pocket_lab/common/component/header_collection.dart';

class CategoryChartView extends StatelessWidget {
  const CategoryChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _padding(),
        MonthPicker(),
        CategoryChart(isHome: true),
        _padding(),
        ChartRangeSegment(),
        CategoryTrendChart()
      ],
    );
  }

  Padding _padding() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: HeaderCollection(headerType: HeaderType.categoryChart),
    );
  }
}
