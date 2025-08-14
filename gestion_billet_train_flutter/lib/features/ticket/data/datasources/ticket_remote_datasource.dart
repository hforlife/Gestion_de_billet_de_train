import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';

abstract class TicketRemoteDataSource {
  Future<TicketModel?> getTicket(String ticketId);
  Future<void> saveTicket(TicketModel ticket);
  Future<TicketModel?> scanTicket(String qrCode);
  Future<void> markAsSynced(String ticketId);
  Future<List<TicketModel>> getUnsyncedTickets(); // Ajouté
  // Supprimé validateTicket car non utilisé ici
}

class MockRemoteDataSource implements TicketRemoteDataSource {
  @override
  Future<TicketModel?> getTicket(String ticketId) async => null;

  @override
  Future<void> saveTicket(TicketModel ticket) async {}

  @override
  Future<TicketModel?> scanTicket(String qrCode) async => null;

  @override
  Future<void> markAsSynced(String ticketId) async {}

  @override
  Future<List<TicketModel>> getUnsyncedTickets() async => [];
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
      baggageWeight: 10,
      isValidated: false,
      hasPenalty: false,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<TicketModel?> getTicket(String ticketId) async {
    // Logique pour récupérer un ticket depuis une source distante (ex. API)
    // Pour l'instant, retourne null (à remplacer par une vraie implémentation)
    return null;
  }

  @override
  Future<void> saveTicket(TicketModel ticket) async {
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
