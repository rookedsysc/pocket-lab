import 'package:pocket_lab/home/model/trend_chart_data_model.dart';

class MonthlyChartModel extends TrendChartDataModel {
  MonthlyChartModel({
    required DateTime date,
    required double amount,
  }) : super(date, amount);
}