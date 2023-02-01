import 'package:to_do_do/data/data_sources/local_data/local_todos.dart';
import 'package:to_do_do/data/models/todo_model.dart';
import 'package:to_do_do/domain/repository/todos_base_repository.dart';

class TodosRepository extends TodosBaseRepository {
  final TodoApi _todoApi;
  TodosRepository({required TodoApi todoApi}) : _todoApi = todoApi;

  @override
  Stream<List<TodoModel>> getTodos() => _todoApi.getTodos();

  @override
  Future<void> saveTodo(TodoModel todo) => _todoApi.saveTodo(todo );

  @override
  Future<void> deleteTodo(String id) => _todoApi.deleteTodo(id);

  @override
  Future<int> clearCompleted() => _todoApi.clearCompleted();

  @override
  Future<int> completeAll({required bool isCompleted}) =>
      _todoApi.completeAll(isCompleted: isCompleted);
}
