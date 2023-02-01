import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_do/data/models/todo_model.dart';

import '../../../application/errors/exceptions.dart';

abstract class TodoApi{
  const TodoApi();
  // real-time updates to all subscribers when the list of todos has changed
  Stream<List<TodoModel>> getTodos();
  /// If a [todo] with the same id already exists, it will be replaced.
  Future<void> saveTodo(TodoModel todo);
  /// If no todo with the given id exists, a [TodoNotFoundException] error is
  /// thrown.
  Future<void> deleteTodo(String id);
  /// Deletes all completed todos.
  ///
  /// Returns the number of deleted todos.
  Future<int> clearCompleted();
  /// Sets the `isCompleted` state of all todos to the given value.
  ///
  /// Returns the number of updated todos.
  Future<int> completeAll({required bool isCompleted});


}



class LocalStorageTodoApi extends TodoApi {
  final SharedPreferences _sharedPreferences;
  LocalStorageTodoApi({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences {
    _init();
  }

  final _todoStreamController = BehaviorSubject<List<TodoModel>>.seeded(const []);

  static const String kTodosCollectionKey = '__todos_collection_key__';

  String? _getValue(String key) => _sharedPreferences.getString(key);
  Future<void> _setValue(String key, String value) =>
      _sharedPreferences.setString(key, value);

  // أول ما ينادي عالكلاس
  void _init() {
    final todoJson = _getValue(kTodosCollectionKey);
    if (todoJson != null) {
      final List<TodoModel> todos =
          List<Map<dynamic, dynamic>>.from(json.decode(todoJson) as List)
              .map(
                (jsonMap) => TodoModel.fromJson(
                  Map<String, dynamic>.from(jsonMap),
                ),
              )
              .toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }
  }

  @override
  Stream<List<TodoModel>> getTodos() => _todoStreamController.asBroadcastStream();

  @override
  Future<void> saveTodo(TodoModel todo) async {
    final List<TodoModel> todos = [..._todoStreamController.value];
    final int todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }
    _todoStreamController.add(todos);
    return await _setValue(kTodosCollectionKey, json.encode(todos));
  }

  @override
  Future<void> deleteTodo(String id) async {
    final List<TodoModel> todos = [..._todoStreamController.value];
    final int todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException;
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      return await _setValue(kTodosCollectionKey, json.encode(todos));
    }
  }

  @override
  Future<int> clearCompleted() async {
    final List<TodoModel> todos = [..._todoStreamController.value];
    final int completedTodosAmount = todos.where((t) => t.isCompleted).length;
    todos.removeWhere((t) => t.isCompleted);
    _todoStreamController.add(todos);
    await _setValue(kTodosCollectionKey, json.encode(todos));
    return completedTodosAmount;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final List<TodoModel> todos = [..._todoStreamController.value];
    final int changesTodosAmount =
        todos.where((t) => t.isCompleted != isCompleted).length;
    final  List<TodoModel> newTodo = [
      for (final TodoModel todo in todos) todo.copyWith(isCompleted: isCompleted)
    ];
    _todoStreamController.add(newTodo);
    await _setValue(kTodosCollectionKey, json.encode(newTodo));
    return changesTodosAmount;
  }
}
