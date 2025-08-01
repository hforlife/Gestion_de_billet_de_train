import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/repositories/ticket_repository.dart';

class ScanTicket {
  final TicketRepository repository;

  ScanTicket(this.repository);

  Future<Either<Failure, Ticket>> call(String qrCode) async {
    return await repository.scanTicket(qrCode);
  }
}
