import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_do/application/manager/route_manager.dart';

import '../data/repository/todos_repository.dart';
import '../features/home/controller/cubit/home_cubit.dart';
import '../features/states/controller/Theme_mode_cubit/theme_mode_cubit.dart';
import 'dependency_injection.dart';
import 'manager/theme_manager.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: instanceGetIt<TodosRepository>(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(),
        ),
        BlocProvider<ThemeModeCubit>(
          create: (context) => ThemeModeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, isDarkState) {
          return MaterialApp(
            theme: isDarkState.isDark
                ? appThemeData[AppTheme.dart]
                : appThemeData[AppTheme.light],
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: Routes.homeTodoPage,
          );
        },
      ),
    );
  }
}
