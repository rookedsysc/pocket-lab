import 'package:isar/isar.dart';
part 'category_trend_chart_model.g.dart';

@collection
@Collection(ignore: {"setLabel", "setDate"})
class CategoryTrendChartDataModel {
  Id id = Isar.autoIncrement;
  int categoryId;
  String categoryName;
  double amount;
  String label = '';
  DateTime date = DateTime.now();

  CategoryTrendChartDataModel({
    required this.categoryName,
    required this.categoryId,
    required this.date,
    required this.label,
    this.amount = 0,
  });

}
