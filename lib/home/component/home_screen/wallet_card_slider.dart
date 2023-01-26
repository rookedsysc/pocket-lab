import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:pocket_lab/home/component/home_screen/wallet_card.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class WalletCardSlider extends ConsumerWidget {
  const WalletCardSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int initialIndex = 0;

    //? 모든 지갑을 가져와서 watch 해줌 > 지갑 list에 변경이 있으면 getWallet 실행
    return ref.watch(walletProvider).when(data: (walletRepository) {
      return StreamBuilder(
          stream: walletRepository.getAllWallets(),
          builder: ((context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final wallets = snapshot.data!;

            return CarouselSlider.builder(
              options: CarouselOptions(
                  aspectRatio: 2.0,
                  disableCenter: true,
                  enlargeCenterPage: true,
                  initialPage: initialIndex),
              itemCount: wallets.length,
              itemBuilder: (context, index, realIndex) {
                return wallets[index].walletToWalletCard();
              },
            );
          }));
    }, error: (err, StackTrace) {
      return Center(
        child: Text(err.toString()),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
