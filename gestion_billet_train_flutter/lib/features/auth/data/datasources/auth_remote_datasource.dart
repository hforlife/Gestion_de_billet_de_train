import 'dart:convert';

import 'package:gestion_billet_train_flutter/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String _baseUrl =
      'http://192.168.101.189:8000/api'; // Remplacez par votre URL

  @override
  Future<UserModel> login(String username, String password) async {
    print('Appel API avec username: $username, password: $password');
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            body: {'login': username, 'password': password},
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          )
          .timeout(const Duration(seconds: 10));

      print('Réponse API: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true || data['success'] == true) {
          final userData = data['user'] ?? data['data'];
          return UserModel(
            id: userData['id'] ?? 0,
            name: userData['name'] ?? username,
            email: userData['email'] ?? '$username@example.com',
            username: userData['username'] ?? username,
            token: data['token'] ?? data['access_token'] ?? 'default_token',
          );
        } else {
          throw Exception(data['message'] ?? 'Échec de la connexion');
        }
      } else {
        throw Exception(
          'Erreur serveur: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Exception dans login: $e');
      throw Exception('Erreur lors de l\'appel API: ${e.toString()}');
    }
  }
}
