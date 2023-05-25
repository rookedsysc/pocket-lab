import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/component/month_pickcer.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/chart/view/time_heatmap_chart.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

class TimeHeatMapChartView extends ConsumerWidget {
  List<Transaction> transactions = [];
  TimeHeatMapChartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Transaction>>(
        stream: ref
            .watch(transactionRepositoryProvider.notifier)
            .getSelectMonthTransactions(ref.watch(calendarProvider).focusedDay),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          try {
            transactions = snapshot.data!
              ..map((e) => e.transactionType == TransactionType.expenditure)
                  .toList();
          } catch (e) {
            return Center(
              child: Text("No Data"),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MonthPicker(),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: TimeHeatmapChart(
                  transactions: transactions,
                ),
              ),
            ],
          );
        });
  }
}
