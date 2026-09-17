# SnapMark

Offline-first Desktop Screenshot & Annotation Application.

## Environment & Requirements

- **Flutter Version:** `3.44.8` (Channel: `stable`)
- **Dart Version:** `3.12.2`
- **macOS Deployment Target:** `12.0` or higher

## Getting Started

1. Ensure dependencies are fetched:
   ```bash
   flutter pub get
   ```

2. For macOS desktop:
   ```bash
   cd macos && pod install && cd ..
   ```

3. Run the application:
   ```bash
   flutter run -d macos
   ```

## Global Shortcuts

- **Take Screenshot:** `⇧⌘9` (macOS) / `Ctrl+Shift+A` (Windows/Linux)
- **Cancel / Dismiss:** `Esc`
- **Copy Image:** `⌘C` / `Ctrl+C`
- **Save to Disk:** `⌘S` / `Ctrl+S`
