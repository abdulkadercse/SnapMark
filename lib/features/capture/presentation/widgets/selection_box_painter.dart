import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/rect_extensions.dart';
import '../../../../app/theme/app_colors.dart';

class SelectionBoxPainter extends CustomPainter {
  final ui.Image? baseImage;
  final Rect? selectionRect;

  SelectionBoxPainter({
    required this.baseImage,
    required this.selectionRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw base captured desktop image
    if (baseImage != null) {
      final srcRect = Rect.fromLTWH(0, 0, baseImage!.width.toDouble(), baseImage!.height.toDouble());
      final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
      canvas.drawImageRect(baseImage!, srcRect, dstRect, Paint());
    }

    // 2. Draw darkened overlay with cutout over selection
    final fullScreenRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final maskPaint = Paint()..color = AppColors.overlayMask;

    if (selectionRect == null || selectionRect!.isEmpty) {
      canvas.drawRect(fullScreenRect, maskPaint);
      return;
    }

    final normRect = selectionRect!.normalized;

    // Cutout mask
    final path = Path()
      ..addRect(fullScreenRect)
      ..addRect(normRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, maskPaint);

    // 3. Draw dashed or solid selection outline
    final borderPaint = Paint()
      ..color = AppColors.selectionBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(normRect, borderPaint);

    // 4. Draw 8 square resize handles
    final handles = normRect.handles;
    final handleFillPaint = Paint()..color = AppColors.handleFill;
    final handleBorderPaint = Paint()
      ..color = AppColors.handleBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const hSize = AppConstants.handleSize;
    for (final handleCenter in handles) {
      final handleRect = Rect.fromCenter(center: handleCenter, width: hSize, height: hSize);
      canvas.drawRect(handleRect, handleFillPaint);
      canvas.drawRect(handleRect, handleBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SelectionBoxPainter oldDelegate) {
    return oldDelegate.baseImage != baseImage || oldDelegate.selectionRect != selectionRect;
  }
}
