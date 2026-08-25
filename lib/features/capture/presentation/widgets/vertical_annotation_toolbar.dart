import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/buttons/color_palette_chip.dart';
import '../../../../shared/widgets/buttons/toolbar_icon_button.dart';
import '../../../editor/domain/entities/annotation_element.dart';
import '../../../editor/presentation/providers/editor_provider.dart';
import '../../../editor/presentation/providers/undo_redo_provider.dart';
import 'color_picker_popup.dart';

class VerticalAnnotationToolbar extends StatefulWidget {
  const VerticalAnnotationToolbar({super.key});

  @override
  State<VerticalAnnotationToolbar> createState() => _VerticalAnnotationToolbarState();
}

class _VerticalAnnotationToolbarState extends State<VerticalAnnotationToolbar> {
  bool _showColorPicker = false;

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<EditorProvider>();
    final undoRedo = context.watch<UndoRedoProvider>();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8FA),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFB0B6C0), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 6,
                offset: Offset(1, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ToolbarIconButton(
                icon: const Icon(Icons.open_with),
                tooltip: 'Move / Adjust Area (V)',
                isSelected: editor.activeTool == AnnotationTool.select,
                onTap: () => editor.setActiveTool(AnnotationTool.select),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Divider(height: 1, color: Color(0xFFD0D7DE)),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Pen (P)',
                isSelected: editor.activeTool == AnnotationTool.pen,
                onTap: () => editor.setActiveTool(AnnotationTool.pen),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.horizontal_rule),
                tooltip: 'Line (L)',
                isSelected: editor.activeTool == AnnotationTool.line,
                onTap: () => editor.setActiveTool(AnnotationTool.line),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.arrow_forward),
                tooltip: 'Arrow (A)',
                isSelected: editor.activeTool == AnnotationTool.arrow,
                onTap: () => editor.setActiveTool(AnnotationTool.arrow),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.crop_din_outlined),
                tooltip: 'Rectangle (R)',
                isSelected: editor.activeTool == AnnotationTool.rectangle,
                onTap: () => editor.setActiveTool(AnnotationTool.rectangle),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.circle_outlined),
                tooltip: 'Circle (O)',
                isSelected: editor.activeTool == AnnotationTool.circle,
                onTap: () => editor.setActiveTool(AnnotationTool.circle),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.border_color_outlined),
                tooltip: 'Highlighter (H)',
                isSelected: editor.activeTool == AnnotationTool.highlighter,
                onTap: () => editor.setActiveTool(AnnotationTool.highlighter),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.text_fields_outlined),
                tooltip: 'Text (T)',
                isSelected: editor.activeTool == AnnotationTool.text,
                onTap: () => editor.setActiveTool(AnnotationTool.text),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.blur_on),
                tooltip: 'Blur / Obscure (B)',
                isSelected: editor.activeTool == AnnotationTool.blur,
                onTap: () => editor.setActiveTool(AnnotationTool.blur),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.looks_one_outlined),
                tooltip: 'Step Counter (N)',
                isSelected: editor.activeTool == AnnotationTool.stepMarker,
                onTap: () => editor.setActiveTool(AnnotationTool.stepMarker),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Divider(height: 1, color: Color(0xFFD0D7DE)),
              ),
              ColorPaletteChip(
                color: editor.currentColor,
                onTap: () => setState(() => _showColorPicker = !_showColorPicker),
              ),
              ToolbarIconButton(
                icon: const Icon(Icons.undo),
                tooltip: 'Undo (Ctrl/Cmd+Z)',
                isSelected: false,
                onTap: undoRedo.canUndo ? () => editor.undo(undoRedo) : null,
              ),
            ],
          ),
        ),
        if (_showColorPicker)
          Positioned(
            left: -110,
            bottom: 30,
            child: ColorPickerPopup(
              activeColor: editor.currentColor,
              onColorSelected: (color) {
                editor.setColor(color);
                setState(() => _showColorPicker = false);
              },
            ),
          ),
      ],
    );
  }
}
