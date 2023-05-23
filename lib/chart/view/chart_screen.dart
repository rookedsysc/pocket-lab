import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/component/chart_type_segement.dart';
import 'package:pocket_lab/chart/constant/chart_type.dart';
import 'package:pocket_lab/chart/view/category_chart_view.dart';
import 'package:pocket_lab/chart/view/time_heatmap_chart_view.dart';
import 'package:pocket_lab/chart/view/trend_chart_view.dart';
import 'package:pocket_lab/common/constant/ad_unit_id.dart';
import 'package:pocket_lab/common/util/daily_budget.dart';
import 'package:pocket_lab/common/view/loading_view.dart';
import 'package:pocket_lab/common/widget/banner_ad_container.dart';
import 'dart:io' show Platform;

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen>
  with SingleTickerProviderStateMixin {
  late TabController controller;
  bool _trendUpdated = false;
  int index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = TabController(length: 3, vsync: this, initialIndex: ref.watch(chartTypeProvider));
    controller.addListener(() {
      tabListner();
    });
    _onRefresh(ref);
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    await DailyBudget().add(ref);
    _trendUpdated = true;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(!_trendUpdated){
      return LoadingView();
    }

    return Material(
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: Column(
            children: [
              BannerAdContainer(
                  adUnitId: Platform.isAndroid
                      ? CHART_PAGE_BANNER_AOS
                      : CHART_PAGE_BANNER_IOS),
              SizedBox(
                height: 8,
              ),
              ChartTypeSegement(
                onValueChanged: _onValueChanged(),
              ),
              Expanded(
                child: TabBarView(
                  // 좌우로 스크롤 안되게 해줌
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: [
                    TrendChartView(),
                    CategoryChartView(),
                    TimeHeatMapChartView()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // Material(
    //   child: Scaffold(
    //     body: CupertinoPageScaffold(
    //       child: SafeArea(
    //           top: true,
    //           child: ListView(
    //             children: [
    //               ChartTypeSegement(),

    //               ///* Trend Chart
    //               TrendChartView(),
    //               //* Category Chart
    //               Padding(
    //                 padding: const EdgeInsets.all(16.0),
    //                 child:
    //                     HeaderCollection(headerType: HeaderType.categoryChart),
    //               ),
    //               MonthPicker()
    //             ],
    //           )),
    //     ),
    //   ),
    // );
  }

  ValueChanged _onValueChanged() {
    return (value) {
      controller.animateTo(value);
      ref.refresh(chartTypeProvider.notifier).state = value;
    };
  }

  void tabListner() {
    if (mounted) {
      index = ref.watch(chartTypeProvider);
      controller.animateTo(index);
    }
  }
}
