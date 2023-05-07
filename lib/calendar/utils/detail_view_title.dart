import 'package:easy_localization/easy_localization.dart';

abstract class DetailViewTitle {
  String get(DateTime date);
}

class MonthDetailTitle implements DetailViewTitle {
  @override
  String get(DateTime date) {
      DateTime date = DateTime(2023, 3);
  String formattedDate = DateFormat('yyyy-03').format(date);
  String result = '$formattedDate Transactions';
    return result;
  }
}
