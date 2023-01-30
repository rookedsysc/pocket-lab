import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:uuid/uuid.dart';

part 'goal_model.g.dart';

@Collection()
class Goal {
  Id id = Isar.autoIncrement;
  //: 목표 이름
  String name;
  //: 목표 금액
  int amount;
  //: 목표 완료 되었는지 안되었는지
  bool isDone = false;
  //: 목표 설정한 날짜
  String firstDate = DateTime.now().toUtc().toString();
  //: 목표 달성한 날짜
  String? lastDate;

  Goal({
    required this.name,
    required this.amount,
    this.lastDate,
    this.isDone = false,
  });
}
