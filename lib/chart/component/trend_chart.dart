import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: [
            ...List.generate(
              trendList.keys.length,
              (index) {
                int _indexKey = trendList.keys.toList()[index];
                return _trendSeries(
                    color: colorGenerate(index % 12),
                    walletId: _indexKey,
                    trends: trendList[_indexKey]!);
              },
            ),
          ]),
    );
  }

  LineSeries _trendSeries(
      {required Color color,
      required int walletId,
      required List<Trend> trends}) {
    List<TrendChartDataModel> chartData = _getChartData(trends);
    return 
      LineSeries<TrendChartDataModel, DateTime>(
          dataSource: chartData,
          color: color,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => data.amount);
      // LineSeries<TrendChartDataModel, DateTime>(
      //     dataLabelSettings: DataLabelSettings(
      //         isVisible: true,
      //         builder: (data, point, series, pointIndex, seriesIndex) {
      //           if (pointIndex == chartData.length - 1) {
      //             return Text(
      //               CustomDateUtils()
      //                   .dateToFyyyyMMdd(futureChartData[pointIndex].date),
      //               style: Theme.of(context).textTheme.bodyMedium,
      //             );
      //           }
      //           return SizedBox();
      //         }),
      //     dataLabelMapper: (_, index) => index + 1 == futureChartData.length
      //         ? CustomDateUtils().dateToFyyyyMMdd(futureChartData[index].date)
      //         : null,
      //     dataSource: futureChartData,
      //     color: Theme.of(context).primaryColor,
      //     xValueMapper: (data, _) => data.date,
      //     yValueMapper: (data, _) => data.amount)
    
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

  List<TrendChartDataModel> _getChartData(List<Trend> trends) {
    List<TrendChartDataModel> chartData = [];
    chartData = TrendChartDataModel.getChartData(trends, chartData);

    return chartData;
  }

  Future<void> fetchTrendList() async {
    trendList =
        await ref.read(trendRepositoryProvider.notifier).getAllTrendsAsMap();
    if (mounted) {
      setState(() {});
    }
  }
}
