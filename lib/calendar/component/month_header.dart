import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/model/calendar_model.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/common/component/category_chart.dart';
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
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  late CalendarModel calendarModel;

  @override
  void didChangeDependencies() {
    calendarModel = ref.watch(calendarProvider);
    final transactionStream = ref
        .watch(transactionRepositoryProvider.notifier)
        .getThisMonthTransactions(calendarModel.focusedDay);
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

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    transactionSubscribtion.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(5)),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
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
