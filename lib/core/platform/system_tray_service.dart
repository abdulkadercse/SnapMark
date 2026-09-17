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
      await trayManager.setIcon(iconPath, isTemplate: true);
    } catch (_) {}

    final shortcutLabel = Platform.isMacOS ? '⇧⌘9' : 'Ctrl+Shift+A';

    final menu = Menu(
      items: [
        MenuItem(
          key: 'take_screenshot',
          label: 'Take screenshot      $shortcutLabel',
          onClick: (_) => listener.onTakeScreenshotClicked(),
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'history',
          label: 'History...',
          onClick: (_) => listener.onHistoryClicked(),
        ),
        MenuItem(
          key: 'preferences',
          label: 'Preferences...',
          onClick: (_) => listener.onPreferencesClicked(),
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'about',
          label: 'About SnapMark',
          onClick: (_) => listener.onAboutClicked(),
        ),
        MenuItem(
          key: 'quit',
          label: 'Quit SnapMark',
          onClick: (_) => listener.onQuitClicked(),
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
