import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestion_billet_train_flutter/core/constants/api_constants.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/repositories/ticket_repository.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ScanTicket {
  final TicketRepository repository;
  final String baseUrl = ApiConstants.baseUrl;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ScanTicket(this.repository);

  Future<Either<Failure, Ticket>> call(String qrCode) async {
    print('Scanning ticket with QR code: $qrCode');
    try {
      if (!qrCode.startsWith('TKT_')) {
        return Left(Failure(message: 'Format de QR code invalide'));
      }

      // Check Hive cache first
      final box = await Hive.openBox<TicketModel>('tickets');
      final cachedTicket = await box.get(qrCode);
      if (cachedTicket != null) {
        print('Returning cached ticket for QR code: $qrCode');
        return Right(cachedTicket.toEntity());
      }

      // Fetch ticket details
      final token = await _getToken();
      if (token == null) {
        return Left(Failure(message: 'Token non trouvé'));
      }

      final response = await http.get(
        Uri.parse('$baseUrl/v1/ventesRef/$qrCode'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('API Response: ${response.statusCode}, ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonData['status'] == true && jsonData['data']?['vente'] != null) {
          final ticket = Ticket.fromJson(jsonData['data']);
          // Cache ticket in Hive
          final ticketModel = TicketModel.fromEntity(ticket);
          await box.put(qrCode, ticketModel);
          return Right(ticket);
        } else {
          return Left(
            Failure(
              message:
                  jsonData['message'] ??
                  'Erreur inconnue lors de la récupération du ticket',
            ),
          );
        }
      } else {
        return Left(Failure(message: 'Erreur API: ${response.statusCode}'));
      }
    } catch (e) {
      print('Error fetching ticket: $e');
      return Left(
        Failure(message: 'Erreur lors de la récupération du ticket: $e'),
      );
    }
  }

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'bearer_token');
  }
}
