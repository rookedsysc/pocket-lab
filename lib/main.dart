
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/view/root_tab.dart';
import 'package:pocket_lab/goal/view/goal_screen.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';
import 'package:pocket_lab/home/view/home_screen.dart';
import 'package:pocket_lab/transaction/view/transaction_config_screen.dart';
import 'package:pocket_lab/utils/app_init.dart';
import 'package:sheet/route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(
  child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //! 어플리케이션 초기화 작업
    AppInit(ref).main();
    
    return MaterialApp(
      theme: _theme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system,

      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  MaterialPageRoute? _onGenerateRoute(settings) {
    switch (settings.name) {
      case('/'):
        return MaterialExtendedPageRoute(builder: ((_) => RootTab()));
      case('/drawer_screen') :
        return MaterialExtendedPageRoute(builder: ((_) => DrawerScreen()));
      case('/drawer_screen/goal_screen') :
        return MaterialExtendedPageRoute(builder: (((_) => GoalScreen())));
    }
    return null;
  }

  final ThemeData _theme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(236, 237, 240, 1),
    //* Bottom Navigation Bar 색
    canvasColor: const Color.fromRGBO(236, 237, 240, 1),

    iconTheme: const IconThemeData(color: Colors.blue),

    //# 메인 색상
    primaryColor: const Color.fromRGBO(74, 110, 94, 1),
    primaryColorLight: const Color.fromRGBO(74, 110, 94, 0.75),

    //# 텍스트 색상
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      //: 보통 글귀
      bodyMedium: TextStyle(color: Colors.black, fontSize: 12),
      bodySmall: TextStyle(color: Colors.black, fontSize: 10),
    ),

    cardColor: Colors.white
  );

  final ThemeData _darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(30, 30, 30, 1),
    //* Bottom Navigation Bar 색
    canvasColor: const Color.fromRGBO(30, 30, 30, 1),

    iconTheme: const IconThemeData(color: Colors.blue),

    //# 메인 색상
    primaryColor: const Color.fromRGBO(74, 110, 94, 1),
    primaryColorLight: const Color.fromRGBO(74, 110, 94, 0.75),

    //# 텍스트 색상
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      //: 보통 글귀
      bodyMedium: TextStyle(color: Colors.white, fontSize: 12),
      bodySmall: TextStyle(color: Colors.white, fontSize: 10),
    ),

    cardColor: Colors.black,
  );
}

