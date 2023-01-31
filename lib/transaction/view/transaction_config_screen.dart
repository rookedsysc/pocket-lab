import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/custom_text_from_field.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/common/layout/two_row_layout.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:pocket_lab/transaction/view/category_config_screen.dart';
import 'package:sheet/route.dart';

final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'formState');

final transactionScrollProvider = Provider<ScrollController>((ref) {
  final ScrollController scrollController = ScrollController();
  return scrollController;
});

class TransactionConfigScreen extends ConsumerStatefulWidget {
  static const routeName = 'transaction_screen';

  ///: true면 EDIT / false면 ADD
  final isEdit;
  final TransactionType transactionType;
  const TransactionConfigScreen(
      {required this.isEdit, required this.transactionType, super.key});

  @override
  ConsumerState<TransactionConfigScreen> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionConfigScreen> {
  late Color appbarColor;

  @override
  Widget build(BuildContext context) {
    _renderAppbarColor();
    // _renderCategories(categories);
    return InputModalScreen(
        scrollController: ref.watch(transactionScrollProvider),
        isEdit: widget.isEdit,
        formKey: _formKey,
        inputTile: _inputTileList(),
        onSavePressed: () {});
  }

  List<InputTile> _inputTileList() {
    return [
      _transactionTitleInputTile(),
      _amountInputTile(),
      _selectDateInputTile(),
      //# Test
      // InputTile(
      //     fieldName: "Test",
      //     inputField: TextButton(
      //       onPressed: () {
      //         showCupertinoModalBottomSheet(
      //             context: context,
      //             builder: (context) => CategoryConfigScreen(isEdit: true));
      //       },
      //       child: Text("Test"),
      //     )),
      //: 지출인 경우에만 category 선택
      if (widget.transactionType == TransactionType.expenditure)
        _categoryInputTile(),
    ];
  }

  InputTile _categoryInputTile() {
    return InputTile(
      fieldName: "Select Category",
      inputField: StreamBuilder<List<TransactionCategory>>(
          stream:
              ref.watch(categoryRepositoryProvider.notifier).getAllCategories(),
          builder: (context, snapshot) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Category가 없습니다.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            final List<TransactionCategory> categories = snapshot.data!;

            return DropdownButton(
                underline: Container(
                  height: 0,
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                items: categories
                    .map((e) => DropdownMenuItem(
                            child: Row(
                          children: [
                            Icon(Icons.circle,
                                color: Color(
                                    int.parse('FF${e.color}', radix: 16))),
                            SizedBox(width: 8),
                            Text(e.name),
                          ],
                        )))
                    .toList(),
                onChanged: (val) {});
          }),
    );
  }

  InputTile _transactionTitleInputTile() {
    return InputTile(
        fieldName: "Transaction Title",
        inputField: TextTypeTextFormField(
          onTap: () {},
        ));
  }

  InputTile _amountInputTile() {
    return InputTile(
        fieldName: "Amount",
        inputField: NumberTypeTextFormField(
          onTap: () {},
        ));
  }

  InputTile _selectDateInputTile() {
    return InputTile(
      fieldName: "Select Date",
      inputField: TextButton(
        child: Text("2023-01-31"),
        onPressed: () => showCupertinoModalPopup(
          context: context,
          builder: (context) => Material(
            child: CalendarDatePicker2(
              onValueChanged: (value) {
                setState(() {});
                Navigator.of(context).pop();
              },
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.single,
              ),
              initialValue: [DateTime.now()],
            ),
          ),
        ),
      ),
    );
  }

  void _renderAppbarColor() {
    switch (widget.transactionType) {
      case TransactionType.remittance:
        appbarColor = Colors.blue;
        break;
      case TransactionType.income:
        appbarColor = Colors.green;
        break;
      case TransactionType.expenditure:
        appbarColor = Colors.red;
        break;
    }
  }

  // void _renderCategories(List<RecordCategoryData> categories) async {
  //   for (RecordCategoryData category in categories) {
  //     _categorieNames.add(category.category);

  //   }
  //   if (_selectedCategory.length == 0) {
  //       _selectedCategory = _categorieNames.first;
  //     }
  // }
}
