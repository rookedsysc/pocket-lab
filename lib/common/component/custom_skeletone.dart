import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class CustomSkeletone {
  Widget circle({double? width, double? height}) {
    return SkeletonAvatar(
      style: SkeletonAvatarStyle(
        shape: BoxShape.circle,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
      ),
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
