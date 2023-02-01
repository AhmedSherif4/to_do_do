import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_do/application/manager/string_manager.dart';


import '../../../../data/models/todos_view_filter.dart';
import '../../controller/bloc/todos_overview_bloc.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter =
        context.select((TodosOverviewBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: AppStrings.filter,
      onSelected: (filter) {
        context
            .read<TodosOverviewBloc>()
            .add(TodosOverviewFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: TodosViewFilter.all,
            child: Text(AppStrings.all),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: Text(AppStrings.activeOnly),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: Text(AppStrings.completedOnly),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
