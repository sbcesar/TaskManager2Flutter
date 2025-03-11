import 'package:flutter/cupertino.dart';
import '../model/Direccion.dart';
import '../dto/UsuarioRegisterDTO.dart';
import '../service/UsuarioService.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();
  final TextEditingController _provinciaController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscurePasswordRepeat = true;
  bool _isLoading = false; // Para mostrar indicador de carga

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Registro'),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crear Cuenta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
                decoration: TextDecoration.none,
              ),
            ),

            const SizedBox(height: 20),

            CupertinoTextField(
              controller: _usernameController,
              placeholder: 'Nombre de usuario',
              placeholderStyle: TextStyle(color: CupertinoColors.systemGrey),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 15),

            CupertinoTextField(
              controller: _passwordController,
              placeholder: 'Contraseña',
              obscureText: _obscurePassword,
              placeholderStyle: TextStyle(color: CupertinoColors.systemGrey),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(10),
              ),
              suffix: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    _obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            CupertinoTextField(
              controller: _passwordRepeatController,
              placeholder: 'Repetir contraseña',
              obscureText: _obscurePasswordRepeat,
              placeholderStyle: TextStyle(color: CupertinoColors.systemGrey),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(10),
              ),
              suffix: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePasswordRepeat = !_obscurePasswordRepeat;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    _obscurePasswordRepeat ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            CupertinoTextField(
              controller: _provinciaController,
              placeholder: 'Provincia',
              placeholderStyle: TextStyle(color: CupertinoColors.systemGrey),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 15),

            CupertinoTextField(
              controller: _municipioController,
              placeholder: 'Municipio',
              placeholderStyle: TextStyle(color: CupertinoColors.systemGrey),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.extraLightBackgroundGray,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 30),

            _isLoading
                ? const CupertinoActivityIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: CupertinoColors.activeBlue,
                      borderRadius: BorderRadius.circular(10),
                      onPressed: _registerUser,
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final passwordRepeat = _passwordRepeatController.text.trim();
    final provincia = _provinciaController.text.trim();
    final municipio = _municipioController.text.trim();

    if (username.isEmpty || password.isEmpty || passwordRepeat.isEmpty || provincia.isEmpty || municipio.isEmpty) {
      _showErrorDialog('Todos los campos son obligatorios.');
      return;
    }

    if (password != passwordRepeat) {
      _showErrorDialog('Las contraseñas no coinciden.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final nuevoUsuario = UsuarioRegisterDTO(
      username: username,
      password: password,
      passwordRepeat: passwordRepeat,
      direccion: Direccion(provincia: provincia, municipio: municipio),
    );

    final resultado = await UsuarioService.registrarUsuario(nuevoUsuario);

    setState(() {
      _isLoading = false;
    });

    resultado.fold(
      (success) => _showSuccessDialog(),
      (error) => _showErrorDialog(error),
    );
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Registro Exitoso'),
        content: const Text('Tu cuenta ha sido creada correctamente.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Volver a la pantalla anterior (login)
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
