import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/view/root_tab.dart';
import 'package:pocket_lab/utils/app_init.dart';

class InitScreen extends ConsumerStatefulWidget {
  const InitScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InitScreenState();
}

class _InitScreenState extends ConsumerState<InitScreen> {
  bool isInitialized = false;

  Future<void> _initializeApp() async {
    // AppInit 실행
    final appInit = AppInit(ref);
    await appInit.main();

    // 초기화가 완료되면 _isInitialized를 true로 변경
    if (mounted) {
      setState(() {
        isInitialized = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    _initializeApp();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // _isInitialized가 false일 때는 Splash Screen을 보여줌
    if (!isInitialized) {
      return Scaffold(
        body: Center(
          child: Text("Loading..."),
        ),
      );
    }

    // _isInitialized가 true일 때는 RootTab()을 보여줌
    return RootTab();
  }
}
