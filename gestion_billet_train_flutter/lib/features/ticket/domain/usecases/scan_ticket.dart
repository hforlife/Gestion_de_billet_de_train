// lib/features/ticket/domain/usecases/scan_ticket.dart
import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/repositories/ticket_repository.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/usecases/usecase.dart';

class ScanTicket extends UseCase<Ticket, String> {
  final TicketRepository repository;

  ScanTicket(this.repository);

  @override
  Future<Either<Failure, Ticket>> call(String params) {
    return repository.scanTicket(params);
  }
}
