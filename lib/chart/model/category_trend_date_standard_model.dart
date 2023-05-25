import 'package:isar/isar.dart';

part 'category_trend_date_standard_model.g.dart';

@collection
class CateogryTrendDateStandardModel{

  Id id = Isar.autoIncrement;
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();
}
