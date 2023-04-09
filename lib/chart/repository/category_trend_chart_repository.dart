import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/chart/model/category_trend_chart_model.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';

final categoryTrendChartProvider = StateNotifierProvider<
    CategoryTrendChartNotifier, CategoryTrendChartDataModel>((ref) {
  return CategoryTrendChartNotifier(ref: ref);
});

class CategoryTrendChartNotifier
    extends StateNotifier<CategoryTrendChartDataModel> {
  final Ref ref;
  CategoryTrendChartNotifier({required this.ref})
      : super(CategoryTrendChartDataModel(
            date: DateTime.now(), categoryId: 1, categoryName: ''));

  //# 새로운 Transaction을 생성할 때 호출
  //: 새로운 Transaction이 마지막 일자보다 뒤에 있으면 마지막 일자까지 사이의 데이터를 넣고
  //: 새로운 Transaction이 첫 번째 일자보다 앞에 있으면 첫 번째 일자까지 사이의 데이터를 넣음
  Future<void> syncDate(Transaction transaction) async {
    DateTime? firstDate;
    DateTime? lastDate;
    final Isar isar = await ref.read(isarProvieder.future);
    List<Transaction> transactions = await isar.transactions.where().findAll();
    transactions.sort((a, b) => a.date.compareTo(b.date));

    //: 첫 번째 데이터 보다 이전 날짜의 데이터가 새로운 transaction으로 생성되면
    //: 첫 번째 날짜를 변경
    if (transactions.first.date.isBefore(transaction.date)) {
      firstDate = transactions.first.date;
    } else if (transactions.first.date.isAfter(transaction.date)) {
      lastDate = transaction.date;
    } else {
      return;
    }

    await ref.read(categoryRepositoryProvider.notifier).syncCategoryCache();
    List<TransactionCategory> categories =
        ref.read(categoryRepositoryProvider.notifier).state;

    for (TransactionCategory category in categories) {
      //: 현재 카테고리와 ID가 동일한 데이터를 모두 받아옴
      List<Transaction> transactions = await isar.transactions
          .filter()
          .categoryIdEqualTo(category.id)
          .findAll();
      transactions.sort((a, b) => a.date.compareTo(b.date));
      DateTime transactionFirstDate = transactions.first.date;
      DateTime transactionLastDate = transactions.last.date;

      //: 첫 번째 날짜가 변경되면 변경된 첫 번째 날짜까지의 데이터를 생성
      if (firstDate != null) {
        firstDate = firstDate.subtract(Duration(days: 1));
        while (CustomDateUtils().isSameDay(firstDate, transactionFirstDate)) {
          transactionFirstDate.subtract(Duration(days: 1));
          await isar.writeTxn(() async {
            CategoryTrendChartDataModel model = CategoryTrendChartDataModel(
                categoryName: category.name,
                categoryId: category.id,
                date: CustomDateUtils().onlyDate(firstDate!));
            model.setLabel =
                DateFormat('yyyy-MM-dd').format(transactionFirstDate);
            await isar.categoryTrendChartDataModels.put(model);
          });
        }
      }
      //: 마지막 날짜가 변경되면 마지막 날짜까지의 데이터를 생성
      else if (lastDate != null) {
        firstDate = lastDate.add(Duration(days: 1));
        while (!(CustomDateUtils().isSameDay(firstDate, transactionLastDate))) {
          transactionLastDate.add(Duration(days: 1));
          await isar.writeTxn(() async {
            CategoryTrendChartDataModel model = CategoryTrendChartDataModel(
                categoryName: category.name,
                categoryId: category.id,
                date: CustomDateUtils().onlyDate(lastDate!));
            model.setLabel = DateFormat('yyyy-MM-dd').format(
              transactionLastDate,
            );
            await isar.categoryTrendChartDataModels.put(model);
          });
        }
      }
    } //: Category별 For문 종료 (Cateogry별로 데이터를 생성)
  }

  //# 데이터 새로 생성
  Future<void> createCategoryTrend(Transaction transaction) async {
    final Isar isar = await ref.read(isarProvieder.future);
    final List<TransactionCategory> categories =
        ref.read(categoryRepositoryProvider.notifier).state;

    //: 같은 날짜의 데이터가 이미 있는지 찾기
    CategoryTrendChartDataModel? _recentData = await isar
        .categoryTrendChartDataModels
        .filter()
        .labelEqualTo(DateFormat('yyyy-MM-dd').format(transaction.date))
        .categoryIdEqualTo(transaction.categoryId!)
        .findFirst();

    //: 이미 기존에 생성된 데이터가 있으면 amount만 더해줌
    if (_recentData != null) {
      await isar.writeTxn(() async {
        _recentData.amount += transaction.amount;
        await isar.categoryTrendChartDataModels.put(_recentData);
      });
    }
    if (categories.contains(transaction.categoryId)) {
      await isar.writeTxn(() async {
        CategoryTrendChartDataModel model = CategoryTrendChartDataModel(
            categoryName: categories
                .firstWhere((element) => element.id == transaction.categoryId)
                .name,
            categoryId: transaction.categoryId!,
            date: CustomDateUtils().onlyDate(transaction.date));
        model.setLabel = DateFormat('yyyy-MM-dd').format(transaction.date);
        await isar.categoryTrendChartDataModels.put(model);
      });
    }

    await syncDate(transaction);
  }

  //# transaction 삭제할 경우 그날의 CategoryTrendData에서
  //# transaction의 amount 만큼 차감
  Future<void> subtranctData(Transaction transaction) async {
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

  //# 카테고리별로 CategoryTrendChartModel 데이터를 가져옴 
  Future<List<List<CategoryTrendChartDataModel>>> getAllTrendModelByCategory() async {
    final Isar isar = await ref.read(isarProvieder.future);
    List<List<CategoryTrendChartDataModel>> result = [];
    await ref.read(categoryRepositoryProvider.notifier).syncCategoryCache();
    List<TransactionCategory> categories =
        ref.read(categoryRepositoryProvider.notifier).state;
    for (TransactionCategory category in categories) {
      List<CategoryTrendChartDataModel> models = await isar
          .categoryTrendChartDataModels
          .filter()
          .categoryIdEqualTo(category.id)
          .findAll();
      models.sort((a, b) => a.date.compareTo(b.date));
      result.add(models);
    }
    return result;
  }
}
