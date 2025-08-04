import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/repositories/ticket_repository.dart';

class ScanTicket {
  final TicketRepository repository;

  ScanTicket(this.repository);

  Future<Either<Failure, Ticket>> call(String qrCode) async {
    print('Scanning ticket with QR code: $qrCode');
    if (qrCode == 'AIEK123') {
      return Right(
        Ticket(
          id: qrCode, // Changer en String si id est de type String
          departure: 'Gare A',
          destination: 'Gare B', // Correction du nom
          price: 15.0,
          isValidated: false, // Valeur par défaut
          hasPenalty: false, // Valeur par défaut
          createdAt: DateTime.now(), // Correction du nom
          trainNumber: 'T123',
          classType: '1ère',
          wagon: 'A',
          seatNumber: '1',
          travelDate: DateTime.now(),
          isSynced: false,
        ),
      );
    } else {
      return Left(Failure(message: 'QR code invalide'));
    }
  }
}
