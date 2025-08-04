import 'package:gestion_billet_train_flutter/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String username, String password) async {
    // Simulation de l'API
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'controller' && password == 'password') {
      return UserModel(
        id: 1, // Valeur fictive
        name: username, // Utilise username comme nom temporaire
        email: '$username@example.com', // Email fictif
        username: username,
        token: 'fake_token',
      );
    }
    throw Exception('Invalid credentials');
  }
}
