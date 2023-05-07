import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';

class TransactionDetailView extends ConsumerStatefulWidget {
  List<Transaction> transactions;
  final String title;
  TransactionDetailView(
      {required this.title, required this.transactions, super.key});

  @override
  ConsumerState<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends ConsumerState<TransactionDetailView> {
  DateTime _currentDate = DateTime(0,0,0);

  @override
  void didChangeDependencies() {
    widget.transactions.sort((a, b) => a.date.compareTo(b.date));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Scaffold(
        body: Column(
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
                  Transaction _transaction = widget.transactions[index];
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
                itemCount: widget.transactions.length,
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List Item
  Widget _transactionItem(Transaction transaction) {
    return Container(
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
    );
  }

  Icon _icon(Transaction transaction) {
    if (transaction.transactionType == TransactionType.income) {
      return Icon(
        Icons.attach_money,
        color: Theme.of(context).primaryColor,
      );
    } else if(transaction.transactionType == TransactionType.expenditure) {
      String _colorString; 

      try {
        _colorString = ref.read(categoryRepositoryProvider).firstWhere((element) => element.id == transaction.categoryId).color;
      } catch (e) {
        // 없으면 빨간색 넣기
        _colorString = ColorUtils.colorToHexString(Colors.red);
      }


      Color _color = ColorUtils.stringToColor(_colorString);
      return Icon(
        Icons.money_off,
        color: _color
      );
    } else {
      return Icon(Icons.compare_arrows, color: Colors.green,);
    }
  }

} 
