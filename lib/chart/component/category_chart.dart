import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/common/component/custom_skeletone.dart';
import 'package:pocket_lab/common/model/category_chart_data_model.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryChart extends ConsumerStatefulWidget {
  final bool isHome;
  DateTime? date;
  CategoryChart({required this.isHome, this.date, super.key});

  @override
  ConsumerState<CategoryChart> createState() => _CategoryChartState();
}

class _CategoryChartState extends ConsumerState<CategoryChart> {
  List<CategoryChartData> chartData = [];

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    //: Chart Data가 없을 때
    return StreamBuilder<List<Transaction>>(
      stream:ref.watch(transactionRepositoryProvider.notifier).getSelectMonthExpenditure(ref.watch(calendarProvider).focusedDay),
      builder: (context, snapshot) {

        if(snapshot.data == null) {
          return _chartSkeleton(width: _width);
        }

        _getChartData(snapshot.data!, ref);

        if(chartDataIsCantVisible()) {
          return _chartSkeleton(width: _width);
        }

        return SfCircularChart(
            //# 카테고리 목록
            legend: Legend(
              textStyle: Theme.of(context).textTheme.bodySmall,
                overflowMode: LegendItemOverflowMode.wrap,
                isVisible: widget.isHome,
                position: LegendPosition.bottom),
            series: <CircularSeries>[
              // Renders doughnut chart
              DoughnutSeries<CategoryChartData, String>(
                dataSource: chartData,
                pointColorMapper: (CategoryChartData data, _) => data.color,
                xValueMapper: (CategoryChartData data, _) => data.name,
                yValueMapper: (CategoryChartData data, _) => data.amount,
    
                //# 라벨 설정
                dataLabelSettings: widget.isHome ? DataLabelSettings(
                    // overflowMode: OverflowMode.trim,
                    // labelPosition: ChartDataLabelPosition.outside,
                    isVisible: true,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.bold)) : null,
                dataLabelMapper: widget.isHome ? (data, _) =>
                    "${CustomNumberUtils.formatCurrency(data.amount)}" : null,
              ),
            ]);
      }
    );
  }

  Widget _chartSkeleton({double? width}) {
    return CustomSkeletone().circle(width: width, height: width);
  }

  void _getChartData(
      List<Transaction> transactions, WidgetRef ref) {
    chartData = [];
    for (final Transaction transaction in transactions) {
      TransactionCategory transactionCategory;
      if (transaction.categoryId == null) continue;
      try {
              transactionCategory = ref
          .read(categoryRepositoryProvider).firstWhere((element) =>
              element.id == transaction.categoryId);
      } catch (e) {
        continue;
      }


      ///# chartData에 해당 카테고리의 값이 이미 있는 경우
      try {
        chartData
            .firstWhere((element) => element.name == transactionCategory.name)
            .amount += transaction.amount;
      }

      ///# chartData에 해당 카테고리의 값이 없는 경우(최초 입력)
      catch (e) {
        chartData.add(CategoryChartData(
            transactionCategory.name,
            transaction.amount,
            ColorUtils.stringToColor(transactionCategory.color)));
      }
    }
  }

  bool chartDataIsCantVisible() {
    return chartData.length == 0 || chartData.every((element) => element.amount == 0);
  }
}