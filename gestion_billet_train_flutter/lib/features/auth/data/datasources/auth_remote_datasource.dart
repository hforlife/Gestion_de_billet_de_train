import 'package:gestion_billet_train_flutter/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String username, String password) async {
    // Simuler une API
    await Future.delayed(const Duration(seconds: 1));
    if (username == 'controller' && password == 'password') {
      return UserModel(username: username, token: 'fake_token');
    }
    throw Exception('Invalid credentials');
  }
}
