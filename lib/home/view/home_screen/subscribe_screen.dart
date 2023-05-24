import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34,31, 59, 1),
      body: Stack(
        children: [
          Container(
              child: Image.asset(
            'asset/img/illustration/subscribe_image.png',
            fit: BoxFit.cover,
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _text("I'm a developer who works all night long."),
              SizedBox(
                height: 8,
              ),
              _text("Your support is very helpful for me to reach my dream."),
              SizedBox(
                height: 8,
              ),
              _text("Thank you for your support."),
            ],
          )

        ],
      ),
    );
  }

  Padding _text(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
        ),
  );
}
