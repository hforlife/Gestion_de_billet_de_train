// lib/features/ticket/domain/repositories/ticket_repository.dart
import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';

abstract class TicketRepository {
  Future<Either<Failure, Ticket>> getTicket(String ticketId);
  Future<Either<Failure, void>> saveTicket(Ticket ticket);
  Future<Either<Failure, Ticket>> scanTicket(String qrCode);
  Future<Either<Failure, void>> markAsSynced(String ticketId);
  Future<Either<Failure, List<Ticket>>> getUnsyncedTickets();
  Future<Either<Failure, void>> sellTicket(Ticket ticket);
}
