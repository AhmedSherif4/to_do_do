import '../../data/models/todo_model.dart';

abstract class TodosBaseRepository {
  Stream<List<TodoModel>> getTodos();

  Future<void> saveTodo(TodoModel todo);

  Future<void> deleteTodo(String id);

  Future<int> clearCompleted();

  Future<int> completeAll({required bool isCompleted});
}
