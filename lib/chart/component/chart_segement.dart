import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/utils/chart_type.dart';

class ChartSegment extends ConsumerWidget {
  late final int groupValue;
  ChartSegment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return CupertinoSegmentedControl(
        borderColor: Colors.transparent,
        selectedColor: Theme.of(context).primaryColor,
        unselectedColor: Theme.of(context).cardColor,
        groupValue: ref.watch(chartSegmentProvider).index,
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
          ref.refresh(chartSegmentProvider.notifier).state =
              numberToType(value);
        });
  }

  ChartSegmentType numberToType(int num) {
    switch (num) {
      case 0:
        return ChartSegmentType.daily;
      case 1:
        return ChartSegmentType.weekly;
      case 2:
        return ChartSegmentType.monthly;
      case 3:
        return ChartSegmentType.quarterly;
      case 4:
        return ChartSegmentType.yearly;
      default:
        return ChartSegmentType.daily;
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
