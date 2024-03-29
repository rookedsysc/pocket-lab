import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/custom_slidable.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/common/util/daily_budget.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/provider/budget_type_provider.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';
import 'package:pocket_lab/home/view/menu_screen/wallet_config_screen.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

class WalletTile extends ConsumerStatefulWidget {
  Wallet wallet;
  WalletTile({required this.wallet, super.key});

  @override
  ConsumerState<WalletTile> createState() => _MenuTileState();
}

class _MenuTileState extends ConsumerState<WalletTile> {
  @override
  Widget build(BuildContext context) {
    debugPrint("build");
    final zoomDrawerController = ref.watch(zoomDrawerControllerProvider);
    return GestureDetector(
      onTap: () async {
        await ref
            .read(walletRepositoryProvider.notifier)
            .setIsSelectedWallet(widget.wallet.id);
        await DailyBudget().add(ref);

        zoomDrawerController.toggle!();
      },
      child: Slidable(
        //: 오른쪽에서 왼쪽으로 슬라이드시 발생하는 액션
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            //# 지갑 수정
            SlidableEdit(onPressed: _onEditPressed()),
            //# 지갑 삭제
            SlidableDelete(onPressed: _onDeletePressed()),
          ],
        ),
        child: Container(
          //: container  바깥 여백
          margin: EdgeInsets.only(left: 8, right: 8, bottom: 4),
          //: container 안 여백
          padding: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            //: isSelected인 타일 색상 primaryColor로
            color: widget.wallet.isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
          ),
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _walletNameAndIcon(context),
                  //: 지갑 잔액
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _walletBalnce(context),
                      _budgetAmountPerPerioid(context)
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _budgetAmountPerPerioid(BuildContext context) {
    if (widget.wallet.budgetType == BudgetType.dontSet) {
      return SizedBox();
    }

    //# BudgetType 별로 표시할 금액을 다르게 설정
    String _amountPerPeriod = "";
    //# Budget Type이 perSpecificDate일 경우
    if (widget.wallet.budgetType == BudgetType.perSpecificDate) {
      if (widget.wallet.budget.balance == null ||
          widget.wallet.budget.budgetDate == null) {
        return SizedBox();
      } else {
        _amountPerPeriod =
            "${CustomNumberUtils.formatCurrency(widget.wallet.budget.balance!)} / ${CustomDateUtils().diffDays(widget.wallet.budget.budgetDate!, DateTime.now())}";
      }
    }

    //# Budget Type이 7일 이나 30일 주기 일 경우
    else {
      if (widget.wallet.budget.balance == null ||
          widget.wallet.budget.budgetPeriod == null) {
        return SizedBox();
      } else {
        _amountPerPeriod =
            "${CustomNumberUtils.formatCurrency(widget.wallet.budget.balance!)} / ${widget.wallet.budget.budgetPeriod}";
      }
    }
    return Text(
      _amountPerPeriod,
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: Colors.grey),
    );
  }

  Text _walletBalnce(BuildContext context) {
    return Text(
      CustomNumberUtils.formatCurrency(widget.wallet.balance),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Row _walletNameAndIcon(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Image.asset(
            widget.wallet.imgAddr,
            height: 30,
            width: 30,
          ),
        ),
        Text(
          widget.wallet.name,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }

  SlidableActionCallback _onDeletePressed() {
    return (_) async {
      final int _walletCount =
          await ref.read(walletRepositoryProvider.notifier).getWalletCount();

      if (_walletCount == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("wallet delete alert".tr()),
          ),
        );

        return;
      }

      await ref
          .read(walletRepositoryProvider.notifier)
          .deleteWallet(widget.wallet);
      await ref
          .read(trendRepositoryProvider.notifier)
          .deleteTrend(widget.wallet.id);
      await ref
          .read(transactionRepositoryProvider.notifier)
          .deleteByWalletId(widget.wallet.id);

      //: 선택된 지갑이 삭제된 경우
      //: 다른 지갑 중 하나를 선택된 지갑으로 설정
      if (widget.wallet.isSelected == true) {
        final _walletRepository = ref.read(walletRepositoryProvider.notifier);
        final Wallet? _wallet = await _walletRepository.getSpecificWallet(null);
        if (_wallet != null) {
          debugPrint(_wallet.toString());
          _wallet.isSelected = true;
          await _walletRepository.configWallet(_wallet);
        }
      }
    };
  }

  SlidableActionCallback _onEditPressed() {
    return (_) {
      ref.read(budgetTypeProvider.notifier).setBudgetType(widget.wallet.budgetType);
      CupertinoScaffold.showCupertinoModalBottomSheet(
          context: context,
          builder: (context) {
            return WalletConfigScreen(
              wallet: widget.wallet,
              isEdit: true,
            );
          });
    };
  }
}
