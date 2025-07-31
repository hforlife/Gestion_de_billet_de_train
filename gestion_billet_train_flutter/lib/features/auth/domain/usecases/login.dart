import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/entities/user.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Either<Failure, User>> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
