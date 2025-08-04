import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/di/injection_container.dart' as di;
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/home_page.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.sl<AuthBloc>())],
      child: GetMaterialApp(
        title: 'SOPAFER',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: AppColors.background,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const HomePage();
              } else if (state is AuthUnauthenticated || state is AuthError) {
                return const LoginPage();
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
