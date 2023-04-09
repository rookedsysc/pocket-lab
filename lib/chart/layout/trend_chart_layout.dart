import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/home/model/trend_chart_data_model.dart';
import 'package:pocket_lab/home/model/trend_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrendChartLayout extends ConsumerStatefulWidget {
  final List<ChartSeries> seriesList;
  //: X축 간격
  final ChartAxis xAxis;
  TrendChartLayout(
      {required this.xAxis, required this.seriesList, super.key});

  @override
  ConsumerState<TrendChartLayout> createState() => _TrendChartLayoutState();
}

class _TrendChartLayoutState extends ConsumerState<TrendChartLayout> {
  Map<int, List<Trend>> trendList = {};
  late TooltipBehavior _tooltipBehavior;

  @override
  void didChangeDependencies() {
    final futureTrends =
        ref.read(trendRepositoryProvider.notifier).getAllTrendsAsMap();
    futureTrends.then((value) {
      trendList = value;
      if (mounted) {
        setState(() {});
      }
    });

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: null,

    );
    super.didChangeDependencies();
  }

  ///! Build 함수
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SfCartesianChart(
          primaryXAxis: widget.xAxis,
          primaryYAxis: NumericAxis(
              //: Y축에 표시되는 값에 Format 적용
              numberFormat: NumberFormat.simpleCurrency()),
          ///# 스크롤 가능하게 설정
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
          ),
          tooltipBehavior: _tooltipBehavior,
          series: widget.seriesList),
    );
  }


}
