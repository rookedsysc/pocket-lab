import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/constant/init_screen.dart';
import 'package:pocket_lab/common/provider/provider_logger.dart';
import 'package:pocket_lab/goal/view/goal_screen.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';
import 'package:sheet/route.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await EasyLocalization.ensureInitialized();

  runApp(ProviderScope(
    observers: [
      Logger()
    ],
    child: EasyLocalization(
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ko', 'KR'),
        ],
        path: 'asset/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp()),
  ));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      ///* easy locaization init
      supportedLocales: context.supportedLocales,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,

      theme: _theme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system,

      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  MaterialPageRoute? _onGenerateRoute(settings) {
    switch (settings.name) {
      case ('/'):
        return MaterialExtendedPageRoute(builder: ((_) => InitScreen()));
      case ('/drawer_screen'):
        return MaterialExtendedPageRoute(builder: ((_) => DrawerScreen()));
      case ('/drawer_screen/goal_screen'):
        return MaterialExtendedPageRoute(builder: (((_) => GoalScreen())));
    }
    return null;
  }

  final ThemeData _theme = ThemeData(
      scaffoldBackgroundColor: const Color.fromRGBO(243, 244, 252, 1),
      //* Bottom Navigation Bar 색
      canvasColor: const Color.fromRGBO(236, 237, 240, 1),
      iconTheme: const IconThemeData(color: Colors.black),

      //# 메인 색상
      primaryColor: Color.fromRGBO(52, 120, 246, 1),
      primaryColorLight: Color.fromRGBO(89, 171, 225, 1),

      //# 텍스트 색상
      fontFamily: 'Korail',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w900),
        //: 보통 글귀
        bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
        bodySmall: TextStyle(color: Colors.black, fontSize: 10),
      ),
      cardColor: Colors.white);

  final ThemeData _darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
    //* Bottom Navigation Bar 색
    canvasColor: const Color.fromRGBO(30, 30, 30, 1),

    iconTheme: const IconThemeData(color: Colors.white),

    //# 메인 색상
    primaryColor: Color.fromRGBO(52, 120, 246, 1),
    primaryColorLight: Color.fromRGBO(89, 171, 225, 1),

    //# 텍스트 색상
    fontFamily: 'Korail',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 24),
      //: 보통 글귀
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      bodySmall: TextStyle(color: Colors.white, fontSize: 10),
    ),

    cardColor: const Color.fromRGBO(30, 30, 30, 1),
  );
}
