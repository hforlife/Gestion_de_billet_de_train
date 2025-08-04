// lib/core/usecase/usecase.dart
import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
