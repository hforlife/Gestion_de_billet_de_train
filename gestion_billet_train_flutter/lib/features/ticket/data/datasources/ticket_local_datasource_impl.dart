import 'package:gestion_billet_train_flutter/core/errors/exceptions.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/datasources/ticket_local_datasource.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';
import 'package:hive/hive.dart';

class TicketLocalDataSourceImpl implements TicketLocalDataSource {
  final HiveInterface hive;

  TicketLocalDataSourceImpl({required this.hive});

  @override
  Future<TicketModel> getTicket(String ticketId) async {
    try {
      final box = await hive.openBox<TicketModel>('tickets');
      final ticket = box.get(ticketId);
      if (ticket == null) throw CacheException(message: 'Ticket not found');
      return ticket;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveTicket(TicketModel ticket) async {
    try {
      final box = await hive.openBox<TicketModel>('tickets');
      await box.put(
        ticket.id,
        ticket,
      ); // Utilise id comme clé (ajustez si seatNumber est préféré)
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> markAsSynced(String ticketId) async {
    try {
      final box = await hive.openBox<TicketModel>('tickets');
      final ticket = box.get(ticketId);
      if (ticket != null) {
        // Ajoutez un champ synced si nécessaire (ex. ticket.synced = true)
        await box.put(ticketId, ticket); // Simulé, ajustez avec un champ synced
      }
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<List<TicketModel>> getUnsyncedTickets() async {
    try {
      final box = await hive.openBox<TicketModel>('tickets');
      // Ajustez la logique pour filtrer les tickets non synchronisés
      return box.values
          .where((ticket) => true)
          .toList(); // Remplacez par une condition (ex. !ticket.synced)
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<TicketModel?> scanTicket(String qrCode) async {
    try {
      final box = await hive.openBox<TicketModel>('tickets');
      // Logique pour parser le QR code (exemple simplifié)
      final parts = qrCode.split(',');
      if (parts.length > 3) {
        final ticketId = parts[3]; // Exemple : utiliser le 4e élément comme ID
        final ticket = box.get(ticketId); // Recherche par ID
        return ticket; // Retourne null si non trouvé
      }
      return null; // Si le QR code n'est pas valide
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
