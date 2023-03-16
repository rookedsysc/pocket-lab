import 'package:flutter/material.dart';
import 'package:pocket_lab/calendar/component/month_pickcer.dart';
import 'package:pocket_lab/chart/component/category_chart.dart';
import 'package:pocket_lab/common/component/header_collection.dart';

class CategoryPieChartView extends StatelessWidget {
  const CategoryPieChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: HeaderCollection(headerType: HeaderType.categoryChart),
        ),
        MonthPicker(),
        CategoryChart(isHome: true),
      ],
    );
  }
}
