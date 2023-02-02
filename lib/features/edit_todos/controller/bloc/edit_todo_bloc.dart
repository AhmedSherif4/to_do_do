import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_do/data/models/todo_model.dart';
import 'package:to_do_do/data/repository/todos_repository.dart';

part 'edit_todo_event.dart';
part 'edit_todo_state.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  final TodosRepository _todosRepository;
  EditTodoBloc({
    required TodosRepository todosRepository,
    required TodoModel? initialTodo,
  })  : _todosRepository = todosRepository,
        super(EditTodoState(
          initialTodo: initialTodo,
          title: initialTodo?.title ?? '',
          description: initialTodo?.description ?? '',
        )) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditTodoDescriptionChanged>(_onDescriptionChanged);
    on<EditTodoDateChanged>(_onDateChanged);
    on<EditTodoStartTimeChanged>(_onStartTimeChanged);
    on<EditTodoEndTimeChanged>(_onEndTimeChanged);
    on<EditTodoColorChanged>(_onColorChanged);
    on<EditTodoRemindChanged>(_onRemindChanged);
    on<EditTodoRepeatChanged>(_onRepeatChanged);

    on<EditTodoSubmitted>(_onSubmitted);
  }

  void _onTitleChanged(
      EditTodoTitleChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
      EditTodoDescriptionChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onDateChanged(EditTodoDateChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _onStartTimeChanged(
      EditTodoStartTimeChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(startTime: event.startTime));
  }

  void _onEndTimeChanged(
      EditTodoEndTimeChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(endTime: event.endTime));
  }

  void _onColorChanged(
      EditTodoColorChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(color: event.color));
  }

  void _onRemindChanged(
      EditTodoRemindChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(remind: event.remind));
  }

  void _onRepeatChanged(
      EditTodoRepeatChanged event, Emitter<EditTodoState> emit) {
    emit(state.copyWith(repeat: event.repeat));
  }

  Future<void> _onSubmitted(
      EditTodoSubmitted event, Emitter<EditTodoState> emit) async {
    emit(state.copyWith(status: EditTodoStatus.loading));

    // the initial or new one put the values on it and save it in repository
    final todo = (state.initialTodo ?? TodoModel(title: '')).copyWith(
      title: state.title,
      description: state.description,
      date: state.date ?? DateFormat.yMd().format(DateTime.now()),
      startTime:
          state.startTime ?? DateFormat('hh:mm a').format(DateTime.now()),
      endTime: state.endTime ??
          DateFormat('hh:mm a')
              .format(DateTime.now().add(const Duration(minutes: 15))),
      color: state.color,
      remind: state.remind,
      repeat: state.repeat,
    );

    try {
      await _todosRepository.saveTodo(todo);
      final stateTi = state.copyWith(status: EditTodoStatus.success);
      emit(stateTi);
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }


}


/**
 * Data Flow
Even though there are many features that depend on the same list of todos, 
there is no bloc-to-bloc communication.
Instead, all features are independent of each other and rely on the TodosRepository 
to listen for changes in the list of todos, as well as perform updates to the list.

For example, the EditTodos doesn't know anything about the TodosOverview or Stats features.

When the UI submits a EditTodoSubmitted event:

EditTodoBloc handles the business logic to update the TodosRepository.
TodosRepository notifies TodosOverviewBloc and StatsBloc.
TodosOverviewBloc and StatsBloc notify the UI which update with the new state.
 */