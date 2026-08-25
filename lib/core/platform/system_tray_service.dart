import 'dart:io';
import 'package:tray_manager/tray_manager.dart';

abstract class SystemTrayEventListener {
  void onTakeScreenshotClicked();
  void onHistoryClicked();
  void onPreferencesClicked();
  void onAboutClicked();
  void onQuitClicked();
}

class SystemTrayService with TrayListener {
  final SystemTrayEventListener listener;

  SystemTrayService({required this.listener}) {
    trayManager.addListener(this);
  }

  Future<void> initialize() async {
    final iconPath = Platform.isWindows ? 'assets/icons/app_icon.ico' : 'assets/icons/tray_icon.png';
    try {
      await trayManager.setIcon(iconPath);
    } catch (_) {}

    final shortcutLabel = Platform.isMacOS ? '⇧⌘9' : 'Ctrl+Shift+A';

    final menu = Menu(
      items: [
        MenuItem(
          key: 'take_screenshot',
          label: 'Take screenshot      $shortcutLabel',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'history',
          label: 'History...',
        ),
        MenuItem(
          key: 'preferences',
          label: 'Preferences...',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'about',
          label: 'About SnapMark',
        ),
        MenuItem(
          key: 'quit',
          label: 'Quit SnapMark',
        ),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'take_screenshot':
        listener.onTakeScreenshotClicked();
        break;
      case 'history':
        listener.onHistoryClicked();
        break;
      case 'preferences':
        listener.onPreferencesClicked();
        break;
      case 'about':
        listener.onAboutClicked();
        break;
      case 'quit':
        listener.onQuitClicked();
        break;
    }
  }

  void dispose() {
    trayManager.removeListener(this);
  }
}
