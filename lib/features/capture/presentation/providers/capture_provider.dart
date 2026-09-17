import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/rect_extensions.dart';
import '../../../../core/platform/screen_capture_service.dart';
import '../../../../core/platform/window_controller.dart';
import '../../../../core/utils/geometry_math.dart';

class CaptureProvider extends ChangeNotifier {
  final ScreenCaptureService screenCaptureService;

  bool _isOverlayOpen = false;
  bool _isLoading = false;
  Uint8List? _rawImageBytes;
  ui.Image? _baseUiImage;

  Rect? _selectionRect;
  Offset? _dragStart;
  int _activeHandleIndex = -1;
  bool _isMovingSelection = false;
  Offset? _moveOffset;

  CaptureProvider(this.screenCaptureService);

  bool get isOverlayOpen => _isOverlayOpen;
  bool get isLoading => _isLoading;
  Uint8List? get rawImageBytes => _rawImageBytes;
  ui.Image? get baseUiImage => _baseUiImage;
  Rect? get selectionRect => _selectionRect;
  int get activeHandleIndex => _activeHandleIndex;
  bool get hasSelection => _selectionRect != null && _selectionRect!.width >= AppConstants.minSelectionSize && _selectionRect!.height >= AppConstants.minSelectionSize;

  Future<void> triggerCapture() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ensure any visible SnapMark window is hidden before capturing screen
      await windowManager.hide();
      await Future.delayed(const Duration(milliseconds: 150));

      // 1. Grab uncompressed screen bitmap
      final bytes = await screenCaptureService.captureEntireScreen();
      _rawImageBytes = bytes;

      // 2. Decode to ui.Image for Flutter canvas
      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      _baseUiImage = frameInfo.image;

      _selectionRect = null;
      _isOverlayOpen = true;
      _isLoading = false;
      notifyListeners();

      // 3. Expand window to fullscreen overlay
      await WindowController.showOverlayWindow();
    } catch (e) {
      _isLoading = false;
      _isOverlayOpen = false;
      notifyListeners();
      debugPrint('Error triggering capture: $e');
    }
  }

  void onPointerDown(Offset pos) {
    if (_selectionRect == null) {
      // Start a brand new selection
      _dragStart = pos;
      _selectionRect = Rect.fromPoints(pos, pos);
      _activeHandleIndex = -1;
      _isMovingSelection = false;
      notifyListeners();
      return;
    }

    final normRect = _selectionRect!.normalized;

    // 1. Check if clicking on one of the 8 resize handles
    final handleIndex = GeometryMath.hitTestHandles(
      normRect.handles,
      pos,
      AppConstants.handleHitRadius,
    );

    if (handleIndex != -1) {
      _activeHandleIndex = handleIndex;
      _dragStart = pos;
      _isMovingSelection = false;
      notifyListeners();
      return;
    }

    // 2. Check if clicking inside the selection (to move it)
    if (normRect.contains(pos)) {
      _isMovingSelection = true;
      _moveOffset = pos - normRect.topLeft;
      _activeHandleIndex = -1;
      notifyListeners();
      return;
    }

    // 3. Clicking outside resets and starts a new selection
    _dragStart = pos;
    _selectionRect = Rect.fromPoints(pos, pos);
    _activeHandleIndex = -1;
    _isMovingSelection = false;
    notifyListeners();
  }

  void onPointerMove(Offset pos) {
    if (_dragStart == null && !_isMovingSelection && _activeHandleIndex == -1) return;

    if (_isMovingSelection && _moveOffset != null && _selectionRect != null) {
      final norm = _selectionRect!.normalized;
      final newTopLeft = pos - _moveOffset!;
      _selectionRect = Rect.fromLTWH(newTopLeft.dx, newTopLeft.dy, norm.width, norm.height);
      notifyListeners();
      return;
    }

    if (_activeHandleIndex != -1 && _selectionRect != null) {
      // Resize by specific handle
      final norm = _selectionRect!.normalized;
      double l = norm.left;
      double t = norm.top;
      double r = norm.right;
      double b = norm.bottom;

      switch (_activeHandleIndex) {
        case 0: // NW
          l = pos.dx;
          t = pos.dy;
          break;
        case 1: // N
          t = pos.dy;
          break;
        case 2: // NE
          r = pos.dx;
          t = pos.dy;
          break;
        case 3: // E
          r = pos.dx;
          break;
        case 4: // SE
          r = pos.dx;
          b = pos.dy;
          break;
        case 5: // S
          b = pos.dy;
          break;
        case 6: // SW
          l = pos.dx;
          b = pos.dy;
          break;
        case 7: // W
          l = pos.dx;
          break;
      }
      _selectionRect = Rect.fromLTRB(l, t, r, b);
      notifyListeners();
      return;
    }

    if (_dragStart != null) {
      // Dragging new selection box
      _selectionRect = Rect.fromPoints(_dragStart!, pos);
      notifyListeners();
    }
  }

  void onPointerUp() {
    if (_selectionRect != null) {
      _selectionRect = _selectionRect!.normalized;
      // If user merely tapped without dragging, reset selection
      if (_selectionRect!.width < AppConstants.minSelectionSize ||
          _selectionRect!.height < AppConstants.minSelectionSize) {
        _selectionRect = null;
      }
    }
    _dragStart = null;
    _activeHandleIndex = -1;
    _isMovingSelection = false;
    _moveOffset = null;
    notifyListeners();
  }

  Future<void> dismissOverlay() async {
    _isOverlayOpen = false;
    _selectionRect = null;
    _rawImageBytes = null;
    _baseUiImage?.dispose();
    _baseUiImage = null;
    notifyListeners();
    await WindowController.hideOverlayWindow();
  }
}
