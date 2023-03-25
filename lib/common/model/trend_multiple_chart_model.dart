import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';

class TransactionTrendChartDataModel {
  String label = '';
  double amount;

  TransactionTrendChartDataModel({required this.amount});

  set setLabel(String changeValue) {
    label = changeValue;
  }

  static List<TransactionTrendChartDataModel> getChartData({
    required TransactionType type,
    required List<Transaction> transactions,
    required WidgetRef ref,
  }) {
    List<TransactionTrendChartDataModel> chartData = [];

    for (var transaction in transactions) {
     if (type == transaction.transactionType) {
        TransactionTrendChartDataModel _trendChartDataModel =
            TransactionTrendChartDataModel(amount: transaction.amount);
        String label = CustomDateUtils().getStringLabel(transaction.date, ref);
        _trendChartDataModel.setLabel = label;
        try {
          chartData.firstWhere((element) => element.label == label).amount +=
              transaction.amount;
        } catch (e) {
          chartData.add(_trendChartDataModel);
        }
      }
    }


    return chartData;
  }
}
