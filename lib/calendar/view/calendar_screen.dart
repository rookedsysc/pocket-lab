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

  void setSelectedDay(DateTime selectedDay) {
    state = CalendarModel(
      focusedDay: state.focusedDay,
      selectedDay: selectedDay
    );
  }

  void setFocusedDay(DateTime focusedDay) {
    state = CalendarModel(
      focusedDay: focusedDay,
      selectedDay: state.selectedDay
    );
  }
}

class CalendarModel {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  CalendarModel({
    required this.focusedDay,
    this.selectedDay
  });
}

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalendarModel _calendarState;

  void initRiverpod() {
    _calendarState = ref.watch(calendarProvider);
    _focusedDay = _calendarState.focusedDay;
    if (_calendarState.selectedDay != null) {
      _selectedDay = _calendarState.selectedDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    initRiverpod();

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
                  CalendarUtils().getWeeksInMonth(_focusedDay),
                  (index) => WeekHeader(index: index,),),
            ),
          ),
          Calendar()
        ],
      ),
    );
  }
}