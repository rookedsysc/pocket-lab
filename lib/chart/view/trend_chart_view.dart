import 'package:flutter/material.dart';
import 'package:pocket_lab/chart/component/chart_range_segement.dart';
import 'package:pocket_lab/chart/component/transaction_trend_chart.dart';
import 'package:pocket_lab/chart/component/trend_chart.dart';
import 'package:pocket_lab/chart/component/trend_chart_tool_tip.dart';
import 'package:pocket_lab/common/component/header_collection.dart';

class TrendChartView extends StatelessWidget {
  const TrendChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16,),
                      ChartRangeSegment(),
        Expanded(
          child: ListView(
            children: [
              ///* Trend Chart
              _padding(
                header: HeaderCollection(headerType: HeaderType.trendChart),
              ),

              TrendChart(),
              SizedBox(
                height: 8,
              ),
              _padding(
                header: HeaderCollection(headerType: HeaderType.transactionTrendChart),
              ),
              TransactionTrendChart(),
              _padding(),
              TrendChartToolTip()
            ],
          ),
        ),
      ],
    );
  }

  Padding _padding({HeaderCollection? header}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: header,
    );
  }
}
