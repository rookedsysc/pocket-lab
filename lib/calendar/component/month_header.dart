import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/common/component/category_chart.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader ({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '지출 : 50000',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '수입 : 40000',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          //: 카테고리별 간략한 통계
          Container(
            width: 100.0,
            height: 100.0,
            child: CategoryChart(isHome: false),
          ),
        ],
      ),
    );
  }
}
