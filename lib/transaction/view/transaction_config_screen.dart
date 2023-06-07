import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/custom_text_form_field.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/common/provider/date_picker_time_provider.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';
import 'package:pocket_lab/transaction/view/wallet_select_screen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
    categoryId: 1,
    transactionType: TransactionType.expenditure,
    walletId: 0,
  );
  //# Custom Validator Check
  String? _selectWalletInputTileHint;
  String? _toWalletInputTileHint;
  String? _categoryInputTileHint;

  GlobalKey _transactionTitleFormFieldKey = GlobalKey();
  GlobalKey _amountFormFieldKey = GlobalKey();

  @override
  void didChangeDependencies() {
    _transaction.transactionType = widget.transactionType;
    _getWallet();
    _transaction.categoryId = ref.read(categoryRepositoryProvider).first.id;

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
    return InputModalScreen(
        title: _getTitle(),
        scrollController: ref.read(transactionScrollControllerProvider),
        isEdit: widget.isEdit,
        formKey: _formKey,
        inputTile: _inputTileList(ref: ref),
        onSavePressed: _onSavedPress());
  }

  String _getTitle() {
    if (widget.transactionType == TransactionType.expenditure) {
      return "transaction config screen.expend".tr();
    } else if (widget.transactionType == TransactionType.income) {
      return "transaction config screen.income".tr();
    } else {
      return "transaction config screen.transfer".tr();
    }
  }

  List<InputTile> _inputTileList({required WidgetRef ref}) {
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
      _selectTimeInputTile(),
    ];
  }

  InputTile _selectTimeInputTile() {
    return InputTile(
      fieldName: "transaction config screen.time".tr(),
      inputField: TextButton(
        onPressed: () {
          showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return Material(
                  child: Container(
                    height: 300,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Theme.of(context).primaryColor),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        use24hFormat: true,
                        initialDateTime:
                            widget.transaction?.date ?? _transaction.date,
                        onDateTimeChanged: (time) {
                          if (widget.transaction != null) {
                            widget.transaction!.date = CustomDateUtils()
                                .mergeDateAndTime(
                                    date: widget.transaction!.date, time: time);
                          }
                          _transaction.date = CustomDateUtils().mergeDateAndTime(
                              date: _transaction.date, time: time);
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        mode: CupertinoDatePickerMode.time,
                      ),
                    ),
                  ),
                );
              });
        },
        child: Text(
          DateFormat('HH:mm')
              .format(widget.transaction?.date ?? _transaction.date),
        ),
      ),
    );
  }

  VoidCallback _onSavedPress() {
    //: 세 가지 경우가 있음
    //: 첫 번째 : 지출일 경우 - 카테고리, fromWallet 검증 필요
    //: 두 번째 : 수입일 경우 - fromWallet 검증 필요
    //: 세 번째 : 계좌 이체일 경우 - fromWallet, to Wallet 검증 필요
    return () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        if (!_getCustomValidatorCheck() && widget.transaction == null) {
          return null;
        }

        ///# 새로 추가하는 경우
        if (widget.transaction == null) {
          await changeWalletBalance(_transaction);
          await ref
              .read(transactionRepositoryProvider.notifier)
              .configTransaction(_transaction);
          await ref
              .read(trendRepositoryProvider.notifier)
              .syncTrend(_transaction.walletId);
        }

        ///# 기존에 있던 것을 수정하는 경우
        else {
          await changeWalletBalance(widget.transaction!);
          await ref
              .read(transactionRepositoryProvider.notifier)
              .configTransaction(widget.transaction!);
          await ref
              .read(trendRepositoryProvider.notifier)
              .syncTrend(widget.transaction!.walletId);
        }

        Navigator.of(context).pop();
      }
    };
  }

  //# Transaction Type에 따라서 기존 wallet의 잔고에 + -
  Future<void> changeWalletBalance(Transaction transaction) async {
    Wallet? _wallet = await ref
        .read(walletRepositoryProvider.notifier)
        .getSpecificWallet(transaction.walletId);
    
    Wallet? _toWallet = await ref
        .read(walletRepositoryProvider.notifier)
        .getSpecificWallet(transaction.toWallet);

    if (_wallet == null) {
      return;
    }
    if (widget.transaction != null) {
      _verifyAndUndoChanges(transaction, _wallet, _toWallet);
    }

    switch (widget.transactionType) {
      case TransactionType.expenditure:
        _wallet.balance -= transaction.amount;
        await ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
        break;
      case TransactionType.income:
        _wallet.balance += transaction.amount;
        await ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
        break;

      case TransactionType.remittance:
        if (_toWallet == null) {
          return;
        }
        _wallet.balance -= transaction.amount;
        _toWallet.balance += transaction.amount;
        ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
        ref.read(walletRepositoryProvider.notifier).configWallet(_toWallet);
        break;
    }
  }

  Future<void> _verifyAndUndoChanges(
      Transaction transaction, Wallet _wallet, Wallet? _toWallet) async {
    try {
      Transaction? _transaction = await ref
          .read(transactionRepositoryProvider.notifier)
          .getSpecificTransaction(transaction.id);
      bool _isNotNull(Transaction? tr) {
        return tr != null;
      }

      if (_isNotNull(_transaction) &&
          _transaction!.transactionType == TransactionType.income) {
        _wallet.balance -= _transaction.amount;
        await ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
      } else if (_isNotNull(_transaction) &&
          _transaction!.transactionType == TransactionType.expenditure) {
        _wallet.balance += _transaction.amount;
        await ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
      } else {
        _wallet.balance += _transaction!.amount;
        _toWallet!.balance -= transaction.amount;
        await ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
        await ref.read(walletRepositoryProvider.notifier).configWallet(_wallet);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool _getCustomValidatorCheck() {
    bool _check = true;
    final Wallet? _fromWallet = ref.watch(walletRepositoryProvider);
    final Wallet? _toWallet = ref.watch(toWalletProvider.notifier).state;
    //: 선택한 지갑 없으면 _check를 false로
    if (_fromWallet == null) {
      _selectWalletInputTileHint = "Select Wallet";
      _check = false;
    }

    //: 송금이면서 선택한 지갑이 없다면 snackBar 호출 후 함수 종료
    if (widget.transactionType == TransactionType.remittance &&
        _toWallet == null) {
      _toWalletInputTileHint = "Select To Wallet";
      _check = false;
    }

    //: 거래타입이 지출이고 widget.category가 존재하지 않으면 category 선택하라는 알림창 나옴
    if (widget.transactionType == TransactionType.expenditure &&
        widget.transaction?.categoryId == null &&
        widget.isEdit) {
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
      _fieldName = "transaction config screen.from wallet".tr();
    } else {
      _fieldName = "transaction config screen.select wallet".tr();
    }

    if (_selectWallet == null) {
      _selectedWalletName = "transaction config screen.select wallet".tr();
    } else {
      _selectedWalletName = _selectWallet.name;
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
        child: Text(_selectedWalletName),
      ),
    );
  }

  InputTile _toWalletInputTile(WidgetRef ref) {
    final Wallet? _toWallet = ref.watch(toWalletProvider.notifier).state;
    String _selectedWalletName;
    String _fieldName;

    _fieldName = "transaction config screen.to wallet".tr();
    if (_toWallet == null) {
      _selectedWalletName = "transaction config screen.to wallet".tr();
    } else {
      _selectedWalletName = _toWallet.name;
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
      fieldName: "transaction config screen.select category".tr(),
      inputField: StreamBuilder<List<TransactionCategory>>(
          stream: ref
              .watch(categoryRepositoryProvider.notifier)
              .allCategoriesStream(),
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
            String _initialValue;
            try {
              _initialValue = categories
                  .firstWhere(
                      (element) => element.id == _transaction.categoryId)
                  .name;

              if (widget.transaction != null) {
                _initialValue = categories
                    .firstWhere((element) =>
                        element.id == widget.transaction!.categoryId)
                    .name;
              }
            } catch (e) {
              _initialValue = categories.first.name;
            }

            return DropdownButton(
                underline: Container(
                  height: 0,
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                value: _initialValue,
                items: categories
                    .map(
                      (e) => DropdownMenuItem<String>(
                          value: e.name,
                          child: Row(
                            children: [
                              Icon(Icons.circle,
                                  color: ColorUtils.stringToColor(e.color)),
                              SizedBox(width: 8),
                              Text(
                                e.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          )),
                    )
                    .toList(),
                onChanged: (val) {
                  _transaction.categoryId = categories
                      .firstWhere((element) => element.name == val)
                      .id;
                  widget.transaction?.categoryId = categories
                      .firstWhere((element) => element.name == val)
                      .id;
                  if (mounted) {
                    setState(() {});
                  }
                });
          }),
    );
  }

  InputTile _transactionTitleInputTile() {
    return InputTile(
        formFieldKey: _transactionTitleFormFieldKey,
        fieldName: "transaction config screen.transaction title".tr(),
        inputField: TextTypeTextFormField(
          hintText: widget.transaction?.title,
          onTap: _onTap,
          onSaved: _transactionTitleOnSaved(),
          validator:
              widget.transaction == null ? _transactionTiltleValidator() : null,
        ));
  }

  FormFieldValidator _transactionTiltleValidator() {
    return (value) {
      if (value == null || value.isEmpty) {
        return "Input Value".tr();
      }
      return null;
    };
  }

  FormFieldSetter _transactionTitleOnSaved() {
    return (value) {
      _transaction.title = value;
      if (value.isNotEmpty) {
        widget.transaction?.title = value;
      }
    };
  }

  void _onTap() {
    final scrollController = ref.watch(transactionScrollControllerProvider);
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /* 
    GestureTapCallback _onTap(WidgetRef ref, GlobalKey key) {
    return () {
      final ScrollController scrollController =
          ref.read(transactionScrollControllerProvider);
      final keyContext = key.currentContext;

      if (keyContext != null) {
        // 위치를 얻습니다.
        final box = keyContext.findRenderObject() as RenderBox;
        scrollController.animateTo(
          box.localToGlobal(Offset.zero).dy,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    };
  }
  */

  InputTile _amountInputTile() {
    return InputTile(
        fieldName: "transaction config screen.amount".tr(),
        formFieldKey: _amountFormFieldKey,
        inputField: NumberTypeTextFormField(
          hintText: widget.transaction?.amount.toString(),
          onTap: _onTap,
          validator: widget.transaction == null ? _amountValidator() : null,
          onSaved: _amountOnSaved(),
        ));
  }

  FormFieldValidator _amountValidator() {
    return (value) {
      if (value == null || value.isEmpty) {
        return "Input Value".tr();
      }
      return null;
    };
  }

  FormFieldSetter _amountOnSaved() {
    return (value) {
      /// newValue가 ₩50,000와 같은 형태로 들어오기 때문에
      /// 숫자만 추출하여 double로 변환
      String _amountOnlyDigit = CustomNumberUtils.getNumberFromString(value);
      if (_amountOnlyDigit.isNotEmpty) {
        widget.transaction?.amount = double.parse(_amountOnlyDigit);
        _transaction.amount = double.parse(_amountOnlyDigit);
      }
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
      fieldName: "transaction config screen.date".tr(),
      inputField: TextButton(
        child: Text(
          _buttonText,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        onPressed: () => showCupertinoModalPopup(
          context: context,
          builder: (context) => Material(
              child: Container(
            height: 400,
            child: SfDateRangePicker(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              initialSelectedDate: widget.transaction == null
                  ? _transaction.date
                  : widget.transaction!.date,
              selectionMode: DateRangePickerSelectionMode.single,
              headerStyle: DateRangePickerHeaderStyle(
                  textStyle: Theme.of(context).textTheme.bodyLarge),
              monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: Theme.of(context).textTheme.bodyMedium),
              yearCellStyle: DateRangePickerYearCellStyle(
                  textStyle: Theme.of(context).textTheme.bodyMedium),
              monthViewSettings: DateRangePickerMonthViewSettings(
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: Theme.of(context).textTheme.bodySmall),
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                ref.refresh(datePickerTimeProvider.notifier).state = args.value;
                final DateTime selectedDate = args.value;
                print(selectedDate); // Do something with selectedDate
                if (args.value != null) {
                  widget.transaction?.date = args.value;
                  _transaction.date = args.value;
                  if (mounted) {
                    setState(() {});
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          )),
        ),
      ),
    );
  }
}
