import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/model/trend_chart_data_model.dart';
import 'package:pocket_lab/home/model/trend_model.dart';

class QuarterlyChartModel extends TrendChartDataModel {
  String label = '';
  QuarterlyChartModel({
    required DateTime date,
    required double amount,
  }) : super(date, amount) {
    label = CustomDateUtils().dateToQuarter(date);
  }

  static List<QuarterlyChartModel> getChartData(
      List<Trend> trends /* db에서 꺼내온 데이터 */,
      List<QuarterlyChartModel> chartData /* 빈 차트 */) {
    Map<String, List<QuarterlyChartModel>> quarterlyMap = {};
    chartData = <QuarterlyChartModel>[];

    for (var trend in trends) {
      ///: 이미 해당 분기에 데이터가 있으면 해당 분기에 데이터를 추가
      try {
        quarterlyMap[CustomDateUtils().dateToQuarter(trend.date)]!
            .add(QuarterlyChartModel(date: trend.date, amount: trend.amount));
      } catch (e) {
        ///: 해당 분기에 데이터가 없으면 해당 분기에 데이터를 추가
        quarterlyMap[CustomDateUtils().dateToQuarter(trend.date)] = [
          QuarterlyChartModel(date: trend.date, amount: trend.amount)
        ];
      }
    }

    final keys = quarterlyMap.keys.toList();

    ///# 각 주별로 데이터를 합산해서 평균을 낸 값을 넣어줌
    for (String key in keys) {
      List<QuarterlyChartModel>? quarterlyChartModel = quarterlyMap[key];
      if (quarterlyChartModel != null) {
        double total = quarterlyChartModel.fold<double>(
            0, (prev, next) => prev + next.amount);
        double average = total / quarterlyChartModel.length;
        chartData.add(QuarterlyChartModel(
            date: quarterlyChartModel[0].date, amount: average));
      }
    }

    return chartData;
  }
}
