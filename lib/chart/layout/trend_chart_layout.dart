import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/home/model/trend_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrendChartLayout extends ConsumerStatefulWidget {
  final List<ChartSeries> seriesList;
  //: X축 간격
  final ChartAxis xAxis;
  final Legend? legend;
  final ChartActualRangeChangedCallback? onActualRangeChanged;
  TrendChartLayout(
      {this.onActualRangeChanged,this.legend,required this.xAxis, required this.seriesList, super.key});

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
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SfCartesianChart(
          onActualRangeChanged: widget.onActualRangeChanged,
          legend: widget.legend,
            primaryXAxis: widget.xAxis,
            primaryYAxis: NumericAxis(
              //: Y축에 표시되는 값에 Format 적용
              axisLine: AxisLine(width: 0),
              majorGridLines: MajorGridLines(width: 0.25, color: Colors.grey.shade200),
            ),
            
            ///# 스크롤 가능하게 설정
            zoomPanBehavior: ZoomPanBehavior(
              //: 가로로만 스크롤 가능함
              zoomMode: ZoomMode.x,
              enablePanning: true,
            ),
            tooltipBehavior: _tooltipBehavior,
            series: widget.seriesList),
      ),
    );
  }


}
