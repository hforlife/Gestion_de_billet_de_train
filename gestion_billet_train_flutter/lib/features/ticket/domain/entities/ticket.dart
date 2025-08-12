import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String id;
  final String departure;
  final String destination;
  final String? clientName;
  final double price;
  final int? quantity;
  final bool isValidated;
  final bool hasPenalty;
  final DateTime createdAt;
  final String? trainNumber;
  final String? classType;
  final String? wagon;
  final String? seatNumber;
  final DateTime? travelDate;
  final bool isSynced;

  const Ticket({
    required this.id,
    required this.departure,
    required this.destination,
    required this.clientName,
    required this.quantity,
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

  @override
  List<Object?> get props => [
    id,
    departure,
    destination,
    clientName,
    quantity,
    price,
    isValidated,
    hasPenalty,
    createdAt,
    trainNumber,
    classType,
    wagon,
    seatNumber,
    travelDate,
    isSynced,
  ];
}
