import 'package:riverpod/riverpod.dart';

import '../model/calendar_model.dart';

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
      focusedDay: DateTime(selectedDay.year, selectedDay.month, 1),
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


