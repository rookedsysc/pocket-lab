import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableEdit extends StatelessWidget {
  final SlidableActionCallback onPressed;
  const SlidableEdit ({required this.onPressed,super.key});

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.grey,
      foregroundColor: Colors.black,
      icon: Icons.edit,
      label: "Edit".tr(),
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
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.red,
      foregroundColor: Colors.black,
      icon: Icons.delete,
      label: "DEL".tr(),
    );
  }
}