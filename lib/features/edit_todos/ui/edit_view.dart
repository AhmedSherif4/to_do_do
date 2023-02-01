import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_do/data/repository/todos_repository.dart';
import 'package:to_do_do/features/edit_todos/controller/bloc/edit_todo_bloc.dart';
import 'package:to_do_do/features/edit_todos/ui/widgets/widgets_edit_view.dart';

import '../../../application/dependency_injection.dart';
import '../../../application/manager/string_manager.dart';
import '../../../data/models/todo_model.dart';

class EditPage extends StatelessWidget {
  final TodoModel? initialTodo;
  const EditPage({super.key, this.initialTodo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTodoBloc(
        todosRepository: instanceGetIt<TodosRepository>(),
        initialTodo: initialTodo,
      ),
      child: const EditView(),
    );
  }
}

class EditView extends StatelessWidget {
  const EditView({super.key});

  @override
  Widget build(BuildContext context) {
/*     final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo = context.select(
      (EditTodoBloc bloc) => bloc.state.isNewTodo,
    ); */
    final isNewTodo = context.read<EditTodoBloc>().state.initialTodo == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewTodo ? AppStrings.addTodo : AppStrings.editTodo,
        ),
      ),
      body: BlocListener<EditTodoBloc, EditTodoState>(
        listener: (context, state) {
          print('UI test --------- ${state.status}');

          if (state.status == EditTodoStatus.success) {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const TitleField(),
              const DescriptionField(),
              DateField(),
              Row(
                children: [
                  Expanded(child: StartEndTimeDateField(isEndTime: false)),
                  Expanded(
                    child: StartEndTimeDateField(
                      isEndTime: true,
                    ),
                  )
                ],
              ),
              Row(
                children: const [
                  Expanded(
                    child: RemindFiled(),
                  ),
                  Expanded(
                    child: RepeatField(),
                  )
                ],
              ),
              const ColorOptions(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppStrings.saveChanges,
        shape: const CircleBorder(),
        onPressed: () =>
            context.read<EditTodoBloc>().add(const EditTodoSubmitted()),
        child: /* status.isLoadingOrSuccess
            ? const CircularProgressIndicator()
            :  */
            const Icon(Icons.check_rounded),
      ),
    );
  }
}
