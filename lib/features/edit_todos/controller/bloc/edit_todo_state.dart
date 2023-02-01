part of 'edit_todo_bloc.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
        EditTodoStatus.loading,
        EditTodoStatus.success,
      ].contains(this);
}

class EditTodoState extends Equatable {
  final EditTodoStatus status;
  final TodoModel? initialTodo;
  final String title;
  final String description;
  final String? date;
  final String? startTime;
  final String? endTime;
  final int color;
  final int remind;
  final RepeatStatus repeat;

  const EditTodoState({
    this.status = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
    this.description = '',
    this.date,
    this.startTime,
    this.endTime,
    this.color = 0,
    this.remind = 5,
    this.repeat = RepeatStatus.none,
  });

  bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({
    EditTodoStatus? status,
    TodoModel? initialTodo,
    String? title,
    String? description,
    String? date,
    String? startTime,
    String? endTime,
    int? color,
    int? remind,
    RepeatStatus? repeat,
  }) {
    return EditTodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      remind: remind ?? this.remind,
      repeat: repeat ?? this.repeat,
    );
  }

  @override
  List<Object?> get props => [
        initialTodo,
        title,
        description,
        date,
        startTime,
        endTime,
        color,
        remind,
        repeat
      ];
}
