import 'package:isar/isar.dart';

@Collection()
class WalletModel {
  Id id = Isar.autoIncrement;

  final String name;

  final BudgetModel budget;
  //: 잔고
  int balance;

  WalletModel({
    required this.name,
    required this.budget,
    this.balance = 0,
});
}

enum BudgetType {
  perWeek,
  perMonth,
  perSpecificDate,
  dontSet
}

//: embedded annotation을 사용하면, 해당 클래스를 다른 클래스의 필드로 사용할 수 있다.
@embedded
class BudgetModel {
  //: 예산 타입
  @Enumerated(EnumType.name)
  BudgetType? budgetType;
  //: 예산 타입이 특정 날짜일 경우, 그 날짜
  String? budgetDate;
  //: 예산 타입이 주기적일 경우, 주기
  int? budgetPeriod;
  //: 예산 금액
  int? amount;

  BudgetModel({
    this.budgetType,
    this.budgetDate,
    this.budgetPeriod,
    this.amount,
  });
}
