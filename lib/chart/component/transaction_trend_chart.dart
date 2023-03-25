import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/component/transaction_trend_chart_series.dart';
import 'package:pocket_lab/chart/layout/trend_chart_layout.dart';
import 'package:pocket_lab/common/model/trend_multiple_chart_model.dart';
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
                  chartData: _expenseData),
              TransactionTrendChartSeries().columnSeriesBySegmentType(
                  seriesName: "Income",
                  color: Colors.green,
                  chartData: _incomeData),
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
  }

  CategoryAxis _categoryAxis() {
    double _maximum = 0;

    _maximum = _incomeData.length > _expenseData.length
        ? _incomeData.length.toDouble()
        : _expenseData.length.toDouble();

    if (_maximum > 10) {
      _maximum = 10;
    } else {
      _maximum = _maximum - 1;
    }



    return CategoryAxis(
        autoScrollingMode: AutoScrollingMode.end,
        visibleMaximum: _maximum,
        axisLine: AxisLine(width: 0),
        //: x축 간격
        interval: 1,
        isInversed: false);
  }
}
