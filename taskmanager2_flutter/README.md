# API REST SEGURA CON MONGODB

### DESCRIPCIÓN BREVE
Esta es una implementación de una API REST segura usando de método de almacenamiento de datos un sistema **No Relacional** con MongoDB (documentos).

Es una aplicación sencilla en la que se gestionarán las tareas de casa. También, permitirá un registro de usuarios y un manejo de tareas que explicaré mas a detalle en adelante...

### DESCRIPCIÓN DETALLADA
Los documentos que compondrán esta aplicación son:
1. Usuarios
   1. username: String (nombre del usuario)
   2. password: String (contraseña del usuario)
   3. roles: Rol (Enum class con los roles: USER, ADMIN)
   4. direccion: Direccion (dirección del usuario)
   5. tareas: List<Tareas> (tareas que tiene el usuario)
2. Dirección
   1. calle: String (nombre de la calle)
   2. num: Int (número del hogar)
   3. provicia: String (provincia del usuario)
   4. municipio: String (municipio del usuario)
   5. cp: Int (código postal del usuario)
3. Tarea
   1. titulo: String (titulo de la tarea)
   2. descripcion: String (breve descripcion de la tarea)
   3. estado: String (estado de la tarea PENDIENTE/COMPLETADO)
   4. usuario: Usuario (usuario propietario de la tarea)

###  ENDPOINTS

#### Usuarios `/usuarios`
- **POST** `/register` -> Registra a un usuario en la base de datos.
- **POST** `/login` -> Inicia sesión.

#### Tareas `/tareas`
- **GET** `/show` -> Muestra todas las tareas.
- **GET** `/showTask` -> Muestra solo las tareas del usuario autenticado.
- **POST** `/create` -> Crea una nueva tarea.
- **PUT** `/update/{id}` -> Actualiza los datos de una tarea por su ID.
- **PUT** `/complete/{id}` -> Marca una tarea como completada.
- **DELETE** `/delete/{id}` -> Borra una tarea por su ID.

### EXCEPCIONES

 * 400 - BadRequestException: Indica que el servidor no puede cumplir con las solicitudes debido a un error por parte del cliente
 * 401 - UnauthorizedException: Indica que el So deniega el acceso debido a un error de seguridad
 * 403 - ForbiddenException: Indica que el usuario autenticado no tiene permisos para acceder al recurso solicitado.
 * 404 - NotFoundException: Indica que el recurso solicitado por el cliente no se encuentra en el servidor
 * 409 - ConflictException: Indica que la solicitud genera un conflicto con el estado actual del servidor, como intentar crear un recurso duplicado.

### RESTRICCIONES DE SEGURIDAD

Para "privar" a los usuarios de cualquier accion he decidido implementar un sistema de roles compuesto por dos tipos:
 * ADMIN (tiene acceso a ver, eliminar y dar de alta cualquier tarea de cualquier usuario)
 * USER (el resto de funciones que no sean las de admin)

Además, se utilizará cifrado asimétrico con clave pública y clave privada, junto con JWT (JSON Web Token), para el control de acceso.

#### Permisos

| Método  | Endpoint                | Roles Permitidos  | Descripción                                 |
|---------|-------------------------|-------------------|---------------------------------------------|
| **POST**   | `/usuario/login`        | Público           | Permite a cualquier usuario autenticarse.   |
| **POST**   | `/usuario/register`     | Público           | Permite a cualquier usuario registrarse.    |
| **GET**    | `/tareas/showTask`      | `USER`            | Muestra las tareas del usuario autenticado. |
| **GET**    | `/tareas/show`          | `ADMIN`           | Muestra todas las tareas (solo admins).     |
| **POST**   | `/tareas/create`        | `USER`, `ADMIN`   | Crea una nueva tarea.                       |
| **PUT**    | `/tareas/complete/{id}` | `USER`, `ADMIN`   | Marca una tarea como completada.            |
| **DELETE** | `/tareas/delete/{id}`   | `USER`, `ADMIN`   | Elimina una tarea.                          |


### CÓDIGO DEL SERVICE

 * Usuario

 ```
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
 ```

 * Tarea

 ```
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
 ```



### VIDEO DEMOSTRATIVO DEL FUNCIONAMIENTO DE LA INTERFAZ

[https://drive.google.com/drive/folders/1yTXi0hOVw5UAs1wg6De9-zlmoy6MhXn-?usp=drive_link](https://drive.google.com/drive/folders/1yTXi0hOVw5UAs1wg6De9-zlmoy6MhXn-?usp=drive_link)
