import 'package:equatable/equatable.dart';

class SettingModel extends Equatable {
  final String theme;
  final String language;

  const SettingModel({required this.theme, required this.language});

  SettingModel copyWith({String? theme, String? language}) => SettingModel(
      theme: theme ?? this.theme, language: language ?? this.language);

  @override
  List<Object?> get props => [theme, language];
}
