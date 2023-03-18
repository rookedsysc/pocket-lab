import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

enum SelectWalletType { from, to, select }

final toWalletProvider = StateProvider<Wallet?>((ref) {
  Wallet? wallet;
  return wallet;
});

class WalletSelectScreen extends ConsumerWidget {
  final SelectWalletType selectWalletType;
  const WalletSelectScreen({required this.selectWalletType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 15),
            _header(context),
            Expanded(
              child: StreamBuilder<List<Wallet>>(
                  stream: ref
                      .watch(walletRepositoryProvider.notifier)
                      .getAllWalletsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final List<Wallet> wallets = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GridView.builder(
                        itemBuilder: (context, index) => GestureDetector(
                          ///! wallet 선택시 실행되는 부분
                          onTap: _onTap(
                              context: context,
                              index: index,
                              ref: ref,
                              wallets: wallets),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _walletNameAndIcon(
                                        wallet: wallets[index],
                                        context: context),
                                    //: 지갑 잔액
                                    Text(
                                      wallets[index].balance.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        itemCount: wallets.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback _onTap(
      {required WidgetRef ref,
      required BuildContext context,
      required List<Wallet> wallets,
      required int index}) {
    final Wallet? fromWallet = ref.watch(walletRepositoryProvider);
    final Wallet? toWallet = ref.watch(toWalletProvider.notifier).state;
    return () async {
      if (selectWalletType == SelectWalletType.to) {
        //: 출발지 wallet과 동일한 wallet이라면 선택 안됨
        if (fromWallet == wallets[index]) {
          debugPrint("It is the same wallet as the source wallet");
          return null;
        } else {
          ref.refresh(toWalletProvider.notifier).state = wallets[index];
        }

        //: toWallet을 클릭해서 선택창 들어왔으면
        //: toWalletProvider에서 데이터 넣어줌
        ref.refresh(toWalletProvider.notifier).state = wallets[index];
      }
      //: 해당 구문에서 from Wallet Type일 때와
      //: select wallet일 때가 들어올 수 있음
      else {
        //: from wallet을 선택했을 경우
        //: to wallet과 같은지 확인해주는 구문을 실행
        if (selectWalletType == SelectWalletType.from) {
          if (toWallet == wallets[index]) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "It cannot be the same account as the receiving account")));
            return null;
          }
        }
        debugPrint("Selected Wallet: ${wallets[index].name}");
        await ref.refresh(walletRepositoryProvider.notifier).setIsSelectedWallet(wallets[index].id);
      }
      Navigator.of(context).pop();
    };
  }

  SizedBox _header(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Text(
        "Select Wallet",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _walletNameAndIcon(
      {required BuildContext context, required Wallet wallet}) {
    return Row(
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
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }
}
