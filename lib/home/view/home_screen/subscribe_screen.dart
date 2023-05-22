import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34,31, 59, 1),
      body: Column(
        children: [
          
          Container(
            child: Image.asset('asset/img/illustration/subscribe_image.png', fit: BoxFit.cover,)),
            _text("I'm a developer who works all night long."),
            _text("Please give me a dollar a month so that I can reach my dream."),
            _text("Thank you for your support."),
        ],
      ),
    );
  }

  Padding _text(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
        ),
  );
}
