import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends HydratedCubit<ThemeModeState> {
  ThemeModeCubit() : super(const ThemeModeState(isDark: false));

  void themeChanges(bool isDark) {
    emit(ThemeModeState(isDark: isDark));
  }

  @override
  ThemeModeState? fromJson(Map<String, dynamic> json) =>
      ThemeModeState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ThemeModeState state) => state.toJson();
}
