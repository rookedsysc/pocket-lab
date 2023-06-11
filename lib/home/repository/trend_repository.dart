import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'dart:math';
import 'package:pocket_lab/home/model/trend_model.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:riverpod/riverpod.dart';

final trendRepositoryProvider =
    StateNotifierProvider<TrendRepositoryNotifier, Trend>((ref) {
  return TrendRepositoryNotifier(ref);
});

class TrendRepositoryNotifier extends StateNotifier<Trend> {
  final Ref ref;
  TrendRepositoryNotifier(this.ref)
      : super(Trend(walletId: 0, amount: 0, date: DateTime.now()));

  ///* Home Card Chart Data 가지고 오기
  Stream<List<Trend>> getTrendStream(int walletId) async* {
    final isar = await ref.read(isarProvieder.future);
    yield* isar.trends
        .filter()
        .walletIdEqualTo(walletId)
        .dateGreaterThan(DateTime.now().subtract(Duration(days: 31)))
        .dateLessThan(DateTime.now().add(Duration(days: 1)))
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  Future<Trend?> getTodayTrend(int walletId) async {
    final isar = await ref.read(isarProvieder.future);
    DateTime now = DateTime.now();

    final trends =
        await isar.trends.filter().walletIdEqualTo(walletId).findAll();
    Trend? todayTrend;
    try {
      todayTrend = trends.firstWhere(
          (element) => CustomDateUtils().isSameDay(element.date, now));
    } catch (e) {}

    return todayTrend;
  }

  ///* 모든 Trend List를 wallet 별로 반환
  Future<Map<int, List<Trend>>> getAllTrendsAsMap() async {
    final isar = await ref.read(isarProvieder.future);
    Map<int, List<Trend>> allTrends = {};
    final wallets =
        await ref.read(walletRepositoryProvider.notifier).getAllWalletsFuture();

    for (Wallet wallet in wallets) {
      List<Trend> trends =
          await isar.trends.filter().walletIdEqualTo(wallet.id).findAll();
      Map<int, List<Trend>> trendMap = {wallet.id: trends};

      allTrends.addAll(trendMap);
    }
    return allTrends;
  }

  ///* 전체 Trend 데이터 가지고 오기
  Future<List<Trend>> getTotalTrends() async {
    List<Trend> trends = [];

    ///: 같은 날짜의 값을 하나로 합친 데이터들
    List<Trend> totalTrends = [];
    final isar = await ref.read(isarProvieder.future);
    final wallets =
        await ref.read(walletRepositoryProvider.notifier).getAllWalletsFuture();
    for (Wallet wallet in wallets) {
      trends.addAll(
          await isar.trends.filter().walletIdEqualTo(wallet.id).findAll());
    }

    ///: results 안에 있는 같은 날짜인 데이터들의 amount를 합친 데이터를 만들어서 totalResults에 넣기
    trends.forEach((element) {
      try {
        Trend? totalTrend = totalTrends.firstWhere((totalElement) =>
            CustomDateUtils().isSameDay(element.date, totalElement.date));
        totalTrend.amount += element.amount;
      } catch (e) {
        totalTrends.add(element);
      }
    });

    return totalTrends;
  }

  ///# 해당 walletId를 가지고 있는 데이터 전부 삭제하기
  Future<void> deleteTrend(int walletId) async {
    final isar = await ref.read(isarProvieder.future);
    final List<Trend> _trends = await isar.trends.filter().walletIdEqualTo(walletId).findAll();
    final List<int> _trendIds = _trends.map((e) => e.id).toList();

    await isar.writeTxn(() async {
      await isar.trends.deleteAll(_trendIds);
    });
  }

  ///* 모든 Wallet의 잔액을 Trend에 저장
  Future<void> allWalletsSync() async {
    final wallets =
        await ref.read(walletRepositoryProvider.notifier).getAllWalletsFuture();
    for (Wallet wallet in wallets) {
      await syncTrend(wallet.id);
    }
  }

  ///* Wallet의 잔액을 Trend에 저장
  Future<void> syncTrend(int walletId) async {
    final isar = await ref.read(isarProvieder.future);

    ///: 같은 날짜인 데이터에 새로운 데이터 덮어쓰기
    Trend? trend = await getTodayTrend(walletId);

    ///: trend가 null이면 새로운 데이터 쓰기
    if (trend == null) {
      await isar.writeTxn(() async {
        await isar.trends
            .put(Trend(walletId: walletId, amount: 0, date: DateTime.now()));
      });

      debugPrint("새로운 Trend 생성");

      return;
    }

    Wallet? wallet = await ref
        .read(walletRepositoryProvider.notifier)
        .getSpecificWallet(walletId);

    if (wallet != null) {
      trend.walletName = wallet.name;
    } else {
      //: 선택한 지갑이나 trend 데이터가 없으면 종료
      return;
    }

    ///: 선택한 지갑의 현재 잔액을 trend에 최종으로 저장
    trend.amount = wallet.balance;
    trend.date = DateTime.now();

    await isar.writeTxn(() async {
      await isar.trends.put(trend);
    });
  }

  ///* 90일치 Random Trend 데이터 생성
  Future<void> createRandomTrend() async {
    final isar = await ref.read(isarProvieder.future);
    double amount = 0; // Starting value
    Random rand = Random();
    DateTime date = DateTime.now().subtract(Duration(days: 90));

    // Define the possible increments
    List<double> possibleIncrements = [];
    for (double i = 100; i <= 10000; i += 5000) {
      possibleIncrements.add(i);
    }

    for (int i = 0; i < 180; i++) {
      // 4 years of data
      double increment =
          possibleIncrements[rand.nextInt(possibleIncrements.length)];
      amount += increment;

      if (DateUtils.isSameDay(date.add(Duration(days: i)), DateTime.now())) {
        Wallet? _wallet =
            await ref.read(walletRepositoryProvider.notifier).getFirstWallet();

        if (_wallet == null) {
          return;
        }
        _wallet.balance = amount;

        await ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);

        await allWalletsSync();
        continue;
      }

      Trend trend =
          Trend(walletId: 1, amount: amount, date: date.add(Duration(days: i)));

      isar.writeTxn(() async {
        await isar.trends.put(trend);
      });
    }
  }
}
