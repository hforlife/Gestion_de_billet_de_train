import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';

abstract class TicketLocalDataSource {
  Future<TicketModel> getTicket(String ticketId);
  Future<void> saveTicket(TicketModel ticket);
  Future<TicketModel?> scanTicket(String qrCode);
  Future<void> markAsSynced(String ticketId); // Pour marquer comme synchronisé
  Future<List<TicketModel>>
  getUnsyncedTickets(); // Pour récupérer les tickets non synchronisés
  // Supprimé validateTicket
}
