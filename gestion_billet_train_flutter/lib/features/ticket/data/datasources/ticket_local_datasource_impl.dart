import 'package:gestion_billet_train_flutter/core/errors/exceptions.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/datasources/ticket_local_datasource.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';
import 'package:hive/hive.dart';

class TicketLocalDataSourceImpl implements TicketLocalDataSource {
  TicketLocalDataSourceImpl();

  @override
  Future<TicketModel?> getTicket(String ticketId) async {
    try {
      final box = await Hive.openBox<TicketModel>('tickets');
      return box.get(ticketId);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveTicket(TicketModel ticket) async {
    try {
      final box = await Hive.openBox<TicketModel>('tickets');
      await box.put(
        ticket.reference ?? ticket.id,
        ticket,
      ); // Use reference as key
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<TicketModel?> scanTicket(String qrCode) async {
    try {
      final box = await Hive.openBox<TicketModel>('tickets');
      final tickets = box.values
          .where((ticket) => ticket.reference == qrCode)
          .toList();
      return tickets.isNotEmpty ? tickets.first : null;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> markAsSynced(String ticketId) async {
    try {
      final box = await Hive.openBox<TicketModel>('tickets');
      final ticket = box.get(ticketId);
      if (ticket != null) {
        ticket.isSynced = true;
        await box.put(ticketId, ticket);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<TicketModel>> getUnsyncedTickets() async {
    try {
      final box = await Hive.openBox<TicketModel>('tickets');
      return box.values.where((ticket) => !ticket.isSynced).toList();
    } catch (e) {
      throw CacheException();
    }
  }
}
