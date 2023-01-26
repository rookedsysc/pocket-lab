import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class WalletCardSlider extends ConsumerWidget {
  const WalletCardSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int initialIndex = 0;

    //? 모든 지갑을 가져와서 watch 해줌 > 지갑 list에 변경이 있으면 getWallet 실행
    final walletFuture = ref.watch(walletProvider);

    return walletFuture.maybeWhen(
      data: (walletRepository) {
        final walletsStream = walletRepository.getWalletsStream();

        return StreamBuilder(
            stream: walletsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final wallets = snapshot.data!;
              return CarouselSlider.builder(
                options: CarouselOptions(
                  aspectRatio: 2.0,
                  disableCenter: true,
                  enlargeCenterPage: true,
                  initialPage: initialIndex,
                ),
                itemCount: wallets.length,
                itemBuilder: (context, index, realIndex) {
                  return wallets[index].walletToWalletCard();
                },
              );
            });
      },
      orElse: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
