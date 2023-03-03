import 'package:isar/isar.dart';

part 'trend_model.g.dart';

@collection
class Trend {
  Id id = Isar.autoIncrement;
  int walletId; 
  String walletName;
  double amount;
  DateTime date;

  Trend({
    this.walletName = "",
    required this.walletId,
    required this.amount,
    required this.date
  });
}