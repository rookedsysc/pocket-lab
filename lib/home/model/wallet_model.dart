import 'package:isar/isar.dart';
import 'package:pocket_lab/home/component/home_screen/wallet_card.dart';

part 'wallet_model.g.dart';

@Collection()
class Wallet {
  Id id = Isar.autoIncrement;
  String imgAddr;
  String name;
  BudgetModel budget;
  ///: 잔고
  int balance;
  @Enumerated(EnumType.name)
  BudgetType budgetType;

  Wallet({
    this.imgAddr = "asset/img/bank/금융아이콘_PNG_카카오뱅크.png",
    this.budgetType = BudgetType.dontSet,
    required this.name,
    required this.budget,
    this.balance = 0,
  });

  @override
  String toString() {
    return "Wallet{id: $id, imgAddr: $imgAddr, name: $name, budgetType: $budgetType, balance: $balance}";
  }

  walletToWalletCard() {
    return WalletCard(
      imgAddr: imgAddr,
      name: name,
      balance: balance,
    );
  }
}

enum BudgetType {
  dontSet,
  perWeek,
  perMonth,
  perSpecificDate,
}

///: embedded annotation을 사용하면, 해당 클래스를 다른 클래스의 필드로 사용할 수 있다.
@embedded
class BudgetModel  {
  ///: 예산 타입이 특정 날짜일 경우, 그 날짜
  String? budgetDate;
  ///: 예산 타입이 주기적일 경우, 주기
  int? budgetPeriod;
  ///: 예산 금액
  int? amount;

  BudgetModel({
    this.budgetDate,
    this.budgetPeriod,
    this.amount,
  });
}
