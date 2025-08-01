import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/repositories/ticket_repository.dart';

class SellTicket {
  final TicketRepository repository;

  SellTicket(this.repository);

  Future<Either<Failure, void>> call(Ticket ticket) async {
    return await repository.sellTicket(ticket);
  }
}
