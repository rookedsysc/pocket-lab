import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/home/model/trend_chart_data_model.dart';
import 'package:pocket_lab/home/model/trend_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';

class TrendChartToolTip extends ConsumerStatefulWidget {
  const TrendChartToolTip({super.key});

  @override
  ConsumerState<TrendChartToolTip> createState() => _TrendChartToolTipState();
}

class _TrendChartToolTipState extends ConsumerState<TrendChartToolTip> {
  Map<int, List<Trend>> trendList = {};

  @override
  void didChangeDependencies() {
    final futureTrends =
        ref.read(trendRepositoryProvider.notifier).getAllTrendsAsMap();
    futureTrends.then((value) {
      trendList = value;
      if (mounted) {
        setState(() {});
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(
            trendList.keys.length,
            (index) {
              int _indexKey = trendList.keys.toList()[index];
              return averageTooltip(
                  textTHeme: Theme.of(context).textTheme,
                  trends: trendList[_indexKey]!);
            },
          ),
        ],
      ),
    );
  }

  Widget averageTooltip({
    required TextTheme textTHeme,
    required List<Trend> trends,
  }) {
    List<TrendChartDataModel> chartData = [];
    chartData = TrendChartDataModel.getChartData(ref: ref, trends: trends);
    List<double> diffList =
        TrendChartDataModel.getDiffList(chartData: chartData);

    double total = diffList.fold<double>(
        0, (previousValue, element) => previousValue + element);
    double average = total / diffList.length;
    //: 평균이 양수면 파란색, 음수면 빨간색으로 표시
    Color color = average >= 0 ? Colors.blue : Colors.red;
    color = average.isNaN ? Colors.purple : color;

    //# 툴팁에 실제로 표시되는 데이터 
    String _text = average.isNaN ? "${chartData.last.name}\'s average growth : " + "not enough data".tr(): "${chartData.last.name}\'s average growth : ${CustomNumberUtils.formatCurrency(average)}";

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8, bottom: 8),
      child: Text(
        _text,
        style: textTHeme.bodyMedium?.copyWith(color: color),
      ),
    );
  }
}
