import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class WeekHeader extends StatelessWidget {
  final int index;
  const WeekHeader ({required this.index,super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0),
      child: Container(
        height: 50.0,
        width: 125.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).cardColor
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text(_indexToWeek(), 
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ), 
          Text('-50000', style: TextStyle(color: Colors.red, fontSize: 12.0),),
          Text('+40000',style: TextStyle(color: Colors.blue, fontSize: 12.0),),
        ],),
      ),
    );
  }

  String _indexToWeek() {
    if(index == 0) return '첫 번째 주';
    else if(index == 1) return '두 번째 주';
    else if(index == 2) return '세 번째 주';
    else if(index == 3) return '네 번째 주';
    else if(index == 4) return '다섯 번째 주';
    else return '여섯 번째 주';
  }
}