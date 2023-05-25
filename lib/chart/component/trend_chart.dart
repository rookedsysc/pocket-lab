import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/layout/trend_chart_layout.dart';
import 'package:pocket_lab/chart/utils/trend_chart_series.dart';
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
  Map<int, List<Trend>> _trendMap = {};

  @override
  void didChangeDependencies() {
    final futureTrends =
        ref.read(trendRepositoryProvider.notifier).getAllTrendsAsMap();
    futureTrends.then((value) {
      _trendMap = value;
      if (mounted) {
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TrendChartLayout(
      // onActualRangeChanged: _onActualRangeChanged(),
      seriesList: List.generate(
        _trendMap.keys.length,
        (index) {
          int _indexKey = _trendMap.keys.toList()[index];
          return _seriesBySegmentType(
              color: _colorGenerate(index % 12),
              walletId: _indexKey,
              trends: _trendMap[_indexKey]!,
              ref: ref);
        },
      ),
      xAxis: _xAxis(),
    );
  }

  // ignore: unused_element
  ChartActualRangeChangedCallback _onActualRangeChanged() {
    return (ActualRangeChangedArgs args) {
      args.visibleMin= _getMinimum().toInt();
      args.visibleMax= _getMaximum().toInt();
    };
  }

  double _getMinimum() {
    List<Trend> flattenedTrends = _trendMap.values.expand((x) => x).toList();

    if (flattenedTrends.isEmpty) {
      return 0;
    }

    double minAmount = flattenedTrends[0].amount;

    for (Trend trend in flattenedTrends) {
      if (trend.amount < minAmount) {
        minAmount = trend.amount;
      }
    }

    if (minAmount < 0) {
      minAmount = minAmount * 1.05;
    } else {
      minAmount = minAmount / 1.05;
    }

    return minAmount;
  }

    double _getMaximum() {
    List<Trend> flattenedTrends = _trendMap.values.expand((x) => x).toList();

    if (flattenedTrends.isEmpty) {
      return 10000;
    }

    double maxAmount = flattenedTrends[0].amount;

    for (Trend trend in flattenedTrends) {
      if (trend.amount > maxAmount) {
        maxAmount = trend.amount;
      }
    }

    if (maxAmount < 0) {
      maxAmount = maxAmount * 1.05;
    } else {
      maxAmount = maxAmount / 1.05;
    }

    return maxAmount;
  }



  ///# 현재 선택한 segmentType에 따라 차트를 그림
  LineSeries _seriesBySegmentType(
      {required Color color,
      required int walletId,
      required List<Trend> trends,
      required WidgetRef ref}) {
    List<TrendChartDataModel> chartData = [];
    chartData = TrendChartDataModel.getChartData(ref: ref, trends: trends);

    return TrendChartSeries().seriesBySegmentType(
        color: color,
        chartData: chartData,
        textStyle: Theme.of(context).textTheme.bodySmall!);
  }

  Color _colorGenerate(int index) {
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




  CategoryAxis _xAxis() {
    double _maximum = 0;
    List<TrendChartDataModel> chartData = [];

    _trendMap.forEach((key, value) {
      chartData = TrendChartDataModel.getChartData(ref: ref, trends: value);
      if (chartData.length > _maximum) {
        _maximum = chartData.length.toDouble() - 1;
      }
    });

    if (_maximum > 7) {
      _maximum = 7;
    }

    return CategoryAxis(
        isInversed: true,
        majorGridLines: MajorGridLines(width: 0),
        autoScrollingMode: AutoScrollingMode.end,
        visibleMaximum: _maximum,
        axisLine: AxisLine(
        width: 0),
        //: x축 간격
        interval: 1
        );
  }
}
