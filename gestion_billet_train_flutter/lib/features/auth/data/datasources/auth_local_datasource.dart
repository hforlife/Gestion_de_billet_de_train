import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();
  Future<void> clearToken(); // Add method to clear token
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> userBox;
  final FlutterSecureStorage _secureStorage;

  AuthLocalDataSourceImpl({
    required this.userBox,
    FlutterSecureStorage? secureStorage, // Optional injection for testing
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> cacheUser(UserModel user) async {
    print('Mise en cache de l\'utilisateur: ${user.toJson()}');
    await userBox.put('current_user', user);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    print('Récupération de l\'utilisateur en cache');
    final user = userBox.get('current_user');
    print('Utilisateur en cache: $user');
    return user;
  }

  @override
  Future<void> clearCachedUser() async {
    print('Suppression de l\'utilisateur en cache');
    await userBox.delete('current_user');
  }

  @override
  Future<void> clearToken() async {
    print('Suppression du token sécurisé');
    await _secureStorage.delete(key: 'bearer_token');
  }
}
