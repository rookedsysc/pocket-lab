import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class CustomSkeletone {
  Widget circle() {
    return SkeletonAvatar(
      style: SkeletonAvatarStyle(shape: BoxShape.circle),
    );
  }

  Widget square({required double? width, required double? height}) {
    return SkeletonAvatar(
      style: SkeletonAvatarStyle(
        padding: EdgeInsets.zero,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        shape: BoxShape.rectangle),
    );
  }
}
