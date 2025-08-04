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
    print('Début de login dans AuthRepositoryImpl');
    try {
      if (await networkInfo.isConnected) {
        print('Connexion réseau disponible');
        final userModel = await remoteDataSource.login(username, password);
        print('Utilisateur récupéré: $userModel');
        final user = User(
          id: userModel.id,
          name: userModel.name,
          email: userModel.email,
        );
        await localDataSource.cacheUser(userModel); // Mise en cache
        print('Utilisateur mis en cache: ${userModel.toJson()}');
        return Right(user);
      } else {
        print('Pas de connexion réseau');
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      print('Exception dans login: $e');
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

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUser() async {
    print('Appel à getUser dans AuthRepositoryImpl');
    try {
      if (await networkInfo.isConnected) {
        final userModel = await localDataSource.getCachedUser();
        if (userModel != null) {
          print('Données en cache: ${userModel.toJson()}');
          return Right(userModel.toJson());
        }
        return Left(
          CacheFailure(message: 'Aucune donnée utilisateur en cache'),
        );
      } else {
        final userModel = await localDataSource.getCachedUser();
        if (userModel != null) {
          print('Données en cache (hors ligne): ${userModel.toJson()}');
          return Right(userModel.toJson());
        }
        return Left(NetworkFailure(message: 'Connexion requise'));
      }
    } catch (e) {
      print('Exception dans getUser: $e');
      return Left(ServerFailure(message: 'Erreur: ${e.toString()}'));
    }
  }
}
