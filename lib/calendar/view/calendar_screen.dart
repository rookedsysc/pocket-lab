import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/component/calendar.dart';
import 'package:pocket_lab/calendar/component/month_header.dart';
import 'package:pocket_lab/calendar/component/month_pickcer.dart';
import 'package:pocket_lab/calendar/component/week_header.dart';
import 'package:pocket_lab/calendar/utils/calendar_utils.dart';
import 'package:table_calendar/table_calendar.dart';

final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarModel>((ref) {
  return CalendarNotifier();
});

class CalendarNotifier extends StateNotifier<CalendarModel> {
  CalendarNotifier(): super(
    CalendarModel(
      focusedDay: DateTime.now(),
      selectedDay: null
    )
  );
}

class CalendarModel {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  CalendarModel({
    required this.focusedDay,
    this.selectedDay
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: ListView(
        children: [
          MonthPicker(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MonthHeader(),
          ),
          SizedBox(
            height: 75.0,
            child: ListView(
              //: 가로로 스크롤
              scrollDirection: Axis.horizontal,
              children: List.generate(
                  CalendarUtils().getWeeksInMonth(focusedDay),
                  (index) => WeekHeader(index: index,),),
            ),
          ),
          Calendar(onDaySelected: _onDaySelected(), onPageChanged: _onPageChanged(), focusedDay: focusedDay, selectedDay: selectedDay,)
        ],
      ),
    );
  }

  OnDaySelected _onDaySelected() {
    return (DateTime selectedDay, DateTime focusedDay) {
      setState(() {
        this.selectedDay = selectedDay;
        this.focusedDay = focusedDay;
      });
    };
  }

  void Function(DateTime focusedDay) _onPageChanged() {
    return ((focusedDay) {
      setState(() {
        this.focusedDay = focusedDay;
      });
    });
  }
}