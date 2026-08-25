import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/editor_provider.dart';
import '../providers/undo_redo_provider.dart';

class InlineTextEditor extends StatefulWidget {
  final Offset position;

  const InlineTextEditor({
    super.key,
    required this.position,
  });

  @override
  State<InlineTextEditor> createState() => _InlineTextEditorState();
}

class _InlineTextEditorState extends State<InlineTextEditor> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final editor = context.read<EditorProvider>();
    final undoRedo = context.read<UndoRedoProvider>();
    editor.submitText(_controller.text, undoRedo);
  }

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<EditorProvider>();

    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: editor.currentColor, width: 1.5),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            maxLines: null,
            style: TextStyle(
              color: editor.currentColor,
              fontSize: editor.fontSize,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: 'Type text...',
              hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
      ),
    );
  }
}
