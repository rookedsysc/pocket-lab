import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';
import 'package:pocket_lab/home/view/menu_screen/icon_select_screen.dart';
import 'package:pocket_lab/home/view/menu_screen/wallet_config_screen.dart';
import 'package:sheet/route.dart';

class WalletTile extends ConsumerStatefulWidget {
  Wallet wallet;
  WalletTile({required this.wallet, super.key});

  @override
  ConsumerState<WalletTile> createState() => _MenuTileState();
}

class _MenuTileState extends ConsumerState<WalletTile> {

  @override
  Widget build(BuildContext context) {
    final zoomDrawerController = ref.watch(zoomDrawerControllerProvider);
    return GestureDetector(
      onTap: () {
        zoomDrawerController.toggle!();
      },
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            //# 지갑 수정
            _walletEdit(context),
            //# 지갑 삭제
            _walletDelete()
          ],
        ),
        child: Container(
            //: container  바깥 여백
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 4),
            //: container 안 여백
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).cardColor,
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
                    _walletBalnce(context),
                  ],
                ),
                _budgetAmountPerPerioid(context)
              ],
            )),
      ),
    );
  }

  Widget _budgetAmountPerPerioid(BuildContext context) {
    if (widget.wallet.budgetType == BudgetType.dontSet) {
      return SizedBox();
    }
    return Text(
      "${widget.wallet.budget.amount} / ${widget.wallet.budget.budgetPeriod}",
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Colors.grey, fontSize: 10.0),
    );
  }

  Text _walletBalnce(BuildContext context) {
    return Text(
      widget.wallet.balance.toString(),
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
        ),
      ],
    );
  }

  SlidableAction _walletDelete() {
    return SlidableAction(
      onPressed: (_) async {
        final int _walletCount =
            await (await ref.read(walletRepositoryProvider.future))
                .getWalletCount();

        if (_walletCount == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("지갑은 최소 한 개 이상 있어야 합니다."),
            ),
          );

          return;
        }

        (await ref.read(walletRepositoryProvider.future))
            .deleteWallet(widget.wallet);
      },
      //TODO: 삭제시 데이터가 한 개 뿐이라면 삭제 불가능하게 dialog 띄우기
      backgroundColor: Colors.red,
      foregroundColor: Colors.black,
      icon: Icons.delete,
      label: "Del",
    );
  }

  SlidableAction _walletEdit(BuildContext context) {
    return SlidableAction(
      onPressed: (_) {
        Navigator.of(context).push(CupertinoSheetRoute<void>(
          initialStop: 0.7,
          stops: <double>[0, 0.7, 1],
          //: Screen은 이동할 스크린
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          builder: (BuildContext context) => WalletConfigScreen(
            wallet: widget.wallet,
          ),
        ));
      },
      backgroundColor: Colors.grey,
      foregroundColor: Colors.black,
      icon: Icons.edit,
      label: "Edit",
    );
  }
}