import 'package:flutter/foundation.dart';
import '../../domain/commands/editor_command.dart';
import '../../domain/entities/annotation_element.dart';

class UndoRedoProvider extends ChangeNotifier {
  final List<EditorCommand> _undoStack = [];
  final List<EditorCommand> _redoStack = [];

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void executeCommand(EditorCommand command, List<AnnotationElement> elements) {
    command.execute(elements);
    _undoStack.add(command);
    _redoStack.clear();
    notifyListeners();
  }

  void undo(List<AnnotationElement> elements) {
    if (!canUndo) return;
    final command = _undoStack.removeLast();
    command.undo(elements);
    _redoStack.add(command);
    notifyListeners();
  }

  void redo(List<AnnotationElement> elements) {
    if (!canRedo) return;
    final command = _redoStack.removeLast();
    command.execute(elements);
    _undoStack.add(command);
    notifyListeners();
  }

  void clearHistory() {
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
  }
}
