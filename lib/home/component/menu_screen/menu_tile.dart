import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';
import 'package:pocket_lab/home/view/menu_screen/icon_select_screen.dart';
import 'package:sheet/route.dart';

class MenuTile extends ConsumerWidget {
  final Wallet wallet;
  const MenuTile({required this.wallet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
            SlidableAction(
              onPressed: (_) {
                Navigator.of(context).push(
                  CupertinoSheetRoute<void>(
                      initialStop: 0.7,
                      stops: <double>[0, 0.7, 1],
                      //: Screen은 이동할 스크린
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      builder: (BuildContext context) => InputModalScreen(
                          isSave: false,
                          formKey: _formKey,
                          inputTile: _inputTileList(context, ref),
                          onSavePressed: () {})),
                );
              },
              backgroundColor: Colors.grey,
              foregroundColor: Colors.black,
              icon: Icons.edit,
              label: "Edit",
            ),
            //# 지갑 삭제
            SlidableAction(
              onPressed: (_) {},
              backgroundColor: Colors.red,
              foregroundColor: Colors.black,
              icon: Icons.delete,
              label: "Del",
            )
          ],
        ),
        child: Container(
            height: 50,
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Image.asset(
                    wallet.imgAddr,
                    height: 30,
                    width: 30,
                  ),
                ),
                Text(
                  wallet.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  wallet.budget.amount.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )),
      ),
    );
  }

  List<InputTile> _inputTileList(BuildContext context, WidgetRef ref) {
    String walletName = "";
    final scrollController = ref.watch(inputModalScrollProvider);
    return [
      // icon 선택
      InputTile(
        fieldName: "Icon",
        inputField: TextButton(
          onPressed: () {
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
          child: Text("SelectIcon"),
        ),
      ),

      InputTile(
          fieldName: "지갑 이름",
          inputField: TextFormField(
            //: amount section에 입력하면 숫자만 입력되게 함
            keyboardType: TextInputType.text,
            textAlign: TextAlign.right,
            //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
            onTap: () {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            validator: (String? val) {
              // null인지 check
              if (val == null || val.isEmpty) {
                return ('Input Value');
              }

              return null;
            },
            //: 입력한 값 저장
            onSaved: ((newValue) {
              walletName = newValue!;
            }),
          )),
    ];
  }
}
