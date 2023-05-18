import 'package:equatable/equatable.dart';
import 'package:flutter_woocommerce/features/settings/data/models/settings_model.dart';

class SettingsState extends Equatable {
  final SettingModel settingModel;

  const SettingsState(this.settingModel);

  SettingsState copyWith(SettingModel? settingModel) =>
      SettingsState(settingModel ?? this.settingModel);

  factory SettingsState.initial() =>
      const SettingsState(SettingModel(theme: 'light', language: 'en'));
  @override
  List<Object?> get props => [settingModel];
}
