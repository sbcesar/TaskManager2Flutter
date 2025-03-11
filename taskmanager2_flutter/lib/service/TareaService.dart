import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;


import 'package:taskmanager2_flutter/dto/TareaDTO.dart';
import 'package:taskmanager2_flutter/model/Tarea.dart';

class TareaService {
  // URL base de la API (render) - (localhost:8081)
  static const String baseUrl = 'https://finalsecuremongodb.onrender.com';

  // Obtener todas las tareas
  static Future<Either<List<Tarea>?, String>> getAllTasks(String token) async {
    final url = Uri.parse('$baseUrl/tareas/show');
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return Left(data.map((json) => Tarea.fromJson(json)).toList());
    } else {
      return Right('Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Obtener tareas del usuario autenticado
  static Future<Either<List<Tarea>?, String>> getUserTasks(String token) async {
    final url = Uri.parse('$baseUrl/tareas/showTask');
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return Left(data.map((json) => Tarea.fromJson(json)).toList());
    } else {
      return Right('Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Crear tarea
  static Future<Either<bool, String>> createTask(String token, TareaDTO tarea) async {
  try {
    final url = Uri.parse('$baseUrl/tareas/create');
    final bodyData = jsonEncode(tarea.toJson());

    print("Enviando solicitud a: $url");
    print("Body: $bodyData");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: bodyData,
    );

    print("Código de respuesta: ${response.statusCode}");
    print("Respuesta del servidor: ${response.body}");

    if (response.statusCode == 201) {
      print("Tarea creada exitosamente.");
      return Left(true);
    } else {
      return Right('Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print("Excepción durante la creación de tarea: $e");
    return Right("Error en la solicitud: $e");
  }
}

  // Completar tarea
  static Future<Either<Tarea, String>> completeTask(String token, String id) async {
    final url = Uri.parse('$baseUrl/tareas/complete/$id');
    final response = await http.put(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final tarea = Tarea.fromJson(jsonDecode(response.body)); 
      return Left(tarea);
    } else {
      return Right('Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Eliminar tarea
  static Future<Either<bool, String>> deleteTask(String token, String id) async {
    final url = Uri.parse('$baseUrl/tareas/delete/$id');
    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 204) {
      return Left(true);
    } else {
      return Right('Error: ${response.statusCode} - ${response.body}');
    }
  }

}
