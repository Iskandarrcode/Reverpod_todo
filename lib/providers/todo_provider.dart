import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../services/database_helper.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  Future<void> loadTodos() async {
    final todosList = await DatabaseHelper.instance.getTodos();
    state = todosList.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<void> addTodo(Todo todo) async {
    await DatabaseHelper.instance.insertTodo(todo.toMap());
    await loadTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await DatabaseHelper.instance.updateTodo(todo.toMap());
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await DatabaseHelper.instance.deleteTodo(id);
    await loadTodos();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier()..loadTodos();
});
