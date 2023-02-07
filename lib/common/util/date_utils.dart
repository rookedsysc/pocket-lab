import 'package:intl/intl.dart';

abstract class AbstaractCustomDateUtils<T> {
  String dateToFyyyyMMdd(T date);
}

class CustomDateUtils implements AbstaractCustomDateUtils<DateTime> { 
  ///: Date / Date를 yyyy-MM-dd 형식으로 변환
  String dateToFyyyyMMdd(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  //: String -> DateTime
  //! UTC 시간은 UTC 시간으로 변환함
  DateTime stringToDate(String date) {
    return DateTime.parse(date);
  }

  //: DateTime List에서 마지막 Date return 
  DateTime getLastDate(List<DateTime> dateTimes) {
    dateTimes.sort();
    return dateTimes.last;
  }

  //* 다음 budgetDate를 구함
  ///: 만약 선택한 날짜가 1월 31일 인데 다음달의 31일을 구하려 했으나
  ///: 2월 2일처럼 28일이 마지막인 경우 다음달의 마지막일로 변환
  DateTime getNextBugdetDate(DateTime date, int day) {
    DateTime _nextMonth = DateTime(date.year, date.month + 1, day);
    if(date.month + 1 != _nextMonth.month) {
      //: 0일은 이전 달의 마지막 일이 됨
      _nextMonth = DateTime(date.year, date.month + 1, 0);
    }

    return _nextMonth;
  }

  ///* 이전 날자인지(시간에 상관없이) 구해줌
  bool isBeforeDay(DateTime dateA, DateTime dateB) {
    dateA = DateTime(dateA.year, dateA.month, dateA.day);
    dateB = DateTime(dateB.year, dateB.month, dateB.day);
    return dateA.isBefore(dateB);
  }

  ///* 시간에 상관없이 일수만 가지고 차이 구해줌 
  /// dateA - dateB
  int diffDays(DateTime dateA, DateTime dateB) {
    if(dateA.isUtc || dateB.isUtc) {
      dateA = dateA.toLocal();
      dateB = dateB.toLocal();
    }
    dateA = DateTime(dateA.year, dateA.month, dateA.day);
    dateB = DateTime(dateB.year, dateB.month, dateB.day);
    return dateA.difference(dateB).inDays;
  }

}

class DateTimeDateUtils implements AbstaractCustomDateUtils<DateTime> {
  String dateToFyyyyMMdd(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime getLastDate(List<DateTime> date) {
    date.sort();
    return date.last;
  }
}