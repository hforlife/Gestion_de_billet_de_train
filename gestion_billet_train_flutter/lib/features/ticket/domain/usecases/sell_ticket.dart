// lib/features/ticket/domain/usecases/sell_ticket.dart
import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/repositories/ticket_repository.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/usecases/usecase.dart';

class SellTicket extends UseCase<void, Ticket> {
  final TicketRepository repository;

  SellTicket(this.repository);

  @override
  Future<Either<Failure, void>> call(Ticket params) {
    return repository.sellTicket(params);
  }
}
