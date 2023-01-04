
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/home/view/goal_detail_view.dart';

class GoalHeader extends StatelessWidget {
  const GoalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //: SafeArea top만 설정
      top: true,

      child: GestureDetector(
        onTap: () => showCupertinoModalBottomSheet(context: context, builder: (context) {
          return GoalDetailView();
        }
        
        ),

        child: Container(
          height: 50,
          decoration: BoxDecoration(
            //: 테두리
            border: Border.all(color: Colors.green, width: 4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("GOAL"),
              Text("50,000원"),
            ],
          ),
          ),
      ),
    );
  }
}
