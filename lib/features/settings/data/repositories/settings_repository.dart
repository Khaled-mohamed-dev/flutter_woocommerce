import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/features/settings/data/models/settings_model.dart';

abstract class SettingsRepository {
  SettingModel getSettings();
  void toggleTheme();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPrefService sharedPrefService;

  SettingsRepositoryImpl(this.sharedPrefService);
  @override
  void toggleTheme() {
    var theme = sharedPrefService.theme;
    if (theme == 'light') {
      sharedPrefService.theme = 'dark';
    } else {
      sharedPrefService.theme = 'light';
    }
  }

  @override
  SettingModel getSettings() {
    var theme = sharedPrefService.theme;

    return SettingModel(
      theme: theme,
      language: sharedPrefService.lang,
      address: sharedPrefService.user?.billing!.address1! ?? '',
    );
  }
}
