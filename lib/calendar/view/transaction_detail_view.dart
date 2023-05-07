import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

class TransactionDetailView extends ConsumerStatefulWidget {
  final String title;
  final Stream<List<Transaction>> stream;
  const TransactionDetailView(
      {required this.stream,
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
        body: StreamBuilder<List<Transaction>>(
            stream: widget.stream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
                  snapshot.data!.sort((a, b) => a.date.compareTo(b.date));
              return Column(
                children: [
                  if (widget.title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        Transaction _transaction = snapshot.data![index];
                        if (!(CustomDateUtils()
                            .isSameDay(_transaction.date, _currentDate))) {
                          _currentDate = _transaction.date;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  _transaction.date.toString().substring(0, 10),
                                  style: Theme.of(context).textTheme.bodyMedium,
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
                ],
              );
            }),
      ),
    );
  }

  // List Item
  Widget _transactionItem(Transaction transaction) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) async {
            await ref
                .read(transactionRepositoryProvider.notifier)
                .delete(transaction);
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: '삭제',
        ),
      ]),
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _icon(transaction),
              Text(
                transaction.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                CustomNumberUtils.formatCurrency(transaction.amount),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Icon _icon(Transaction transaction) {
    if (transaction.transactionType == TransactionType.income) {
      return Icon(
        Icons.attach_money,
        color: Theme.of(context).primaryColor,
      );
    } else if (transaction.transactionType == TransactionType.expenditure) {
      String _colorString;

      try {
        _colorString = ref
            .read(categoryRepositoryProvider)
            .firstWhere((element) => element.id == transaction.categoryId)
            .color;
      } catch (e) {
        // 없으면 빨간색 넣기
        _colorString = ColorUtils.colorToHexString(Colors.red);
      }

      Color _color = ColorUtils.stringToColor(_colorString);
      return Icon(Icons.money_off, color: _color);
    } else {
      return Icon(
        Icons.compare_arrows,
        color: Colors.green,
      );
    }
  }
}
