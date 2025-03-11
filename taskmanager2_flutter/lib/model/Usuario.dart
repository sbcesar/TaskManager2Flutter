import 'Direccion.dart';

class Usuario {
  final String? id;
  final String username;
  final Role? roles;
  final Direccion direccion;

  Usuario({
    this.id,
    required this.username,
    this.roles,
    required this.direccion,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "username": username,
      "roles": roles?.name,
      "direccion": direccion.toJson(),
    };
  }

  // Convertir desde JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json["_id"],
      username: json["username"],
      roles: json["roles"] != null ? Role.values.firstWhere((e) => e.name == json["roles"]) : null,
      direccion: Direccion.fromJson(json["direccion"]),
    );
  }
}

// Enum para roles de usuario
enum Role { ADMIN, USER }
