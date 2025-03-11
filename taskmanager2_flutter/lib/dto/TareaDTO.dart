import '../model/Tarea.dart';

class TareaDTO {
  final String titulo;
  final String descripcion;
  final Estado estado;
  final String usuarioId; // Solo enviamos el ID del usuario

  TareaDTO({
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.usuarioId,
  });

  // Convertir a JSON para enviar
  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "descripcion": descripcion,
      "estado": estado.name,
      "usuarioId": usuarioId,
    };
  }
}
