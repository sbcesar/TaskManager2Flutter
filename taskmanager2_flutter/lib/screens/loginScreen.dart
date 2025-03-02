import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/taskDatabase.dart';
import 'taskScreen.dart';

class LoginScreen extends StatefulWidget {
  final Taskdatabase database;

  const LoginScreen({super.key, required this.database});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos de texto
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  var _passwordVisibility = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
              placeholder: 'Email',
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
                // Icono para mostrar/ocultar la contraseña
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
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/tasks');
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
