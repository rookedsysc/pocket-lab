import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/chart/layout/trend_chart_layout.dart';
import 'package:pocket_lab/chart/model/category_trend_chart_model.dart';
import 'package:pocket_lab/chart/repository/category_trend_chart_repository.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryTrendChart extends ConsumerStatefulWidget {
  const CategoryTrendChart({super.key});

  @override
  ConsumerState<CategoryTrendChart> createState() => _CategoryTrendChartState();
}

class _CategoryTrendChartState extends ConsumerState<CategoryTrendChart> {
  List<CategoryTrendChartDataModel> _chartDataModels = [];
  List<ChartSeries> _seriesList = [];
  int _xAxisLength = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryTrendChartDataModel>>(
        future: ref
            .read(categoryTrendChartProvider.notifier)
            .getAllTrendModelByCategory(),
        builder: (context, snapshot) {
          // 동기 처리가 아직 끝나지 않았을 경우
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          _chartDataModels = snapshot.data!;
          _xAxisLength = 0;
          List<TransactionCategory> categories =
              ref.read(categoryRepositoryProvider);
          _seriesList = categories.map((e) => _getChartSeries(e)).toList();

          if (_xAxisLength == 0) {
            return Center(child: Column(
              children: [
                SizedBox(height: 100,),
                Text("not enough data".tr()),
              ],
            ));
          }

          return TrendChartLayout(
                        legend: Legend(
              textStyle: Theme.of(context).textTheme.bodySmall,
                overflowMode: LegendItemOverflowMode.wrap,
                isVisible: true,
                position: LegendPosition.bottom),

              xAxis: _xAxis(),
              seriesList: _seriesList);
        });
  }

  ChartSeries _getChartSeries(TransactionCategory category) {
    List<CategoryTrendChartDataModel> _chartData = [];
    List<CategoryTrendChartDataModel> _willDell = [];
    for (CategoryTrendChartDataModel model in _chartDataModels) {
      if (model.categoryId == category.id) {
        model.label = CustomDateUtils().getStringLabel(date: model.date, ref: ref);
        try {
          _chartData
              .firstWhere((element) => element.label == model.label)
              .amount += model.amount;
        }
        //: _chartData의 요소 중 현재 model의 label과 동일한 label을 가진 요소의 amount에 현재 model의 amount를 더 함
        catch (e) {
          _chartData.add(model);
        }
        _willDell.add(model);
      }
    }

    _chartDataModels.removeWhere((element) => _willDell.contains(element));

    _chartData.sort((a, b) => a.date.compareTo(b.date));
    _chartData = _chartData.reversed.toList();
    //: X축 최대 사이즈 측정하기 위함
    _xAxisLength = _chartData.length > _xAxisLength
        ? _xAxisLength = _chartData.length
        : _xAxisLength = _xAxisLength;

    return LineSeries<CategoryTrendChartDataModel, String>(
      dataSource: _chartData,
      xValueMapper: (CategoryTrendChartDataModel data, _) => data.label,
      yValueMapper: (CategoryTrendChartDataModel data, _) => data.amount,
      name: category.name,
      color: ColorUtils.stringToColor(category.color),
      markerSettings: MarkerSettings(isVisible: true),
      dataLabelSettings: DataLabelSettings(
          isVisible: false, textStyle: Theme.of(context).textTheme.bodySmall!,
          ),
    );
  }

  CategoryAxis _xAxis() {
    if (_xAxisLength > 10) {
      _xAxisLength = 10;
    } else {
      _xAxisLength -= 1;
    }

    return CategoryAxis(
        isInversed: true,
        autoScrollingMode: AutoScrollingMode.end,
        visibleMaximum: _xAxisLength.toDouble(),
        axisLine: AxisLine(width: 0),
        //: x축 간격
        interval: 1);
  }
}
