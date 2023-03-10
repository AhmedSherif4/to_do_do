part of 'todos_overview_bloc.dart';

abstract class TodosOverviewEvent extends Equatable {
  const TodosOverviewEvent();

  @override
  List<Object> get props => [];
}

// This is the startup event. 
//In response, 
//the bloc subscribes to the stream of todos from the TodosRepository.
class TodosOverviewSubscriptionRequested extends TodosOverviewEvent {
  const TodosOverviewSubscriptionRequested();
}

// This toggles a todo's completed status
class TodosOverviewTodoCompletionToggled extends TodosOverviewEvent {
  const TodosOverviewTodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final TodoModel todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo, isCompleted];
}

//  This deletes a Todo.
class TodosOverviewTodoDeleted extends TodosOverviewEvent {
  const TodosOverviewTodoDeleted(this.todo);

  final TodoModel todo;

  @override
  List<Object> get props => [todo];
}

// This undoes a todo deletion, e.g. an accidental deletion
class TodosOverviewUndoDeletionRequested extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequested();
}

// This takes a TodosViewFilter 
// as an argument and changes the view by applying a filter.
class TodosOverviewFilterChanged extends TodosOverviewEvent {
  const TodosOverviewFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}

// This toggles completion for all todos
class TodosOverviewToggleAllRequested extends TodosOverviewEvent {
  const TodosOverviewToggleAllRequested();
}

// This deletes all completed todos
class TodosOverviewClearCompletedRequested extends TodosOverviewEvent {
  const TodosOverviewClearCompletedRequested();
}

// select which date will be shown
class TodosOverviewSelectDate extends TodosOverviewEvent {
  final DateTime? selectedDate;
  const TodosOverviewSelectDate({ this.selectedDate});
}