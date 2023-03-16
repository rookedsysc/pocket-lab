import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/component/chart_type_segement.dart';
import 'package:pocket_lab/chart/constant/chart_type.dart';
import 'package:pocket_lab/chart/view/category_pie_chart_view.dart';
import 'package:pocket_lab/chart/view/trend_chart_view.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(() {
      tabListner();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: Column(
            children: [
              ChartTypeSegement(onValueChanged: _onValueChanged(),),
              Expanded(
                child: TabBarView(
                    // 좌우로 스크롤 안되게 해줌
                    physics: NeverScrollableScrollPhysics(),
                    controller: controller,
                    children: [
                      TrendChartView(),
                      CategoryPieChartView(),
                      CategoryPieChartView(),
                      CategoryPieChartView(),
                    ]),
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
    }
  }
}
