import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dto/UsuarioLoginDTO.dart';
import '../service/UsuarioService.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos de texto
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  var _passwordVisibility = true;

  // Método para mostrar el ErrorDialog
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Método de login
  Future<void> login() async {
    final loginDTO = UsuarioLoginDTO(
      username: _userController.text,
      password: _passController.text,
    );

    final result = await UsuarioService.login(loginDTO);
    
    result.fold(
      (token) {
        // Si el login es exitoso, navegar a la pantalla de tareas
        Navigator.pushReplacementNamed(
          context, 
          '/tasks', 
          arguments: {
            'token': token, 
            'username': _userController.text, 
            'password': _passController.text
          }
        );
      },
      (errorMessage) {
        // Si ocurre un error, mostrar el ErrorDialog
        showErrorDialog(context, errorMessage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Título de la pantalla
            const Text(
              'Iniciar Sesion',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
                decoration: TextDecoration.none,
              ),
            ),

            const SizedBox(height: 50),

            // Campo de Email
            CupertinoTextField(
              controller: _userController,
              placeholder: 'Username',
              placeholderStyle: TextStyle(color: CupertinoColors.systemGrey),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 15),

            // Campo de Contraseña
            CupertinoTextField(
              controller: _passController,
              placeholder: 'Password',
              placeholderStyle: TextStyle(color: CupertinoColors.systemGrey),
              obscureText: _passwordVisibility,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(10),
              ),
              suffix: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _passwordVisibility = !_passwordVisibility;
                    });
                  },
                  child: Icon(
                    _passwordVisibility ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Botón de Login
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(10),
                onPressed: login,  // Llamar al método login
                child: const Text(
                  'Login',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Botón para ir a registro
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),

          ],
        ),
      ),
    );
  }
}
