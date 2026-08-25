import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../app/theme/app_colors.dart';

class ToolbarIconButton extends StatefulWidget {
  final Widget icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? activeColor;
  final double size;

  const ToolbarIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isSelected = false,
    this.activeColor,
    this.size = AppConstants.toolbarButtonSize,
  });

  @override
  State<ToolbarIconButton> createState() => _ToolbarIconButtonState();
}

class _ToolbarIconButtonState extends State<ToolbarIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final hoverBg = isDark ? AppColors.toolbarButtonHoverDark : AppColors.toolbarButtonHoverLight;
    final selectedBg = widget.activeColor != null
        ? widget.activeColor!.withValues(alpha: 0.25)
        : (isDark ? const Color(0xFF333842) : const Color(0xFFDCE2E9));

    final effectiveBg = widget.isSelected
        ? selectedBg
        : (_isHovered ? hoverBg : Colors.transparent);

    final borderSide = widget.isSelected
        ? BorderSide(color: widget.activeColor ?? AppColors.primaryBlue, width: 1.2)
        : BorderSide.none;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: effectiveBg,
              borderRadius: BorderRadius.circular(4),
              border: Border.fromBorderSide(borderSide),
            ),
            alignment: Alignment.center,
            child: IconTheme(
              data: IconThemeData(
                size: 16,
                color: widget.isSelected
                    ? (widget.activeColor ?? (isDark ? Colors.white : Colors.black87))
                    : (isDark ? const Color(0xFFC0C4CC) : const Color(0xFF4A4E57)),
              ),
              child: widget.icon,
            ),
          ),
        ),
      ),
    );
  }
}
