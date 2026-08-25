import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/rect_extensions.dart';
import '../../../../core/utils/geometry_math.dart';
import '../../../editor/domain/entities/annotation_element.dart';
import '../../../editor/presentation/providers/editor_provider.dart';
import '../../../editor/presentation/providers/undo_redo_provider.dart';
import '../../../editor/presentation/views/canvas/annotation_canvas.dart';
import '../../../editor/presentation/widgets/inline_text_editor.dart';
import '../providers/capture_provider.dart';
import '../widgets/dimension_badge.dart';
import '../widgets/horizontal_action_toolbar.dart';
import '../widgets/selection_box_painter.dart';
import '../widgets/vertical_annotation_toolbar.dart';

class CaptureOverlayView extends StatefulWidget {
  final VoidCallback onOpenHistory;
  final VoidCallback onPin;

  const CaptureOverlayView({
    super.key,
    required this.onOpenHistory,
    required this.onPin,
  });

  @override
  State<CaptureOverlayView> createState() => _CaptureOverlayViewState();
}

class _CaptureOverlayViewState extends State<CaptureOverlayView> {
  final FocusNode _focusNode = FocusNode();
  MouseCursor _currentCursor = SystemMouseCursors.precise;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final capture = context.read<CaptureProvider>();
    final editor = context.read<EditorProvider>();
    final undoRedo = context.read<UndoRedoProvider>();

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      editor.reset();
      capture.dismissOverlay();
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyV) {
      editor.setActiveTool(AnnotationTool.select);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyP) {
      editor.setActiveTool(AnnotationTool.pen);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
      editor.setActiveTool(AnnotationTool.arrow);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
      editor.setActiveTool(AnnotationTool.rectangle);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyO) {
      editor.setActiveTool(AnnotationTool.circle);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyL) {
      editor.setActiveTool(AnnotationTool.line);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyT) {
      editor.setActiveTool(AnnotationTool.text);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyB) {
      editor.setActiveTool(AnnotationTool.blur);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
      editor.setActiveTool(AnnotationTool.stepMarker);
      return KeyEventResult.handled;
    } else if (HardwareKeyboard.instance.isMetaPressed || HardwareKeyboard.instance.isControlPressed) {
      if (event.logicalKey == LogicalKeyboardKey.keyZ) {
        editor.undo(undoRedo);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _updateCursor(Offset pos, Rect? selectionRect, AnnotationTool tool) {
    if (selectionRect == null) {
      if (_currentCursor != SystemMouseCursors.precise) {
        setState(() => _currentCursor = SystemMouseCursors.precise);
      }
      return;
    }

    final handleIndex = GeometryMath.hitTestHandles(
      selectionRect.handles,
      pos,
      AppConstants.handleHitRadius,
    );

    MouseCursor newCursor;
    if (handleIndex != -1) {
      switch (handleIndex) {
        case 0:
        case 4:
          newCursor = SystemMouseCursors.resizeUpLeftDownRight;
          break;
        case 1:
        case 5:
          newCursor = SystemMouseCursors.resizeUpDown;
          break;
        case 2:
        case 6:
          newCursor = SystemMouseCursors.resizeUpRightDownLeft;
          break;
        case 3:
        case 7:
          newCursor = SystemMouseCursors.resizeLeftRight;
          break;
        default:
          newCursor = SystemMouseCursors.move;
      }
    } else if (selectionRect.contains(pos)) {
      if (tool == AnnotationTool.select) {
        newCursor = SystemMouseCursors.move;
      } else {
        newCursor = SystemMouseCursors.precise;
      }
    } else {
      newCursor = SystemMouseCursors.precise;
    }

    if (_currentCursor != newCursor) {
      setState(() => _currentCursor = newCursor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final capture = context.watch<CaptureProvider>();
    final editor = context.watch<EditorProvider>();
    final undoRedo = context.watch<UndoRedoProvider>();
    final screenSize = MediaQuery.of(context).size;

    final selectionRect = capture.selectionRect?.normalized;
    final hasSelection = capture.hasSelection && selectionRect != null;

    // Smart Toolbar Positioning & Flipping calculations
    double verticalToolbarLeft = 0;
    double verticalToolbarTop = 0;
    double horizontalToolbarLeft = 0;
    double horizontalToolbarTop = 0;
    double badgeLeft = 0;
    double badgeTop = 0;

    if (hasSelection) {
      // 1. Dimension Badge (Top-left above selection or flipped inside if near screen top)
      badgeLeft = selectionRect.left;
      badgeTop = (selectionRect.top - 24 < 4) ? selectionRect.top + 4 : selectionRect.top - 24;

      // 2. Vertical Annotation Toolbar (Docked right of selection)
      const vToolbarWidth = 36.0;
      if (selectionRect.right + AppConstants.toolbarGap + vToolbarWidth > screenSize.width - 4) {
        // Flip inside or to the left
        verticalToolbarLeft = selectionRect.right - vToolbarWidth - 4;
      } else {
        verticalToolbarLeft = selectionRect.right + AppConstants.toolbarGap;
      }
      verticalToolbarTop = selectionRect.top.clamp(4.0, screenSize.height - 380.0);

      // 3. Horizontal Action Toolbar (Docked below selection)
      const hToolbarHeight = 36.0;
      if (selectionRect.bottom + AppConstants.toolbarGap + hToolbarHeight > screenSize.height - 4) {
        // Flip inside or above
        horizontalToolbarTop = selectionRect.bottom - hToolbarHeight - 4;
      } else {
        horizontalToolbarTop = selectionRect.bottom + AppConstants.toolbarGap;
      }
      horizontalToolbarLeft = selectionRect.left.clamp(4.0, screenSize.width - 240.0);
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: MouseRegion(
          cursor: _currentCursor,
          onHover: (event) => _updateCursor(event.position, selectionRect, editor.activeTool),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Screenshot Cutout & 8-Handle Selection Box
              Listener(
                onPointerDown: (event) {
                  final handleIndex = hasSelection
                      ? GeometryMath.hitTestHandles(selectionRect.handles, event.position, AppConstants.handleHitRadius)
                      : -1;

                  if (!hasSelection || handleIndex != -1 || editor.activeTool == AnnotationTool.select || !selectionRect.contains(event.position)) {
                    // Selection move/resize or starting new box
                    capture.onPointerDown(event.position);
                  } else if (hasSelection && selectionRect.contains(event.position)) {
                    // Drawing with active tool inside selection
                    editor.onDrawStart(event.position, undoRedo);
                  }
                },
                onPointerMove: (event) {
                  _updateCursor(event.position, selectionRect, editor.activeTool);
                  if (editor.inProgressElement != null) {
                    editor.onDrawUpdate(event.position);
                  } else {
                    capture.onPointerMove(event.position);
                  }
                },
                onPointerUp: (_) {
                  if (editor.inProgressElement != null) {
                    editor.onDrawEnd(undoRedo);
                  }
                  capture.onPointerUp();
                },
                child: CustomPaint(
                  painter: SelectionBoxPainter(
                    baseImage: capture.baseUiImage,
                    selectionRect: capture.selectionRect,
                  ),
                  child: hasSelection
                      ? ClipRect(
                          clipper: _SelectionRectClipper(selectionRect),
                          child: CustomPaint(
                            painter: AnnotationCanvasPainter(
                              elements: editor.elements,
                              inProgressElement: editor.inProgressElement,
                            ),
                          ),
                        )
                      : const SizedBox.expand(),
                ),
              ),

              // 2. Top-Left Dimension Badge [ 452x345 ]
              if (hasSelection)
                Positioned(
                  left: badgeLeft,
                  top: badgeTop,
                  child: DimensionBadge(
                    width: selectionRect.width.round(),
                    height: selectionRect.height.round(),
                  ),
                ),

              // 3. Right Vertical Annotation Toolbar
              if (hasSelection)
                Positioned(
                  left: verticalToolbarLeft,
                  top: verticalToolbarTop,
                  child: const VerticalAnnotationToolbar(),
                ),

              // 4. Bottom Horizontal Action Toolbar
              if (hasSelection)
                Positioned(
                  left: horizontalToolbarLeft,
                  top: horizontalToolbarTop,
                  child: HorizontalActionToolbar(
                    onPin: widget.onPin,
                    onOpenHistory: widget.onOpenHistory,
                  ),
                ),

              // 5. In-line Text Editor (when Text tool active)
              if (editor.isWritingText && editor.textPosition != null)
                InlineTextEditor(position: editor.textPosition!),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionRectClipper extends CustomClipper<Rect> {
  final Rect rect;
  _SelectionRectClipper(this.rect);

  @override
  Rect getClip(Size size) => rect;

  @override
  bool shouldReclip(covariant _SelectionRectClipper oldClipper) => oldClipper.rect != rect;
}
