import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/constant/chart_range_type.dart';
import 'package:pocket_lab/common/util/date_utils.dart';

final customDateFormatProvider = StateProvider<DateFormat>((ref) {
  switch (ref.watch(chartRangeProvider)) {
    //: 일별
    case ChartRangeType.daily:
      return DateFormat('yyyy-MM-dd');
    //: 주별
    case ChartRangeType.weekly:
      return DateToWeekDateFormat();
    //: 월별
    case ChartRangeType.monthly:
      return DateFormat('yyyy-MM');
    //: 분기별
    case ChartRangeType.quarterly:
      return QuarterDateFormat();
    //: 연간
    case ChartRangeType.yearly:
      return DateFormat('yyyy');
    default:
      return DateFormat('yyyy-MM-dd');
  }
});


class QuarterDateFormat extends DateFormat {
  QuarterDateFormat();

  @override
  String format(DateTime date) {
    final quarter = (date.month / 3).ceil();
    return '${date.year}Q$quarter';
  }
}

class DateToWeekDateFormat extends DateFormat {
  DateToWeekDateFormat();

  @override
  String format(DateTime date) {
    DateTime firstSunday = CustomDateUtils().findFirstSundayOfMonth(date);

    if (date.isBefore(firstSunday)) {
      firstSunday = CustomDateUtils()
          .findFirstSundayOfMonth(DateTime(date.year, date.month - 1, 1));
    }

    int weekOfMonth = 0;

    while (firstSunday.isBefore(date)) {
      firstSunday = firstSunday.add(Duration(days: 7));
      weekOfMonth++;
    }

    return '${CustomDateUtils().monthToEng(firstSunday.month)} ${CustomDateUtils().numberToOrdinal(weekOfMonth)}';
  }
}

