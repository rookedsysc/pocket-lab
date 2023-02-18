import 'package:pocket_lab/home/model/trend_model.dart';

class TrendChartDataModel {
  TrendChartDataModel(this.date, this.amount);
  final DateTime date;
  final double amount;

  copyWith({DateTime? date, double? amount}) {
    return TrendChartDataModel(date ?? this.date, amount ?? this.amount);
  }

  static List<TrendChartDataModel> getChartData(List<Trend> trends, List<TrendChartDataModel> chartData) {
    chartData = <TrendChartDataModel>[];

    if (trends.length == 1) {
      chartData.add(
          TrendChartDataModel(trends[0].date.subtract(Duration(days: 1)), 0));
    }
    for (var trend in trends) {
      chartData.add(TrendChartDataModel(trend.date, trend.amount));
    }

    return chartData;
  }
}
