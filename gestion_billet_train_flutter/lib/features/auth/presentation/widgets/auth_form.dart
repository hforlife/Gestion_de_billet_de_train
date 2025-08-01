import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/widgets/custom_button.dart';
import 'package:gestion_billet_train_flutter/core/widgets/custom_text_field.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final Function(String, String) onLogin;

  const AuthForm({super.key, required this.isLoading, required this.onLogin});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!widget.isLoading) {
      widget.onLogin(_usernameController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextField(
          label: 'Nom d\'utilisateur',
          icon: Icons.person,
          controller: _usernameController,
        ),
        CustomTextField(
          label: 'Mot de passe',
          icon: Icons.lock,
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Se connecter',
          onPressed: _handleLogin, // Utilisation d'une méthode séparée
        ),
      ],
    );
  }
}
