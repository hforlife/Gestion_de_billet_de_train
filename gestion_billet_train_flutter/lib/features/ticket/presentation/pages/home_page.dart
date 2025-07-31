import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/widgets/custom_button.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<AuthBloc>(context).state as AuthAuthenticated).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('SOPAFER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bienvenue, ${user.username} (contrôleur)',
              style: const TextStyle(fontSize: 16),
            ),
            const Text(
              'Scannez ou vendez des billets',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Scanner un billet',
              color: AppColors.primary,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Vendre un billet',
              color: AppColors.secondary,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
