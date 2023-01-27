import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/constant/bank_icon.dart';

class IconSelectScreen extends ConsumerWidget {
  const IconSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankIconKeys = bankIcon.keys.toList();
    return Scaffold(
      body: GridView(
        //# 행 갯수, 패딩, 가로 세로 비율
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

            //: 1개의 Row에 보여줄 Column 갯수
            crossAxisCount: 8,
            //: 가로 세로 비율
            childAspectRatio: 1,
            //: 가로 패딩
            mainAxisSpacing: 4,
            //: 세로 패딩
            crossAxisSpacing: 4),
        children: List.generate(bankIconKeys.length,
            (index) => Image.asset(bankIcon[bankIconKeys[index]]!)).toList(),
      ),
    );
  }
}
