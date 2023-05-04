import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/component/trend_chart.dart';
import 'package:pocket_lab/common/component/custom_skeletone.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/model/trend_chart_data_model.dart';
import 'package:pocket_lab/home/model/trend_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../home/model/wallet_model.dart';

class GoalChart extends ConsumerStatefulWidget {
  final double goalAmount;
  const GoalChart({required this.goalAmount, super.key});

  @override
  ConsumerState<GoalChart> createState() => _GoalChartState();
}

class _GoalChartState extends ConsumerState<GoalChart> {
  List<TrendChartDataModel> chartData = [];
  List<TrendChartDataModel> futureChartData = [];
  bool _chartDataLoading = true;
  double totalBalance = 0;
  double average = 0;
  int futureDays = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getChartData().then((value) {
      _chartDataLoading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_chartDataLoading || chartData.length == 0) {
      return _loading();
    }

    ///# 지금 당장 구매가 가능한 경우
    if (totalBalance >= widget.goalAmount) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('can buy'.tr()),
      );
    }

    ///# 목표 예상 달성일이 예측 불가능할 경우
    if (futureDays < 1) {
      return unpredictability();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          ///: 남을 일 수
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'remain day'.tr(args: [futureDays.toString()]),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Text(
              "+${CustomNumberUtils.formatCurrency(average)}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        SfCartesianChart(
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries>[
            ///# Trend 그래프
            LineSeries<TrendChartDataModel, DateTime>(
                dataSource: chartData,
                color: Colors.blue,
                xValueMapper: (data, _) => data.date,
                yValueMapper: (data, _) => data.amount),
            LineSeries<TrendChartDataModel, DateTime>(
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    builder: (data, point, series, pointIndex, seriesIndex) {
                      if (pointIndex == futureChartData.length - 1) {
                        return Text(
                          CustomDateUtils().dateToFyyyyMMdd(
                              futureChartData[pointIndex].date),
                          style: Theme.of(context).textTheme.bodyMedium,
                        );
                      }
                      return SizedBox();
                    }),
                dataLabelMapper: (_, index) =>
                    index + 1 == futureChartData.length
                        ? CustomDateUtils()
                            .dateToFyyyyMMdd(futureChartData[index].date)
                        : null,
                dashArray: <double>[5, 10],
                dataSource: futureChartData,
                color: Theme.of(context).primaryColor,
                xValueMapper: (data, _) => data.date,
                yValueMapper: (data, _) => data.amount)
          ],
        ),
      ],
    );
  }

  Column unpredictability() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'asset grownth nagative mention'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        CustomSkeletone().square(width: null, height: 164),
      ],
    );
  }

  Center _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  ///* chartData 가져오기
  Future<void> _getChartData() async {
    final List<Trend> _trends =
        await ref.read(trendRepositoryProvider.notifier).getTotalTrends();
    chartData = TrendChartDataModel.getChartData(ref:ref, trends: _trends);

    ///: 현재 전체 지갑의 잔액 총 합
    final List<Wallet> wallets =
        await ref.read(walletRepositoryProvider.notifier).getAllWalletsFuture();
    wallets.map((e) => totalBalance += e.balance).toList();

    _getFutureChartData(totalBalance);

    if (mounted) {
      setState(() {});
    }
  }

  ///* 목표 도달까지 걸릴 일 수를 return 해주고
  ///* futureChartData에 미래 데이터를 추가해줌
  int _getFutureChartData(double totalBalance) {
    List<double> diffList = TrendChartDataModel.getDiffList(chartData: chartData);

    average = (diffList.fold<double>(0, (prev, next) => prev + next)) /
        diffList.length;

    debugPrint("average : $average");

    if (average < 0) {
      return 0;
    }

    while (widget.goalAmount > totalBalance) {
      futureDays++;

      ///: 미래 데이터가 첫 날이라면 chartData의 마지막 데이터를 복사해서 추가
      ///: 아니라면 futureChartData의 마지막 데이터를 복사해서 추가
      if (futureChartData.isEmpty) {
        ///: 첫 날 데이터
        futureChartData
            .add(TrendChartDataModel(chartData.last.name,chartData.last.date, totalBalance));

        ///: 두 번째 날 데이터
        totalBalance += average;
        TrendChartDataModel nextDateData = chartData.last.copyWith(
            amount: totalBalance,
            date: chartData.last.date.add(Duration(days: 1)));
        futureChartData.add(nextDateData);
      } else {
        TrendChartDataModel data = futureChartData.last.copyWith(
            amount: totalBalance,
            date: futureChartData.last.date.add(Duration(days: 1)));
        futureChartData.add(data);
      }
      totalBalance += average;
    }
    return futureDays;
  }
}
