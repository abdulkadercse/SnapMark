class PlatformCaptureException implements Exception {
  final String message;
  const PlatformCaptureException(this.message);

  @override
  String toString() => 'PlatformCaptureException: $message';
}

class StorageException implements Exception {
  final String message;
  const StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
