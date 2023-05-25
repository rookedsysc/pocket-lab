import 'package:isar/isar.dart';

part 'goal_model.g.dart';

@Collection()
class Goal {
  Id id = Isar.autoIncrement;
  //: 목표 이름
  String name;
  //: 목표 금액
  double amount;
  //: 목표 완료 되었는지 안되었는지
  bool isDone = false;
  //: 목표 설정한 날짜
  String firstDate = DateTime.now().toString();
  //: 목표 달성한 날짜
  String? lastDate;

  Goal({
    required this.name,
    required this.amount,
    this.lastDate,
    this.isDone = false,
  });
}
