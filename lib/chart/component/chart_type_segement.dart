import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/constant/chart_type.dart';

class ChartTypeSegement extends ConsumerWidget {
  final ValueChanged onValueChanged; 
  const ChartTypeSegement({required this.onValueChanged,super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width / 3;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: CupertinoSegmentedControl(
        borderColor: Colors.transparent,
        selectedColor: Theme.of(context).primaryColor,
        unselectedColor: Theme.of(context).cardColor,
        groupValue: ref.watch(chartTypeProvider),
        padding: EdgeInsets.symmetric(horizontal: 4),
        children: {
          0: buildSegment(
            width: width,
            icon: Icon(Icons.trending_up, size: width * 0.1),
            text: "Trend",
            textTheme: textTheme,
          ),
          1: buildSegment(
            width: width,
            icon: Icon(Icons.pie_chart, size: width * 0.1),
            text: "Category",
            textTheme: textTheme,
          ),
          2: buildSegment(
            width: width,
            icon: Icon(Icons.view_column, size: width * 0.1),
            text: "Time HeatMap",
            textTheme: textTheme,
          ),
        },
        onValueChanged: onValueChanged,
      ),
    );
  }

  ChartSegmentType numberToType(int num) {
    switch (num) {
      case 0:
        return ChartSegmentType.trendChart;
      case 1:
        return ChartSegmentType.categoryChart;
      case 2:
        return ChartSegmentType.timeChart;
      default:
        return ChartSegmentType.trendChart;
    }
  }

  Widget buildSegment({
    required double width,
    required Icon icon,
    required String text,
    required TextTheme textTheme,
  }) {
    return SizedBox(
      width: width,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
        icon,
        SizedBox(width: 8),
        Text(
          text,
          style: textTheme.bodySmall?.copyWith(fontSize: 10),
          overflow: TextOverflow.ellipsis,
        ),
      ]),
    );
  }
}
