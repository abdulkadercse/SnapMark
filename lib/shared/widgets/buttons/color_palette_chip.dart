import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ColorPaletteChip extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final double size;

  const ColorPaletteChip({
    super.key,
    required this.color,
    required this.onTap,
    this.size = AppConstants.toolbarButtonSize,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Change Color',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(4),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.white, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
