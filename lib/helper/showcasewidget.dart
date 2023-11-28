import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;
  final VoidCallback? onTap;

  ShowCaseView({super.key, required this.globalKey, required this.title, required this.description, required this.child, required this.shapeBorder, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Showcase(
      onBarrierClick: (onTap == null)?(){}:onTap,
   //   onTargetClick: (onTap == null)?(){}:onTap,
      onToolTipClick: (onTap == null)?(){}:onTap,
      key: globalKey,
      title: title,
      description: description,
      targetShapeBorder: shapeBorder,
      child: child,
    );
  }
}
