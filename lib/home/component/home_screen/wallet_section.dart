import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';

class WalletSection extends ConsumerWidget {
  const WalletSection({
    super.key,
    required this.iconTheme,
  });

  final IconThemeData iconTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomDrawerController = ref.read(zoomDrawerControllerProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => zoomDrawerController.toggle!(),
            icon: Icon(Icons.wallet_outlined, color: iconTheme.color),
          ),
          HeaderCollection(
            headerType: HeaderType.wallet,
          ),
        ],
      ),
    );
  }
}
