import 'dart:math' as math;
import 'package:flutter/material.dart';

class GeometryMath {
  /// Calculate arrow head path points from start point to end point
  static Path computeArrowHeadPath({
    required Offset start,
    required Offset end,
    double headLength = 16.0,
    double headAngle = math.pi / 6, // 30 degrees
  }) {
    final path = Path();
    final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

    final p1 = Offset(
      end.dx - headLength * math.cos(angle - headAngle),
      end.dy - headLength * math.sin(angle - headAngle),
    );
    final p2 = Offset(
      end.dx - headLength * math.cos(angle + headAngle),
      end.dy - headLength * math.sin(angle + headAngle),
    );

    path.moveTo(end.dx, end.dy);
    path.lineTo(p1.dx, p1.dy);
    path.moveTo(end.dx, end.dy);
    path.lineTo(p2.dx, p2.dy);

    return path;
  }

  /// Distance between two 2D points
  static double distance(Offset p1, Offset p2) {
    return math.sqrt(math.pow(p1.dx - p2.dx, 2) + math.pow(p1.dy - p2.dy, 2));
  }

  /// Check which resize handle is hit by point, if any (-1 if none)
  /// Handles: 0: NW, 1: N, 2: NE, 3: E, 4: SE, 5: S, 6: SW, 7: W
  static int hitTestHandles(List<Offset> handles, Offset point, double hitRadius) {
    for (int i = 0; i < handles.length; i++) {
      if (distance(handles[i], point) <= hitRadius) {
        return i;
      }
    }
    return -1;
  }
}
