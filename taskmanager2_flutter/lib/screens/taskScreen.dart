import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../database/taskDatabase.dart';
import '../model/taskDao.dart';
import '../model/taskModel.dart';

class TaskScreen extends StatefulWidget {
  final Taskdatabase database;

  const TaskScreen({super.key, required this.database});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late TaskDao taskDao;
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskDao = widget.database.taskDao;
  }
  
  // Muestra un diálogo para agregar una nueva tarea
  Future<void> _showAddTaskDialog() async {
    _taskController.clear();
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Nueva tarea'),
          content: Column(
            children: [
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _taskController,
                placeholder: 'Ingrese el nombre de la tarea',
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                final taskName = _taskController.text.trim();
                if (taskName.isNotEmpty) {
                  final newTask = Task(task: taskName);
                  await taskDao.insertTask(newTask);
                  setState(() {});
                }
                Navigator.pop(context);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
 
  // Muestra un diálogo para editar una tarea
  Future<void> _showEditTaskDialog(Task task) async {
    _taskController.text = task.task;
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Editar tarea'),
          content: Column(
            children: [
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _taskController,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                final updatedName = _taskController.text.trim();
                if (updatedName.isNotEmpty) {
                  final updatedTask = Task(id: task.id, task: updatedName, selected: task.selected);
                  await taskDao.updateTask(updatedTask);
                  setState(() {});
                }
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager App'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ),
      // Mostrado de la lista de tareas
      body: FutureBuilder<List<Task>>(
        future: taskDao.getAllTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay tareas aún'));
          } else {
            final tasks = snapshot.data!; // Lista de tareas
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.task),
                  leading: Checkbox(
                    value: task.selected,
                    onChanged: (bool? value) async {
                      final updatedTask = Task(id: task.id, task: task.task, selected: value ?? false);
                      await taskDao.updateTask(updatedTask);
                      setState(() {});
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await taskDao.deleteTask(task);
                      setState(() {});
                    },
                  ),
                  onLongPress: () => _showEditTaskDialog(task),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
