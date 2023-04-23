import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
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
