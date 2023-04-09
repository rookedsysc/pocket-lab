import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_lab/chart/constant/chart_range_type.dart';
import 'package:pocket_lab/chart/layout/trend_chart_layout.dart';
import 'package:pocket_lab/chart/model/category_trend_chart_model.dart';
import 'package:pocket_lab/chart/utils/category_trend_chart_series.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/custom_date_format.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryTrendChart extends ConsumerStatefulWidget {
  const CategoryTrendChart({super.key});

  @override
  ConsumerState<CategoryTrendChart> createState() => _CategoryTrendChartState();
}

class _CategoryTrendChartState extends ConsumerState<CategoryTrendChart> {
  //: 카테고리별 Transaction
  Map<int, List<Transaction>> _transactions = {};
  List<CategoryTrendChartDataModel> _chartModel = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<int, List<Transaction>>>(
        stream: ref
            .watch(transactionRepositoryProvider.notifier)
            .getTransactionsByCategory(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          _transactions.addAll(snapshot.data!);
          _makeDefaultChartModel();

          return TrendChartLayout(
              xAxis: _xAxis(),
              seriesList: List.generate(_transactions.keys.length, (index) {
                int _indexKey = _transactions.keys.toList()[index];
                List<TransactionCategory> _categories =
                    ref.watch(categoryRepositoryProvider);
                //# 현재 index의 Category
                TransactionCategory _currentCategory;
                try {
                  _currentCategory = _categories.firstWhere((element) =>
                      element.id == _transactions[_indexKey]?.first.categoryId);
                } catch (e) {
                  _currentCategory = _categories.first;
                }
                String _colorString = _currentCategory.color;

                Color _color = ColorUtils.stringToColor(_colorString);
                return CategoryTrendChartSeries().seriseBySegmentType(
                    isFirst: false,
                    color: _color,
                    chartData: CategoryTrendChartDataModel.getChartData(
                        allTransactions: _getAllTransactions(),
                        transactions: _transactions[_indexKey]!,
                        ref: ref));
              }));
        });
  }

  void _makeDefaultChartModel() {
    int _key;
    try {
      _key = _transactions.keys.reduce((value, element) {
            if (value > element) {
              return value;
            } else {
              return element;
            }
          }) +
          1;
    } catch (e) {
      return;
    }

    DateTime _lastDate = _getLastDate().subtract(Duration(days: 1));
    DateTime _firstDate = _getFirstDate().add(Duration(days: 1));

    while (_firstDate.isBefore(_lastDate)) {
      try {
        _transactions[_key]!.add(Transaction(
            transactionType: TransactionType.expenditure,
            categoryId: 1,
            amount: 0,
            date: _firstDate,
            title: '',
            walletId: 0));
      } catch (e) {
        _transactions[_key] = [
          Transaction(
              transactionType: TransactionType.expenditure,
              categoryId: 1,
              amount: 0,
              date: _firstDate,
              title: '',
              walletId: 0)
        ];
      }

      _firstDate = _firstDate.add(Duration(days: 1));
    }
    final List<List<Transaction>> _tmp = _transactions.values.toList();
    final List<int> _keys = _transactions.keys.toList();
    _transactions[_keys.first] = _tmp.last;
    _transactions[_keys.last] = _tmp.first;
  }

  DateTime _getFirstDate() {
    DateTime? _firstDate;

    for (int key in _transactions.keys) {
      List<Transaction> _list = _transactions[key]!;
      _firstDate = _list
          .reduce((value, element) =>
              value.date.isBefore(element.date) ? value : element)
          .date;
    }

    if (_firstDate == null) {
      _firstDate = DateTime.now();
    }

    return _firstDate;
  }

  DateTime _getLastDate() {
    DateTime? _lastDate;
    for (int key in _transactions.keys) {
      List<Transaction> _list = _transactions[key]!;
      _lastDate = _list
          .reduce((value, element) =>
              value.date.isAfter(element.date) ? value : element)
          .date;
    }

    if (_lastDate == null) {
      _lastDate = DateTime.now();
    }

    return _lastDate;
  }

  List<Transaction> _getAllTransactions() {
    List<Transaction> _allTransaction = [];

    for (List<Transaction> value in _transactions.values) {
      _allTransaction += value;
    }

    return _allTransaction;
  }

  CategoryAxis _xAxis() {
    double _maximum = 0;
    List<CategoryTrendChartDataModel> chartData = [];

    _transactions.forEach((key, value) {
      chartData = CategoryTrendChartDataModel.getChartData(
        ref: ref,
        allTransactions: _getAllTransactions(),
        transactions: _getAllTransactions(),
      );
      if (chartData.length > _maximum) {
        _maximum = chartData.length.toDouble() - 1;
      }
    });

    if (_maximum > 10) {
      _maximum = 10;
    }

    return CategoryAxis(
        isInversed: true,
        autoScrollingMode: AutoScrollingMode.end,
        visibleMaximum: _maximum,
        axisLine: AxisLine(width: 0),
        //: x축 간격
        interval: 1);
  }
}
