import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:to_do_do/application/manager/theme_manager.dart';
import 'package:to_do_do/features/todos_overview/ui/widgets/date_picker_view.dart';

import '../../../application/dependency_injection.dart';
import '../../../application/manager/assets_manager.dart';
import '../../../application/manager/route_manager.dart';
import '../../../application/manager/string_manager.dart';
import '../controller/bloc/todos_overview_bloc.dart';
import 'widgets/todo_list_tile.dart';
import 'widgets/todos_overview_filter_button.dart';
import 'widgets/todos_overview_options_button.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instanceGetIt<TodosOverviewBloc>()
        ..add(const TodosOverviewSubscriptionRequested()),
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.toDoDo),
        actions: const [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
          listeners: [
            BlocListener<TodosOverviewBloc, TodosOverviewState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == TodosOverviewStatus.failure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.errorSnackbarText),
                      ),
                    );
                }
                Future.delayed(const Duration(seconds: 4), () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                });
              },
            ),
            BlocListener<TodosOverviewBloc, TodosOverviewState>(
              listenWhen: (previous, current) =>
                  previous.lastDeletedTodo != current.lastDeletedTodo &&
                  current.lastDeletedTodo != null,
              listener: (context, state) {
                final deletedTodo = state.lastDeletedTodo!;
                final messenger = ScaffoldMessenger.of(context);
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: const Color.fromARGB(255, 192, 38, 27),
                      showCloseIcon: true,
                      content: Text(AppStrings.todoDeleted + deletedTodo.title),
                      action: SnackBarAction(
                        label: AppStrings.undo,
                        onPressed: () {
                          messenger.hideCurrentSnackBar();
                          context
                              .read<TodosOverviewBloc>()
                              .add(const TodosOverviewUndoDeletionRequested());
                        },
                      ),
                    ),
                  );
                Future.delayed(const Duration(seconds: 5), () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                });
              },
            ),
          ],
          child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
            builder: (context, state) {
              if (state.todos.isEmpty) {
                if (state.status == TodosOverviewStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status != TodosOverviewStatus.success) {
                  return const SizedBox();
                } else {
                  return ListView(
                    children: const [
                      TodayDate(),
                      TodosOverviewDatePicker(),
                      NoTaskAdded(),
                    ],
                  );
                  
                }
              }
              return ListView(
                shrinkWrap: false,
                children: [
                  const TodayDate(),
                  const TodosOverviewDatePicker(),
                  ...state.filteredTodos
                      .map(
                        (todo) => Container(
                          margin: const EdgeInsets.all(12),
                          child: TodoListTile(
                            todo: todo,
                            onToggleCompleted: (isCompleted) {
                              context.read<TodosOverviewBloc>().add(
                                    TodosOverviewTodoCompletionToggled(
                                      todo: todo,
                                      isCompleted: isCompleted,
                                    ),
                                  );
                            },
                            onDismissed: (_) {
                              context
                                  .read<TodosOverviewBloc>()
                                  .add(TodosOverviewTodoDeleted(todo));
                            },
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.editTodoPage,
                                arguments: todo,
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                ],
              );
            },
          )),
    );
  }
}

class NoTaskAdded extends StatelessWidget {
  const NoTaskAdded({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          AppAssets.task,
          height: 90,
          semanticsLabel: 'task',
          color: primaryColor.withOpacity(0.5),
        ),
        Text(
          AppStrings.noTodosFoundWithTheSelectedFilters,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class TodayDate extends StatelessWidget {
  const TodayDate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        DateFormat.yMMMMd().format(DateTime.now()),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
