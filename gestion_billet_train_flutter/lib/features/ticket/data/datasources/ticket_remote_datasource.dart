import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';

abstract class TicketRemoteDataSource {
  Future<TicketModel?> scanTicket(String qrCode);
  Future<void> saveTicket(TicketModel ticket);
  Future<void> validateTicket(String ticketId);
  Future<void> markAsSynced(String ticketId); // Ajouté
  Future<List<TicketModel>> getUnsyncedTickets(); // Ajouté
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  @override
  Future<TicketModel?> scanTicket(String qrCode) async {
    // Simuler une API
    await Future.delayed(const Duration(seconds: 1));
    return TicketModel(
      id: qrCode,
      departure: 'Bamako',
      destination: 'Koulikoro',
      price: 15500,
      isValidated: false,
      hasPenalty: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> saveTicket(TicketModel ticket) async {
    // Implémentation API
  }

  @override
  Future<void> validateTicket(String ticketId) async {
    // Implémentation API
  }

  @override
  Future<void> markAsSynced(String ticketId) async {
    // Implémentation API (par exemple, mettre à jour un statut sur le serveur)
  }

  @override
  Future<List<TicketModel>> getUnsyncedTickets() async {
    // Implémentation API (par exemple, récupérer les tickets non synchronisés)
    return []; // Remplacez par la logique réelle
  }
}
