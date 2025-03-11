import '../model/Direccion.dart';
import '../model/Usuario.dart';

class UsuarioRegisterDTO {
  final String username;
  final String password;
  final String passwordRepeat;
  final Role? roles;
  final Direccion direccion;

  UsuarioRegisterDTO({
    required this.username,
    required this.password,
    required this.passwordRepeat,
    this.roles,
    required this.direccion,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "passwordRepeat": passwordRepeat,
      "roles": roles?.name ?? "USER",
      "direccion": direccion.toJson(),
    };
  }

}
