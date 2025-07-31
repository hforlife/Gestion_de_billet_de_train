import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gestion_billet_train_flutter/core/network/network_info.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/models/user_model.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/usecases/login.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/usecases/logout.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => AuthBloc(login: sl(), logout: sl()));

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => Connectivity());

  // Hive
  final userBox = await Hive.openBox<UserModel>('users');
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);
}
