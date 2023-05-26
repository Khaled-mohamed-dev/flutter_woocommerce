import 'package:equatable/equatable.dart';

class SettingModel extends Equatable {
  final String theme;
  final String language;
  final String address;
  const SettingModel(
      {required this.theme, required this.language, required this.address});

  SettingModel copyWith({
    String? theme,
    String? language,
    String? address,
  }) =>
      SettingModel(
        theme: theme ?? this.theme,
        language: language ?? this.language,
        address: address ?? this.address,
      );

  @override
  List<Object?> get props => [theme, language, address];
}
