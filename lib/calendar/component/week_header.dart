import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/calendar/utils/calendar_utils.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
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
            borderRadius: BorderRadius.circular(10.0),
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
    CalendartWeekModel week =
        CalendarUtils().getEndOfWeek(date: date, index: index);

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

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _indexToWeek(),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (totalIncome != 0)
                Text(
                  '+${CustomNumberUtils.formatNumber(totalIncome)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              if (totalExpenditure != 0)
                Text(
                  "-${CustomNumberUtils.formatNumber(totalExpenditure)}",
                  style: TextStyle(color: Colors.red, fontSize: 12.0),
                ),
            ],
          );
        });
  }

  Center _isLoading(TextTheme textTheme) {
    return Center(
      child: Text(
        _indexToWeek(),
        style: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _indexToWeek() {
    if (index == 0)
      return '첫 번째 주';
    else if (index == 1)
      return '두 번째 주';
    else if (index == 2)
      return '세 번째 주';
    else if (index == 3)
      return '네 번째 주';
    else if (index == 4)
      return '다섯 번째 주';
    else
      return '여섯 번째 주';
  }
}
