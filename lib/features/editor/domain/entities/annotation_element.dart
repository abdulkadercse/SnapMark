import 'package:flutter/material.dart';

enum AnnotationTool {
  select,
  pen,
  line,
  arrow,
  circle,
  rectangle,
  highlighter,
  text,
  blur,
  stepMarker,
}

abstract class AnnotationElement {
  final String id;
  final Color color;
  final double strokeWidth;
  final double opacity;
  final bool isSelected;

  const AnnotationElement({
    required this.id,
    required this.color,
    required this.strokeWidth,
    this.opacity = 1.0,
    this.isSelected = false,
  });

  void draw(Canvas canvas, Size size);
  Rect get bounds;
}

class PenElement extends AnnotationElement {
  final List<Offset> points;

  const PenElement({
    required super.id,
    required super.color,
    required super.strokeWidth,
    required this.points,
    super.opacity,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (points.length == 1) {
      canvas.drawCircle(points.first, strokeWidth / 2, paint..style = PaintingStyle.fill);
      return;
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  Rect get bounds {
    if (points.isEmpty) return Rect.zero;
    double minX = points.first.dx, maxX = points.first.dx;
    double minY = points.first.dy, maxY = points.first.dy;
    for (final p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY).inflate(strokeWidth);
  }
}

class LineElement extends AnnotationElement {
  final Offset start;
  final Offset end;

  const LineElement({
    required super.id,
    required super.color,
    required super.strokeWidth,
    required this.start,
    required this.end,
    super.opacity,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  Rect get bounds => Rect.fromPoints(start, end).inflate(strokeWidth);
}

class ArrowElement extends AnnotationElement {
  final Offset start;
  final Offset end;

  const ArrowElement({
    required super.id,
    required super.color,
    required super.strokeWidth,
    required this.start,
    required this.end,
    super.opacity,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    // Arrowhead
    final headLength = (strokeWidth * 4.5).clamp(12.0, 32.0);
    const headAngle = 0.52; // ~30 deg
    final angle = (end - start).direction;

    final p1 = end - Offset.fromDirection(angle - headAngle, headLength);
    final p2 = end - Offset.fromDirection(angle + headAngle, headLength);

    final headPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();

    final fillPaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawPath(headPath, fillPaint);
  }

  @override
  Rect get bounds => Rect.fromPoints(start, end).inflate(strokeWidth * 3);
}

class RectangleElement extends AnnotationElement {
  final Rect rect;

  const RectangleElement({
    required super.id,
    required super.color,
    required super.strokeWidth,
    required this.rect,
    super.opacity,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect, paint);
  }

  @override
  Rect get bounds => rect.inflate(strokeWidth);
}

class CircleElement extends AnnotationElement {
  final Rect rect;

  const CircleElement({
    required super.id,
    required super.color,
    required super.strokeWidth,
    required this.rect,
    super.opacity,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawOval(rect, paint);
  }

  @override
  Rect get bounds => rect.inflate(strokeWidth);
}

class HighlighterElement extends AnnotationElement {
  final List<Offset> points;

  const HighlighterElement({
    required super.id,
    required super.color,
    required super.strokeWidth,
    required this.points,
    super.opacity = 0.35,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth * 3.5
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  Rect get bounds {
    if (points.isEmpty) return Rect.zero;
    double minX = points.first.dx, maxX = points.first.dx;
    double minY = points.first.dy, maxY = points.first.dy;
    for (final p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY).inflate(strokeWidth * 4);
  }
}

class TextElement extends AnnotationElement {
  final Offset position;
  final String text;
  final double fontSize;

  const TextElement({
    required super.id,
    required super.color,
    required super.strokeWidth,
    required this.position,
    required this.text,
    this.fontSize = 16.0,
    super.opacity,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas, Size size) {
    if (text.isEmpty) return;

    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color.withValues(alpha: opacity),
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  @override
  Rect get bounds => Rect.fromLTWH(position.dx, position.dy, 120, fontSize * 1.5);
}

class BlurElement extends AnnotationElement {
  final Rect rect;

  const BlurElement({
    required super.id,
    required this.rect,
    super.color = Colors.transparent,
    super.strokeWidth = 0,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas, Size size) {
    // Drawn via special backdrop or pixelated shader pass
    final paint = Paint()
      ..color = const Color(0x992B2D33)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);
  }

  @override
  Rect get bounds => rect;
}

class StepMarkerElement extends AnnotationElement {
  final Offset center;
  final int stepNumber;
  final double radius;

  const StepMarkerElement({
    required super.id,
    required super.color,
    required this.center,
    required this.stepNumber,
    this.radius = 13.0,
    super.strokeWidth = 2.0,
    super.opacity,
    super.isSelected,
  });

  @override
  void draw(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, circlePaint);
    canvas.drawCircle(center, radius, borderPaint);

    final textSpan = TextSpan(
      text: '$stepNumber',
      style: TextStyle(
        color: Colors.white,
        fontSize: radius * 1.1,
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    final textOffset = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  Rect get bounds => Rect.fromCircle(center: center, radius: radius);
}
