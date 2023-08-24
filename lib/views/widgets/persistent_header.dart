import 'package:flutter/material.dart';
import 'package:resty/themes/colors.dart';

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double height;

  PersistentHeader({required this.widget, required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: primaryColor[50],
      width: double.infinity,
      height: height,
      child: Align(alignment: Alignment.centerLeft, child: widget),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
