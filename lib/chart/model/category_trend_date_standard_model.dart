import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/chart/model/category_trend_chart_model.dart';

part 'category_trend_date_standard_model.g.dart';

@collection
class CateogryTrendDateStandardModel{

  Id id = Isar.autoIncrement;
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now();
}
