import 'package:flutter/material.dart';
import '../../../../app/theme/app_typography.dart';

class DimensionBadge extends StatelessWidget {
  final int width;
  final int height;

  const DimensionBadge({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xCC1A1C23),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0x44FFFFFF), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.crop_free, size: 10, color: Color(0xFF38BDF8)),
          const SizedBox(width: 4),
          Text(
            '$width x $height',
            style: AppTypography.badgeStyle,
          ),
        ],
      ),
    );
  }
}
