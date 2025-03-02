import 'package:flutter/material.dart';

import 'database/taskDatabase.dart';
import 'screens/loginScreen.dart';
import 'screens/taskScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorTaskdatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final Taskdatabase database;

  const MyApp(this.database, {super.key});

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
        '/login': (context) => LoginScreen(database: database),
        '/tasks': (context) => TaskScreen(database: database),
      },
    );
  }
}
