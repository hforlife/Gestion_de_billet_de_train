import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/core/constants/text_strings.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _hidePassword = true.obs;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final authBloc = context.read<AuthBloc>();
      print(
        'Envoi de LoginEvent avec username: ${_usernameController.text}, password: ${_passwordController.text}',
      );
      authBloc.add(
        LoginEvent(_usernameController.text, _passwordController.text),
      );
    } else {
      print('Validation du formulaire échouée');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('Nouvel état reçu: $state'); // Log pour débogage
        if (state is AuthError) {
          setState(() {
            _errorMessage = state.message;
          });
        } else if (state is AuthAuthenticated) {
          // Optionnel : Réinitialiser les champs ou naviguer
          _usernameController.clear();
          _passwordController.clear();
          setState(() {
            _errorMessage = null;
          });
        } else if (state is AuthUnauthenticated) {
          setState(() {
            _errorMessage = 'Authentification requise ou échouée';
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                validator: (value) => value!.isEmpty
                    ? "Veuillez entrer votre nom d'utilisateur ou email"
                    : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.user),
                  labelText: TTexts.emailUserName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6B8DC8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: TColors.primary,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: TSizes.spaceBtwInputFields),
              Obx(
                () => TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.lock),
                    labelText: TTexts.password,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF6B8DC8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: TColors.primary,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                      ),
                      onPressed: () {
                        _hidePassword.toggle();
                      },
                    ),
                  ),
                  validator: (value) => value!.isEmpty
                      ? "Veuillez entrer votre mot de passe"
                      : null,
                ),
              ),
              SizedBox(height: TSizes.spaceBtwInputFields * 3),
              SizedBox(
                height: THelperFunctions.screenHeight() * 0.07,
                width: THelperFunctions.screenWidth() * 0.7,
                child: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) =>
                      previous.runtimeType != current.runtimeType,
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: TColors.buttonSecondary,
                        minimumSize: Size(
                          THelperFunctions.screenWidth() * 0.4,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isLoading ? null : _handleLogin,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Se connecter',
                              style: GoogleFonts.roboto(
                                fontSize: TSizes.fontSizeMd,
                              ),
                            ),
                    );
                  },
                ),
              ),

              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (_, state) => state is AuthError,
                builder: (context, state) {
                  if (state is AuthError) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
