import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/app.dart';
import '../../../../app/theme/app_typography.dart';
import '../providers/settings_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _pickDirectory(BuildContext context) async {
    final settings = context.read<SettingsProvider>();
    final selectedDir = await FilePicker.platform.getDirectoryPath();
    if (selectedDir != null && selectedDir.isNotEmpty) {
      await settings.setSaveDirectory(selectedDir);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences', style: AppTypography.dialogTitle),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to History',
          onPressed: () {
            SnapMarkApp.of(context)?.openHistory();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Shortcuts Section
          const Text('Keyboard Shortcuts', style: AppTypography.bodyBold),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.keyboard_outlined),
              title: const Text('Capture Screen Shortcut'),
              subtitle: const Text('Global shortcut to trigger capture overlay'),
              trailing: Chip(
                label: Text(
                  settings.settings.captureHotkey,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. Storage & Export Section
          const Text('Storage & Export', style: AppTypography.bodyBold),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.folder_open_outlined),
                  title: const Text('Default Save Location'),
                  subtitle: Text(
                    settings.saveDirectory.isEmpty ? 'Not selected' : settings.saveDirectory,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: OutlinedButton(
                    onPressed: () => _pickDirectory(context),
                    child: const Text('Browse...'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('Default Image Format'),
                  subtitle: const Text('Format used when saving screenshots'),
                  trailing: DropdownButton<String>(
                    value: settings.exportFormat,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'png', child: Text('PNG (Lossless)')),
                      DropdownMenuItem(value: 'jpg', child: Text('JPG (Compact)')),
                      DropdownMenuItem(value: 'webp', child: Text('WEBP (Modern)')),
                    ],
                    onChanged: (val) {
                      if (val != null) settings.setExportFormat(val);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Automation Section
          const Text('Automation & Behavior', style: AppTypography.bodyBold),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.content_copy_outlined),
                  title: const Text('Auto-copy to Clipboard'),
                  subtitle: const Text('Automatically copy image to clipboard when saved'),
                  value: settings.autoCopyToClipboard,
                  onChanged: (val) => settings.toggleAutoCopy(val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark Mode Theme'),
                  subtitle: const Text('Switch between sleek dark and light appearance'),
                  value: settings.isDarkMode,
                  onChanged: (val) => settings.toggleDarkMode(val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
