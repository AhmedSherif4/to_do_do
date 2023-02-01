part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

class TodosOverviewState extends Equatable {
  final TodosOverviewStatus status;
  final List<TodoModel> todos;
  final TodosViewFilter filter;
  final DateTime? selectedDate;

  final TodoModel? lastDeletedTodo;
  const TodosOverviewState({
    this.selectedDate,
    this.status = TodosOverviewStatus.initial,
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
  });

  Iterable<TodoModel> get filteredTodos => filter.applyAll(todos);

  TodosOverviewState copyWith({
    TodosOverviewStatus Function()? status,
    List<TodoModel> Function()? todos,
    TodosViewFilter Function()? filter,
    TodoModel? Function()? lastDeletedTodo,
    DateTime? Function()? selectedDate,
  }) {
    return TodosOverviewState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
      selectedDate: selectedDate != null ? selectedDate() : this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [status, todos, filter, lastDeletedTodo, selectedDate];
}
