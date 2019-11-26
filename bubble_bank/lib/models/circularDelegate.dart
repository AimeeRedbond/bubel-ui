import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/widgets.dart';

class CircularLayoutDelegate extends MultiChildLayoutDelegate {
  final int itemCount;
  final double radius;
  static const String actionButton = 'GROUP';
  Offset center;

  CircularLayoutDelegate({
    @required this.itemCount,
    @required this.radius,
  });

  @override
  void performLayout(Size size) {
    center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < itemCount; i++) {
      final String actionButtonId = '$actionButton$i';

      if (hasChild(actionButtonId)) {
        final Size buttonSize =
        layoutChild(actionButtonId, BoxConstraints.loose(size));
        final double itemAngle = _calculateItemAngle(i);

        positionChild(
          actionButtonId,
          Offset(
            (center.dx - buttonSize.width / 2) + (radius) * cos(itemAngle),
            (center.dy - buttonSize.height / 2) +
                (radius) * sin(itemAngle),
          ),
        );
      }
    }
  }

  @override
  bool shouldRelayout(CircularLayoutDelegate oldDelegate) =>
      itemCount != oldDelegate.itemCount ||
          radius != oldDelegate.radius ;

  static double _radiansPerDegree = pi / 180;
  final double _startAngle = -90.0 * _radiansPerDegree;
  double _calculateItemAngle(int index) {
    return _startAngle + index * (360.0 / itemCount) * _radiansPerDegree;
  }

}