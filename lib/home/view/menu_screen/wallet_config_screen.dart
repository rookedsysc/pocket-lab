import 'dart:ffi';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
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
  WalletConfigScreen({this.wallet, super.key});

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
        isSave: false,
        formKey: _formKey,
        inputTile: _inputTileList(context),
        onSavePressed: () async {
          debugPrint("widget wallet name : ${widget.wallet?.name}");

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
                await ref.read(walletRepositoryProvider.future);
            if (widget.wallet != null) {
              await walletRepository.configWallet(widget.wallet!);
            } else {
              //: 선택된 아이콘 저장
              await walletRepository.configWallet(_wallet);
            }
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
    if (budgetType == BudgetType.perSpecificDate) {
      if (widget.wallet != null && widget.wallet!.budget.budgetDate != null) {
        print("DateTime.parse(widget.wallet!.budget.budgetDate!)");
      }
    }
    return 0;
  }

  List<InputTile> _inputTileList(BuildContext context) {
    final budgetType = ref.watch(budgetTypeProvider);
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
        inputField: TextFormField(
            //: 숫자만 입력
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            //: 키보드가 숫자만 표시됨
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
            validator: !isDontSetType ? _amountInputTileValidator() : null,
            //: 입력한 값 저장
            onSaved: (_amountInputTileOnSaved),
            onTap: _onTap,
            decoration: InputDecoration(
              hintText: widget.wallet?.budget.amount != null
                  ? widget.wallet?.budget.amount.toString()
                  : "0",
              border: InputBorder.none,
            )));
  }

  void _amountInputTileOnSaved(String? newValue) {
    if (newValue == null || newValue.isEmpty) return;
    if (widget.wallet == null) {
      _wallet.budget.amount = int.parse(newValue);
    }
    widget.wallet?.budget.amount = int.parse(newValue);
  }

  FormFieldValidator<String?> _amountInputTileValidator() => (String? val) {
        //: 이미 예산 금액이 있을 경우 그냥 통과
        if (widget.wallet?.budget.amount != null) {
          return null;
        }

        // null인지 check
        //: edit mode일 경우 wallet의 결과가 null이 아니어서
        //: 값을 입력하지 않아도 해당 validator를 통과함
        if (val == null || val.isEmpty) {
          return ('Input Value');
        }

        //: 예산 금액이 1보다 작을 경우
        if (int.parse(val) < 1) {
          return "The budget amount must be greater than zero.";
        }

        return null;
      };

  InputTile _isSpecificDateInputTile(bool isSpecificDateType) {
    late String _selectedDate;
    if (widget.wallet?.budget.budgetDate != null) {
      _selectedDate = CustomDateUtils.dateToFyyyyMMdd(
          DateTime.parse(widget.wallet!.budget.budgetDate!));
    } else {
      _selectedDate = "SelectDate";
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
                              _wallet.budget.budgetDate = value[0].toString();
                            }
                            widget.wallet?.budget.budgetDate =
                                value[0].toString();
                            debugPrint(
                                "[WalletConfigScreen]\n\nwidget.wallet?.budget.budgetDate = ${widget.wallet?.budget.budgetDate}");
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          config: CalendarDatePicker2Config(
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
      initialValue = widget.wallet!.budgetType;
    } else {
      initialValue = ref.read(budgetTypeProvider);
    }

    return InputTile(
      fieldName: "Budget Type",
      // hint: "none / perWeek / perMonth / perSpecificDate",
      inputField: DropdownButton<BudgetType>(
          underline: Container(
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          value: ref.watch(budgetTypeProvider),
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
          onTap: () {
            //: Icon Select Screen으로 이동
            Navigator.of(context).push(
              CupertinoSheetRoute<void>(
                initialStop: 0.6,
                stops: <double>[0, 0.6, 1],
                // Screen은 이동할 스크린
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                builder: (context) => IconSelectScreen(),
              ),
            );
          },
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
        inputField: TextFormField(
            keyboardType: TextInputType.text,
            textAlign: TextAlign.right,
            //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
            validator:
                widget.wallet == null ? _walletNameInputTileValidator() : null,
            //: 입력한 값 저장
            onSaved: (_walletNameInputTileOnSaved),
            onTap: _onTap,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.wallet?.name ?? null)));
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
      inputField: TextFormField(
          //: 키보드가 숫자만 표시됨
          keyboardType: TextInputType.number,
          //: 숫자만 입력되게 함
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          textAlign: TextAlign.right,
          //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
          onTap: _onTap,
          //: 입력한 값 저장
          onSaved: _balanceInputTileOnSaved,
          decoration: InputDecoration(
            hintText: widget.wallet?.balance.toString() ?? null,
            border: InputBorder.none,
          )),
    );
  }

  void _balanceInputTileOnSaved(String? newValue) {
    if (newValue == null || newValue.isEmpty) return;
    if (widget.wallet == null) {
      _wallet.balance = int.parse(newValue);
      return;
    }
    widget.wallet?.balance = int.parse(newValue);
  }
}
