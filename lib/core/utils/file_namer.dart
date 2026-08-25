import 'package:intl/intl.dart';

class FileNamer {
  static String generateScreenshotName({String extension = 'png'}) {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd_HHmmss');
    final formattedDate = formatter.format(now);
    return 'SnapMark_$formattedDate.$extension';
  }
}
