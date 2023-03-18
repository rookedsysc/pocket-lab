import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/model/calendar_model.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/chart/component/category_chart.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

class MonthHeader extends ConsumerStatefulWidget {
  const MonthHeader({super.key});

  @override
  ConsumerState<MonthHeader> createState() => _MonthHeaderState();
}

class _MonthHeaderState extends ConsumerState<MonthHeader> {
  late StreamSubscription transactionSubscribtion;
  late Stream<List<Transaction>> transactionStream;
  late StreamSubscription dateStreamSubscription;
  late DateTime date;

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void didChangeDependencies() {
    final Stream<CalendarModel> dateStream =
        ref.watch(calendarProvider.notifier).stream;
    transactionStream = ref
        .watch(transactionRepositoryProvider.notifier)
        .getSelectMonthTransactions(ref.watch(calendarProvider).focusedDay);
    dateStreamSubscription = dateStream.listen((event) {
      debugPrint('date chage ${event.focusedDay}');
      transactionStream = ref
          .watch(transactionRepositoryProvider.notifier)
          .getSelectMonthTransactions(event.focusedDay);
      totalExpense = 0;
      totalIncome = 0;
      transactionSubscribtion = transactionStream.listen((events) {
        for (Transaction event in events) {
          if (event.transactionType == TransactionType.income) {
            totalIncome += event.amount;
          } else if (event.transactionType == TransactionType.expenditure) {
            totalExpense += event.amount;
          }
        }
      });
      if (mounted) {
        setState(() {});
      }
    });

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant MonthHeader oldWidget) {
    transactionStream = ref
        .watch(transactionRepositoryProvider.notifier)
        .getSelectMonthTransactions(ref.watch(calendarProvider).focusedDay);
    transactionSubscribtion = transactionStream.listen((events) {
      for (Transaction event in events) {
        if (event.transactionType == TransactionType.income) {
          totalIncome += event.amount;
        } else if (event.transactionType == TransactionType.expenditure) {
          totalExpense += event.amount;
        }
      }
      setState(() {});
    });
    debugPrint('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    transactionSubscribtion.cancel();
    dateStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (totalIncome != 0)
                  Text(
                    "+ ${CustomNumberUtils.formatCurrency(totalIncome)}",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                if (totalExpense != 0)
                  Text(
                    "- ${CustomNumberUtils.formatCurrency(totalExpense)}",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.red),
                  ),
              ],
            ),
          ),
          //: 카테고리별 간략한 통계
          Container(
            width: 100.0,
            height: 100.0,
            child: CategoryChart(isHome: false),
          ),
        ],
      ),
    );
  }
}
