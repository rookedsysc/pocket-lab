import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/calendar/component/calendar.dart';
import 'package:pocket_lab/calendar/component/month_header.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({super.key});

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MonthHeader(),
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
