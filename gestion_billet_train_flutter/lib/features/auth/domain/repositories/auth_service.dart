import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/entities/user.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService implements AuthRepository {
  static const String _baseUrl =
      'http://192.168.1.15'; // Remplacez par votre URL

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    print('Requête vers $url avec username: $username, password: $password');
    try {
      final response = await http.post(
        url,
        body: {'login': username, 'password': password},
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      print('Statut: ${response.statusCode}, Réponse: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final userData = data['user'];
          final user = User(
            id: userData['id'],
            name: userData['name'],
            email: userData['email'],
          );
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
          await prefs.setString('user_data', json.encode(userData));
          return Right(user);
        } else {
          return Left(
            ServerFailure(message: data['message'] ?? 'Échec de la connexion'),
          );
        }
      } else {
        return Left(
          ServerFailure(message: 'Erreur serveur: ${response.statusCode}'),
        );
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Erreur: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Erreur lors de la déconnexion: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        return Right(json.decode(userData) as Map<String, dynamic>);
      } else {
        return Left(
          ServerFailure(message: 'Aucune donnée utilisateur trouvée'),
        );
      }
    } catch (e) {
      return Left(
        ServerFailure(
          message:
              'Erreur lors de la récupération de l\'utilisateur: ${e.toString()}',
        ),
      );
    }
  }
}
