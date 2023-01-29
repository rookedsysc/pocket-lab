import 'package:intl/intl.dart';

class CustomDateUtils {
  ///: Date / DateString을 yyyy-MM-dd 형식으로 변환
  static String dateToFyyyyMMdd(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}