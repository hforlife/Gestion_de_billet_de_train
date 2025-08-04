import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/usecases/usecase.dart';

// Classe utilitaire pour les cas d'utilisation sans paramètres
class NoParams {}

class Logout implements UseCase<void, NoParams> {
  final AuthRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
