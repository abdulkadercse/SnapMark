import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/commands/editor_command.dart';
import '../../domain/entities/annotation_element.dart';
import 'undo_redo_provider.dart';

class EditorProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  AnnotationTool _activeTool = AnnotationTool.select; // Default to select/move mode
  Color _currentColor = AppConstants.defaultDrawColor;
  double _strokeWidth = AppConstants.defaultStrokeWidth;
  double _fontSize = AppConstants.defaultFontSize;
  int _stepCounter = 1;

  final List<AnnotationElement> _elements = [];
  AnnotationElement? _inProgressElement;

  // In-line Text Editing State
  Offset? _textPosition;
  bool _isWritingText = false;

  AnnotationTool get activeTool => _activeTool;
  Color get currentColor => _currentColor;
  double get strokeWidth => _strokeWidth;
  double get fontSize => _fontSize;
  int get stepCounter => _stepCounter;
  List<AnnotationElement> get elements => List.unmodifiable(_elements);
  AnnotationElement? get inProgressElement => _inProgressElement;
  Offset? get textPosition => _textPosition;
  bool get isWritingText => _isWritingText;

  void setActiveTool(AnnotationTool tool) {
    // If clicking same tool again, toggle back to select/move mode
    if (_activeTool == tool && tool != AnnotationTool.select) {
      _activeTool = AnnotationTool.select;
    } else {
      _activeTool = tool;
    }
    _inProgressElement = null;
    _isWritingText = false;
    notifyListeners();
  }

  void setColor(Color color) {
    _currentColor = color;
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void resetStepCounter() {
    _stepCounter = 1;
    notifyListeners();
  }

  // Pointer Interaction Handlers for Drawing on Canvas
  void onDrawStart(Offset point, UndoRedoProvider undoRedo) {
    final id = _uuid.v4();

    switch (_activeTool) {
      case AnnotationTool.pen:
        _inProgressElement = PenElement(
          id: id,
          color: _currentColor,
          strokeWidth: _strokeWidth,
          points: [point],
        );
        break;
      case AnnotationTool.line:
        _inProgressElement = LineElement(
          id: id,
          color: _currentColor,
          strokeWidth: _strokeWidth,
          start: point,
          end: point,
        );
        break;
      case AnnotationTool.arrow:
        _inProgressElement = ArrowElement(
          id: id,
          color: _currentColor,
          strokeWidth: _strokeWidth,
          start: point,
          end: point,
        );
        break;
      case AnnotationTool.rectangle:
        _inProgressElement = RectangleElement(
          id: id,
          color: _currentColor,
          strokeWidth: _strokeWidth,
          rect: Rect.fromPoints(point, point),
        );
        break;
      case AnnotationTool.circle:
        _inProgressElement = CircleElement(
          id: id,
          color: _currentColor,
          strokeWidth: _strokeWidth,
          rect: Rect.fromPoints(point, point),
        );
        break;
      case AnnotationTool.highlighter:
        _inProgressElement = HighlighterElement(
          id: id,
          color: _currentColor,
          strokeWidth: _strokeWidth,
          points: [point],
        );
        break;
      case AnnotationTool.blur:
        _inProgressElement = BlurElement(
          id: id,
          rect: Rect.fromPoints(point, point),
        );
        break;
      case AnnotationTool.stepMarker:
        final marker = StepMarkerElement(
          id: id,
          color: _currentColor,
          center: point,
          stepNumber: _stepCounter++,
        );
        undoRedo.executeCommand(AddElementCommand(marker), _elements);
        _inProgressElement = null;
        break;
      case AnnotationTool.text:
        _textPosition = point;
        _isWritingText = true;
        _inProgressElement = null;
        break;
      case AnnotationTool.select:
        _inProgressElement = null;
        break;
    }
    notifyListeners();
  }

  void onDrawUpdate(Offset point) {
    if (_inProgressElement == null) return;

    if (_inProgressElement is PenElement) {
      final current = _inProgressElement as PenElement;
      _inProgressElement = PenElement(
        id: current.id,
        color: current.color,
        strokeWidth: current.strokeWidth,
        points: [...current.points, point],
      );
    } else if (_inProgressElement is LineElement) {
      final current = _inProgressElement as LineElement;
      _inProgressElement = LineElement(
        id: current.id,
        color: current.color,
        strokeWidth: current.strokeWidth,
        start: current.start,
        end: point,
      );
    } else if (_inProgressElement is ArrowElement) {
      final current = _inProgressElement as ArrowElement;
      _inProgressElement = ArrowElement(
        id: current.id,
        color: current.color,
        strokeWidth: current.strokeWidth,
        start: current.start,
        end: point,
      );
    } else if (_inProgressElement is RectangleElement) {
      final current = _inProgressElement as RectangleElement;
      _inProgressElement = RectangleElement(
        id: current.id,
        color: current.color,
        strokeWidth: current.strokeWidth,
        rect: Rect.fromPoints(current.rect.topLeft, point),
      );
    } else if (_inProgressElement is CircleElement) {
      final current = _inProgressElement as CircleElement;
      _inProgressElement = CircleElement(
        id: current.id,
        color: current.color,
        strokeWidth: current.strokeWidth,
        rect: Rect.fromPoints(current.rect.topLeft, point),
      );
    } else if (_inProgressElement is HighlighterElement) {
      final current = _inProgressElement as HighlighterElement;
      _inProgressElement = HighlighterElement(
        id: current.id,
        color: current.color,
        strokeWidth: current.strokeWidth,
        points: [...current.points, point],
      );
    } else if (_inProgressElement is BlurElement) {
      final current = _inProgressElement as BlurElement;
      _inProgressElement = BlurElement(
        id: current.id,
        rect: Rect.fromPoints(current.rect.topLeft, point),
      );
    }
    notifyListeners();
  }

  void onDrawEnd(UndoRedoProvider undoRedo) {
    if (_inProgressElement != null) {
      undoRedo.executeCommand(AddElementCommand(_inProgressElement!), _elements);
      _inProgressElement = null;
      notifyListeners();
    }
  }

  void submitText(String text, UndoRedoProvider undoRedo) {
    if (text.trim().isNotEmpty && _textPosition != null) {
      final element = TextElement(
        id: _uuid.v4(),
        color: _currentColor,
        strokeWidth: _strokeWidth,
        position: _textPosition!,
        text: text,
        fontSize: _fontSize,
      );
      undoRedo.executeCommand(AddElementCommand(element), _elements);
    }
    _isWritingText = false;
    _textPosition = null;
    notifyListeners();
  }

  void cancelText() {
    _isWritingText = false;
    _textPosition = null;
    notifyListeners();
  }

  void undo(UndoRedoProvider undoRedo) {
    undoRedo.undo(_elements);
    notifyListeners();
  }

  void clearAll(UndoRedoProvider undoRedo) {
    undoRedo.executeCommand(ClearAllCommand(), _elements);
    _stepCounter = 1;
    _inProgressElement = null;
    _isWritingText = false;
    notifyListeners();
  }

  void reset() {
    _elements.clear();
    _inProgressElement = null;
    _activeTool = AnnotationTool.select;
    _stepCounter = 1;
    _isWritingText = false;
    _textPosition = null;
    notifyListeners();
  }
}
