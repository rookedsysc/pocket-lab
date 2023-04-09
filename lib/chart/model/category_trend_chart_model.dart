import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
part 'category_trend_chart_model.g.dart';

@collection
class CategoryTrendChartDataModel {
  Id id = Isar.autoIncrement;
  int categoryId;
  String categoryName;
  double amount;
  String label = '';
  DateTime date = DateTime.now();

  CategoryTrendChartDataModel({
    required this.categoryName,
    required this.categoryId,
    required this.date,
    this.amount = 0,
  });

  set setLabel(String changeValue) {
    label = changeValue;
  }

  set setDate(DateTime changeValue) {
    date = changeValue;
  }

  static List<CategoryTrendChartDataModel> getChartData({
    required List<Transaction> allTransactions,
    required List<Transaction> transactions,
    required WidgetRef ref,
  }) {
    List<CategoryTrendChartDataModel> chartData = [];

    //# 모든 트랜잭션 리스트에서 있는 날짜의 데이터가 없으면 0으로 채워줌
    for (Transaction transaction in allTransactions) {
      transaction = transactions.firstWhere(
          (element) =>
              CustomDateUtils().isSameDay(element.date, transaction.date),
          orElse: () {
        Transaction newTransaction = Transaction(
            transactionType: transactions.first.transactionType,
            categoryId: transactions.first.categoryId,
            amount: 0,
            date: transaction.date,
            title: "Test",
            walletId: transactions.first.walletId);
        transactions.add(newTransaction);
        return newTransaction;
      });
    }

    for (Transaction transaction in transactions) {
      String label = CustomDateUtils().getStringLabel(transaction.date, ref);
      String categoryName = '';

      Color color = Colors.blue;
      String _colorString;

      if (transaction.categoryId == null) {
        continue;
      } else {
        final categories = ref.read(categoryRepositoryProvider);

        try {
          _colorString = categories
              .firstWhere((element) => element.id == transaction.categoryId)
              .color;
          categoryName = categories
              .firstWhere((element) => element.id == transaction.categoryId)
              .name;
        } catch (e) {
          _colorString = categories.first.color;
          categoryName = categories.first.name;
        }

        color = ColorUtils.stringToColor(_colorString);
      }

      CategoryTrendChartDataModel singleData = CategoryTrendChartDataModel(
          amount: transaction.amount,
          categoryId: transaction.categoryId!,
          categoryName: categoryName, date: DateTime.now());
      singleData.setDate =
          CustomDateUtils().getFristDateBySegment(transaction.date, ref);
      singleData.setLabel = label;
      try {
        chartData.firstWhere((element) => element.label == label).amount +=
            transaction.amount;
      } catch (e) {
        chartData.add(singleData);
      }
    }

    chartData.sort((a, b) => a.date.compareTo(b.date));
    chartData = chartData.reversed.toList();
    return chartData;
  }
}
