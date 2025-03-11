import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../dto/UsuarioLoginDTO.dart';
import '../dto/UsuarioRegisterDTO.dart';

class UsuarioService {
  // URL base de la API (render) - (localhost:8081)
  static const String baseUrl = "https://finalsecuremongodb.onrender.com";

  // Iniciar sesión
  static Future<Either<String, String>> login(UsuarioLoginDTO loginDTO) async {
    final url = Uri.parse("$baseUrl/usuario/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(loginDTO.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Left(data["token"]); // Devuelve el token si es exitoso
    } else {
      return Right('Error: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<Either<bool, String>> registrarUsuario(UsuarioRegisterDTO userDTO) async {
    final url = Uri.parse("$baseUrl/usuario/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userDTO.toJson()),
    );

    if (response.statusCode == 201) {
      return Left(true); // Devuelve true si el registro fue exitoso
    } else {
      return Right('Error: ${response.statusCode} - ${response.body}');
    }
  }
}
