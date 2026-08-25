import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/widgets/buttons/toolbar_icon_button.dart';
import '../../../editor/data/datasources/export_datasource.dart';
import '../../../editor/presentation/providers/editor_provider.dart';
import '../../../history/domain/entities/history_item.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../presentation/providers/capture_provider.dart';

class HorizontalActionToolbar extends StatelessWidget {
  final VoidCallback onPin;
  final VoidCallback onOpenHistory;

  const HorizontalActionToolbar({
    super.key,
    required this.onPin,
    required this.onOpenHistory,
  });

  Future<void> _handleCopy(BuildContext context) async {
    final capture = context.read<CaptureProvider>();
    final editor = context.read<EditorProvider>();
    final settings = context.read<SettingsProvider>();
    final history = context.read<HistoryProvider>();

    if (capture.baseUiImage == null || capture.selectionRect == null) return;

    try {
      final exportDs = ExportDatasource();
      final bytes = await exportDs.renderCompositeImage(
        baseImage: capture.baseUiImage!,
        selectionRect: capture.selectionRect!,
        elements: editor.elements,
      );

      // Copy to system clipboard
      await exportDs.copyToClipboard(bytes);

      // Save to history automatically in background
      final savedFile = await exportDs.saveToFile(
        imageBytes: bytes,
        directoryPath: settings.saveDirectory,
      );

      await history.addCapture(
        HistoryItem(
          id: const Uuid().v4(),
          filePath: savedFile.path,
          timestamp: DateTime.now(),
          width: capture.selectionRect!.width.round(),
          height: capture.selectionRect!.height.round(),
          fileSizeBytes: bytes.lengthInBytes,
        ),
      );

      // Close overlay
      editor.reset();
      await capture.dismissOverlay();
    } catch (e) {
      debugPrint('Error copying screenshot: $e');
    }
  }

  Future<void> _handleSave(BuildContext context) async {
    final capture = context.read<CaptureProvider>();
    final editor = context.read<EditorProvider>();
    final settings = context.read<SettingsProvider>();
    final history = context.read<HistoryProvider>();

    if (capture.baseUiImage == null || capture.selectionRect == null) return;

    try {
      final exportDs = ExportDatasource();
      final bytes = await exportDs.renderCompositeImage(
        baseImage: capture.baseUiImage!,
        selectionRect: capture.selectionRect!,
        elements: editor.elements,
      );

      final savedFile = await exportDs.saveToFile(
        imageBytes: bytes,
        directoryPath: settings.saveDirectory,
      );

      await history.addCapture(
        HistoryItem(
          id: const Uuid().v4(),
          filePath: savedFile.path,
          timestamp: DateTime.now(),
          width: capture.selectionRect!.width.round(),
          height: capture.selectionRect!.height.round(),
          fileSizeBytes: bytes.lengthInBytes,
        ),
      );

      if (settings.autoCopyToClipboard) {
        await exportDs.copyToClipboard(bytes);
      }

      editor.reset();
      await capture.dismissOverlay();
    } catch (e) {
      debugPrint('Error saving screenshot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final capture = context.read<CaptureProvider>();
    final editor = context.read<EditorProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ToolbarIconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Save to Disk (Ctrl/Cmd+S)',
            onTap: () => _handleSave(context),
          ),
          ToolbarIconButton(
            icon: const Icon(Icons.copy_outlined),
            tooltip: 'Copy to Clipboard (Ctrl/Cmd+C)',
            onTap: () => _handleCopy(context),
          ),
          ToolbarIconButton(
            icon: const Icon(Icons.push_pin_outlined),
            tooltip: 'Pin on Screen',
            onTap: onPin,
          ),
          ToolbarIconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'History Gallery',
            onTap: onOpenHistory,
          ),
          const SizedBox(
            height: 18,
            child: VerticalDivider(width: 6, color: Color(0xFFD0D7DE)),
          ),
          ToolbarIconButton(
            icon: const Icon(Icons.close, color: Color(0xFFDA3633)),
            tooltip: 'Cancel (Esc)',
            onTap: () {
              editor.reset();
              capture.dismissOverlay();
            },
          ),
        ],
      ),
    );
  }
}
