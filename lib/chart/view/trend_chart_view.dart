import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pocket_lab/chart/component/chart_range_segement.dart';
import 'package:pocket_lab/chart/component/trend_chart.dart';
import 'package:pocket_lab/chart/component/trend_chart_tool_tip.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:sheet/route.dart';

class TrendChartView extends StatelessWidget {
  const TrendChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ///* Trend Chart
        Padding(
            padding: const EdgeInsets.all(16),
            child: HeaderCollection(headerType: HeaderType.trendChart),
          ),
          ChartRangeSegment(),
          TrendChart(),
          SizedBox(
            height: 8,
          ),
          TrendChartToolTip()
      ],
    );
  }
}
