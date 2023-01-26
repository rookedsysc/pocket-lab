import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/goal/component/goal_list_view.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/goal/view/goal_add_modal_screen.dart';
import 'package:sheet/route.dart';


class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Goal> goals = []; 
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //: 그림자 제거
          elevation: 0,

          title: Text(
            "목표 설정",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            //# 추가 버튼
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  builder: ((context) {
                    return GoalAddModalScreen(
                      height: MediaQuery.of(context).size.height * 0.49,
                      width: MediaQuery.of(context).size.width,
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      cardColor: Theme.of(context).cardColor,
                    );
                  }),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: goals == null || goals.isEmpty
                      ? Text("설정된 목표가 없습니다.")
                      : ListView.builder(
                          itemBuilder: (context, index) => Container(
                            //: container 둥글게
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: ListTile(
                              title: Text(goals[index].name),
                              subtitle: Text(goals[index].firstDate.toString()),
                              trailing: Text(goals[index].amount.toString()),
                            ),
                          ),
                          itemCount: goals.length,
                        ),
                )
        ),
      );
      
    
  }
}


//! 동작안함
//! 왜 그런지 모르겠음
// class GoalScreen extends ConsumerWidget {
//   const GoalScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//         final goalFuture = ref.watch(goalProvider);
//     return goalFuture.maybeWhen(data: (data) {
//       return Scaffold(
//         appBar: AppBar(
//           iconTheme: Theme.of(context).iconTheme,
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           //: 그림자 제거
//           elevation: 0,

//           title: Text(
//             "목표 설정",
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           actions: [
//             //# 추가 버튼
//             IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () {
//                 showMaterialModalBottomSheet(
//                   expand: false,
//                   context: context,
//                   builder: ((context) {
//                     return GoalAddModalScreen(
//                       height: MediaQuery.of(context).size.height * 0.49,
//                       width: MediaQuery.of(context).size.width,
//                       textStyle: Theme.of(context).textTheme.bodyMedium,
//                       cardColor: Theme.of(context).cardColor,
//                     );
//                   }),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: SafeArea(
//           child: StreamBuilder<List<Goal>>(
//             stream: data.getAllGoals(),
//               builder: (context, snapshot) {
//                 if (snapshot.data == null) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 final goals = snapshot.data;
//                 return Padding(
//                   padding:
//                       const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//                   child: goals == null || goals.isEmpty
//                       ? Text("설정된 목표가 없습니다.")
//                       : ListView.builder(
//                           itemBuilder: (context, index) => Container(
//                             //: container 둥글게
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).cardColor,
//                               borderRadius: BorderRadius.circular(10),
//                             ),

//                             child: ListTile(
//                               title: Text(goals[index].name),
//                               subtitle: Text(goals[index].firstDate.toString()),
//                               trailing: Text(goals[index].amount.toString()),
//                             ),
//                           ),
//                           itemCount: goals.length,
//                         ),
//                 );
//               }),
//         ),
//       );
//     }, orElse: (() {
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }),
//     error: (error, stackTrace) {
//       return Scaffold(body: Center(child: Text(error.toString())));
//     },

//     );
//   }
// }