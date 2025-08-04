// lib/features/ticket/data/models/ticket_model.dart
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:hive/hive.dart';
part 'ticket_model.g.dart';

@HiveType(typeId: 0)
class TicketModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String departure;
  @HiveField(2)
  final String destination;
  @HiveField(3)
  final double price;
  @HiveField(4)
  bool isValidated; // Supprimé 'final'
  @HiveField(5)
  final bool hasPenalty;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final String? trainNumber;
  @HiveField(8)
  final String? classType;
  @HiveField(9)
  final String? wagon;
  @HiveField(10)
  final String? seatNumber;
  @HiveField(11)
  final DateTime? travelDate;
  @HiveField(12)
  bool isSynced = false;

  TicketModel({
    required this.id,
    required this.departure,
    required this.destination,
    required this.price,
    required this.isValidated,
    required this.hasPenalty,
    required this.createdAt,
    this.trainNumber,
    this.classType,
    this.wagon,
    this.seatNumber,
    this.travelDate,
    this.isSynced = false,
  });

  factory TicketModel.fromEntity(Ticket ticket) {
    return TicketModel(
      id: ticket.id,
      departure: ticket.departure,
      destination: ticket.destination,
      price: ticket.price,
      isValidated: ticket.isValidated,
      hasPenalty: ticket.hasPenalty,
      createdAt: ticket.createdAt,
      trainNumber: ticket.trainNumber,
      classType: ticket.classType,
      wagon: ticket.wagon,
      seatNumber: ticket.seatNumber,
      travelDate: ticket.travelDate,
      isSynced: ticket.isSynced ?? false,
    );
  }

  Ticket toEntity() => Ticket(
    id: id,
    departure: departure,
    destination: destination,
    price: price,
    isValidated: isValidated,
    hasPenalty: hasPenalty,
    createdAt: createdAt,
    trainNumber: trainNumber,
    classType: classType,
    wagon: wagon,
    seatNumber: seatNumber,
    travelDate: travelDate,
    isSynced: isSynced,
  );
}
