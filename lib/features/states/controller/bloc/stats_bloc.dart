import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_do/data/models/todo_model.dart';
import 'package:to_do_do/data/repository/todos_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosRepository _todosRepository;

  StatsBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onStatsSubscriptionRequested);
  }

  Future<void> _onStatsSubscriptionRequested(
      StatsSubscriptionRequested event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: StatsStatus.loading));
    await emit.forEach<List<TodoModel>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: StatsStatus.success,
        completedTodos: todos.where((todo) => todo.isCompleted).length,
        activeTodos: todos.where((todo) => !todo.isCompleted).length,
      ),
      onError: (error, stackTrace) => state.copyWith(
        status: StatsStatus.failure,
      ),
    );
  }
}
