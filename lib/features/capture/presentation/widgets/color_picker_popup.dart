import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class ColorPickerPopup extends StatelessWidget {
  final Color activeColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerPopup({
    super.key,
    required this.activeColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2025),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF3B3E48), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: AppColors.annotationPalette.map((color) {
          final isSelected = color.toARGB32() == activeColor.toARGB32();
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.black45,
                  width: isSelected ? 2 : 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
