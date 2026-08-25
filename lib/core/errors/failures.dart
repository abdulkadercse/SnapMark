abstract class Failure {
  final String message;
  final dynamic cause;

  const Failure(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

class CaptureFailure extends Failure {
  const CaptureFailure(super.message, [super.cause]);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.cause]);
}

class HotkeyFailure extends Failure {
  const HotkeyFailure(super.message, [super.cause]);
}
