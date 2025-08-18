import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestion_billet_train_flutter/core/constants/api_constants.dart';
import 'package:gestion_billet_train_flutter/core/errors/exceptions.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';
import 'package:http/http.dart' as http;

abstract class TicketRemoteDataSource {
  Future<TicketModel?> getTicket(String ticketId);
  Future<TicketModel> saveTicket(TicketModel ticket);
  Future<TicketModel?> scanTicket(String qrCode);
  Future<void> markAsSynced(String ticketId);
  Future<List<TicketModel>> getUnsyncedTickets();
}

class MockRemoteDataSource implements TicketRemoteDataSource {
  @override
  Future<TicketModel?> getTicket(String ticketId) async => null;

  @override
  Future<TicketModel> saveTicket(TicketModel ticket) async {
    return ticket.copyWith(isSynced: true);
  }

  @override
  Future<TicketModel?> scanTicket(String qrCode) async => null;

  @override
  Future<void> markAsSynced(String ticketId) async {}

  @override
  Future<List<TicketModel>> getUnsyncedTickets() async => [];
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final http.Client client;
  final FlutterSecureStorage secureStorage;

  TicketRemoteDataSourceImpl({
    required this.client,
    required this.secureStorage,
  });

  @override
  Future<TicketModel?> scanTicket(String qrCode) async {
    await Future.delayed(const Duration(seconds: 1));
    return TicketModel(
      id: qrCode,
      departure: 'Bamako',
      destination: 'Koulikoro',
      price: 15500,
      baggageWeight: 10,
      isValidated: false,
      hasPenalty: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<TicketModel?> getTicket(String ticketId) async {
    return null;
  }

  @override
  Future<TicketModel> saveTicket(TicketModel ticket) async {
    try {
      final token = await secureStorage.read(key: 'bearer_token');
      if (token == null) {
        throw ServerException(message: 'No bearer token found');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = {
        'voyage_id': ticket.voyageId,
        'client_nom': ticket.clientName,
        'mode_paiement_id': ticket.modePaiementId?.toString(),
        'classe_wagon_id': ticket.classeWagonId?.toString(),
        'quantite': ticket.quantity?.toString() ?? '1',
        'demi_tarif': '0', // Always '0' as per backend
        'prix': ticket.price.toStringAsFixed(2),
        'bagage': ticket.hasBagage == true ? '1' : '0',
        if (ticket.hasBagage == true)
          'poids_bagage': ticket.baggageWeight?.toStringAsFixed(2),
        'statut': ticket.statut ?? 'payé',
      };

      print('POST body: $body');

      // Initial POST request
      var uri = Uri.parse('${ApiConstants.baseUrl}/v1/ventes');
      var response = await client.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      // Handle 307 redirect
      if (response.statusCode == 307) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          print('Following 307 redirect to: $redirectUrl');
          uri = Uri.parse(redirectUrl);
          response = await client.post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
        } else {
          throw ServerException(
            message: '307 redirect received but no Location header provided',
          );
        }
      }

      print('POST response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print('POST response data: $jsonData');
        if (jsonData['status'] == true) {
          final venteData = jsonData['data'] as Map<String, dynamic>;
          final qrcodeUrl = jsonData['qrcode'] as String?;
          final updatedTicket = ticket.copyWith(
            id: venteData['id'].toString(),
            reference: venteData['reference'],
            qrcode: venteData['reference'], // Use reference for qrcode
            qrcodeUrl: qrcodeUrl,
            placeId: venteData['place_id'] as int?,
            createdAt: DateTime.tryParse(
              venteData['date_vente']?.toString() ?? '',
            ),
            hasBagage:
                venteData['bagage'] == true || venteData['bagage'] == '1',
            isDemiTarif: venteData['demi_tarif'] == '1' ? true : null,
            baggageWeight: double.tryParse(
              venteData['poids_bagage']?.toString() ?? '0.0',
            ),
            statut: venteData['statut'],
            isSynced: true,
          );
          return updatedTicket;
        } else {
          throw ServerException(
            message: jsonData['message'] ?? 'Failed to save ticket',
          );
        }
      } else {
        throw ServerException(
          message:
              'Failed to save ticket: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      print('Error saving ticket: $e');
      throw ServerException(message: 'Error saving ticket: $e');
    }
  }

  @override
  Future<void> markAsSynced(String ticketId) async {
    // Optionally implement server-side sync status update if required
  }

  @override
  Future<List<TicketModel>> getUnsyncedTickets() async {
    return [];
  }
}
