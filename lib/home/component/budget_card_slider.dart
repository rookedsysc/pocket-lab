import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/home/component/budget_card.dart';

class BudgetCardSlider extends StatelessWidget {
  const BudgetCardSlider ({super.key});

  @override
  Widget build(BuildContext context) {
    int initialIndex = 0;

    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 2.0,
          disableCenter: true,
          enlargeCenterPage: true,
          initialPage: initialIndex),
      items: [
        BudgetCard(name: "Budget 1", period: "35000 / 7", amount: 5000),
        BudgetCard(name: "Budget 2", period: "49000 / 7", amount: 7000),
        BudgetCard(name: "Budget 3", period: "60000 / 30", amount: 200)
      ],
    );
  }
}
