import 'package:isar/isar.dart';

part 'trend_model.g.dart';

@collection
class Trend {
  Id id = Isar.autoIncrement;
  int walletId; 
  double amount;
  DateTime date;

  Trend({
    required this.walletId,
    required this.amount,
    required this.date
  });
}