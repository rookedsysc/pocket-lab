import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableEdit extends StatelessWidget {
  final SlidableActionCallback onPressed;
  const SlidableEdit ({required this.onPressed,super.key});

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: onPressed,
      backgroundColor: Colors.grey,
      foregroundColor: Colors.black,
      icon: Icons.edit,
      label: "Edit",
    );
  }
}

class SlidableDelete extends StatelessWidget {
  final SlidableActionCallback onPressed;
const SlidableDelete ({required this.onPressed,super.key});

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: onPressed,
      //TODO: 삭제시 데이터가 한 개 뿐이라면 삭제 불가능하게 dialog 띄우기
      backgroundColor: Colors.red,
      foregroundColor: Colors.black,
      icon: Icons.delete,
      label: "Del",
    );
  }
}