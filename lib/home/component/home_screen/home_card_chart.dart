import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/home/model/trend_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeCardChart extends ConsumerStatefulWidget {
  final int walletId;
  const HomeCardChart({required this.walletId, super.key});

  @override
  ConsumerState<HomeCardChart> createState() => _HomeCardChartState();
}

class _HomeCardChartState extends ConsumerState<HomeCardChart> {
  List<HomeCardChartData> chartData = <HomeCardChartData>[];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trend>>(
        stream: ref
            .watch(trendRepositoryProvider.notifier)
            .getTrendStream(widget.walletId),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            _getChartData(snapshot.data!);
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SfCartesianChart(
              
                //: minimum 0으로 설정
                onActualRangeChanged: (ActualRangeChangedArgs args) {
                  if (args.axisName == 'primaryYAxis') {
                    //: chartData의 가장 최소값
                    // args.visibleMin = _getMinimumValue();

                    // //# 그래프의 최대 값을 최대 값보다 평균의 25% 높게 설정
                    if (chartData.length <= 5) {
                      double total = 0;
                      for (HomeCardChartData data in chartData) {
                        total += data.y;
                      }


                        args.visibleMax -= (total / chartData.length) * 0.3;
                    }
                  }
                },
                //# x축 설정
                primaryXAxis: _primaryXAxis(),
                    //# y축 설정
                primaryYAxis: _primaryYAxis(),
                //: 기본 패딩 없앰
                margin: EdgeInsets.zero,
                //: 기본 테두리 안보이게 설정
                plotAreaBorderWidth: 0,
                enableSideBySideSeriesPlacement: false,
                series: <ChartSeries>[
                  _splineAreaSeries(context),
                ]),
          );
        });
  }

  NumericAxis _primaryYAxis() {
    return NumericAxis(
              //: y축 안보이게 설정
                minimum: _getMinimumValue(),
                maximum: _getMaximumValue(),
                  isVisible: false,
                  rangePadding: ChartRangePadding.round);
  }

  NumericAxis _primaryXAxis() {
    return NumericAxis(
              //: x축 안보이게 설정
                  isVisible: false, rangePadding: ChartRangePadding.round);
  }

  SplineAreaSeries<HomeCardChartData, int> _splineAreaSeries(BuildContext context) {
    return SplineAreaSeries<HomeCardChartData, int>(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        borderColor: Theme.of(context).primaryColor,
        borderWidth: 4,
        animationDuration: 0,
        dataSource: chartData,
        xValueMapper: (HomeCardChartData data, _) => data.x.day,
        yValueMapper: (HomeCardChartData data, _) => data.y);
  }

  _getMaximumValue() {
    double? maximum;
    for (HomeCardChartData data in chartData) {
      if(maximum == null) {
        maximum = data.y;
      } else if (data.y > maximum) {
        maximum = data.y;
      }
    }
    
    if (chartData.length <= 5) {
      double total = 0;
      for (HomeCardChartData data in chartData) {
        total += data.y;
      }

      debugPrint(((total / chartData.length) * 0.3).toString());
      double avarage = total / chartData.length * 0.2;

      if(maximum == null) {
        debugPrint('maximum is null');
        maximum = 0;
      } else {
        debugPrint('maximum is $maximum');
      }

      if(total < 0) {
        maximum += avarage;
      } else {
        maximum += avarage;
      }
    }
    return maximum;
  }

  _getMinimumValue() {
    double minimum = 0;
    for (HomeCardChartData data in chartData) {
      if (data.y < minimum) {
        minimum = data.y;
      }
    }
    return minimum;
  }

  void _getChartData(List<Trend> trends) {
    chartData = <HomeCardChartData>[];

    if (trends.length == 1) {
      chartData.add(HomeCardChartData(
          trends[0].date.subtract(Duration(days: 2)),
          trends[0].amount - trends[0].amount * 0.1));
          chartData.add(
          HomeCardChartData(trends[0].date.subtract(Duration(days: 1)), 10000));
    }
    for (var trend in trends) {
      chartData.add(HomeCardChartData(trend.date, trend.amount));
    }
  }
}

class HomeCardChartData {
  HomeCardChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
