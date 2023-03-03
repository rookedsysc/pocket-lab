import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/component/trend_chart.dart';
import 'package:pocket_lab/chart/utils/chart_type.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/model/trend_model.dart';

class TrendChartDataModel {
  String label = '';
  String name;
  DateTime date;
  double amount;
  TrendChartDataModel(this.name,this.date, this.amount);

  String get getLabel {
    return this.label;
  }

  set setLabel(String changeValue) {
    label = changeValue;
  }

  // copy with copyWith
  TrendChartDataModel copyWith({
    DateTime? date,
    double? amount,
  }) {
    return TrendChartDataModel(this.name, date ?? this.date, amount ?? this.amount);
  }

  static List<TrendChartDataModel> getChartData({
    required List<Trend> trends,
    required WidgetRef ref,
  }) {
    List<TrendChartDataModel> chartData = [];
    Map<String, List<TrendChartDataModel>> trendMap = {};

    //# 모든 데이터에서 동일한 기한 대로 묶이는 Data들을 Map 형태로 저장
    for (var trend in trends) {
      TrendChartDataModel _trendChartDataModel =
          TrendChartDataModel(trend.walletName, trend.date, trend.amount);
      _trendChartDataModel.setLabel = _getStringLabel(trend.date, ref);
      String label = _getStringLabel(trend.date, ref);
      if (trendMap.containsKey(label)) {
        trendMap[label]!.add(_trendChartDataModel);
      } else {
        trendMap[label] = [TrendChartDataModel(trend.walletName,trend.date, trend.amount)];
      }
    }

    //# 기한 별로 총 합의 평균값을 구해서 저장함
    final keys = trendMap.keys;
    for (var key in keys) {
      final List<TrendChartDataModel>? trendChartList = trendMap[key];
      if (trendChartList != null) {
        double amount = trendChartList.fold<double>(
            0, (previousValue, element) => element.amount + previousValue);
        double average = amount / trendChartList.length;
        TrendChartDataModel result =
            TrendChartDataModel(trendChartList.last.name,trendChartList.last.date, average);
        result.setLabel = _getStringLabel(trendChartList[0].date, ref);
        chartData.add(result);
      }
    }

    //: chartData 시간순으로 정렬
    chartData.sort((a, b) => a.date.compareTo(b.date));
    chartData = chartData.reversed.toList();

    return chartData;
  }

  static String _getStringLabel(DateTime date, WidgetRef ref) {
    switch (ref.watch(chartSegmentProvider)) {
      //: 일별
      case ChartSegmentType.daily:
        return CustomDateUtils().dateToFyyyyMMdd(date);
      //: 주별
      case ChartSegmentType.weekly:
        return CustomDateUtils().dateToWeek(date);
      //: 월별
      case ChartSegmentType.monthly:
        return CustomDateUtils().monthToEng(date.month);
      //: 분기별
      case ChartSegmentType.quarterly:
        return CustomDateUtils().dateToQuarter(date);
      //: 연간
      case ChartSegmentType.yearly:
        return "${date.year}";
      default:
        return CustomDateUtils().dateToFyyyyMMdd(date);
    }
  }
}
