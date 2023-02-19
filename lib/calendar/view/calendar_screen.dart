import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/component/calendar.dart';
import 'package:pocket_lab/calendar/component/month_header.dart';
import 'package:pocket_lab/calendar/component/month_pickcer.dart';
import 'package:pocket_lab/calendar/component/week_header.dart';
import 'package:pocket_lab/calendar/model/calendar_model.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/calendar/utils/calendar_utils.dart';


class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalendarModel _calendarState;

  @override
  void didChangeDependencies() {
    initRiverpod();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: ListView(
        children: [
          MonthPicker(),
          MonthHeader(),
          SizedBox(
            height: 75.0,
            child: ListView(
              //: 가로로 스크롤
              scrollDirection: Axis.horizontal,
              children: List.generate(
                CalendarUtils().getWeeksInMonth(_focusedDay),
                (index) => Padding(
                  padding: getPadding(index),
                  child: WeekHeader(
                    index: index,
                  ),
                ),
              ),
            ),
          ),
          Calendar()
        ],
      ),
    );
  }

  EdgeInsets getPadding(int index) {
    if (index == 0) {
      return EdgeInsets.only(left: 16.0);
    } else if (CalendarUtils().getWeeksInMonth(_focusedDay) == index + 1) {
      return EdgeInsets.only(left: 4, right: 16.0);
    }
    return EdgeInsets.only(left: 4);

  }

  void initRiverpod() {
    _calendarState = ref.watch(calendarProvider);
    _focusedDay = _calendarState.focusedDay;
    if (_calendarState.selectedDay != null) {
      _selectedDay = _calendarState.selectedDay;
    }
  }
}
