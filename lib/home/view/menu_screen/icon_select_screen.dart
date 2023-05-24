import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/constant/bank_icon.dart';


final selectedIconProvider = StateProvider<String>((ref) {
  String defaultIcon = "asset/img/bank/금융아이콘_PNG_토스.png";
  return defaultIcon;
});


class IconSelectScreen extends ConsumerWidget {
  const IconSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData _theme = Theme.of(context);
    final bankIconKeys = koreanBankIcon.keys.toList();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: _theme.textTheme.bodyLarge?.color,
        elevation: 0,
        backgroundColor: _theme.scaffoldBackgroundColor,
        title: Text(
          "Select Icon",
          style: _theme.textTheme.bodyLarge,
        ),
      ),
      body: GridView(
        //# 행 갯수, 패딩, 가로 세로 비율
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //: 1개의 Row에 보여줄 Column 갯수
            crossAxisCount: 5,
            //: 가로 세로 비율
            childAspectRatio: 1 / 1.3,
            //: 세로 패딩
            mainAxisSpacing: 12,
            //: 가로 패딩
            crossAxisSpacing: 12),
        children: List.generate(
            bankIconKeys.length,
            (index) => GestureDetector(
                  onTap: () {
                    try {
                      ref.read(selectedIconProvider.notifier).state =
                          koreanBankIcon[bankIconKeys[index]]!;
                    } catch (e) {
                      ref.read(selectedIconProvider.notifier).state =
                          "asset/img/bank/금융아이콘_PNG_토스.png";
                      debugPrint(
                          "[Icon Select Screen] Error Alert : e.toString()");
                    }

                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(12),
                            child: Image.asset(koreanBankIcon[bankIconKeys[index]]!)),
                        Text(
                          bankIconKeys[index],
                          style: _theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                )).toList(),
      ),
    );
  }
}
