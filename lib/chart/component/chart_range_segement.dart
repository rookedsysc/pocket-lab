import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/constant/chart_range_type.dart';

class ChartRangeSegment extends ConsumerWidget {
  late final int groupValue;
  ChartRangeSegment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return CupertinoSegmentedControl(
        borderColor: Colors.transparent,
        selectedColor: Theme.of(context).primaryColor,
        unselectedColor: Theme.of(context).cardColor,
        groupValue: ref.watch(chartRangeProvider).index,
        children: {
          0: buildSegment(
            text: "D",
            textTheme: textTheme,
          ),
          1: buildSegment(
            text: "W",
            textTheme: textTheme,
          ),
          2: buildSegment(
            text: "M",
            textTheme: textTheme,
          ),
          3: buildSegment(
            text: "3M",
            textTheme: textTheme,
          ),
          4: buildSegment(
            text: "Y",
            textTheme: textTheme,
          ),
        },
        onValueChanged: (value) {
          ref.refresh(chartRangeProvider.notifier).state =
              numberToType(value);
        });
  }

  ChartRangeType numberToType(int num) {
    switch (num) {
      case 0:
        return ChartRangeType.daily;
      case 1:
        return ChartRangeType.weekly;
      case 2:
        return ChartRangeType.monthly;
      case 3:
        return ChartRangeType.quarterly;
      case 4:
        return ChartRangeType.yearly;
      default:
        return ChartRangeType.daily;
    }
  }

  Widget buildSegment({required String text, required TextTheme textTheme}) {
    return Container(
      child: Text(
        text,
        style: textTheme.bodyMedium,
      ),
    );
  }
}
