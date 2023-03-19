import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/common/constant/daily_budget.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';

final transactionRepositoryProvider =
    StateNotifierProvider<TransactionRepositoryNotifier, Transaction>((ref) {
  return TransactionRepositoryNotifier(ref);
});

class TransactionRepositoryNotifier extends StateNotifier<Transaction> {
  final Ref ref;
  TransactionRepositoryNotifier(this.ref)
      : super(Transaction(
            transactionType: TransactionType.expenditure,
            categoryId: 0,
            amount: 0,
            date: DateTime.now(),
            title: "",
            walletId: 0));

  //# Transaction 추가
  Future<void> configTransaction(Transaction transaction) async {
    state = transaction;
    final Isar isar = await ref.read(isarProvieder.future);

    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }

  ///# 최근 한 달 지출 Stream으로 가져오기
  Stream<List<Transaction>> getLast30DaysExpenditure(int? walletId) async* {
    final Isar isar = await ref.read(isarProvieder.future);

    //: 특정 wallet을 지정해주면 해당 id의 지출만 가져오기
    if (walletId != null) {
      yield* isar.transactions
          .filter()
          .walletIdEqualTo(walletId)
          .transactionTypeEqualTo(TransactionType.expenditure)
          .dateGreaterThan(DateTime.now().subtract(Duration(days: 31)))
          .watch(fireImmediately: true)
          .asBroadcastStream();
    }

    yield* isar.transactions
        .filter()
        .transactionTypeEqualTo(TransactionType.expenditure)
        .dateGreaterThan(DateTime.now().subtract(Duration(days: 31)))
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  ///# 해당 월 지출 Stream으로 가져오기
  Stream<List<Transaction>> getSelectMonthExpenditure(DateTime date) async* {
    final Isar isar = await ref.read(isarProvieder.future);
    //: 카테고리 ID를 통해서 Category Name, Color 가져옴
    //: 그전에 DB와 Local Cache간의 데이터 동기화 
    await ref.read(categoryRepositoryProvider.notifier).syncCategoryCache(); 

    yield* isar.transactions
        .filter()
        .transactionTypeEqualTo(TransactionType.expenditure)
        .dateGreaterThan(DateTime(date.year, date.month, 1))
        .dateLessThan(DateTime(date.year, date.month + 1, 1))
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  ///# 해당 월 Transaction Stream으로 가져오기
  Stream<List<Transaction>> getSelectMonthTransactions(DateTime date) async* {
    final Isar isar = await ref.read(isarProvieder.future);

    yield* isar.transactions
        .filter()
        .dateGreaterThan(DateTime(date.year, date.month, 1))
        .dateLessThan(DateTime(date.year, date.month + 1, 1))
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  ///# 특정 기간의 거래내역 Stream으로 가져오기
  ///: startDate(포함) ~ endDate(포함)
  Stream<List<Transaction>> getTransactionByPeriod(
      DateTime startDate, DateTime endDate) async* {
    final Isar isar = await ref.read(isarProvieder.future);

    startDate = DateTime(startDate.year, startDate.month, startDate.day - 1, 23,
        59, 59, 999, 999);
    endDate =
        DateTime(endDate.year, endDate.month, endDate.day + 1, 0, 0, 0, 0, 0);

    yield* isar.transactions
        .filter()
        .dateGreaterThan(startDate)
        .dateLessThan(endDate)
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  ///# 특정 일자 지출 가져오기
  Future<List<Transaction>> getExpenditureByDate(DateTime date) async {
    final Isar isar = await ref.read(isarProvieder.future);

    return isar.transactions
        .filter()
        .transactionTypeEqualTo(TransactionType.expenditure)
        .dateEqualTo(date)
        .findAll();
  }

  //* 모든 트랜잭션 가져오기
  Future<List<Transaction>> getAllTransactions() async {
    final Isar isar = await ref.read(isarProvieder.future);

    return isar.transactions.where().findAll();
  }

  ///# 해당 Wallet의 마지막 Daily Budget 가져오기
  Future<Transaction?> getLastDailyBudgetByWalletId(Wallet wallet) async {
    final Isar isar = await ref.read(isarProvieder.future);
    //: 해당 Wallet의 마지막 Daily Budget 가져오기
    final Transaction? lastDailyTransactions = await isar.transactions
        .filter()
        .walletIdEqualTo(wallet.id)
        .titleEqualTo(dailyBudget)
        .sortByDateDesc()
        .findFirst();

    return lastDailyTransactions;
  }
}
