import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/widgets/custom_button.dart';
import 'package:gestion_billet_train_flutter/core/widgets/custom_text_field.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/widgets/auth_form.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Future<void> _requestPermissions(BuildContext context) async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La permission de la caméra est nécessaire pour scanner les billets.',
          ),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primary,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_forward, size: 50, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Connexion',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const Text(
                'Accédez à votre espace de gestion',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) async {
                      if (state is AuthAuthenticated) {
                        await _requestPermissions(context);
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      return AuthForm(
                        isLoading: state is AuthLoading,
                        onLogin: (username, password) {
                          context.read<AuthBloc>().add(
                            LoginEvent(username, password),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
