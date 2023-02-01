import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_do/application/dependency_injection.dart';
import 'package:to_do_do/application/manager/string_manager.dart';
import 'package:to_do_do/features/states/controller/Theme_mode_cubit/theme_mode_cubit.dart';
import 'package:to_do_do/features/states/controller/bloc/stats_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          instanceGetIt<StatsBloc>()..add(const StatsSubscriptionRequested()),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StatsBloc>().state;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.stats),
        actions: [
          BlocBuilder<ThemeModeCubit, ThemeModeState>(
            builder: (context, state) {
              return Switch(
                value: state.isDark,
                onChanged: (isDark) {
                  context.read<ThemeModeCubit>().themeChanges(isDark);
                },
                thumbIcon: MaterialStateProperty.all(
                  state.isDark
                      ? const Icon(
                          Icons.light_mode_rounded,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.dark_mode_rounded,
                          color: Colors.black,
                        ),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            key: const Key('statsView_completedTodos_listTile'),
            leading: const Icon(Icons.check_rounded),
            title: const Text(AppStrings.completedTodos),
            trailing: Text(
              '${state.completedTodos}',
              style: textTheme.headlineSmall,
            ),
          ),
          ListTile(
            key: const Key('statsView_activeTodos_listTile'),
            leading: const Icon(Icons.radio_button_unchecked_rounded),
            title: const Text(AppStrings.activeTodos),
            trailing: Text(
              '${state.activeTodos}',
              style: textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
