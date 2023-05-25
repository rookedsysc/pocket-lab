import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/component/transaction_trend_chart_series.dart';
import 'package:pocket_lab/chart/layout/trend_chart_layout.dart';
import 'package:pocket_lab/chart/model/transaction_trend_chart_data_model.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionTrendChart extends ConsumerStatefulWidget {
  const TransactionTrendChart({super.key});

  @override
  ConsumerState<TransactionTrendChart> createState() =>
      _TransactionTrendChartState();
}

class _TransactionTrendChartState extends ConsumerState<TransactionTrendChart> {
  List<TransactionTrendChartDataModel> _incomeData = [];
  List<TransactionTrendChartDataModel> _expenseData = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
        future: ref
            .watch(transactionRepositoryProvider.notifier)
            .getAllTransactions(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          _fetchData(snapshot.data!);

          return TrendChartLayout(
            seriesList: [
              TransactionTrendChartSeries().columnSeriesBySegmentType(
                  seriesName: "Expense",
                  color: Colors.red,
                  chartData: _expenseData,
                  textStyle: Theme.of(context).textTheme.bodySmall!),
              TransactionTrendChartSeries().columnSeriesBySegmentType(
                  seriesName: "Income",
                  color: Colors.green,
                  chartData: _incomeData,
                  textStyle: Theme.of(context).textTheme.bodySmall!),
            ],
            xAxis: _categoryAxis(),
          );
        });
  }

  void _fetchData(List<Transaction> data) {
    _incomeData = TransactionTrendChartDataModel.getChartData(
        type: TransactionType.income, transactions: data, ref: ref);
    _expenseData = TransactionTrendChartDataModel.getChartData(
        type: TransactionType.expenditure, transactions: data, ref: ref);

    //: _income 데이터가 있는 날 중 _expense 데이터가 없는 날에 대해서
    //: _expnese 데이터를 동일한 label, date에 amount는 0으로 지정해서 넣어줌
    for (final model in _incomeData) {
      TransactionTrendChartDataModel? temp;
      try {
        temp =
            _expenseData.firstWhere((element) => element.label == model.label);
      } catch (e) {}
      if (temp == null) {
        temp = TransactionTrendChartDataModel(amount: 0, date: model.date);
        temp.setLabel = CustomDateUtils().getStringLabel(date: model.date, ref: ref);
        _expenseData.add(temp);
      }
    }
    //: 위의 반복문을 반대로 작업
    for (final model in _expenseData) {
      TransactionTrendChartDataModel? temp;
      try {
        temp =
            _incomeData.firstWhere((element) => element.label == model.label);
      } catch (e) {}
      if (temp == null) {
        temp = TransactionTrendChartDataModel(amount: 0, date: model.date);
        temp.setLabel = CustomDateUtils().getStringLabel(date: model.date, ref: ref);
        _incomeData.add(temp);
      }
    }

    _incomeData.sort((a, b) => a.date.compareTo(b.date));
    _incomeData = _incomeData.reversed.toList();
    _expenseData.sort((a, b) => a.date.compareTo(b.date));
    _expenseData = _expenseData.reversed.toList();
  }

  CategoryAxis _categoryAxis() {
    double _maximum = 0;

    _maximum = _incomeData.length > _expenseData.length
        ? _incomeData.length.toDouble()
        : _expenseData.length.toDouble();

    if (_maximum > 7) {
      _maximum = 7;
    } else {
      _maximum = _maximum - 1;
    }

    return CategoryAxis(
        autoScrollingMode: AutoScrollingMode.end,
        visibleMaximum: _maximum,
        axisLine: AxisLine(width: 0),
        majorGridLines: MajorGridLines(width: 0),
        //: x축 간격
        interval: 1,
        isInversed: true);
  }
}
