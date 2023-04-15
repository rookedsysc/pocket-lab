import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_lab/chart/constant/chart_range_type.dart';

class CustomDateUtils {
  ///* Date / String을 String yyyy-MM-dd 형식으로 변환
  String dateToFyyyyMMdd(dynamic date) {
    if (date is DateTime) {
      return DateFormat('yyyy-MM-dd').format(date);
    } else {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    }
  }

  //: String -> DateTime
  //! UTC 시간은 UTC 시간으로 변환함
  DateTime stringToDate(String date) {
    return DateTime.parse(date);
  }

  ///* DateTime List에서 마지막 Date return
  DateTime getLastDate(List<DateTime> dateTimes) {
    dateTimes.sort();
    return dateTimes.last;
  }

  ///* 년, 월, 일만 return 
  DateTime onlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  //* 다음 budgetDate를 구함
  ///: 만약 선택한 날짜가 1월 31일 인데 다음달의 31일을 구하려 했으나
  ///: 2월 2일처럼 28일이 마지막인 경우 다음달의 마지막일로 변환
  DateTime getNextBugdetDate(DateTime date, int day) {
    DateTime _nextMonth = DateTime(date.year, date.month + 1, day);
    if (date.month + 1 != _nextMonth.month) {
      //: 0일은 이전 달의 마지막 일이 됨
      _nextMonth = DateTime(date.year, date.month + 1, 0);
    }

    return _nextMonth;
  }

  ///* 이전 날짜인지(시간에 상관없이) 구해줌
  bool isBeforeDay(DateTime dateA, DateTime dateB) {
    dateA = DateTime(dateA.year, dateA.month, dateA.day);
    dateB = DateTime(dateB.year, dateB.month, dateB.day);
    return dateA.isBefore(dateB);
  }

  ///* 이전 날짜인지(시간에 상관없이) 구해줌
  bool isAfterDay(DateTime dateA, DateTime dateB) {
    dateA = DateTime(dateA.year, dateA.month, dateA.day);
    dateB = DateTime(dateB.year, dateB.month, dateB.day);
    return dateA.isAfter(dateB);
  }

  ///* 시간에 상관없이 일수만 가지고 차이 구해줌
  /// dateA - dateB
  int diffDays(DateTime dateA, DateTime dateB) {
    if (dateA.isUtc || dateB.isUtc) {
      dateA = dateA.toLocal();
      dateB = dateB.toLocal();
    }
    dateA = DateTime(dateA.year, dateA.month, dateA.day);
    dateB = DateTime(dateB.year, dateB.month, dateB.day);
    return dateA.difference(dateB).inDays;
  }

  ///* 시간에 상관없이 날짜만 비교해서 같은 날인지 비교해줌
  bool isSameDay(DateTime dateA, DateTime dateB) {
    if (dateA.isUtc || dateB.isUtc) {
      dateA = dateA.toLocal();
      dateB = dateB.toLocal();
    }
    dateA = DateTime(dateA.year, dateA.month, dateA.day);
    dateB = DateTime(dateB.year, dateB.month, dateB.day);
    return dateA == dateB;
  }

  ///* 해당 날짜가 몇 월 몇 번째 주인지 반환
  String dateToWeek(DateTime date) {
    DateTime firstSunday = findFirstSundayOfMonth(date);

    if (date.isBefore(firstSunday)) {
      firstSunday =
          findFirstSundayOfMonth(DateTime(date.year, date.month - 1, 1));
    }

    int weekOfMonth = 0;

    while (firstSunday.isBefore(date)) {
      firstSunday = firstSunday.add(Duration(days: 7));
      weekOfMonth++;
    }

    return '${monthToEng(firstSunday.month)} ${numberToOrdinal(weekOfMonth)}';
  }

  DateTime findFirstSundayOfWeek(DateTime date) {
    if (date.weekday != 7) {
      date = date.subtract(Duration(days: date.weekday));
    }
    return date;
  }

  ///* 시간 > 분기로 변환
  String dateToQuarter(DateTime date) {
    switch (date.month) {
      case 1:
      case 2:
      case 3:
        return '${date.year} 1st Quarter';
      case 4:
      case 5:
      case 6:
        return '${date.year} 2nd Quarter';
      case 7:
      case 8:
      case 9:
        return '${date.year} 3rd Quarter';
      case 10:
      case 11:
      case 12:
        return '${date.year} 4th Quarter';
      default:
        return '';
    }
  }

  ///* 해당 쿼터의 첫 번째 날을 Return
  DateTime dateToFirstQuarterDay(DateTime date) {
    switch (date.month) {
      case 1:
      case 2:
      case 3:
        return DateTime(date.year, 1, 1);
      case 4:
      case 5:
      case 6:
        return DateTime(date.year, 4, 1);
      case 7:
      case 8:
      case 9:
        return DateTime(date.year, 7, 1);
      case 10:
      case 11:
      case 12:
        return DateTime(date.year, 10, 1);
      default:
        return DateTime(date.year, 1, 1);
    }
  }

  ///* 입력받은 날짜의 첫 번째 일요일을 반환하는 함수
  DateTime findFirstSundayOfMonth(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

    if (firstDayOfMonth.weekday == DateTime.sunday) {
      return firstDayOfMonth;
    }

    //: 해당 월의 첫 번째 일요일을 찾음.
    DateTime firstSundayOfMonth =
        firstDayOfMonth.add(Duration(days: 7 - firstDayOfMonth.weekday));

    return firstSundayOfMonth;
  }

  ///* 숫자 > 기수로 변환
  String numberToOrdinal(int number) {
    if (number == 1) {
      return '1st';
    } else if (number == 2) {
      return '2nd';
    } else if (number == 3) {
      return '3rd';
    } else {
      return '${number}th';
    }
  }

  ///* 숫자 > 영어 '달'로 변환
  String monthToEng(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  String getStringLabel(DateTime date, WidgetRef ref) {
    switch (ref.watch(chartRangeProvider)) {
      //: 일별
      case ChartRangeType.daily:
        return CustomDateUtils().dateToFyyyyMMdd(date);
      //: 주별
      case ChartRangeType.weekly:
        return CustomDateUtils().dateToWeek(date);
      //: 월별
      case ChartRangeType.monthly:
        return CustomDateUtils().monthToEng(date.month);
      //: 분기별
      case ChartRangeType.quarterly:
        return CustomDateUtils().dateToQuarter(date);
      //: 연간
      case ChartRangeType.yearly:
        return "${date.year}";
      default:
        return CustomDateUtils().dateToFyyyyMMdd(date);
    }
  }

  ///* 세그먼트의 타입에 따라서 첫 번째 날짜를 반환
  DateTime getFristDateBySegment(DateTime date, WidgetRef ref) {
    switch (ref.watch(chartRangeProvider)) {
      //: 일별
      case ChartRangeType.daily:
        return date;
      //: 주별
      case ChartRangeType.weekly:
        return CustomDateUtils().findFirstSundayOfWeek(date);
      //: 월별
      case ChartRangeType.monthly:
        return DateTime(date.year, date.month, 1);
      //: 분기별
      case ChartRangeType.quarterly:
        return CustomDateUtils().dateToFirstQuarterDay(date);
      //: 연간
      case ChartRangeType.yearly:
        return DateTime(date.year, 1, 1);
      default:
        return date;
    }
  }
}

class DateTimeDateUtils {
  String dateToFyyyyMMdd(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  DateTime getLastDate(List<DateTime> date) {
    date.sort();
    return date.last;
  }
}
