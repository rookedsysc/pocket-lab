import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/chart/repository/category_trend_chart_repository.dart';
import 'package:pocket_lab/common/constant/daily_budget.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
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
    //: 지출 이벤트일 경우 카테고리 트렌드 차트 데이터 생성
    if (transaction.transactionType == TransactionType.expenditure) {
      await ref
          .read(categoryTrendChartProvider.notifier)
          .createCategoryTrend(transaction);
    }
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

  ///# 받아온 ID에 해당되는 Transaction return
  Future<Transaction?> getSpecificTransaction(int id) async {
    final Isar isar = await ref.read(isarProvieder.future);

    return await isar.transactions.get(id);
  }

  //* 모든 거래 내역 Stream으로 가져오기
  //: Category 별로 Map<int(카테고리 ID), List<Transaction>> 형태로 가져옴
  Stream<Map<int, List<Transaction>>> getTransactionsByCategory() async* {
    final Isar isar = await ref.read(isarProvieder.future);

    yield* isar.transactions
        .where()
        .watch(fireImmediately: true)
        .asBroadcastStream()
        .map((event) {
      Map<int, List<Transaction>> map = {};
      event.forEach((element) {
        if (map.containsKey(element.categoryId)) {
          map[element.categoryId]!.add(element);
        } else {
          if (element.categoryId == null) return;
          map[element.categoryId!] = [element];
        }
      });
      return map;
    });
  }

  ///# 해당 월 지출 Stream으로 가져오기
  Stream<List<Transaction>> getSelectMonthExpenditureByWallet(
      DateTime date, int walletId) async* {
    final Isar isar = await ref.read(isarProvieder.future);

    yield* isar.transactions
        .filter()
        .walletIdEqualTo(walletId)
        .transactionTypeEqualTo(TransactionType.expenditure)
        .dateGreaterThan(DateTime(date.year, date.month, 1))
        .dateLessThan(DateTime(date.year, date.month + 1, 1))
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  ///# 해당 월 모든 종류의 거래내역 Stream으로 가져오기
  Stream<List<Transaction>> getSelectMonthExpenditureByCategory(
      DateTime date, int categoryId) async* {
    final Isar isar = await ref.read(isarProvieder.future);

    yield* isar.transactions
        .filter()
        .categoryIdEqualTo(categoryId)
        .transactionTypeEqualTo(TransactionType.expenditure)
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

  //* 모든 지출내역 가져오기
  Future<List<Transaction>> getAllExpenditures() async {
    final Isar isar = await ref.read(isarProvieder.future);

    return isar.transactions
        .filter()
        .transactionTypeEqualTo(TransactionType.expenditure)
        .findAll();
  }

  //* 특정 카테고리의 지출내역들 가져오기
  Future<List<Transaction>> getTransactionsByCategoryId(int id) async {
    final Isar isar = await ref.read(isarProvieder.future);

    return isar.transactions
        .filter()
        .transactionTypeEqualTo(TransactionType.expenditure)
        .categoryIdEqualTo(id)
        .findAll();
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

  //* 랜덤 트랜잭션 생성
  Future<void> createRandomTransaction() async {
    List<TransactionCategory> _categoryIds =
        await ref.read(categoryRepositoryProvider.notifier).getAllCategories();
    _categoryIds.removeAt(0);
    _categoryIds.removeAt(0);

    final List<Wallet> _wallets =
        await ref.read(walletRepositoryProvider.notifier).getAllWalletsFuture();

    // Each category can have a different set of possible titles and amount ranges
    Map<int, List<String>> possibleTitles = {
      1: [
        "Miscellaneous",
        "Unexpected cost",
        "Other",
        "Non-categorized expense",
        "Unknown"
      ],
      2: [
        "Groceries",
        "Dining out",
        "Takeout food",
        "Coffee shop",
        "Supermarket",
        "Lunch at work",
        "Dinner expense",
        "Brunch expense",
        "Snack expense",
        "Drink expense"
      ],
      3: [
        "Movie ticket",
        "Book",
        "Concert ticket",
        "Art supplies",
        "Online gaming",
        "Gym membership",
        "Yoga class",
        "Music lesson",
        "Outdoor gear",
        "Hobby club membership"
      ],
      4: [
        "Electricity bill",
        "Water bill",
        "Internet bill",
        "Heating cost",
        "Groceries",
        "Household items",
        "Cleaning supplies",
        "Public transport",
        "Gasoline",
        "Car maintenance"
      ],
      5: [
        "Shirt purchase",
        "Pants purchase",
        "Dress purchase",
        "Shoe purchase",
        "Accessories",
        "Jacket purchase",
        "Suit purchase",
        "Swimsuit purchase",
        "Hat purchase",
        "Underwear purchase"
      ],
      6: [
        "Book purchase",
        "Online course",
        "Tutoring",
        "Seminar fee",
        "Stationery",
        "Education software",
        "Library fee",
        "Exam fee",
        "Scholarship donation",
        "Study group expense"
      ],
    };

    Map<int, List<double>> possibleAmounts = {
      1: [10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0],
      2: [15.0, 25.0, 35.0, 45.0, 55.0, 65.0, 75.0, 85.0, 95.0, 105.0],
      3: [20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0],
      4: [50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0, 120.0, 130.0, 140.0],
      5: [30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0, 120.0],
      6: [20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0],
    };

    for (Wallet _wallet in _wallets) {
      for (int i = 0; i < 100; i++) {
        DateTime date = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day - i, Random().nextInt(24), Random().nextInt(60));

        int dailyTransactionCount = Random().nextInt(10) + 1;
        for (int j = 0; j < dailyTransactionCount; j++) {
          TransactionCategory _randomCategory =
              _categoryIds[Random().nextInt(_categoryIds.length)];

          // Select a random title and amount based on the category
          String title = possibleTitles[_randomCategory.id]![
              Random().nextInt(possibleTitles[_randomCategory.id]!.length)];
          double amount = Random().nextDouble() *
                  (possibleAmounts[_randomCategory.id]![1] -
                      possibleAmounts[_randomCategory.id]![0]) +
              possibleAmounts[_randomCategory.id]![0];

          Transaction _randomTransaction = Transaction(
              transactionType: TransactionType.expenditure,
              categoryId: _randomCategory.id,
              amount: amount,
              date: date,
              title: title,
              walletId: _wallet.id);
              

          await ref
              .read(transactionRepositoryProvider.notifier)
              .configTransaction(_randomTransaction);
          await ref
              .read(categoryTrendChartProvider.notifier)
              .createCategoryTrend(_randomTransaction);
        }
      }
    }
  }

  Future<void> createRandomIncomeTransactions() async {
    final isar = await ref.read(isarProvieder.future);
    double minIncome = 100; // Minimum income in USD
    double maxIncome = 5000; // Maximum income in USD
    Random rand = Random();

    for (int i = 0; i < 90; i++) {
        double incomeAmount = minIncome + rand.nextDouble() * (maxIncome - minIncome);
        
        Transaction incomeTransaction = Transaction(
            transactionType: TransactionType.income,
            categoryId: null, // Income transactions typically don't have a category
            amount: incomeAmount,
            date: DateTime.now().subtract(Duration(days: i)),
            title: "Income for day $i",
            walletId: 1); // Assuming walletId 1

        await isar.writeTxn(() async {
            await isar.transactions.put(incomeTransaction);
        });
    }
}

  ///# 카테고리 삭제시 해당하는 카테고리를 가지고 있는 Transaction에 대해
  ///# Category ID를 1로 변경
  Future<void> handleDeletedCategoryInTransactions(
      {required int categoryId}) async {
    final Isar isar = await ref.read(isarProvieder.future);

    List<Transaction> _transaction = await isar.transactions
        .filter()
        .categoryIdEqualTo(categoryId)
        .findAll();
    List<Transaction> _temp = [];

    // 모든 Transaction의 Category ID를 1로 변경
    for (Transaction _transaction in _transaction) {
      _transaction.categoryId = 1;
      _temp.add(_transaction);
    }

    isar.writeTxn(() async {
      await isar.transactions.putAll(_temp);
    });
  }

  Future<void> delete(Transaction transaction) async {
    final Isar isar = await ref.read(isarProvieder.future);

    await _updateCategoryTrend(transaction);
    await _modifyWalletBalance(transaction);

    await ref.read(trendRepositoryProvider.notifier).allWalletsSync();
    return isar.writeTxn(() async {
      await isar.transactions.delete(transaction.id);
    });
  }

  Future<void> _updateCategoryTrend(Transaction transaction) async {
    if (transaction.transactionType == TransactionType.expenditure) {
      await ref
          .read(categoryTrendChartProvider.notifier)
          .subtractData(transaction);
    }
  }

  Future<void> _modifyWalletBalance(Transaction transaction) async {
    final Wallet? fromWallet = await ref
        .read(walletRepositoryProvider.notifier)
        .getSpecificWallet(transaction.walletId);

    if (fromWallet != null) {
      if (transaction.transactionType == TransactionType.expenditure) {
        fromWallet.balance += transaction.amount;
      } else if (transaction.transactionType == TransactionType.income) {
        fromWallet.balance -= transaction.amount;
      } else if (transaction.toWallet != null) {
        final Wallet? toWallet = await ref
            .read(walletRepositoryProvider.notifier)
            .getSpecificWallet(transaction.toWallet!);

        fromWallet.balance -= transaction.amount;
        toWallet!.balance += transaction.amount;
        await ref
            .read(walletRepositoryProvider.notifier)
            .configWallet(toWallet);
      }

      await ref
          .read(walletRepositoryProvider.notifier)
          .configWallet(fromWallet);
    }
  }

  //* 모든 트랜잭션 삭제
  Future<void> deleteAllTransactions() async {
    final Isar isar = await ref.read(isarProvieder.future);
    final List<Transaction> _transactions = await getAllTransactions();
    List<Id> _ids = [];

    for (Transaction _transaction in _transactions) {
      _ids.add(_transaction.id);
      await ref
          .read(categoryTrendChartProvider.notifier)
          .subtractData(_transaction);
    }

    await isar.writeTxn(() async {
      await isar.transactions.deleteAll(_ids);
    });
  }
}
