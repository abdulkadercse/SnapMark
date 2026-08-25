import 'package:flutter/material.dart';
import '../../../domain/entities/annotation_element.dart';

class AnnotationCanvasPainter extends CustomPainter {
  final List<AnnotationElement> elements;
  final AnnotationElement? inProgressElement;

  AnnotationCanvasPainter({
    required this.elements,
    this.inProgressElement,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final element in elements) {
      element.draw(canvas, size);
    }
    if (inProgressElement != null) {
      inProgressElement!.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant AnnotationCanvasPainter oldDelegate) {
    return true;
  }
}
