import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final String id;
  final String departure;
  final String destination;
  final double price;
  final bool isValidated;
  final bool hasPenalty;
  final DateTime createdAt;

  const Ticket({
    required this.id,
    required this.departure,
    required this.destination,
    required this.price,
    required this.isValidated,
    required this.hasPenalty,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
    id,
    departure,
    destination,
    price,
    isValidated,
    hasPenalty,
    createdAt,
  ];
}
