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
  bool isValidated; // Non-final to allow updates
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
  @HiveField(13) // New field
  final String? clientName;
  @HiveField(14) // New field
  final int? quantity;

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
    this.clientName,
    this.quantity,
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
      clientName: ticket.clientName, // New field
      quantity: ticket.quantity, // New field
    );
  }

  Ticket toEntity() => Ticket(
    id: id,
    departure: departure,
    destination: destination,
    clientName: clientName,
    quantity: quantity,
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

  // Add toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departure': departure,
      'destination': destination,
      'price': price,
      'isValidated': isValidated,
      'hasPenalty': hasPenalty,
      'createdAt': createdAt.toIso8601String(),
      'trainNumber': trainNumber,
      'classType': classType,
      'wagon': wagon,
      'seatNumber': seatNumber,
      'travelDate': travelDate?.toIso8601String(),
      'isSynced': isSynced,
      'clientName': clientName,
      'quantity': quantity,
    };
  }

  // Add fromJson factory method
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] as String,
      departure: json['departure'] as String,
      destination: json['destination'] as String,
      price: (json['price'] as num).toDouble(),
      isValidated: json['isValidated'] as bool,
      hasPenalty: json['hasPenalty'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      trainNumber: json['trainNumber'] as String?,
      classType: json['classType'] as String?,
      wagon: json['wagon'] as String?,
      seatNumber: json['seatNumber'] as String?,
      travelDate: json['travelDate'] != null
          ? DateTime.parse(json['travelDate'] as String)
          : null,
      isSynced: json['isSynced'] as bool? ?? false,
      clientName: json['clientName'] as String?,
      quantity: json['quantity'] as int?,
    );
  }
}
