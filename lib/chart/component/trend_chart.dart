import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/component/trend_chart_series.dart';
import 'package:pocket_lab/home/model/trend_chart_data_model.dart';
import 'package:pocket_lab/home/model/trend_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrendChart extends ConsumerStatefulWidget {
  const TrendChart({super.key});

  @override
  ConsumerState<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends ConsumerState<TrendChart> {
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
        borderRadius: BorderRadius.circular(5),
      ),
      child: SfCartesianChart(
          primaryXAxis: _xAxis(
            trendMap: trendList,
          ),
          primaryYAxis: NumericAxis(
              //: Y축에 표시되는 값에 Format 적용
              numberFormat: NumberFormat.simpleCurrency()),

          ///# 스크롤 가능하게 설정
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
          ),
          tooltipBehavior: _tooltipBehavior,
          series: [
            ...List.generate(
              trendList.keys.length,
              (index) {
                int _indexKey = trendList.keys.toList()[index];
                return _seriesBySegmentType(
                    color: colorGenerate(index % 12),
                    walletId: _indexKey,
                    trends: trendList[_indexKey]!,
                    ref: ref);
              },
            ),
          ]),
    );
  }

  Container _chart(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: SfCartesianChart(
          primaryXAxis: _xAxis(
            trendMap: trendList,
          ),
          primaryYAxis: NumericAxis(
              //: Y축에 표시되는 값에 Format 적용
              numberFormat: NumberFormat.simpleCurrency()),

          ///# 스크롤 가능하게 설정
          zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
          ),
          tooltipBehavior: _tooltipBehavior,
          series: [
            ...List.generate(
              trendList.keys.length,
              (index) {
                int _indexKey = trendList.keys.toList()[index];
                return _seriesBySegmentType(
                    color: colorGenerate(index % 12),
                    walletId: _indexKey,
                    trends: trendList[_indexKey]!,
                    ref: ref);
              },
            ),
          ]),
    );
  }

  CategoryAxis _xAxis({required Map<int, List<Trend>> trendMap}) {
    double _maximum = 0;
    List<TrendChartDataModel> chartData = [];

    trendMap.forEach((key, value) {
      chartData = TrendChartDataModel.getChartData(ref: ref, trends: value);
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

  ///# 현재 선택한 segmentType에 따라 차트를 그림
  LineSeries _seriesBySegmentType(
      {required Color color,
      required int walletId,
      required List<Trend> trends,
      required WidgetRef ref}) {
    List<TrendChartDataModel> chartData = [];
    chartData = TrendChartDataModel.getChartData(ref: ref, trends: trends);

    return TrendChartSeries()
        .seriesBySegmentType(color: color, chartData: chartData);
  }

  Color colorGenerate(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.orange;
      case 6:
        return Colors.pink;
      case 7:
        return Colors.brown;
      case 8:
        return Colors.cyan;
      case 9:
        return Colors.indigo;
      case 10:
        return Colors.lime;
      case 11:
        return Colors.teal;
      default:
        return Colors.black;
    }
  }

  Future<void> fetchTrendList() async {
    trendList =
        await ref.read(trendRepositoryProvider.notifier).getAllTrendsAsMap();
    if (mounted) {
      setState(() {});
    }
  }
}
