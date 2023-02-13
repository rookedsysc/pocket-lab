import 'package:intl/intl.dart';

class CustomNumberUtils {
  static String formatNumber(double number) {
    final formatter = NumberFormat("#,###");
    return formatter.format(number);
  }

  static String formatCurrency(double number) {
    final formatCurrency = NumberFormat.simpleCurrency();

    return formatCurrency.format(number);
  }

  // 문자열에서 숫자인 부분만 추출
  static String getNumberFromString(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }
}