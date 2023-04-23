import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocket_lab/chart/model/time_heatmap_chart_model.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';

class TimeHeatmapChart extends StatelessWidget {
  final List<Transaction> transactions;
  List<double> amounts = [];
  TimeHeatmapChartModel chartData = TimeHeatmapChartModel();

  TimeHeatmapChart({required this.transactions, super.key});

  @override
  Widget build(BuildContext context) {
    _convertHeatmapModel();
    _setAmounts();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: 24,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: _getColor(chartData.hourlyData[index]!),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                    child: Text(
                      DateFormat('HH').format(DateTime(2023, 4, 17, index)),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                    child: Text(
                      CustomNumberUtils.formatCurrency(
                          chartData.hourlyData[index]!),
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _convertHeatmapModel() {
    for (Transaction t in transactions) {
      if (chartData.hourlyData[t.date.hour] != null) {
        chartData.hourlyData[t.date.hour] =
            chartData.hourlyData[t.date.hour]! + t.amount;
      }
    }
  }

  void _setAmounts() {
    amounts = chartData.hourlyData.values.toList();
    amounts.sort((a, b) => b.compareTo(a));
  }

  Color _getColor(double value) {
    //: 가장 큰 값인 경우
    if (value == amounts[0]) {
      if (value == 0) {
        return Color(0xFFC2E8FF);
      }
      return Color(0xFF01579B);
    }
    //: 상위 25% 인 경우
    if (value > amounts[(amounts.length * 0.25).toInt()]) {
      return Color(0xFF039BE5);
    }
    //: 상위 25 ~ 50% 인 경우
    else if (amounts[(amounts.length * 0.25).toInt()] >= value &&
        value > amounts[(amounts.length * 0.50).toInt()]) {
      return Color(0xFF29B6F6);
    }
    //: 상위 50 ~ 75%인 경우
    else if (amounts[(amounts.length * 0.50).toInt()] >= value &&
        value > amounts[(amounts.length * 0.75).toInt()]) {
      return Color(0xFF4FC3F7);
    }
    //: 상위 75%인 경우
    else if (amounts[(amounts.length * 0.75).toInt()] >= value && value > 0) {
      return Color(0xFF81D4FA);
    }
    //: 0인 경우
    else {
      return Color(0xFFC2E8FF);
    }
  }
}
