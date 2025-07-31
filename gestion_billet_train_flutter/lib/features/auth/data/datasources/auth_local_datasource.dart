import 'package:gestion_billet_train_flutter/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> userBox;

  AuthLocalDataSourceImpl(this.userBox);

  @override
  Future<void> cacheUser(UserModel user) async {
    await userBox.put('current_user', user);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    return userBox.get('current_user');
  }

  @override
  Future<void> clearCachedUser() async {
    await userBox.delete('current_user');
  }
}
