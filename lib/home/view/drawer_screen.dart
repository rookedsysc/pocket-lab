import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pocket_lab/home/view/menu_screen.dart';
import 'package:pocket_lab/home/view/home_screen.dart';

final zoomDrawerControllerProvider = Provider<ZoomDrawerController>((ref) {
  final zoomDrawerController = ZoomDrawerController();
  return zoomDrawerController;
});

class DrawerScreen extends ConsumerStatefulWidget {
  static const routeName = 'root_screen';
  const DrawerScreen({super.key});

  @override
  ConsumerState<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends ConsumerState<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    final double _slideWidth = MediaQuery.of(context).size.width * 0.9;
    final _zoomDrawerController = ref.watch(zoomDrawerControllerProvider);

    return Scaffold(
      body: ZoomDrawer(
        style: DrawerStyle.style3,
        controller: _zoomDrawerController,
        //: drawer  열었을 때 열리는 화면
        menuScreen: MenuScreen(),
        mainScreen: HomeScreen(),
        //# Drawer 열었을 때 main화면 크기
        //: 작을 수록 화면 커짐
        mainScreenScale: 0.0,
        borderRadius: 0.0,
        showShadow: false,
        //# 기울기 
        angle: 0.0,
        drawerShadowsBackgroundColor: Colors.grey,
        //# slide 사이즈
        slideWidth: _slideWidth,
        // //# 옆으로 드래그 했을 때 drawer 열리지 않음
        // disableDragGesture: true,
      ),
    );
  }
}