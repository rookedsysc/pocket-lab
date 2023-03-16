import 'package:isar/isar.dart';

part 'category_model.g.dart';


@Collection()
class TransactionCategory {
  Id id = Isar.autoIncrement;
  String name;
  String color;

  TransactionCategory({
    required this.name,
    required this.color,
  });
}