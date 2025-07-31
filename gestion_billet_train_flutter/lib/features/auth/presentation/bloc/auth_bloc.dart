import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/usecases/login.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/usecases/logout.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Logout logout;

  AuthBloc({required this.login, required this.logout}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await login(event.username, event.password);
    result.fold(
      (failure) => emit(AuthError('Échec de la connexion')),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logout();
    result.fold(
      (failure) => emit(AuthError('Échec de la déconnexion')),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
