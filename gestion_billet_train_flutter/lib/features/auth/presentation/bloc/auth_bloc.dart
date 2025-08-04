import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/entities/user.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/usecases/login.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/usecases/logout.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Logout logout;
  final AuthLocalDataSource localDataSource; // Ajout de la dépendance

  AuthBloc({
    required this.login,
    required this.logout,
    required this.localDataSource, // Injection manuelle
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print(
      'Tentative de connexion avec username: ${event.username}, password: ${event.password}',
    );
    try {
      final result = await login(
        LoginParams(username: event.username, password: event.password),
      );
      print('Résultat de login: $result');
      result.fold(
        (failure) {
          print('Échec: ${failure.message}');
          emit(AuthError('Échec de la connexion: ${failure.message}'));
        },
        (user) {
          print('Succès, utilisateur: $user');
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      print('Exception dans _onLogin: $e');
      emit(AuthError('Erreur inattendue: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    print('Tentative de déconnexion');
    final result = await logout(NoParams());
    result.fold(
      (failure) =>
          emit(AuthError('Échec de la déconnexion: ${failure.message}')),
      (_) {
        print('Déconnexion réussie');
        emit(AuthUnauthenticated());
      },
    );
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    print('Vérification de l\'authentification');
    try {
      final cachedUser = await localDataSource
          .getCachedUser(); // Utilisation de localDataSource
      if (cachedUser != null) {
        emit(
          AuthAuthenticated(
            User(
              id: cachedUser.id,
              name: cachedUser.name,
              email: cachedUser.email,
            ),
          ),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('Exception dans _onCheckAuth: $e');
      emit(AuthUnauthenticated());
    }
  }
}
