import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource datasource;

  SettingsRepositoryImpl(this.datasource);

  @override
  Future<AppSettings> getSettings() async {
    return await datasource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await datasource.saveSettings(settings);
  }
}
