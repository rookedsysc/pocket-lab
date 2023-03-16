import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';

part 'transaction_model.g.dart';

@Collection()
class Transaction {
  Id id = Isar.autoIncrement;
  //: 지출/수입/송금
  @Enumerated(EnumType.name)
  TransactionType transactionType;
  //: 지출 카테고리
  //: category ID
  int? categoryId;
  //: 지출/수입/송금 금액
  double amount;
  //: 지출/수입/송금 날짜
  DateTime date;
  //: 지출/수입/송금 제목
  String title;
  //: 지출/수입/송금 지갑
  int walletId;
  //: 송금 받는 지갑
  int? toWallet;

  Transaction({
    required this.transactionType,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.title,
    required this.walletId,
    this.toWallet,
  });
}
