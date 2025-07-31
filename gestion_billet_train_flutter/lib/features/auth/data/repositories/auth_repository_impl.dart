import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/core/network/network_info.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/entities/user.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.login(username, password);
        await localDataSource.cacheUser(user);
        return Right(user);
      } else {
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCachedUser();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
