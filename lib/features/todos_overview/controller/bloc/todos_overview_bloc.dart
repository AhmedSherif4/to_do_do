import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_do/data/models/todo_model.dart';

import '../../../../data/models/todos_view_filter.dart';
import '../../../../data/repository/todos_repository.dart';
part 'todos_overview_event.dart';
part 'todos_overview_state.dart';

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  final TodosRepository _todosRepository;
  TodosOverviewBloc(TodosRepository todosRepository)
      : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    on<TodosOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<TodosOverviewTodoCompletionToggled>(_onTodoCompletionToggled);
    on<TodosOverviewTodoDeleted>(_onTodoDeleted);
    on<TodosOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<TodosOverviewFilterChanged>(_onFilterChanged);
    on<TodosOverviewToggleAllRequested>(_onToggleAllRequested);
    on<TodosOverviewClearCompletedRequested>(_onClearCompletedRequested);
    on<TodosOverviewSelectDate>(_onSelectedDate);
  }

// we use emit.forEach<List<Todo>>( ... )
//which creates a subscription on the todos stream from the TodosRepository.
// emit.forEach() is not the same forEach() used by lists.
//This forEach enables the bloc to subscribe to a Stream and emit a new state for each update from the stream.
  Future<void> _onSubscriptionRequested(
      TodosOverviewSubscriptionRequested event,
      Emitter<TodosOverviewState> emit) async {
    emit(state.copyWith(status: () => TodosOverviewStatus.loading));
    await emit.forEach<List<TodoModel>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: () => TodosOverviewStatus.success,
        todos: () => todos,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TodosOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onTodoCompletionToggled(
    TodosOverviewTodoCompletionToggled event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  Future<void> _onTodoDeleted(
      TodosOverviewTodoDeleted event, Emitter<TodosOverviewState> emit) async {
    emit(state.copyWith(lastDeletedTodo: () => event.todo));
    await _todosRepository.deleteTodo(event.todo.id);
  }

  Future<void> _onUndoDeletionRequested(
      TodosOverviewUndoDeletionRequested event,
      Emitter<TodosOverviewState> emit) async {
    assert(
      state.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );

    final TodoModel todo = state.lastDeletedTodo!;
    emit(state.copyWith(
      lastDeletedTodo: () => null,
    ));
    await _todosRepository.saveTodo(todo);
  }

  void _onFilterChanged(
      TodosOverviewFilterChanged event, Emitter<TodosOverviewState> emit) {
    emit(state.copyWith(
      filter: () => event.filter,
    ));
  }

  Future<void> _onToggleAllRequested(TodosOverviewToggleAllRequested event,
      Emitter<TodosOverviewState> emit) async {
    final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
    await _todosRepository.completeAll(isCompleted: !areAllCompleted);
  }

  Future<void> _onClearCompletedRequested(
      TodosOverviewClearCompletedRequested event,
      Emitter<TodosOverviewState> emit) async {
    await _todosRepository.clearCompleted();
  }

  void _onSelectedDate(
      TodosOverviewSelectDate event, Emitter<TodosOverviewState> emit) {
    emit(state.copyWith(
        selectedDate: () => event.selectedDate ?? DateTime.now()));
  }
}
