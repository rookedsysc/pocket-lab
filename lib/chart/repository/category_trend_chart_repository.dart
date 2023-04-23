import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/chart/model/category_trend_chart_model.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

final categoryTrendChartProvider = StateNotifierProvider<
    CategoryTrendChartNotifier, CategoryTrendChartDataModel>((ref) {
  return CategoryTrendChartNotifier(ref: ref);
});

class CategoryTrendChartNotifier
    extends StateNotifier<CategoryTrendChartDataModel> {
  final Ref ref;
  CategoryTrendChartNotifier({required this.ref})
      : super(CategoryTrendChartDataModel(
            date: DateTime.now(), categoryId: 1, categoryName: '', label: ''));

  ///# 새로운 Transaction을 생성할 때 호출
  ///# 해당 Transaction의 Category 외의 다른 Category에도 동일한 일자에
  ///# 데이터를 넣어줌
  Future<void> syncCategory(Transaction transaction) async {
    final Isar isar = await ref.read(isarProvieder.future);
    await ref.read(categoryRepositoryProvider.notifier).syncCategoryCache();
    List<TransactionCategory> categories =
        ref.read(categoryRepositoryProvider.notifier).state;
    for (TransactionCategory category in categories) {
      // 해당 Transaction에 해당하는 날짜의 데이터가 있으면 통과
      // 없으면 0원의 데이터를 생성
      if (category.id != transaction.categoryId) {
        String _label = DateFormat('yyyy-MM-dd').format(transaction.date);
        CategoryTrendChartDataModel? categoryTrendData = await isar
            .categoryTrendChartDataModels
            .filter()
            .labelEqualTo(_label)
            .categoryIdEqualTo(category.id)
            .findFirst();
        if (categoryTrendData == null) {
          CategoryTrendChartDataModel model = CategoryTrendChartDataModel(
              categoryName: category.name,
              categoryId: category.id,
              date: CustomDateUtils().onlyDate(transaction.date),
              label: _label);
          await isar.writeTxn(() async {
            await isar.categoryTrendChartDataModels.put(model);
          });
        }
      }
    }
  }

  ///# 데이터 새로 생성
  Future<void> createCategoryTrend(Transaction transaction) async {
    final Isar isar = await ref.read(isarProvieder.future);
    await ref.read(categoryRepositoryProvider.notifier).syncCategoryCache();
    final List<TransactionCategory> categories =
        ref.read(categoryRepositoryProvider.notifier).state;
    final List<Id> _categoryIds = categories.map((e) => e.id).toList();

    //: 같은 날짜의 데이터가 이미 있는지 찾기
    CategoryTrendChartDataModel? _recentData = await isar
        .categoryTrendChartDataModels
        .filter()
        .labelEqualTo(DateFormat('yyyy-MM-dd').format(transaction.date))
        .categoryIdEqualTo(transaction.categoryId!)
        .findFirst();
    if (_recentData != null) {
      await isar.writeTxn(() async {
        _recentData.amount += transaction.amount;
        await isar.categoryTrendChartDataModels.put(_recentData);
      });
    } else {
      if (_categoryIds.contains(transaction.categoryId)) {
        String _label = DateFormat('yyyy-MM-dd').format(transaction.date);
        CategoryTrendChartDataModel model = CategoryTrendChartDataModel(
          amount: transaction.amount,
            categoryName: categories
                .firstWhere((element) => element.id == transaction.categoryId)
                .name,
            categoryId: transaction.categoryId!,
            date: CustomDateUtils().onlyDate(transaction.date),
            label: _label);
        await isar.writeTxn(() async {
          await isar.categoryTrendChartDataModels.put(model);
        });
      }
    }
    await syncCategory(transaction);
  }

  ///# transaction 삭제할 경우 그날의 CategoryTrendData에서
  ///# transaction의 amount 만큼 차감
  Future<void> subtractData(Transaction transaction) async {
    final Isar isar = await ref.read(isarProvieder.future);

    try {
      CategoryTrendChartDataModel? _recentData = await isar
          .categoryTrendChartDataModels
          .filter()
          .labelEqualTo(DateFormat('yyyy-MM-dd').format(transaction.date))
          .categoryIdEqualTo(transaction.categoryId!)
          .findFirst();
      _recentData!.amount -= transaction.amount;
      await isar.writeTxn(() async {
        await isar.categoryTrendChartDataModels.put(_recentData);
      });
    } catch (e) {
      return;
    }
  }

  ///* 모든 Category Trend Chart Data Model을 가져옴
  Future<List<CategoryTrendChartDataModel>>
      getAllTrendModelByCategory() async {
    final Isar isar = await ref.read(isarProvieder.future);
    await ref.read(categoryRepositoryProvider.notifier).syncCategoryCache();
    List<CategoryTrendChartDataModel> result = await isar.categoryTrendChartDataModels.where().findAll();
    //: 각각 category 별로 Category Trend List 생성
    return result;
  }
}
