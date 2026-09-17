import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:provider/provider.dart';
import '../../../../app/app.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../capture/presentation/providers/capture_provider.dart';
import '../providers/history_provider.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    final items = history.filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SnapMark — Capture History', style: AppTypography.dialogTitle),
        elevation: 0,
        actions: [
          FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            icon: const Icon(Icons.camera_alt, size: 16),
            label: const Text('Take Screenshot (⇧⌘9)'),
            onPressed: () {
              final appState = SnapMarkApp.of(context);
              appState?.openCaptureOverlay();
              context.read<CaptureProvider>().triggerCapture();
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Preferences',
            onPressed: () {
              SnapMarkApp.of(context)?.openSettings();
            },
          ),
          if (history.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear All History',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear All Captures?'),
                    content: const Text('This will remove all history records. Files on disk will remain safe.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: AppColors.dangerRed),
                        onPressed: () {
                          history.clearAll();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search captures by date, name, dimensions...',
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => history.setSearchQuery(val),
            ),
          ),
          // History Grid
          Expanded(
            child: history.isLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.photo_library_outlined, size: 56, color: Colors.grey.shade500),
                            const SizedBox(height: 16),
                            const Text('No captures yet in history.', style: AppTypography.bodyBold),
                            const SizedBox(height: 6),
                            Text(
                              'Press ⇧⌘9 or click below to capture any portion of your screen.',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                            const SizedBox(height: 18),
                            FilledButton.icon(
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Take Screenshot Now'),
                              onPressed: () {
                                final appState = SnapMarkApp.of(context);
                                appState?.openCaptureOverlay();
                                context.read<CaptureProvider>().triggerCapture();
                              },
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final file = File(item.filePath);
                          final dateStr = DateFormat('MMM dd, yyyy  HH:mm').format(item.timestamp);
                          final sizeKb = (item.fileSizeBytes / 1024).toStringAsFixed(1);

                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: file.existsSync()
                                          ? Tooltip(
                                              message: dateStr,
                                              child: Image.file(file, fit: BoxFit.cover),
                                            )
                                          : const Center(child: Icon(Icons.broken_image)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      color: Colors.black26,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${item.width}x${item.height} px', style: AppTypography.caption),
                                          Text('$sizeKb KB', style: AppTypography.caption),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Quick action buttons on card
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton.filledTonal(
                                        iconSize: 14,
                                        padding: const EdgeInsets.all(6),
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.copy),
                                        tooltip: 'Copy Image',
                                        onPressed: () async {
                                          if (file.existsSync()) {
                                            final bytes = await file.readAsBytes();
                                            await Pasteboard.writeImage(bytes);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Copied to clipboard!'), duration: Duration(seconds: 1)),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton.filledTonal(
                                        iconSize: 14,
                                        padding: const EdgeInsets.all(6),
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.delete_outline, color: AppColors.dangerRed),
                                        tooltip: 'Delete',
                                        onPressed: () => history.deleteItem(item.id),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
