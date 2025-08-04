import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/custom_shape/container/primary_header_container.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/core/constants/text_strings.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/widgets/auth_form.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _requestPermissions() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      // Pas de navigation ici, laissée au Bloc
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
  void initState() {
    super.initState();
    _requestPermissions(); // Demander les permissions au démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              TPrimaryHeaderContainer(
                child: SizedBox(
                  width: THelperFunctions.screenWidth(),
                  child: Column(
                    children: [
                      SizedBox(height: THelperFunctions.screenHeight() * 0.1),
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
                        style: TextStyle(
                          fontSize: TSizes.xl,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: TSizes.spaceBtwInputFields),
                      Text(
                        TTexts.loginWord,
                        style: TextStyle(
                          fontSize: TSizes.md,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: THelperFunctions.screenHeight() * 0.13),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    return AuthForm(isLoading: state is AuthLoading);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
