import 'package:gestion_billet_train_flutter/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> userBox;

  AuthLocalDataSourceImpl(this.userBox);

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
}
