import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/component/trend_chart.dart';
import 'package:pocket_lab/chart/constant/chart_range_type.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/model/trend_model.dart';

class TrendChartDataModel {
  String label = '';
  String name;
  DateTime date;
  double amount;
  TrendChartDataModel(this.name, this.date, this.amount);

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
    return TrendChartDataModel(
        this.name, date ?? this.date, amount ?? this.amount);
  }

  static List<TrendChartDataModel> getChartData({
    required List<Trend> trends,
    required WidgetRef ref,
    bool isHome = false,
  }) {
    List<TrendChartDataModel> chartData = [];
    Map<String, List<TrendChartDataModel>> trendMap = {};

    //# 모든 데이터에서 동일한 기한 대로 묶이는 Data들을 Map 형태로 저장
    for (var trend in trends) {
      TrendChartDataModel _trendChartDataModel =
          TrendChartDataModel(trend.walletName, trend.date, trend.amount);
      if (isHome) {
        ref.read(chartRangeProvider.notifier).state = ChartRangeType.daily;
      }
      _trendChartDataModel.setLabel =
          CustomDateUtils().getStringLabel(trend.date, ref);
      String label = CustomDateUtils().getStringLabel(trend.date, ref);
      if (trendMap.containsKey(label)) {
        trendMap[label]!.add(_trendChartDataModel);
      } else {
        trendMap[label] = [
          TrendChartDataModel(trend.walletName, trend.date, trend.amount)
        ];
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
        TrendChartDataModel result = TrendChartDataModel(
            trendChartList.last.name, trendChartList.last.date, average);
        result.setLabel =
            CustomDateUtils().getStringLabel(trendChartList[0].date, ref);
        chartData.add(result);
      }
    }

    //: chartData 시간순으로 정렬
    chartData.sort((a, b) => a.date.compareTo(b.date));
    chartData = chartData.reversed.toList();

    return chartData;
  }

  ///* 차트의 각 데이터의 차이를 List로 정렬해서 반환함
  static List<double> getDiffList({
    required List<TrendChartDataModel> chartData,
  }) {
    chartData.sort((a, b) => a.date.compareTo(b.date));
    List<double> diffList = [];
    for (int i = 0; i < chartData.length; i++) {
      if (i != 0) {
        double diff = 0;
        //: 빼야할 금액이 음수일 경우 -- 는 +연산이 되므로 더해줌
        if (chartData[i - 1].amount < 0) {
          diff = chartData[i].amount + chartData[i - 1].amount;
        } else {
          diff = chartData[i].amount - chartData[i - 1].amount;
        }

        diffList.add(diff);
      }
    }
    return diffList;
  }
}
