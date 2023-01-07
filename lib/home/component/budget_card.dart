import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard ({super.key});

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
        Container(
          padding: const EdgeInsets.only(
              right: 36.0, left: 24.0, top: 36.0, bottom: 24.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Budget 1",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.left,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "7 / 35000",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    Text(
                      "5000",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
              right: 36.0, left: 24.0, top: 36.0, bottom: 24.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Budget 2",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.left,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "30 / 300000",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    Text(
                      "30000",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
