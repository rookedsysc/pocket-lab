import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';

class CalendarUtils {
  ///# 한달의 총 주수 계산
  int getWeeksInMonth(DateTime date) {
    final DateTime firstDay = DateTime(date.year, date.month, 1);
    final DateTime lastDay = DateTime(date.year, date.month + 1, 0);
    //: weekDay는 월요일이 1이기 때문에 7일 중 하루가 비어있다는 것을 의미할 수도 있음
    //: 즉, 첫 주와 마지막주의 부족한 일 수 만큼 채워준 다음, 7로 나누면
    //: 해당 달이 몇 개의 주로 이루어져 있는지 알 수 있음k
    //: 주의 첫 날이 일요일인 경우 0으로 계산
    final int firstWeekday = firstDay.weekday == 7 ? 0 : firstDay.weekday;
    //: 월 마지막 날의 그 주 토요일까지의 날짜 차이
    final int diffFromLastDayOfWeek =
        6 - lastDay.weekday == -1 ? 6 : 6 - lastDay.weekday;
    final int daysInMonth = lastDay.day;

    //: 한 달에 6주 있는 경우도 계산이 됨
    int weeks = (daysInMonth + firstWeekday + diffFromLastDayOfWeek) ~/ 7;

    return weeks;
  }

  ///# 이번 주의 첫 날(일요일) 이번 주의 마지막 날(토요일) 계산
  CalendartWeekModel getEndOfWeek(
      {required DateTime date, required int index}) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    date = DateTime(date.year, date.month, 1);
    CalendartWeekModel weekModel = CalendartWeekModel(
        firstDayOfWeek: date,
        lastDayOfWeek: date.add(Duration(days: 6 - date.weekday)));
    int lastIndex = getWeeksInMonth(date);

    for (int week = 0; week < lastIndex; week++) {
      if (week == index) {
        ///# 첫 번째 주인 경우
        if (index == 0) {
          int _weekDay = date.weekday == 7 ? 0 : date.weekday;
          weekModel = CalendartWeekModel(
              firstDayOfWeek: date,
              lastDayOfWeek: date.add(Duration(days: 6 - _weekDay)));
          break;
        }

        ///# 첫 번째 주가 아닌 경우
        else {
          ///# 날짜가 다음 달로 넘어갔을 경우
          if (date.isAfter(nextMonth)) {
            final DateTime _lastDayOfWeek =
                DateTime(nextMonth.year, nextMonth.month, nextMonth.day - 1);
            weekModel = CalendartWeekModel(
                firstDayOfWeek: getFirstDayOfWeek(_lastDayOfWeek),
                lastDayOfWeek: _lastDayOfWeek);
          }

          ///# 날짜가 다음 달로 넘어가지 않았을 경우
          else {
            weekModel = CalendartWeekModel(
                firstDayOfWeek: getFirstDayOfWeek(date),
                lastDayOfWeek: getFirstDayOfWeek(date).add(Duration(days: 6)));
          }
          break;
        }
      }
      //: 다음주로 증가
      date = date.add(Duration(days: 7));
    } //: end of for loopk

    return weekModel;
  }

  ///# 주의 첫 날짜를 반환
  DateTime getFirstDayOfWeek(DateTime date) {
    while (date.weekday != 7) {
      date = date.subtract(Duration(days: 1));
    }
    return date;
  }

  double getCalendarHeight(DateTime date) {
    final int weeks = getWeeksInMonth(date);
    return weeks * 90.0;
  }

  ///# Type별 총 합을 반환
  double getTotalAmount(List<Transaction> list, TransactionType type) {
    double total = 0.0;
    for (Transaction event in list) {
      if (event.transactionType == type) {
        total += event.amount;
      }
    }
    return total;
  }
}

class CalendartWeekModel {
  final DateTime firstDayOfWeek;
  final DateTime lastDayOfWeek;

  CalendartWeekModel(
      {required this.firstDayOfWeek, required this.lastDayOfWeek});
}
