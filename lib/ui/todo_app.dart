import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            trailing: Checkbox(
              value: todo.isCompleted,
              onChanged: (value) {
                ref.read(todoProvider.notifier).updateTodo(
                      Todo(
                        id: todo.id,
                        title: todo.title,
                        isCompleted: value ?? false,
                      ),
                    );
              },
            ),
            onLongPress: () {
              ref.read(todoProvider.notifier).deleteTodo(todo.id!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final title = await _showAddTodoDialog(context);
          if (title != null && title.isNotEmpty) {
            ref.read(todoProvider.notifier).addTodo(
                  Todo(
                    title: title,
                    isCompleted: false,
                  ),
                );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _showAddTodoDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter todo title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
