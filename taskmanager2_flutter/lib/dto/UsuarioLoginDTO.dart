class UsuarioLoginDTO {
  final String username;
  final String password;

  UsuarioLoginDTO({
    required this.username,
    required this.password,
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }
}
