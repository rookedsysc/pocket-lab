import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/diary/view/test_screen.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              _createRandomTrend(ref);
            },
            child: Text("Create Random Trend")),
        ElevatedButton(
            onPressed: () {
              _createRandomTransaction(ref);
            },
            child: Text("Create Random Transaction")),
        ElevatedButton(
            onPressed: () {
              _deleteAllTransaction(ref);
            },
            child: Text("Delete All Transaction")),
                    ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return TestScreen();
                  },
                ),
              );
            },
            child: Text("Text Form Field Test Screen")),

      ],
    );
  }

  Future<void> _createRandomTrend(WidgetRef ref) async {
    await ref.read(trendRepositoryProvider.notifier).createRandomTrend();
  }

  Future<void> _createRandomTransaction(WidgetRef ref) async {
    await ref
        .read(transactionRepositoryProvider.notifier)
        .createRandomTransaction();
  }

  Future<void> _deleteAllTransaction(WidgetRef ref) async {
    await ref
        .read(transactionRepositoryProvider.notifier)
        .deleteAllTransactions();
  }
}
