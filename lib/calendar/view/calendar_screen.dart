import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/calendar/component/calendar.dart';
import 'package:pocket_lab/calendar/component/month_header.dart';
import 'package:pocket_lab/calendar/component/month_pickcer.dart';
import 'package:pocket_lab/calendar/layout/week_header_layout.dart';
import 'package:pocket_lab/calendar/model/calendar_model.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';

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
    _focusedDay = ref.watch(calendarProvider).focusedDay;

    return Material(
      child: CupertinoScaffold(
        body: Scaffold(
          body:  SafeArea(
              top: true,
              child: ListView(
                children: [
                  MonthPicker(),
                  MonthHeader(),
                  WeekHeaderLayOut(focusedDay: _focusedDay),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Calendar(),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }

  void initRiverpod() {
    _calendarState = ref.watch(calendarProvider);
    _focusedDay = _calendarState.focusedDay;
    if (_calendarState.selectedDay != null) {
      _selectedDay = _calendarState.selectedDay;
    }
  }
}
