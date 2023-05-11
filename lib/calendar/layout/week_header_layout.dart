import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/component/week_header.dart';
import 'package:pocket_lab/calendar/utils/calendar_utils.dart';

class WeekHeaderLayOut extends ConsumerWidget {
  final DateTime focusedDay;
  const WeekHeaderLayOut({required this.focusedDay, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 75.0,
      child: ListView(
        //: 가로로 스크롤
        scrollDirection: Axis.horizontal,
        children: List.generate(
          CalendarUtils().getWeeksInMonth(focusedDay),
          (index) => Padding(
            padding: getPadding(index),
            child: WeekHeader(
              index: index,
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets getPadding(int index) {
    if (index == 0) {
      return EdgeInsets.only(left: 8.0);
    } else if (CalendarUtils().getWeeksInMonth(focusedDay) == index + 1) {
      return EdgeInsets.only(left: 4, right: 8.0);
    }
    return EdgeInsets.only(left: 4);
  }
}
