import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/core/constants/text_strings.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/widgets/auth_form.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/home_page.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: THelperFunctions.screenHeight() * 0.05),
                Container(
                  width: THelperFunctions.screenWidth() * 0.2,
                  height: THelperFunctions.screenWidth() * 0.2,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(79, 255, 255, 255),
                    borderRadius: BorderRadius.circular(
                      THelperFunctions.screenWidth() * 1,
                    ),
                  ),
                  child: Icon(
                    Icons.login,
                    size: TSizes.xl,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: TSizes.spaceBtwInputFields),
                Text(
                  TTexts.connexion,
                  style: TextStyle(fontSize: TSizes.xl, color: Colors.white),
                ),
                Text(
                  'Accédez à votre espace de gestion',
                  style: TextStyle(
                    fontSize: TSizes.fontSizeLg,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: THelperFunctions.screenHeight() * 0.1),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(TSizes.sm),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          THelperFunctions.screenWidth() * 0.12,
                        ),
                      ),
                    ),
                    child: BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) async {
                        if (state is AuthAuthenticated) {
                          await _requestPermissions(context);
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
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
      ),
    );
  }
}
