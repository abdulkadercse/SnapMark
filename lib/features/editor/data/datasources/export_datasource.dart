import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import '../../../../core/utils/file_namer.dart';
import '../../domain/entities/annotation_element.dart';

class ExportDatasource {
  /// Render base screenshot cropped to [selectionRect] with all [elements] on top
  Future<Uint8List> renderCompositeImage({
    required ui.Image baseImage,
    required Rect selectionRect,
    required List<AnnotationElement> elements,
    double pixelRatio = 1.0,
  }) async {
    final width = selectionRect.width.round();
    final height = selectionRect.height.round();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

    // Draw the cropped portion of the base image
    final srcRect = Rect.fromLTWH(
      selectionRect.left * pixelRatio,
      selectionRect.top * pixelRatio,
      selectionRect.width * pixelRatio,
      selectionRect.height * pixelRatio,
    );
    final dstRect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

    canvas.drawImageRect(baseImage, srcRect, dstRect, Paint());

    // Shift canvas coordinate space so (0,0) is top-left of selection
    canvas.save();
    canvas.translate(-selectionRect.left, -selectionRect.top);

    for (final element in elements) {
      element.draw(canvas, Size(width.toDouble(), height.toDouble()));
    }
    canvas.restore();

    final picture = recorder.endRecording();
    final compositeUiImage = await picture.toImage(width, height);
    final byteData = await compositeUiImage.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to encode image to PNG format.');
    }

    return byteData.buffer.asUint8List();
  }

  /// Copy PNG bytes to system clipboard
  Future<void> copyToClipboard(Uint8List imageBytes) async {
    await Pasteboard.writeImage(imageBytes);
  }

  /// Save PNG bytes to local file path
  Future<File> saveToFile({
    required Uint8List imageBytes,
    required String directoryPath,
    String? customFileName,
  }) async {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final fileName = customFileName ?? FileNamer.generateScreenshotName(extension: 'png');
    final filePath = '$directoryPath/$fileName';
    final file = File(filePath);
    return await file.writeAsBytes(imageBytes);
  }
}
