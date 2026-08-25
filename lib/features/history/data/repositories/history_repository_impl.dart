import '../../domain/entities/history_item.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDatasource datasource;

  HistoryRepositoryImpl(this.datasource);

  @override
  Future<List<HistoryItem>> getHistory() async {
    return await datasource.getHistory();
  }

  @override
  Future<void> addHistoryItem(HistoryItem item) async {
    await datasource.addHistoryItem(item);
  }

  @override
  Future<void> deleteHistoryItem(String id) async {
    await datasource.deleteHistoryItem(id);
  }

  @override
  Future<void> clearHistory() async {
    await datasource.clearHistory();
  }
}
