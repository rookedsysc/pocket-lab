import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/common/layout/two_row_layout.dart';
import 'package:pocket_lab/home/component/transaction_button.dart';

final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'formState');

class TransactionScreen extends StatefulWidget {
  static const routeName = 'transaction_screen';
  final TransactionType transactionType;
  const TransactionScreen({required this.transactionType,super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late Color appbarColor;

  @override
  Widget build(BuildContext context) {
    _renderAppbarColor();
    // _renderCategories(categories);
    return Scaffold(
              appBar: _AppBar(context),
              body: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _inputTransactionTitle(context),
                    _inputAmount(context),
                    TextButton(onPressed: (){}, child: Text("2023.01.01.")),
                    if(widget.transactionType != TransactionType.remittance)_selectCategory(context, (String? val) {
                      setState(() {
                        if (val != null) {
                          // _selectedCategory = val;
                          // print(_selectedCategory);
                          // _createTransactionModel.category = val;
                        }
                      });
                    }),
                    // if(widget.transactionType == TransactionType.expenditure) _selectObserver(context),
                    _inputContent(context),
                  ],
                ),
              ));
        }
        

  PreferredSizeWidget _AppBar(BuildContext context) {
    return AppBar(
      backgroundColor: appbarColor,
      title: Text(widget.transactionType.name),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.cancel),
      ),
      actions: [
        // 저장 버튼
        IconButton(
            onPressed: () async {
              // if (_formKey.currentState!.validate()) {
              //   _formKey.currentState!.save();
              //   _createTransactionModel.widget.transactionType = widget.transactionType.name;
              //   TransactionRecord.createTransaction(boxCreateDate: DateTime.parse('${_selectedDate} ${_selectedTime}'), budgetId: widget.budgetId, createTransactionModel: _createTransactionModel);
              //   Navigator.of(context).pop();
              // }
            },
            icon: const Icon(Icons.save))
      ],
    );
  }

  Widget _inputTransactionTitle(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 8.0, left: 8.0, top: 4.0, bottom: 8.0),
      child: TwoRowLayout(
          firstWidget: Text(
            'Transaction Title',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          secondWidget: SizedBox(
              width: MediaQuery.of(context).size.width * (9 / 20),
              child: TextFormField(
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Input Value';
                  }
                  return null;
                },
                onSaved: (val) {
                  // setState(() {
                  //   _createTransactionModel.transactionTitle = val!;
                  // });
                },
                style: Theme.of(context).textTheme.bodyText2,
                cursorColor: Colors.purple,
              ))),
    );
  }

  Widget _inputAmount(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 8.0, left: 8.0, top: 4.0, bottom: 8.0),
      child: TwoRowLayout(
          firstWidget:Text(
            'Amount',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          secondWidget:SizedBox(
              width: MediaQuery.of(context).size.width * (9 / 20),
              child: TextFormField(
                validator: (val) {
                  if(val == null || val.isEmpty) {
                    return 'Input Value';
                  }
                  return null;
                },

                onSaved: (val) {
                  // setState(() {
                  //   _createTransactionModel.amount = int.parse(val!);
                  // });
                },

                cursorColor: Colors.purple,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(hintText: 'Input Number',hintStyle: Theme.of(context).textTheme.bodyMedium),
              ),
        )),
    );
  }

  Widget _selectCategory(BuildContext context, _onCategoryChanged) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0, bottom: 8.0),
      child: TwoRowLayout(
        firstWidget:Text(
          'Category',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        secondWidget:DropdownButton<String>(
            value: "Category 1",
            isDense: true,
            elevation: 16,
            items: [
              DropdownMenuItem<String>(
                value: "Category 1",
                child: Text(
                  "Category 1",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              DropdownMenuItem<String>(
                value: "Category 2",
                child: Text(
                  "Category 2",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              DropdownMenuItem<String>(
                value: "Category 3",
                child: Text(
                  "Category 3",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
            onChanged: _onCategoryChanged),
      ),
    );
  }

  Widget _inputContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          right: 8.0, left: 8.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Content",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(
            height:
            MediaQuery.of(context).size.height * (13 / 30),
            child: TextFormField(
              onSaved: (val) {
                // if(val != null) {
                //   _createTransactionModel.transactionDetail = val;
                // }
              },
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.top,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              decoration:
              InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          // if (widget.transactionType ==
          //     widget.transactionType.expenditure)
          //   _selectObserver(context),
        ],
      ),
    );
  }

  // Widget _selectObserver(BuildContext ctx) {
  //   return Padding(
  //     padding:
  //         const EdgeInsets.only(right: 8.0, left: 8.0, top: 4.0, bottom: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text("Consumption Interval"),
  //         TextButton(
  //             onPressed: () {
  //               // showFloatingModalBottomSheet(
  //               //     context: ctx,
  //               //     builder: (context) {
  //               //       return ModalFit(items: _categorieNames);
  //               //     });
  //             },
  //             child: Text(
  //                 style: Theme.of(ctx)
  //                     .textTheme
  //                     .bodyText2
  //                     ?.copyWith(color: dollarColor),
  //                 _selectedCategory)),
  //       ],
  //     ),
  //   );
  // }

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