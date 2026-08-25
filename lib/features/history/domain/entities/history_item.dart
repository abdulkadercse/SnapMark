class HistoryItem {
  final String id;
  final String filePath;
  final DateTime timestamp;
  final int width;
  final int height;
  final int fileSizeBytes;

  const HistoryItem({
    required this.id,
    required this.filePath,
    required this.timestamp,
    required this.width,
    required this.height,
    required this.fileSizeBytes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'filePath': filePath,
    'timestamp': timestamp.toIso8601String(),
    'width': width,
    'height': height,
    'fileSizeBytes': fileSizeBytes,
  };

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      width: json['width'] as int,
      height: json['height'] as int,
      fileSizeBytes: json['fileSizeBytes'] as int,
    );
  }
}
