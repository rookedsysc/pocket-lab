import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen ({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: (){
          _createRandomTrend(ref);
        }, child: Text("Create Random Trend")),
      ],
    );
  }

  Future<void> _createRandomTrend(WidgetRef ref) async{
    await ref.read(trendRepositoryProvider.notifier).createRandomTrend();
  }
}