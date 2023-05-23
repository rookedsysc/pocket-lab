import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/home/model/trend_chart_data_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeCardChart extends ConsumerStatefulWidget {
  final int walletId;
  bool isHome;
  HomeCardChart({this.isHome = false, required this.walletId, super.key});

  @override
  ConsumerState<HomeCardChart> createState() => _HomeCardChartState();
}

class _HomeCardChartState extends ConsumerState<HomeCardChart> {
  List<TrendChartDataModel> chartData = <TrendChartDataModel>[];
  late Stream trendStream;
  late StreamSubscription trendStreamSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trendStream = ref
        .watch(trendRepositoryProvider.notifier)
        .getTrendStream(widget.walletId);
    trendStreamSubscription = trendStream.listen((event) {
      chartData = TrendChartDataModel.getChartData(
          isHome: widget.isHome, trends: event, ref: ref);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    trendStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SfCartesianChart(
          //# 그래프 가시 범위
          onActualRangeChanged: _onActualRangeChanged(),
          //# x축 설정
          primaryXAxis: _primaryXAxis(),
          //# y축 설정
          primaryYAxis: _primaryYAxis(),
          //: 기본 패딩 없앰
          margin: EdgeInsets.zero,
          //: 기본 테두리 안보이게 설정
          plotAreaBorderWidth: 0,
          enableSideBySideSeriesPlacement: false,
          series: <ChartSeries<TrendChartDataModel, DateTime>>[
            _splineAreaSeries(context),
          ]),
    );
  }

  ChartActualRangeChangedCallback _onActualRangeChanged() {
    return (ActualRangeChangedArgs args) {
      if (args.axisName == 'primaryYAxis') {
        // : chartData의 가장 최소값
        args.visibleMin = _getMinimumValue();

        ///# 최대값 구함
        double max;
        try {
          max = chartData[0].amount;
        } catch (e) {
          max = 0;
        }
        //: chartData의 가장 최대값
        for (TrendChartDataModel data in chartData) {
          if (data.amount < 0) {
            max = data.amount.abs() > max ? data.amount.abs() : max;
          } else {
            max = data.amount > max ? data.amount : max;
          }
        }
        args.visibleMax = max * 1.75;
      }
    };
  }

  NumericAxis _primaryYAxis() {
    return NumericAxis(
      minimum: _getMinimumValue(),
        isVisible: false,
        rangePadding: ChartRangePadding.round);
  }

  ChartAxis _primaryXAxis() {
    return DateTimeAxis(
      //: x축 안보이게 설정
      isVisible: false,
    );
  }

  SplineAreaSeries<TrendChartDataModel, DateTime> _splineAreaSeries(
      BuildContext context) {
    return SplineAreaSeries<TrendChartDataModel, DateTime>(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        borderColor: Theme.of(context).primaryColor,
        borderWidth: 4,
        animationDuration: 0,
        dataSource: chartData,
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.transparent],
          begin: Alignment.topCenter,
          stops: [0.0, 10.0],
          end: Alignment.bottomCenter,

        ),
        xValueMapper: (TrendChartDataModel data, _) => data.date,
        yValueMapper: (TrendChartDataModel data, _) => data.amount);
  }

  _getMinimumValue() {
    double minimum;
    try {
      minimum = chartData[0].amount;
    } catch (e) {
      minimum = 0;
    }

    for (TrendChartDataModel data in chartData) {
      if (data.amount < minimum) {
        minimum = data.amount;
      }
    }

    if(minimum > 0) {
      minimum = 0;
    } else {
      minimum = minimum * 2;
    }

    return minimum;
  }
}
