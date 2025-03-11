import 'Usuario.dart';

class Tarea {
  final String? id;
  final String titulo;
  final String descripcion;
  Estado estado;
  final Usuario usuario;

  Tarea({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.usuario,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "titulo": titulo,
      "descripcion": descripcion,
      "estado": estado.name,
      "usuario": usuario.toJson(),
    };
  }

  // Convertir desde JSON
  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json["_id"],
      titulo: json["titulo"],
      descripcion: json["descripcion"],
      estado: Estado.values.firstWhere((e) => e.name == json["estado"]),
      usuario: Usuario.fromJson(json["usuario"]),
    );
  }
}

// Enum para el estado de la tarea
enum Estado { COMPLETADO, PENDIENTE }
