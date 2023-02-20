import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
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
  late Stream expenditureStream;
  late StreamSubscription expenditureStreamSubscription;

  @override
  void didChangeDependencies() {
    //: home이면 지난 31일 기준으로 데이터 가져옴
    if (widget.isHome) {
      expenditureStream = ref
          .watch(transactionRepositoryProvider.notifier)
          .getLast30DaysExpenditure(null);
    }
    //: home이 아닌 calendar screen에서 호출되면
    //: focusedDay의 month를 기준으로 데이터 가져옴
    else {
      DateTime date = ref.watch(calendarProvider).focusedDay;
      expenditureStream = ref
          .watch(transactionRepositoryProvider.notifier)
          .getThisMonthExpenditure(date);
    }

    expenditureStreamSubscription = expenditureStream.listen((event) {
      _getChartData(event, ref);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    expenditureStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //: Chart Data가 없을 때
    if (chartDataIsCantVisible()) {
      return Container(
        child: Center(
          child: Text("no expend data".tr()),
        ),
      );
    }
    return SfCircularChart(
        //# 카테고리 목록
        legend: Legend(
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
            dataLabelMapper: !widget.isHome ? (data, _) =>
                "${CustomNumberUtils.formatCurrency(data.amount)}" : null,
          ),
        ]);
  }

  Future<void> _getChartData(
      List<Transaction> transactions, WidgetRef ref) async {
    chartData = [];
    for (final Transaction transaction in transactions) {
      if (transaction.category == null) continue;
      final TransactionCategory? transactionCategory = await ref
          .read(categoryRepositoryProvider.notifier)
          .getCategoryById(transaction.category!);
      if (transactionCategory == null) continue;

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
    if (mounted) {
      setState(() {});
    }
  }

  chartDataIsCantVisible() {
    return chartData.length == 0 ||
        chartData.every((element) => element.amount == 0);
  }
}
