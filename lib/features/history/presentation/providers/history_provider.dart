import 'package:flutter/foundation.dart';
import '../../domain/entities/history_item.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryRepository repository;

  List<HistoryItem> _items = [];
  bool _isLoading = false;
  String _searchQuery = '';

  HistoryProvider(this.repository);

  List<HistoryItem> get items => _items;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  List<HistoryItem> get filteredItems {
    if (_searchQuery.trim().isEmpty) return _items;
    final q = _searchQuery.toLowerCase();
    return _items.where((item) =>
      item.filePath.toLowerCase().contains(q) ||
      '${item.width}x${item.height}'.contains(q) ||
      item.timestamp.toString().contains(q)
    ).toList();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    _items = await repository.getHistory();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCapture(HistoryItem item) async {
    await repository.addHistoryItem(item);
    _items.insert(0, item);
    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    await repository.deleteHistoryItem(id);
    _items.removeWhere((it) => it.id == id);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await repository.clearHistory();
    _items.clear();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
