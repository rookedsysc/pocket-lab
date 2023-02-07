import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:pocket_lab/home/component/home_screen/wallet_card.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class WalletCardSlider extends ConsumerStatefulWidget {
  const WalletCardSlider({super.key});

  @override
  ConsumerState<WalletCardSlider> createState() => _WalletCardSliderState();
}

class _WalletCardSliderState extends ConsumerState<WalletCardSlider> {
  @override
  Widget build(BuildContext context) {
    late int _initialIndex;

    return StreamBuilder(
          stream: ref.watch(walletRepositoryProvider.notifier).getAllWalletsStream(),
          builder: ((context, snapshot) {
            if (snapshot.data == null || snapshot.data!.length == 0) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }


            final wallets = snapshot.data!;
            _initialIndex = wallets.indexWhere((element) => element.isSelected);

            return CarouselSlider.builder(
              options: _carouselOptions(_initialIndex, wallets: wallets),
              itemCount: wallets.length,
              itemBuilder: (context, index, realIndex) {
                return wallets[index].walletToWalletCard();
              },
            );
          }));
  }

  CarouselOptions _carouselOptions(int _initialIndex,
      {required List<Wallet> wallets}) {
    return CarouselOptions(
        aspectRatio: 2.0,
        disableCenter: true,
        enlargeCenterPage: true,
        initialPage: _initialIndex,
        onPageChanged: (index, reason) async {
          await ref
              .read(walletRepositoryProvider.notifier)
              .setIsSelectedWallet(wallets[index].id);
        });
  }
}
