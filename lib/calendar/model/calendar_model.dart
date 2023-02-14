class CalendarModel {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  CalendarModel({
    required this.focusedDay,
    this.selectedDay
  });
}