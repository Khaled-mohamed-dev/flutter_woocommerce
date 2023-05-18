import 'package:bloc/bloc.dart';
import 'package:flutter_woocommerce/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter_woocommerce/features/settings/presentation/bloc/bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  SettingsBloc(this.settingsRepository) : super(SettingsState.initial()) {
    on<LoadTheme>(
      (event, emit) async {
        var settings = settingsRepository.getSettings();
        emit(SettingsState(settings));
      },
    );
    on<ThemeChanged>(
      (event, emit) async {
        settingsRepository.toggleTheme();
        var theme = state.settingModel.theme == 'light' ? 'dark' : 'light';
        emit(SettingsState(state.settingModel.copyWith(theme: theme)));
      },
    );
  }
}
