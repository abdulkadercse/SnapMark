import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../app/theme/app_colors.dart';

class PinnedOverlayView extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback onClose;

  const PinnedOverlayView({
    super.key,
    required this.imageBytes,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          border: Border.all(color: AppColors.primaryBlue, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Draggable Window Surface
            GestureDetector(
              onPanStart: (details) {
                windowManager.startDragging();
              },
              child: SizedBox.expand(
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Close Button
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
