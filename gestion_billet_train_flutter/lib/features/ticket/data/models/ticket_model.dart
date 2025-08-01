import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:hive/hive.dart';

part 'ticket_model.g.dart';

@HiveType(typeId: 0)
class TicketModel extends Ticket {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String departure;
  @override
  @HiveField(2)
  final String destination;
  @override
  @HiveField(3)
  final double price;
  @override
  @HiveField(4)
  final bool isValidated;
  @override
  @HiveField(5)
  final bool hasPenalty;
  @override
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final bool isSynced;

  const TicketModel({
    required this.id,
    required this.departure,
    required this.destination,
    required this.price,
    required this.isValidated,
    required this.hasPenalty,
    required this.createdAt,
    this.isSynced = false,
  }) : super(
         id: id,
         departure: departure,
         destination: destination,
         price: price,
         isValidated: isValidated,
         hasPenalty: hasPenalty,
         createdAt: createdAt,
       );

  factory TicketModel.fromEntity(Ticket ticket) {
    return TicketModel(
      id: ticket.id,
      departure: ticket.departure,
      destination: ticket.destination,
      price: ticket.price,
      isValidated: ticket.isValidated,
      hasPenalty: ticket.hasPenalty,
      createdAt: ticket.createdAt,
      isSynced: false,
    );
  }
}
