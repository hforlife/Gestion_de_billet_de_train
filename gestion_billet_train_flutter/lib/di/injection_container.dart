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
import 'package:gestion_billet_train_flutter/features/ticket/data/datasources/ticket_local_datasource.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/datasources/ticket_local_datasource_impl.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/datasources/ticket_remote_datasource.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/repositories/ticket_repository_impl.dart'
    hide TicketLocalDataSource, TicketLocalDataSourceImpl;
import 'package:gestion_billet_train_flutter/features/ticket/domain/repositories/ticket_repository.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/usecases/scan_ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/usecases/sell_ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => AuthBloc(login: sl(), logout: sl()));
  sl.registerFactory(
    () => TicketBloc(
      scanTicket: sl(),
      sellTicket: sl(),
    ), // Supprimé validateTicket
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => ScanTicket(sl()));
  sl.registerLazySingleton(() => SellTicket(sl()));
  // Supprimé ValidateTicket

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<TicketRepository>(
    () => TicketRepositoryImpl(
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
  sl.registerLazySingleton<TicketLocalDataSource>(
    () => TicketLocalDataSourceImpl(hive: sl()),
  );
  sl.registerLazySingleton<TicketRemoteDataSource>(
    () => TicketRemoteDataSourceImpl(),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => Connectivity());

  // Hive
  final userBox = await Hive.openBox<UserModel>('users');
  final ticketBox = await Hive.openBox<TicketModel>('tickets');
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);
  sl.registerLazySingleton<Box<TicketModel>>(() => ticketBox);
}
