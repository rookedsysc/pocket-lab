import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum HeaderType {
  wallet,
  goal,
  total,
  trendChart,
  transactionTrendChart,
  categoryList,
  categoryChart,
  categoryTrendChart,
  averageGrowth
}

class HeaderCollection extends StatelessWidget {
  final HeaderType headerType;
  const HeaderCollection({required this.headerType, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      _getHeaderName(headerType),
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 20.0, fontWeight: FontWeight.w900),
    );
  }

  String _getHeaderName(HeaderType headerType) {
    switch (headerType) {
      case HeaderType.wallet:
        return "header name.Wallet List".tr();
      case HeaderType.categoryList:
        return "header name.Category List".tr();
      case HeaderType.goal:
        return "header name.Goal".tr();
      case HeaderType.total:
        return "header name.Total Balance";
      case HeaderType.trendChart:
        return "header name.Trend Chart".tr();
      case HeaderType.categoryChart:
        return "header name.Category Chart".tr();
      case HeaderType.categoryTrendChart:
        return "header name.Category Trend Chart".tr();
      case HeaderType.averageGrowth:
        return "header name.Average Growth".tr();
      case HeaderType.transactionTrendChart:
        return "header name.Transaction Trend Chart".tr();
    }
  }
}
