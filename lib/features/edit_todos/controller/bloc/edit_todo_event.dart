part of 'edit_todo_bloc.dart';

abstract class EditTodoEvent extends Equatable {
  const EditTodoEvent();

  @override
  List<Object?> get props => [];
}

class EditTodoTitleChanged extends EditTodoEvent {
  const EditTodoTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class EditTodoDescriptionChanged extends EditTodoEvent {
  const EditTodoDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class EditTodoDateChanged extends EditTodoEvent {
  const EditTodoDateChanged(this.date);

  final String date;

  @override
  List<Object> get props => [date];
}

class EditTodoStartTimeChanged extends EditTodoEvent {
  const EditTodoStartTimeChanged(this.startTime);

  final String? startTime;

  @override
  List<Object?> get props => [startTime];
}

class EditTodoEndTimeChanged extends EditTodoEvent {
  const EditTodoEndTimeChanged(this.endTime);

  final String? endTime;

  @override
  List<Object?> get props => [endTime];
}

class EditTodoColorChanged extends EditTodoEvent {
  const EditTodoColorChanged(this.color);

  final int color;

  @override
  List<Object> get props => [color];
}

class EditTodoRemindChanged extends EditTodoEvent {
  const EditTodoRemindChanged(this.remind);

  final int remind;

  @override
  List<Object> get props => [remind];
}

class EditTodoRepeatChanged extends EditTodoEvent {
  const EditTodoRepeatChanged(this.repeat);

  final RepeatStatus repeat;

  @override
  List<Object> get props => [repeat];
}


class EditTodoSubmitted extends EditTodoEvent {
  const EditTodoSubmitted();
}