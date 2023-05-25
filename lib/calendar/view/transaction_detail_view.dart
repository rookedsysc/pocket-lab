import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/custom_slidable.dart';
import 'package:pocket_lab/common/constant/ad_unit_id.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/common/widget/banner_ad_container.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';
import 'package:pocket_lab/transaction/view/transaction_config_screen.dart';
import 'package:pocket_lab/transaction/view/wallet_select_screen.dart';
import 'dart:io' show Platform;

class TransactionDetailView extends ConsumerStatefulWidget {
  final String title;
  final DateTime startDate;
  final DateTime endDate;

  const TransactionDetailView(
      {required this.startDate,
      required this.endDate,
      required this.title,
      super.key});

  @override
  ConsumerState<TransactionDetailView> createState() =>
      _TransactionDetailViewState();
}

class _TransactionDetailViewState extends ConsumerState<TransactionDetailView> {
  DateTime _currentDate = DateTime(0, 0, 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Scaffold(
        body: Stack(
          children: [
            StreamBuilder<List<Transaction>>(
              stream: ref
                  .watch(transactionRepositoryProvider.notifier)
                  .getTransactionByPeriod(widget.startDate, widget.endDate),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }
                snapshot.data!.sort((a, b) => a.date.compareTo(b.date));
                return Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),

                    if (widget.title.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),

                    /// dailyBudget만 남아있는 경우 Empty List 반환
                    _isOnlyDailyBudgetLeft(snapshot.data!)
                        ? _emptyList()
                        : Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                Transaction _transaction =
                                    snapshot.data![index];

                                if (_transaction.title == "#DAILY_BUDGET") {
                                  return SizedBox();
                                }

                                if (!(CustomDateUtils().isSameDay(
                                    _transaction.date, _currentDate))) {
                                  _currentDate = _transaction.date;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          _transaction.date
                                              .toString()
                                              .substring(0, 10),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      _transactionItem(_transaction)
                                    ],
                                  );
                                } else {
                                  return _transactionItem(_transaction);
                                }
                              },
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                            ),
                          ),
                    // banner 높이 (기본 높이 50 + 패딩 32)
                    SizedBox(
                      height: 82,
                    )
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: BannerAdContainer(
                    adUnitId: Platform.isAndroid
                        ? TRANSACTION_LIST_BANNER_AOS
                        : TRANSACTION_LIST_BANNER_IOS),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isOnlyDailyBudgetLeft(List<Transaction> transactions) {
    List<Transaction> tmp = [];
    for (Transaction transaction in transactions) {
      if (transaction.title != "#DAILY_BUDGET") {
        tmp.add(transaction);
      }
    }

    return tmp.length == 0;
  }

  Widget _emptyList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        Text(
          "No records found".tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  // List Item
  Widget _transactionItem(Transaction transaction) {
    String? _categoryName;
    Color? _categoryColor;
    if (transaction.transactionType == TransactionType.expenditure) {
      try {
        TransactionCategory _transactionCategory = ref
            .watch(categoryRepositoryProvider)
            .firstWhere((element) => element.id == transaction.categoryId);
        _categoryName = _transactionCategory.name;
        _categoryColor = ColorUtils.stringToColor(_transactionCategory.color);
      } catch (e) {
        _categoryName = "카테고리 없음";
        _categoryColor = Colors.grey;
      }
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          _slidableEdit(transaction),
          _slidableDelete(transaction),
        ],
      ),
      child: _container(transaction,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _icon(transaction),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (transaction.transactionType ==
                        TransactionType.expenditure)
                      Text(
                        _categoryName!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: _categoryColor),
                      )
                  ],
                ),
                Text(
                  CustomNumberUtils.formatCurrency(transaction.amount),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )),
    );
  }

  Container _container(Transaction transaction, {required Widget child}) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
      ),
      child: child,
    );
  }

  SlidableDelete _slidableDelete(Transaction transaction) {
    return SlidableDelete(
      onPressed: (context) async {
        await ref
            .read(transactionRepositoryProvider.notifier)
            .delete(transaction);
      },
    );
  }

  SlidableEdit _slidableEdit(Transaction transaction) {
    return SlidableEdit(
      onPressed: (context) async {
        await _syncSelectedWalletByTransaction(transaction);

        showModalBottomSheet(
            context: context,
            builder: (context) {
              return TransactionConfigScreen(
                isEdit: true,
                transactionType: transaction.transactionType,
                transaction: transaction,
              );
            });
      },
    );
  }

  Future<void> _syncSelectedWalletByTransaction(Transaction transaction) async {
    await ref
        .read(walletRepositoryProvider.notifier)
        .setIsSelectedWallet(transaction.walletId);
    if (transaction.toWallet != null) {
      ref.refresh(toWalletProvider.notifier).state = await ref
          .read(walletRepositoryProvider.notifier)
          .getSpecificWallet(transaction.toWallet);
    }
  }

  Icon _icon(Transaction transaction) {
    if (transaction.transactionType == TransactionType.income) {
      return Icon(
        Icons.attach_money,
        color: Colors.blue,
      );
    } else if (transaction.transactionType == TransactionType.expenditure) {
      Color _color = Colors.red;
      return Icon(Icons.money_off, color: _color);
    } else {
      return Icon(
        Icons.compare_arrows,
        color: Colors.blue,
      );
    }
  }
}
