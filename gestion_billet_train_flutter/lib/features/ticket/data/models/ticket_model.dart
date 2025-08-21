import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:hive/hive.dart';

part 'ticket_model.g.dart';

@HiveType(typeId: 0)
class TicketModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? departure;
  @HiveField(2)
  final String? destination;
  @HiveField(3)
  final double price;
  @HiveField(4)
  bool isValidated;
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
  final String? clientName;
  @HiveField(13)
  final int? quantity;
  @HiveField(14)
  final double? baggageWeight;
  @HiveField(15)
  final String? reference;
  @HiveField(16)
  final String? voyageId;
  @HiveField(17)
  final String? voyageName;
  @HiveField(18)
  final String? modePaiementType;
  @HiveField(19)
  final String? pointVenteType;
  @HiveField(20)
  final String? creatorName;
  @HiveField(21)
  final String? statut;
  @HiveField(22)
  bool isSynced;
  @HiveField(23)
  final int? modePaiementId;
  @HiveField(24)
  final int? pointVenteId;
  @HiveField(25)
  final int? classeWagonId;
  @HiveField(26)
  final bool? demiTarif;
  @HiveField(27)
  final bool? bagage;
  @HiveField(28)
  final int? placeId;
  @HiveField(29)
  final String? qrcode;
  @HiveField(30)
  final String? qrcodeUrl;
  @HiveField(31)
  final int? createdBy;
  @HiveField(32)
  final int? updatedBy;
  @HiveField(33)
  final DateTime? updatedAt;
  @HiveField(34)
  final DateTime? deletedAt;
  @HiveField(35)
  final double? total;
  @HiveField(36)
  final bool? isDemiTarif;
  @HiveField(37)
  final bool? hasBagage;
  @HiveField(38)
  final String? numeroVoyage;
  @HiveField(39)
  final int? ligneId;
  @HiveField(40)
  final DateTime? dateArrivee;
  @HiveField(41)
  final int? gareId;
  @HiveField(42)
  final int? actif;
  @HiveField(43)
  final int? nombreSieges;
  @HiveField(44)
  final int? siegesDisponibles;
  @HiveField(45)
  final String? prixMultiplier;
  @HiveField(46)
  final String? creatorUsername;
  @HiveField(47)
  final String? creatorEmail;
  @HiveField(48)
  final DateTime? creatorEmailVerifiedAt;
  @HiveField(49)
  final String? qrCodeUrl;
  @HiveField(50)
  final bool? penalite;
  @HiveField(51)
  final int? quantite_demi_tarif;

  TicketModel({
    required this.id,
    this.departure,
    this.destination,
    required this.price,
    required this.isValidated,
    required this.hasPenalty,
    required this.createdAt,
    this.trainNumber,
    this.penalite,
    this.quantite_demi_tarif,
    this.classType,
    this.wagon,
    this.seatNumber,
    this.travelDate,
    this.clientName,
    this.quantity,
    this.baggageWeight,
    this.reference,
    this.voyageId,
    this.voyageName,
    this.modePaiementType,
    this.pointVenteType,
    this.creatorName,
    this.statut,
    this.isSynced = false,
    this.modePaiementId,
    this.pointVenteId,
    this.classeWagonId,
    this.demiTarif,
    this.bagage,
    this.placeId,
    this.qrcode,
    this.qrcodeUrl,
    this.createdBy,
    this.updatedBy,
    this.updatedAt,
    this.deletedAt,
    this.total,
    this.isDemiTarif,
    this.hasBagage,
    this.numeroVoyage,
    this.ligneId,
    this.dateArrivee,
    this.gareId,
    this.actif,
    this.nombreSieges,
    this.siegesDisponibles,
    this.prixMultiplier,
    this.creatorUsername,
    this.creatorEmail,
    this.creatorEmailVerifiedAt,
    this.qrCodeUrl,
  });

  // Add copyWith method
  TicketModel copyWith({
    String? id,
    String? departure,
    String? destination,
    int? quantite_demi_tarif,
    bool? penalite,
    double? price,
    bool? isValidated,
    bool? hasPenalty,
    DateTime? createdAt,
    String? trainNumber,
    String? classType,
    String? wagon,
    String? seatNumber,
    DateTime? travelDate,
    String? clientName,
    int? quantity,
    double? baggageWeight,
    String? reference,
    String? voyageId,
    String? voyageName,
    String? modePaiementType,
    String? pointVenteType,
    String? creatorName,
    String? statut,
    bool? isSynced,
    int? modePaiementId,
    int? pointVenteId,
    int? classeWagonId,
    bool? demiTarif,
    bool? bagage,
    int? placeId,
    String? qrcode,
    String? qrcodeUrl,
    int? createdBy,
    int? updatedBy,
    DateTime? updatedAt,
    DateTime? deletedAt,
    double? total,
    bool? isDemiTarif,
    bool? hasBagage,
    String? numeroVoyage,
    int? ligneId,
    DateTime? dateArrivee,
    int? gareId,
    int? actif,
    int? nombreSieges,
    int? siegesDisponibles,
    String? prixMultiplier,
    String? creatorUsername,
    String? creatorEmail,
    DateTime? creatorEmailVerifiedAt,
    String? qrCodeUrl,
  }) {
    return TicketModel(
      id: id ?? this.id,
      departure: departure ?? this.departure,
      penalite: penalite ?? this.penalite,
      quantite_demi_tarif: quantite_demi_tarif ?? this.quantite_demi_tarif,
      destination: destination ?? this.destination,
      price: price ?? this.price,
      isValidated: isValidated ?? this.isValidated,
      hasPenalty: hasPenalty ?? this.hasPenalty,
      createdAt: createdAt ?? this.createdAt,
      trainNumber: trainNumber ?? this.trainNumber,
      classType: classType ?? this.classType,
      wagon: wagon ?? this.wagon,
      seatNumber: seatNumber ?? this.seatNumber,
      travelDate: travelDate ?? this.travelDate,
      clientName: clientName ?? this.clientName,
      quantity: quantity ?? this.quantity,
      baggageWeight: baggageWeight ?? this.baggageWeight,
      reference: reference ?? this.reference,
      voyageId: voyageId ?? this.voyageId,
      voyageName: voyageName ?? this.voyageName,
      modePaiementType: modePaiementType ?? this.modePaiementType,
      pointVenteType: pointVenteType ?? this.pointVenteType,
      creatorName: creatorName ?? this.creatorName,
      statut: statut ?? this.statut,
      isSynced: isSynced ?? this.isSynced,
      modePaiementId: modePaiementId ?? this.modePaiementId,
      pointVenteId: pointVenteId ?? this.pointVenteId,
      classeWagonId: classeWagonId ?? this.classeWagonId,
      demiTarif: demiTarif ?? this.demiTarif,
      bagage: bagage ?? this.bagage,
      placeId: placeId ?? this.placeId,
      qrcode: qrcode ?? this.qrcode,
      qrcodeUrl: qrcodeUrl ?? this.qrcodeUrl,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      total: total ?? this.total,
      isDemiTarif: isDemiTarif ?? this.isDemiTarif,
      hasBagage: hasBagage ?? this.hasBagage,
      numeroVoyage: numeroVoyage ?? this.numeroVoyage,
      ligneId: ligneId ?? this.ligneId,
      dateArrivee: dateArrivee ?? this.dateArrivee,
      gareId: gareId ?? this.gareId,
      actif: actif ?? this.actif,
      nombreSieges: nombreSieges ?? this.nombreSieges,
      siegesDisponibles: siegesDisponibles ?? this.siegesDisponibles,
      prixMultiplier: prixMultiplier ?? this.prixMultiplier,
      creatorUsername: creatorUsername ?? this.creatorUsername,
      creatorEmail: creatorEmail ?? this.creatorEmail,
      creatorEmailVerifiedAt:
          creatorEmailVerifiedAt ?? this.creatorEmailVerifiedAt,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
    );
  }

  factory TicketModel.fromEntity(Ticket ticket) {
    return TicketModel(
      id: ticket.id,
      departure: ticket.departure,
      penalite: ticket.penalite,
      quantite_demi_tarif: ticket.quantite_demi_tarif,
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
      clientName: ticket.clientName,
      quantity: ticket.quantity,
      baggageWeight: ticket.baggageWeight,
      reference: ticket.reference,
      voyageId: ticket.voyageId,
      voyageName: ticket.voyageName,
      modePaiementType: ticket.modePaiementType,
      pointVenteType: ticket.pointVenteType,
      creatorName: ticket.creatorName,
      statut: ticket.statut,
      isSynced: ticket.isSynced,
      modePaiementId: ticket.modePaiementId,
      pointVenteId: ticket.pointVenteId,
      classeWagonId: ticket.classeWagonId,
      demiTarif: ticket.demiTarif,
      bagage: ticket.bagage,
      placeId: ticket.placeId,
      qrcode: ticket.qrcode,
      qrcodeUrl: ticket.qrcodeUrl,
      createdBy: ticket.createdBy,
      updatedBy: ticket.updatedBy,
      updatedAt: ticket.updatedAt,
      deletedAt: ticket.deletedAt,
      total: ticket.total,
      isDemiTarif: ticket.isDemiTarif,
      hasBagage: ticket.hasBagage,
      numeroVoyage: ticket.numeroVoyage,
      ligneId: ticket.ligneId,
      dateArrivee: ticket.dateArrivee,
      gareId: ticket.gareId,
      actif: ticket.actif,
      nombreSieges: ticket.nombreSieges,
      siegesDisponibles: ticket.siegesDisponibles,
      prixMultiplier: ticket.prixMultiplier,
      creatorUsername: ticket.creatorUsername,
      creatorEmail: ticket.creatorEmail,
      creatorEmailVerifiedAt: ticket.creatorEmailVerifiedAt,
      qrCodeUrl: ticket.qrCodeUrl,
    );
  }

  Ticket toEntity() => Ticket(
    id: id,
    departure: departure,
    destination: destination,
    penalite: penalite,
    quantite_demi_tarif: quantite_demi_tarif,
    price: price,
    isValidated: isValidated,
    hasPenalty: hasPenalty,
    createdAt: createdAt,
    trainNumber: trainNumber,
    classType: classType,
    wagon: wagon,
    seatNumber: seatNumber,
    travelDate: travelDate,
    clientName: clientName,
    quantity: quantity,
    baggageWeight: baggageWeight,
    reference: reference,
    voyageId: voyageId,
    voyageName: voyageName,
    modePaiementType: modePaiementType,
    pointVenteType: pointVenteType,
    creatorName: creatorName,
    statut: statut,
    isSynced: isSynced,
    modePaiementId: modePaiementId,
    pointVenteId: pointVenteId,
    classeWagonId: classeWagonId,
    demiTarif: demiTarif,
    bagage: bagage,
    placeId: placeId,
    qrcode: qrcode,
    qrcodeUrl: qrcodeUrl,
    createdBy: createdBy,
    updatedBy: updatedBy,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    total: total,
    isDemiTarif: isDemiTarif,
    hasBagage: hasBagage,
    numeroVoyage: numeroVoyage,
    ligneId: ligneId,
    dateArrivee: dateArrivee,
    gareId: gareId,
    actif: actif,
    nombreSieges: nombreSieges,
    siegesDisponibles: siegesDisponibles,
    prixMultiplier: prixMultiplier,
    creatorUsername: creatorUsername,
    creatorEmail: creatorEmail,
    creatorEmailVerifiedAt: creatorEmailVerifiedAt,
    qrCodeUrl: qrCodeUrl,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departure': departure,
      'destination': destination,
      'price': price,
      'isValidated': isValidated,
      'quantite_demi_tarif': quantite_demi_tarif,
      'penalite': penalite,
      'hasPenalty': hasPenalty,
      'createdAt': createdAt.toIso8601String(),
      'trainNumber': trainNumber,
      'classType': classType,
      'wagon': wagon,
      'seatNumber': seatNumber,
      'travelDate': travelDate?.toIso8601String(),
      'clientName': clientName,
      'quantity': quantity,
      'baggageWeight': baggageWeight,
      'reference': reference,
      'voyageId': voyageId,
      'voyageName': voyageName,
      'modePaiementType': modePaiementType,
      'pointVenteType': pointVenteType,
      'creatorName': creatorName,
      'statut': statut,
      'isSynced': isSynced,
      'modePaiementId': modePaiementId,
      'pointVenteId': pointVenteId,
      'classeWagonId': classeWagonId,
      'demiTarif': demiTarif,
      'bagage': bagage,
      'placeId': placeId,
      'qrcode': qrcode,
      'qrcodeUrl': qrcodeUrl,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'total': total,
      'isDemiTarif': isDemiTarif,
      'hasBagage': hasBagage,
      'numeroVoyage': numeroVoyage,
      'ligneId': ligneId,
      'dateArrivee': dateArrivee?.toIso8601String(),
      'gareId': gareId,
      'actif': actif,
      'nombreSieges': nombreSieges,
      'siegesDisponibles': siegesDisponibles,
      'prixMultiplier': prixMultiplier,
      'creatorUsername': creatorUsername,
      'creatorEmail': creatorEmail,
      'creatorEmailVerifiedAt': creatorEmailVerifiedAt?.toIso8601String(),
      'qrCodeUrl': qrCodeUrl,
    };
  }

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id']?.toString() ?? '',
      departure: json['departure']?.toString(),
      destination: json['destination']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isValidated: json['isValidated'] as bool? ?? false,
      hasPenalty: json['hasPenalty'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      trainNumber: json['trainNumber']?.toString(),
      classType: json['classType']?.toString(),
      wagon: json['wagon']?.toString(),
      seatNumber: json['seatNumber']?.toString(),
      travelDate: json['travelDate'] != null
          ? DateTime.tryParse(json['travelDate'] as String)
          : null,
      clientName: json['clientName']?.toString(),
      quantity: json['quantity'] as int?,
      baggageWeight: (json['baggageWeight'] as num?)?.toDouble(),
      reference: json['reference']?.toString(),
      voyageId: json['voyageId']?.toString(),
      voyageName: json['voyageName']?.toString(),
      modePaiementType: json['modePaiementType']?.toString(),
      pointVenteType: json['pointVenteType']?.toString(),
      creatorName: json['creatorName']?.toString(),
      statut: json['statut']?.toString(),
      isSynced: json['isSynced'] as bool? ?? false,
      modePaiementId: json['modePaiementId'] as int?,
      pointVenteId: json['pointVenteId'] as int?,
      classeWagonId: json['classeWagonId'] as int?,
      demiTarif: json['demiTarif'] as bool?,
      bagage: json['bagage'] as bool?,
      placeId: json['placeId'] as int?,
      qrcode: json['qrcode']?.toString(),
      qrcodeUrl: json['qrcodeUrl']?.toString(),
      createdBy: json['createdBy'] as int?,
      updatedBy: json['updatedBy'] as int?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'] as String)
          : null,
      total: (json['total'] as num?)?.toDouble(),
      isDemiTarif: json['isDemiTarif'] as bool?,
      hasBagage: json['hasBagage'] as bool?,
      numeroVoyage: json['numeroVoyage']?.toString(),
      ligneId: json['ligneId'] as int?,
      dateArrivee: json['dateArrivee'] != null
          ? DateTime.tryParse(json['dateArrivee'] as String)
          : null,
      gareId: json['gareId'] as int?,
      actif: json['actif'] as int?,
      nombreSieges: json['nombreSieges'] as int?,
      siegesDisponibles: json['siegesDisponibles'] as int?,
      prixMultiplier: json['prixMultiplier']?.toString(),
      creatorUsername: json['creatorUsername']?.toString(),
      creatorEmail: json['creatorEmail']?.toString(),
      creatorEmailVerifiedAt: json['creatorEmailVerifiedAt'] != null
          ? DateTime.tryParse(json['creatorEmailVerifiedAt'] as String)
          : null,
      qrCodeUrl: json['qrCodeUrl']?.toString(),
    );
  }
}
