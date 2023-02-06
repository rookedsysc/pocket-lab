import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/budget_icon_and_name.dart';
import 'package:pocket_lab/common/component/custom_text_from_field.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/common/layout/two_row_layout.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/home/view/menu_screen.dart';
import 'package:pocket_lab/home/view/menu_screen/icon_select_screen.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';
import 'package:pocket_lab/transaction/view/category_config_screen.dart';
import 'package:pocket_lab/transaction/view/wallet_select_screen.dart';
import 'package:sheet/route.dart';

final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: 'formState');

final transactionScrollControllerProvider = Provider<ScrollController>((ref) {
  final ScrollController scrollController = ScrollController();
  return scrollController;
});

class TransactionConfigScreen extends ConsumerStatefulWidget {
  static const routeName = 'transaction_screen';
  ///: true면 EDIT / false면 ADD
  final isEdit;
  final TransactionType transactionType;
  Transaction? transaction;

  Wallet? fromWallet;
  Wallet? toWallet;
  TransactionConfigScreen(
      {this.toWallet,
      this.fromWallet,
      this.transaction,
      required this.isEdit,
      required this.transactionType,
      super.key});

  @override
  ConsumerState<TransactionConfigScreen> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionConfigScreen> {
  late Color appbarColor;
  Transaction _transaction = Transaction(
    amount: 0,
    title: "",
    date: DateTime.now(),
    category: 1,
    transactionType: TransactionType.expenditure,
    walletId: 0,
  );
  //# Custom Validator Check
  String? _selectWalletInputTileHint;
  String? _toWalletInputTileHint;
  String? _categoryInputTileHint;

  @override
  void didChangeDependencies() {
    _transaction.transactionType = widget.transactionType;
    _getWallet();
    super.didChangeDependencies();
  }

  void _getWallet() {
    _transaction.walletId = ref.watch(walletRepositoryProvider).id;
    widget.transaction?.walletId = ref.watch(walletRepositoryProvider).id;
    _transaction.toWallet = ref.watch(toWalletProvider.notifier).state?.id;
    widget.transaction?.toWallet =
        ref.watch(toWalletProvider.notifier).state?.id;
  }
  

  @override
  Widget build(BuildContext context) {
    _renderAppbarColor();
    // _renderCategories(categories);
    return Scaffold(
      body: InputModalScreen(
          scrollController: ref.watch(transactionScrollControllerProvider),
          isEdit: widget.isEdit,
          formKey: _formKey,
          inputTile: _inputTileList(ref),
          onSavePressed: _onSavedPress()),
    );
  }

  List<InputTile> _inputTileList(WidgetRef ref) {
    return [
      //: Wallet Select Screen에서 riverpod으로 전달
      _selectWalletInputTile(ref),
      if (widget.transactionType == TransactionType.remittance)
      //: Wallet Select Screen에서 riverpod으로 전달
        _toWalletInputTile(ref), 
        //: validator로 체크
      _transactionTitleInputTile(), 
      //: validator로 체크
      _amountInputTile(), 
      if (widget.transactionType == TransactionType.expenditure)

        _categoryInputTile(), //: check
      _selectDateInputTile(), //: check
    ];
  }

  VoidCallback _onSavedPress() {
    //: 세 가지 경우가 있음
    //: 첫 번째 : 지출일 경우 - 카테고리, fromWallet 검증 필요
    //: 두 번째 : 수입일 경우 - fromWallet 검증 필요
    //: 세 번째 : 계좌 이체일 경우 - fromWallet, to Wallet 검증 필요
    return () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (!_getCustomValidatorCheck()) {
          return null;
        }

        if (widget.transaction == null) {
          changeWalletBalance(_transaction);
          await ref
              .read(transactionRepositoryProvider.notifier)
              .configTransaction(_transaction);
        } else {
          changeWalletBalance(widget.transaction!);
          await ref
              .read(transactionRepositoryProvider.notifier)
              .configTransaction(widget.transaction!);
        }
        Navigator.of(context).pop();
      }
    };
  }

  //# Transaction Type에 따라서 기존 wallet의 잔고에 + - 
  void changeWalletBalance(Transaction transaction) async {
    final Wallet? _wallet = await ref.read(walletRepositoryProvider.notifier).getSpecificWallet(transaction.walletId);
    final Wallet? _toWallet = await ref.read(walletRepositoryProvider.notifier).getSpecificWallet(transaction.toWallet);

    if(_wallet == null) {
      return ;
    }

    switch(widget.transactionType) {
      case TransactionType.expenditure:
        _wallet.balance -= transaction.amount;
        await ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
        break;
        case TransactionType.income:
        _wallet.balance += transaction.amount;
        await ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
        break;

        case TransactionType.remittance:
        if(_toWallet == null) {
          return;
        }
        _wallet.balance -= transaction.amount;
        _toWallet.balance += transaction.amount;
        ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
        ref.read(walletRepositoryProvider.notifier).configWallet(_toWallet);
        break;
    }

  }

  bool _getCustomValidatorCheck() {
    bool _check = true;
    final Wallet? _fromWallet = ref.watch(walletRepositoryProvider);
    final Wallet? _toWallet = ref.watch(toWalletProvider.notifier).state;
    //: 선택한 지갑 없으면 _check를 false로
    if (_fromWallet == null) {
      debugPrint("Check1");
      _selectWalletInputTileHint = "Select Wallet";
      _check = false;
    }

    //: 송금이면서 선택한 지갑이 없다면 snackBar 호출 후 함수 종료
    if (widget.transactionType == TransactionType.remittance &&
        _toWallet == null) {
                debugPrint("Check2");
      _toWalletInputTileHint = "Select To Wallet";
      _check = false;
    }

    //: 거래타입이 지출이고 widget.category가 존재하지 않으면 category 선택하라는 알림창 나옴
    if (widget.transactionType == TransactionType.expenditure &&
        widget.transaction?.category == null && widget.isEdit) {
                debugPrint("Check3");
      _categoryInputTileHint = "Select Category";
      _check = false;
    }
    return _check;
  }

  //: 만약에 TransactionType이 송금이면 selectWalletType.to 선택
  //: 송금이 아니라면 selectWalletType.select 선택
  InputTile _selectWalletInputTile(WidgetRef ref) {
    Wallet? _selectWallet = ref.watch(walletRepositoryProvider);
    String _selectedWalletName;
    String _fieldName;

    if (widget.transactionType == TransactionType.remittance) {
      _fieldName = "from Wallet";
    } else {
      _fieldName = "Select Wallet";
    }

    if (_selectWallet == null) {
      _selectedWalletName = "Select Wallet";
    } else {
      _selectedWalletName = _selectWallet.name;
      debugPrint(_selectedWalletName);
    }
    return InputTile(
        hint: _selectWalletInputTileHint,
        fieldName: _fieldName,
        inputField: TextButton(
            onPressed: () => showCupertinoModalBottomSheet(
                expand: false,
                context: context,
                builder: (context) => WalletSelectScreen(
                      selectWalletType:
                          TransactionType.remittance == widget.transactionType
                              ? SelectWalletType.from
                              : SelectWalletType.select,
                    )),
            child: Text(_selectedWalletName)));
  }

  InputTile _toWalletInputTile(WidgetRef ref) {
    final Wallet? _toWallet = ref.watch(toWalletProvider.notifier).state;
    String _selectedWalletName;
    String _fieldName;

    _fieldName = "to Wallet";
    if (_toWallet == null) {
      _selectedWalletName = "from Wallet";
    } else {
      _selectedWalletName = _toWallet.name;
      debugPrint(_selectedWalletName);
    }

    return InputTile(
        hint: _toWalletInputTileHint,
        fieldName: _fieldName,
        inputField: TextButton(
            onPressed: () => showCupertinoModalBottomSheet(
                expand: false,
                context: context,
                builder: (context) => WalletSelectScreen(
                      selectWalletType: SelectWalletType.to,
                    )),
            child: Text(_selectedWalletName)));
  }

  InputTile _categoryInputTile() {
    return InputTile(
      hint: _categoryInputTileHint,
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
                    .map(
                      (e) => DropdownMenuItem<String>(
                          child: Row(
                        children: [
                          Icon(Icons.circle,
                              color:
                                  Color(int.parse('FF${e.color}', radix: 16))),
                          SizedBox(width: 8),
                          Text(e.name),
                        ],
                      )),
                    )
                    .toList(),
                onChanged: (val) {
                  _transaction.category = categories.firstWhere((element) => element.name == val).id;
                  widget.transaction?.category = categories
                      .firstWhere((element) => element.name == val)
                      .id;
                });
          }),
    );
  }

  InputTile _transactionTitleInputTile() {
    return InputTile(
        fieldName: "Transaction Title",
        inputField: TextTypeTextFormField(
          onTap: _onTap(ref),
          onSaved: _transactionTitleOnSaved(),
          validator: _transactionTiltleValidator(),
        ));
  }

  FormFieldValidator _transactionTiltleValidator() {
    return (value) {
      if (value == null || value.isEmpty) {
        return "Input Value";
      }
      return null;
    };
  }

  FormFieldSetter _transactionTitleOnSaved() {
    return (value) {
      _transaction.title = value;
      widget.transaction?.title = value;
    };
  }

  GestureTapCallback _onTap(WidgetRef ref) {
    return () {
      final scrollController = ref.watch(transactionScrollControllerProvider);
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    };
  }

  InputTile _amountInputTile() {
    return InputTile(
        fieldName: "Amount",
        inputField: NumberTypeTextFormField(
          onTap: () {},
          validator: _amountValidator(),
          onSaved: _amountOnSaved(),
        ));
  }

  FormFieldValidator _amountValidator() {
    return (value) {
      if (value == null || value.isEmpty) {
        return "Input Value";
      }
      return null;
    };
  }

  FormFieldSetter _amountOnSaved() {
    return (value) {
      _transaction.amount = double.parse(value);
      widget.transaction?.amount = double.parse(value);
    };
  }

  InputTile _selectDateInputTile() {
    String _buttonText = "";
    if (widget.isEdit) {
      _buttonText = CustomDateUtils().dateToFyyyyMMdd(widget.transaction!.date);
    } else {
      _buttonText = CustomDateUtils().dateToFyyyyMMdd(_transaction.date);
    }

    return InputTile(
      fieldName: "Select Date",
      inputField: TextButton(
        child: Text(
          _buttonText,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        onPressed: () => showCupertinoModalPopup(
          context: context,
          builder: (context) => Material(
            child: CalendarDatePicker2(
              onValueChanged: (value) {
                if (value[0] != null) {
                  setState(() {
                    widget.transaction?.date = value[0]!;
                    _transaction.date = value[0]!;
                  });
                }
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
