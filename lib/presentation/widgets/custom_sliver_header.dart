import 'package:flutter/material.dart';

class CustomSliverHeader extends SliverPersistentHeaderDelegate {
  CustomSliverHeader(
    this._widget, {
    this.backgroundColor,
  });
  final PreferredSizeWidget _widget;
  final Color? backgroundColor;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: _widget,
    );
  }

  @override
  double get maxExtent => _widget.preferredSize.height;

  @override
  double get minExtent => _widget.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
