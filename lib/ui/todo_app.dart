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
                // Todo ni yangilash (tugallangan statusini o'zgartirish)
                ref.read(todoProvider.notifier).updateTodo(
                      Todo(
                        id: todo.id,
                        title: todo.title,
                        isCompleted: value ?? false,
                      ),
                    );
              },
            ),
            onTap: () async {
              // Tahrirlash oynasini ochish
              final newTitle = await _showEditTodoDialog(context, todo.title);
              if (newTitle != null && newTitle.isNotEmpty) {
                ref.read(todoProvider.notifier).updateTodo(
                      Todo(
                        id: todo.id,
                        title: newTitle,
                        isCompleted: todo.isCompleted,
                      ),
                    );
              }
            },
            onLongPress: () {
              // Todo ni o'chirish
              ref.read(todoProvider.notifier).deleteTodo(todo.id!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Todo o\'chirildi: ${todo.title}'),
                ),
              );
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

  // Yangi todo qo'shish dialog oynasi
  Future<String?> _showAddTodoDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yangi Todo qo\'shish'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Todo nomini kiriting'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Bekor qilish'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Qo\'shish'),
            ),
          ],
        );
      },
    );
  }

  // Todo ni tahrirlash dialog oynasi
  Future<String?> _showEditTodoDialog(BuildContext context, String currentTitle) async {
    final controller = TextEditingController(text: currentTitle);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Todo ni tahrirlash'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Yangi todo nomini kiriting'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Bekor qilish'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Saqlash'),
            ),
          ],
        );
      },
    );
  }
}
