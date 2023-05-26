import 'package:bloc/bloc.dart';
import 'package:flutter_woocommerce/core/services/sharedpref_service.dart';
import 'package:flutter_woocommerce/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter_woocommerce/features/settings/presentation/bloc/bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  final SharedPrefService sharedPrefService;

  SettingsBloc(
      {required this.settingsRepository, required this.sharedPrefService})
      : super(SettingsState.initial()) {
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

    on<ChangeAddress>(
      (event, emit) {
        var user = sharedPrefService.user!;
        sharedPrefService.user = user.copyWith(
          shipping: user.shipping!.copyWith(address1: event.address),
          billing: user.shipping!.copyWith(address1: event.address),
        );
        emit(
          SettingsState(
            state.settingModel.copyWith(address: event.address),
          ),
        );
      },
    );
  }
}
