import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapmark/features/editor/domain/commands/editor_command.dart';
import 'package:snapmark/features/editor/domain/entities/annotation_element.dart';
import 'package:snapmark/features/editor/presentation/providers/undo_redo_provider.dart';

void main() {
  test('UndoRedoProvider executes command and reverts correctly', () {
    final undoRedo = UndoRedoProvider();
    final List<AnnotationElement> elements = [];

    final rectElement = RectangleElement(
      id: 'test-1',
      color: Colors.red,
      strokeWidth: 2.0,
      rect: const Rect.fromLTWH(10, 10, 100, 100),
    );

    // 1. Execute Add Command
    undoRedo.executeCommand(AddElementCommand(rectElement), elements);
    expect(elements.length, 1);
    expect(undoRedo.canUndo, isTrue);
    expect(undoRedo.canRedo, isFalse);

    // 2. Undo
    undoRedo.undo(elements);
    expect(elements.isEmpty, isTrue);
    expect(undoRedo.canUndo, isFalse);
    expect(undoRedo.canRedo, isTrue);

    // 3. Redo
    undoRedo.redo(elements);
    expect(elements.length, 1);
    expect(elements.first.id, 'test-1');
  });
}
