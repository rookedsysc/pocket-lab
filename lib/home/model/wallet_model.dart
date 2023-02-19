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
  double balance;
  @Enumerated(EnumType.name)
  BudgetType budgetType;
  ///: 선택되었는지 여부  
  bool isSelected;

  Wallet({
    this.imgAddr = "asset/img/bank/금융아이콘_PNG_토스.png",
    this.budgetType = BudgetType.dontSet,
    this.isSelected = false,
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
      walletId: id,
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
  ///: 실제로 예산을 입력 받을 특정한 일자
  DateTime? budgetDate;
  ///: orginDate가 1월 31일일 경우 
  ///: 2월달에는 31일이 없기 때문에 
  ///: StringDateUtils().getLastDate 함수를 사용하여 데이터를 가져올 경우
  ///: 2월 28일이나 2월 29일이 될 수 있음.
  ///: 2월 28일 이후에 또 다음달 예산을 받아올 때 다음달은 3월 31일이 될 수 있도록 
  ///: originDate와 budgetDate를 따로 두어서 사용함.
  int? originDay;
  ///: 예산 타입이 주기적일 경우, 주기
  int? budgetPeriod;
  ///: 남은 예산 금액
  double? balance;
  ///: 원래 담고 있던 예산 금액
  double? originBalance;

  BudgetModel({
    this.budgetDate,
    this.budgetPeriod,
    this.balance,
  });
}
