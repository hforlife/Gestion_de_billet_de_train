import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestion_billet_train_flutter/core/constants/api_constants.dart';
import 'package:gestion_billet_train_flutter/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static String _baseUrl = ApiConstants.baseUrl; // Remplacez par votre URL
  static String _baseUrlLocal =
      ApiConstants.baseUrlLocalWork; // Remplacez par votre URL

  // Instance de flutter_secure_storage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            body: {'login': username, 'password': password},
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true || data['success'] == true) {
          // Stocker le token dans le storage sécurisé
          final token =
              data['token'] ?? data['access_token'] ?? 'default_token';
          await _secureStorage.write(key: 'bearer_token', value: token);

          final userData = data['user'] ?? data['data'];
          return UserModel(
            id: userData['id'] ?? 0,
            name: userData['name'] ?? username,
            email: userData['email'] ?? '$username@example.com',
            username: userData['username'] ?? username,
            token: token,
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
      throw Exception('Erreur lors de l\'appel API: ${e.toString()}');
    }
  }
}
