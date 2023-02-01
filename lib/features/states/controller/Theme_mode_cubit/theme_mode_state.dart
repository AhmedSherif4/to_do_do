part of 'theme_mode_cubit.dart';

class ThemeModeState extends Equatable {
  final bool isDark;
  const ThemeModeState({required this.isDark});

  @override
  List<Object> get props => [isDark];

  Map<String, dynamic> toJson() => {'isDark': isDark};

  factory ThemeModeState.fromJson(Map<String, dynamic> json) =>
      ThemeModeState(isDark: json['isDark'] ?? false);
}
