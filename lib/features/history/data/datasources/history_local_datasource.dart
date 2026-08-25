import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/history_item.dart';

class HistoryLocalDatasource {
  Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonListStr = prefs.getStringList(AppConstants.prefsHistoryKey) ?? [];
    final List<HistoryItem> items = [];

    for (final itemStr in jsonListStr) {
      try {
        final map = jsonDecode(itemStr) as Map<String, dynamic>;
        final item = HistoryItem.fromJson(map);
        // Only return if the image file still exists on disk
        if (File(item.filePath).existsSync()) {
          items.add(item);
        }
      } catch (_) {}
    }

    // Sort newest first
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return items;
  }

  Future<void> addHistoryItem(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = prefs.getStringList(AppConstants.prefsHistoryKey) ?? [];
    currentList.insert(0, jsonEncode(item.toJson()));

    // Keep max 100 recent captures
    if (currentList.length > 100) {
      currentList.removeRange(100, currentList.length);
    }

    await prefs.setStringList(AppConstants.prefsHistoryKey, currentList);
  }

  Future<void> deleteHistoryItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = prefs.getStringList(AppConstants.prefsHistoryKey) ?? [];
    final updatedList = <String>[];

    for (final itemStr in currentList) {
      try {
        final map = jsonDecode(itemStr) as Map<String, dynamic>;
        if (map['id'] == id) {
          final filePath = map['filePath'] as String;
          final file = File(filePath);
          if (file.existsSync()) {
            file.deleteSync();
          }
        } else {
          updatedList.add(itemStr);
        }
      } catch (_) {}
    }

    await prefs.setStringList(AppConstants.prefsHistoryKey, updatedList);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefsHistoryKey);
  }
}
