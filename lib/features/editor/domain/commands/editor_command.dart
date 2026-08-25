import '../entities/annotation_element.dart';

abstract class EditorCommand {
  void execute(List<AnnotationElement> targetList);
  void undo(List<AnnotationElement> targetList);
}

class AddElementCommand implements EditorCommand {
  final AnnotationElement element;

  AddElementCommand(this.element);

  @override
  void execute(List<AnnotationElement> targetList) {
    targetList.add(element);
  }

  @override
  void undo(List<AnnotationElement> targetList) {
    targetList.removeWhere((e) => e.id == element.id);
  }
}

class DeleteElementCommand implements EditorCommand {
  final AnnotationElement element;
  int _removedIndex = -1;

  DeleteElementCommand(this.element);

  @override
  void execute(List<AnnotationElement> targetList) {
    _removedIndex = targetList.indexWhere((e) => e.id == element.id);
    if (_removedIndex != -1) {
      targetList.removeAt(_removedIndex);
    }
  }

  @override
  void undo(List<AnnotationElement> targetList) {
    if (_removedIndex != -1 && _removedIndex <= targetList.length) {
      targetList.insert(_removedIndex, element);
    } else {
      targetList.add(element);
    }
  }
}

class ClearAllCommand implements EditorCommand {
  final List<AnnotationElement> _backup = [];

  @override
  void execute(List<AnnotationElement> targetList) {
    _backup.clear();
    _backup.addAll(targetList);
    targetList.clear();
  }

  @override
  void undo(List<AnnotationElement> targetList) {
    targetList.clear();
    targetList.addAll(_backup);
  }
}
