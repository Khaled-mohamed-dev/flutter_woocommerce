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

class ChangeAddress extends SettingsEvent {
  final String address;

  ChangeAddress(this.address);

  @override
  List<Object?> get props => [address];
}
