import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:screen_retriever/screen_retriever.dart';
import '../errors/exceptions.dart';

abstract class ScreenCaptureService {
  Future<Uint8List> captureEntireScreen();
  Future<List<Display>> getDisplays();
}

class ScreenCaptureServiceImpl implements ScreenCaptureService {
  @override
  Future<List<Display>> getDisplays() async {
    try {
      return await ScreenRetriever.instance.getAllDisplays();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Uint8List> captureEntireScreen() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/snapmark_raw_capture_${DateTime.now().millisecondsSinceEpoch}.png';

      if (Platform.isMacOS) {
        // macOS built-in screencapture utility (Fast & high-res Retina support)
        final result = await Process.run('screencapture', ['-x', '-C', tempFilePath]);
        if (result.exitCode != 0) {
          throw PlatformCaptureException('Failed to capture screen: ${result.stderr}');
        }
      } else if (Platform.isWindows) {
        // Windows capture using powershell .NET bitmap capture
        const psScript = '''
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
\$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
\$bmp = New-Object System.Drawing.Bitmap \$bounds.Width, \$bounds.Height
\$g = [System.Drawing.Graphics]::FromImage(\$bmp)
\$g.CopyFromScreen(\$bounds.Location, [System.Drawing.Point]::Empty, \$bounds.Size)
\$bmp.Save(\$args[0], [System.Drawing.Imaging.ImageFormat]::Png)
\$g.Dispose()
\$bmp.Dispose()
''';
        final result = await Process.run('powershell', ['-Command', psScript, tempFilePath]);
        if (result.exitCode != 0) {
          throw PlatformCaptureException('Failed Windows screen capture: ${result.stderr}');
        }
      } else if (Platform.isLinux) {
        // Linux capture with scrot, import or gnome-screenshot
        ProcessResult? result;
        try {
          result = await Process.run('gnome-screenshot', ['-f', tempFilePath]);
        } catch (_) {
          try {
            result = await Process.run('scrot', [tempFilePath]);
          } catch (_) {
            result = await Process.run('import', ['-window', 'root', tempFilePath]);
          }
        }
        if (result.exitCode != 0) {
          throw PlatformCaptureException('Failed Linux screen capture: ${result.stderr}');
        }
      }

      final file = File(tempFilePath);
      if (!await file.exists()) {
        throw const PlatformCaptureException('Captured image file was not created.');
      }

      final bytes = await file.readAsBytes();
      // Clean up temporary capture file asynchronously
      file.delete().ignore();

      return bytes;
    } catch (e) {
      if (e is PlatformCaptureException) rethrow;
      throw PlatformCaptureException(e.toString());
    }
  }
}
