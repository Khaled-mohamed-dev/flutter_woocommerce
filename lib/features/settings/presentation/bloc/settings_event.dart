import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {}

class ThemeChanged extends SettingsEvent {
  @override
  List<Object?> get props => [];
}

class LoadTheme extends SettingsEvent {
  @override
  List<Object?> get props => [];
}
