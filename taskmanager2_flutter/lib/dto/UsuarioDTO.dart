import '../model/Direccion.dart';
import '../model/Usuario.dart';

class UsuarioDTO {
  final String username;
  final Role? roles;
  final Direccion direccion;

  UsuarioDTO({
    required this.username,
    this.roles,
    required this.direccion,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "roles": roles?.name,
      "direccion": direccion.toJson(),
    };
  }
}
