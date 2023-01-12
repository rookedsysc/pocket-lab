




class CalendarUtils {
  //: 한달의 총 주수 계산
  int getWeeksInMonth(DateTime date) {
    final DateTime firstDay = DateTime(date.year, date.month, 1);
    final DateTime lastDay = DateTime(date.year, date.month + 1, 0);
    //: 주의 첫 날이 일요일인 경우 0으로 계산
    final int firstWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday;
    //: 월 마지막 날의 그 주 토요일까지의 날짜 차이
    final int diffFromLastDayOfWeek = 6 - lastDay.weekday == -1 ? 6 : 6 - lastDay.weekday;
    final int daysInMonth = lastDay.day;

    //: 한 달에 6주 있는 경우도 계산이 됨
    int weeks = (daysInMonth + firstWeekday + diffFromLastDayOfWeek) ~/ 7;

    return weeks;
  }
  
  double getCalendarHeight(DateTime date) {
    final int weeks = getWeeksInMonth(date);
    return weeks * 100.0;
  }
}
