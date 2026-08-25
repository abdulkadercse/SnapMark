import 'package:flutter/material.dart';

extension RectExtensions on Rect {
  /// Normalize a rectangle so left <= right and top <= bottom regardless of drag direction
  Rect get normalized {
    final l = left < right ? left : right;
    final r = left < right ? right : left;
    final t = top < bottom ? top : bottom;
    final b = top < bottom ? bottom : top;
    return Rect.fromLTRB(l, t, r, b);
  }

  /// Calculates positions for 8 resize handles
  /// 0: NW, 1: N, 2: NE, 3: E, 4: SE, 5: S, 6: SW, 7: W
  List<Offset> get handles {
    final norm = normalized;
    return [
      norm.topLeft,
      Offset(norm.center.dx, norm.top),
      norm.topRight,
      Offset(norm.right, norm.center.dy),
      norm.bottomRight,
      Offset(norm.center.dx, norm.bottom),
      norm.bottomLeft,
      Offset(norm.left, norm.center.dy),
    ];
  }
}
