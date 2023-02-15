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
                    args.visibleMin = chartData.fold<HomeCardChartData>(HomeCardChartData(DateTime.now(), 0), (prev, next) => prev.y < next.y ? prev : next).y;
                  }
                },
                //: x축 안보이게 설정
                primaryXAxis: NumericAxis(
                    isVisible: false, rangePadding: ChartRangePadding.round),
                //: y축 안보이게 설정
                primaryYAxis: NumericAxis(
                    isVisible: false, rangePadding: ChartRangePadding.round),
                //: 기본 패딩 없앰
                margin: EdgeInsets.zero,
                //: 기본 테두리 안보이게 설정
                plotAreaBorderWidth: 0,
                enableSideBySideSeriesPlacement: false,
                series: <ChartSeries>[
                  SplineAreaSeries<HomeCardChartData, int>(
                      animationDuration: 0,
                      opacity: 0.75,
                      color: Theme.of(context).primaryColor,
                      dataSource: chartData,
                      xValueMapper: (HomeCardChartData data, _) => data.x.day,
                      yValueMapper: (HomeCardChartData data, _) => data.y),
                ]),
          );
        });
  }

  void _getChartData(List<Trend> trends) {
    chartData = <HomeCardChartData>[];

    if (trends.length == 1) {
      chartData.add(HomeCardChartData(
          trends[0].date.subtract(Duration(days: 1)), trends[0].amount));
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
