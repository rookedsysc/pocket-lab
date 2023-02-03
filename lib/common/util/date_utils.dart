import 'package:intl/intl.dart';

abstract class AbstaractCustomDateUtils<T> {
  String dateToFyyyyMMdd(T date);
}

class StringDateUtils implements AbstaractCustomDateUtils<String> { 
  ///: Date / DateString을 yyyy-MM-dd 형식으로 변환
  String dateToFyyyyMMdd(String date) {
    return DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd').parse(date));
  }
}

class DateTimeDateUtils implements AbstaractCustomDateUtils<DateTime> {
  String dateToFyyyyMMdd(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}