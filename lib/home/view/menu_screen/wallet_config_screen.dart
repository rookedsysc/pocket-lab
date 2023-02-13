import 'dart:ffi';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/custom_text_form_field.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/common/util/get_daily_budget.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/home/component/menu_screen/wallet_tile.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/provider/budget_type_provider.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/home/view/menu_screen/icon_select_screen.dart';
import 'package:sheet/route.dart';

final walletConfigScrollProvider = Provider<ScrollController>((ref) {
  final ScrollController _scrollController = ScrollController();
  return _scrollController;
});

class WalletConfigScreen extends ConsumerStatefulWidget {
  Wallet? wallet = Wallet(budget: BudgetModel(), name: '');
  bool isEdit;
  WalletConfigScreen({required this.isEdit, this.wallet, super.key});

  @override
  ConsumerState<WalletConfigScreen> createState() => _WalletConfigScreenState();
}

class _WalletConfigScreenState extends ConsumerState<WalletConfigScreen> {
  Wallet _wallet = Wallet(budget: BudgetModel(), name: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return InputModalScreen(
        scrollController: ref.watch(walletConfigScrollProvider),
        isEdit: widget.isEdit,
        formKey: _formKey,
        //# Input Tile List
        inputTile: _inputTileList(context),
        onSavePressed: () async {
          //: 오류가 없다면 실행하는 부분
          //: 여기서 오류가 없다는 것은 값이 모두 들어 갔다는 것임.
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            //: 선택된 주기 확인
            widget.wallet?.budget.budgetPeriod = getBudgetPeriod();
            _wallet.budget.budgetPeriod = getBudgetPeriod();

            //: 선택된 아이콘 저장
            widget.wallet?.imgAddr =
                ref.read(selectedIconProvider.notifier).state;
            _wallet.imgAddr = ref.read(selectedIconProvider.notifier).state;

            //: 추가 / 수정
            final walletRepository =
                ref.read(walletRepositoryProvider.notifier);
            //: widget.wallet != null일 경우는 edit mode
            if (widget.wallet != null) {
              await walletRepository.configWallet(widget.wallet!);
            } else {
              //: 선택된 아이콘 저장
              //: add mode
              await walletRepository.configWallet(_wallet);
            }
            await GetDailyBudget(ref).main();
            Navigator.of(context).pop();
          }
        });
  }

  int? getBudgetPeriod() {
    final budgetType = ref.watch(budgetTypeProvider);

    switch (budgetType) {
      case BudgetType.perWeek:
        return 7;
      case BudgetType.perMonth:
        return 30;
      default:
        break;
    }
    return 0;
  }

  List<InputTile> _inputTileList(BuildContext context) {
    BudgetType budgetType = ref.watch(budgetTypeProvider);
    if (widget.wallet != null) {
      budgetType = widget.wallet!.budgetType;
    }

    bool _isSpecificDateType = budgetType == BudgetType.perSpecificDate;
    bool _isDontSetType = budgetType == BudgetType.dontSet;

    //: budget type이 don't set인지 확인
    return [
      _walletNameInputTile(),
      _selectIconInputTile(context),
      _balanceInputTile(),
      _selectBudgetTypeInputTile(),

      ///# : budget type에 따라 다른 input tile을 보여줌
      if (!_isDontSetType && _isSpecificDateType)
        _isSpecificDateInputTile(_isSpecificDateType),
      if (!_isDontSetType) _budgetAmountInputTile(_isDontSetType)
    ];
  }

  InputTile _budgetAmountInputTile(bool isDontSetType) {
    return InputTile(
      fieldName: "Budget Amount",
      inputField: NumberTypeTextFormField(
        onTap: _onTap,
        onSaved: _amountInputTileOnSaved,
        validator: !isDontSetType ? _amountInputTileValidator() : null,
        hintText: widget.wallet?.budget.balance != null
            ? widget.wallet?.budget.balance.toString()
            : "0",
      ),
    );
  }

  void _amountInputTileOnSaved(String? newValue) {
    if (newValue == null || newValue.isEmpty) return;
    _wallet.budget.balance = double.parse(newValue);
    _wallet.budget.originBalance = double.parse(newValue);
    widget.wallet?.budget.originBalance = double.parse(newValue);
    widget.wallet?.budget.balance = double.parse(newValue);
  }

  FormFieldValidator<String?> _amountInputTileValidator() => (String? val) {
        //: 이미 예산 금액이 있을 경우 그냥 통과
        if (widget.wallet?.budget.balance != null) {
          return null;
        }

        /// newValue가 ₩50,000와 같은 형태로 들어오기 때문에
        /// 숫자만 추출하여 double로 변환
        String _amount = CustomNumberUtils.getNumberFromString(val!);

        // null인지 check
        //: edit mode일 경우 wallet의 결과가 null이 아니어서
        //: 값을 입력하지 않아도 해당 validator를 통과함
        if (_amount == null || _amount.isEmpty) {
          return ('Input _amountue');
        }

        //: 예산 금액이 1보다 작을 경우
        if (int.parse(_amount) < 1) {
          return "The budget amount must be greater than zero.";
        }

        return null;
      };

  InputTile _isSpecificDateInputTile(bool isSpecificDateType) {
    late String _selectedDate;
    if (widget.wallet?.budget.budgetDate != null) {
      _selectedDate = DateTimeDateUtils()
          .dateToFyyyyMMdd(widget.wallet!.budget.budgetDate!);
    } else {
      _selectedDate = _wallet.budget.budgetDate == null
          ? "Select Date"
          : CustomDateUtils().dateToFyyyyMMdd(_wallet.budget.budgetDate!);
    }
    return InputTile(
        fieldName: "Date",
        inputField: TextButton(
            onPressed: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => Material(
                        child: CalendarDatePicker2(
                          onValueChanged: (value) {
                            if (widget.wallet == null) {
                              _wallet.budget.budgetDate = value[0];
                              _wallet.budget.originDay = value[0]!.day;
                            }
                            widget.wallet?.budget.budgetDate = value[0];
                            widget.wallet?.budget.originDay = value[0]!.day;
                            debugPrint(
                                "[WalletConfigScreen]\n widget.wallet?.budget.budgetDate = ${widget.wallet?.budget.budgetDate}");
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          config: CalendarDatePicker2Config(
                            firstDate: DateTime.now(),
                            lastDate: CustomDateUtils().getNextBugdetDate(
                                DateTime.now(), DateTime.now().day),
                            calendarType: CalendarDatePicker2Type.single,
                          ),
                          initialValue: [DateTime.now()],
                        ),
                      ));
            },

            ///: 선택된 시간이 없으면 "Select Date"를 보여주고, 있으면 선택된 시간을 보여줌
            child: Text(
              _selectedDate,
              textAlign: TextAlign.center,
            )));
  }

  InputTile _selectBudgetTypeInputTile() {
    BudgetType initialValue = BudgetType.dontSet;

    ///: edit mode일 경우
    ///: 해당 wallet의 budgetType을 가져옴
    if (widget.wallet != null) {
      debugPrint("Select Budget Type : ${widget.wallet!.budgetType.name}");
      initialValue = widget.wallet!.budgetType;
    } else {
      initialValue = ref.read(budgetTypeProvider);
    }

    return InputTile(
      fieldName: "Budget Type",
      // hint: "none / perWeek / perMonth / perSpecificDate",
      inputField: DropdownButton<BudgetType>(
          underline: Container(
            height: 0,
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          value: initialValue,
          isDense: true,
          items: BudgetType.values
              .map((item) => DropdownMenuItem<BudgetType>(
                    value: item,
                    child: Text(
                      item.name,
                    ),
                  ))
              .toList(),
          onChanged: (BudgetType? val) {
            ref.read(budgetTypeProvider.notifier).setBudgetType(val!);
            if (widget.wallet == null) {
              _wallet.budgetType = val;
              ref.read(budgetTypeProvider.notifier).setBudgetType(val);
              return;
            }
            widget.wallet?.budgetType = val;
          }),
    );
  }

  //# icon 선택
  InputTile _selectIconInputTile(BuildContext context) {
    return InputTile(
        fieldName: "Icon",
        inputField: GestureDetector(
          onTap: () => showCupertinoModalPopup(
              context: context, builder: (context) => IconSelectScreen()),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            //: 선태된 이미지
            child: Image.asset(
              ref.watch(selectedIconProvider),
              fit: BoxFit.fill,
            ),
          ),
        ));
  }

  //# 지갑 이름
  InputTile _walletNameInputTile() {
    return InputTile(
        fieldName: "Wallet Name",
        inputField: TextTypeTextFormField(
            validator:
                widget.wallet == null ? _walletNameInputTileValidator() : null,
            onTap: _onTap,
            onSaved: (_walletNameInputTileOnSaved),
            hintText: widget.wallet?.name ?? null));
  }

  void _onTap() {
    final scrollController = ref.watch(walletConfigScrollProvider);
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _walletNameInputTileOnSaved(String? newValue) {
    if (newValue == null || newValue.isEmpty) return;
    if (widget.wallet == null) {
      _wallet.name = newValue;
      return;
    }
    widget.wallet?.name = newValue;
  }

  FormFieldValidator<String?> _walletNameInputTileValidator() => (String? val) {
        // null인지 check
        if (val == null || val.isEmpty) {
          return ('Input Value');
        }

        return null;
      };

  //# 계좌 잔고
  InputTile _balanceInputTile() {
    return InputTile(
      fieldName: "Balance",
      inputField: NumberTypeTextFormField(
        onTap: _onTap,
        onSaved: (_balanceInputTileOnSaved),
        hintText: widget.wallet?.balance.toString() ?? null,
      ),
    );
  }

  void _balanceInputTileOnSaved(String? newValue) {
    if (newValue == null || newValue.isEmpty) return;
    /// newValue가 ₩50,000와 같은 형태로 들어오기 때문에
    /// 숫자만 추출하여 double로 변환
    String _amountOnlyDigit = CustomNumberUtils.getNumberFromString(newValue);
    if (widget.wallet == null) {
      _wallet.balance = double.parse(_amountOnlyDigit);
      return;
    }
    widget.wallet?.balance = double.parse(_amountOnlyDigit);
  }
}
