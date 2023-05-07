import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/calendar/utils/calendar_utils.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

class WeekHeader extends ConsumerWidget {
  final int index;
  const WeekHeader({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0),
      child: Container(
        height: 50.0,
        width: 125.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor),
        child: _weeksTransactionColumn(
            textTheme: Theme.of(context).textTheme, ref: ref),
      ),
    );
  }

  Widget _weeksTransactionColumn(
      {required TextTheme textTheme, required WidgetRef ref}) {
    final date = ref.watch(calendarProvider).focusedDay;
    double totalIncome = 0.0;
    double totalExpenditure = 0.0;
    CalendarWeekModel week =
        CalendarUtils().getEndOfWeekByMonth(date: date, index: index);

    return Stack(
      children: [
        _badge(textTheme),
        _amount(ref, week, textTheme, totalIncome, totalExpenditure),
      ],
    );
  }

  StreamBuilder<List<Transaction>> _amount(
      WidgetRef ref,
      CalendarWeekModel week,
      TextTheme textTheme,
      double totalIncome,
      double totalExpenditure) {
    return StreamBuilder<List<Transaction>>(
        stream: ref
            .watch(transactionRepositoryProvider.notifier)
            .getTransactionByPeriod(week.firstDayOfWeek, week.lastDayOfWeek),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return _isLoading(textTheme);
          }

          totalIncome = 0;
          totalExpenditure = 0;

          for (Transaction event in snapshot.data!) {
            if (event.transactionType == TransactionType.income) {
              totalIncome += event.amount;
            } else if (event.transactionType == TransactionType.expenditure) {
              totalExpenditure += event.amount;
            }
          }

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (totalIncome != 0)
                  Text(
                    '+${CustomNumberUtils.formatNumber(totalIncome)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 12),
                  ),
                if (totalExpenditure != 0)
                  Text(
                    "-${CustomNumberUtils.formatNumber(totalExpenditure)}",
                    style: TextStyle(color: Colors.red, fontSize: 12.0),
                  ),
              ],
            ),
          );
        });
  }

  Container _badge(TextTheme textTheme) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(_indexToWeek(),
            style: textTheme.bodyMedium!.copyWith(
                color: ColorUtils.getComplementaryColor(
                    textTheme.bodyLarge!.color!))),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: textTheme.bodyMedium!.color,
      ),
    );
  }

  Widget _isLoading(TextTheme textTheme) {
    return SizedBox();
  }

  String _indexToWeek() {
    if (index == 0)
      return 'week name.firstWeek'.tr();
    else if (index == 1)
      return 'week name.secondWeek'.tr();
    else if (index == 2)
      return 'week name.thirdWeek'.tr();
    else if (index == 3)
      return 'week name.fourthWeek'.tr();
    else if (index == 4)
      return 'week name.fifthWeek'.tr();
    else
      return 'week name.sixthWeek'.tr();
  }
}
