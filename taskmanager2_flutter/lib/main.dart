import 'package:flutter/material.dart';
import 'screens/loginScreen.dart';
import 'screens/registerScreen.dart';
import 'screens/taskScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/tasks') {
          final args = settings.arguments as Map<String, String>;  // Recibimos los argumentos como Map
          final token = args['token']!;
          final username = args['username']!;
          final password = args['password']!;
          return MaterialPageRoute(
            builder: (context) => TaskScreen(token: token, username: username, password: password,), // Pasamos el token al TaskScreen
          );
        }
        return null; // En caso de que no coincida ninguna ruta
      },
    );
  }
}
