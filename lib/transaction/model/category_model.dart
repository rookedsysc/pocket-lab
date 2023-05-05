import 'package:isar/isar.dart';

part 'category_model.g.dart';

@Collection()
class TransactionCategory {
  Id id;
  String name;
  String color;
  int order;

  TransactionCategory({
    this.id = Isar.autoIncrement,
    required this.name,
    required this.color,
    this.order = 0,
  });
}