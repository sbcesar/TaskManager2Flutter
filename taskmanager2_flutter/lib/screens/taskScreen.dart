import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskmanager2_flutter/service/TareaService.dart';
import '../dto/TareaDTO.dart';
import '../model/Tarea.dart';

class TaskScreen extends StatefulWidget {
  final String token;
  final String username; // Agregar username
  final String password; // Agregar password

  const TaskScreen({
    super.key,
    required this.token,
    required this.username,
    required this.password,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _usuarioIdController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  // Muestra un diálogo para agregar una nueva tarea
  Future<void> _showAddTaskDialog() async {
    _tituloController.clear();
    _descripcionController.clear();
    _usuarioIdController.clear();
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Nueva tarea'),
          content: Column(
            children: [
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _tituloController,
                placeholder: 'Ingrese el título de la tarea',
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _descripcionController,
                placeholder: 'Ingrese la descripción de la tarea',
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _usuarioIdController,
                placeholder: 'Ingrese el ID del usuario',
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
                final titulo = _tituloController.text.trim();
                final descripcion = _descripcionController.text.trim();
                final usuarioId = _usuarioIdController.text.trim();

                if (titulo.isNotEmpty && descripcion.isNotEmpty && usuarioId.isNotEmpty) {
                  final newTask = TareaDTO(
                    titulo: titulo,
                    descripcion: descripcion,
                    estado: Estado.PENDIENTE,
                    usuarioId: usuarioId,
                  );

                  final resultado = await TareaService.createTask(widget.token, newTask);

                  resultado.fold(
                    (successMessage) {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    (errorMessage) {
                      Navigator.pop(context);
                      _showErrorDialog(errorMessage);
                    },
                  );
                }
              },
              child: const Text('Agregar'),
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
      body: FutureBuilder<List<Tarea>>(
        future: widget.username == 'ADMIN' && widget.password == 'ADMIN'
            ? _fetchAllTasks() // Si es ADMIN, usa getAllTasks
            : _fetchUserTasks(), // Si no es ADMIN, usa getUserTasks
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay tareas aún'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.titulo),
                  subtitle: Text(task.descripcion),
                  leading: Checkbox(
                    value: task.estado == Estado.COMPLETADO,
                    onChanged: (bool? value) async {
                      if (value == true) {
                        await TareaService.completeTask(widget.token, task.id!);
                        setState(() {});
                      }
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await TareaService.deleteTask(widget.token, task.id!);
                      setState(() {});
                    },
                  ),
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

  // Método para obtener todas las tareas
  Future<List<Tarea>> _fetchAllTasks() async {
    final result = await TareaService.getAllTasks(widget.token);
    return result.fold((tasks) => tasks ?? [], (error) => []);
  }

  // Método para obtener las tareas de usuario
  Future<List<Tarea>> _fetchUserTasks() async {
    final result = await TareaService.getUserTasks(widget.token);
    return result.fold((tasks) => tasks ?? [], (error) => []);
  }
}
