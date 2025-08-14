class Ticket {
  final String id;
  final String? clientName;
  final String? departure;
  final String? destination;
  final double price;
  final bool isValidated;
  final bool hasPenalty;
  final DateTime createdAt;
  final String? trainNumber;
  final String? classType;
  final String? wagon;
  final String? seatNumber;
  final DateTime? travelDate;
  final int? quantity;
  final double? baggageWeight;
  final String? reference;
  final String? voyageId;
  final String? voyageName;
  final String? modePaiementType;
  final String? pointVenteType;
  final String? creatorName;
  final String? statut;
  final bool isSynced;
  final int? modePaiementId;
  final int? pointVenteId;
  final int? classeWagonId;
  final bool? demiTarif;
  final bool? bagage;
  final int? placeId;
  final String? qrcode;
  final String? qrcodeUrl;
  final int? createdBy;
  final int? updatedBy;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final double? total;
  final bool? isDemiTarif;
  final bool? hasBagage;
  final String? numeroVoyage;
  final int? ligneId;
  final DateTime? dateArrivee;
  final int? gareId;
  final int? actif;
  final int? nombreSieges;
  final int? siegesDisponibles;
  final String? prixMultiplier;
  final String? creatorUsername;
  final String? creatorEmail;
  final DateTime? creatorEmailVerifiedAt;
  final String? qrCodeUrl;

  Ticket({
    required this.id,
    this.clientName,
    this.departure,
    this.destination,
    required this.price,
    required this.isValidated,
    required this.hasPenalty,
    required this.createdAt,
    this.trainNumber,
    this.classType,
    this.wagon,
    this.seatNumber,
    this.travelDate,
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

  factory Ticket.fromJson(
    Map<String, dynamic> json, {
    Map<String, String>? gareCache,
  }) {
    final vente = json['vente'] ?? json;
    final voyage = vente['voyage'] ?? {};
    final modePaiement = vente['mode_paiement'] ?? {};
    final pointVente = vente['point_vente'] ?? {};
    final place = vente['place'] ?? {};
    final wagon = place['wagon'] ?? {};
    final classeWagon = vente['classe_wagon'] ?? wagon['classe_wagon'] ?? {};

    final departureId = voyage['gare_depart_id']?.toString() ?? 'Inconnu';
    final destinationId = voyage['gare_arrivee_id']?.toString() ?? 'Inconnu';
    final departure = gareCache != null
        ? gareCache[departureId] ?? departureId
        : departureId;
    final destination = gareCache != null
        ? gareCache[destinationId] ?? destinationId
        : destinationId;

    return Ticket(
      id: vente['id']?.toString() ?? '',
      clientName: vente['client_nom']?.toString(),
      departure: departure,
      destination: destination,
      price: double.tryParse(vente['prix']?.toString() ?? '0.0') ?? 0.0,
      isValidated: vente['statut'] == 'payé',
      hasPenalty:
          (vente['penalite'] != null &&
          double.parse(vente['penalite']?.toString() ?? '0') > 0),
      createdAt:
          DateTime.tryParse(vente['date_vente']?.toString() ?? '') ??
          DateTime.now(),
      trainNumber: voyage['train_id']?.toString(),
      classType: classeWagon['classe']?.toString(),
      wagon: wagon['numero_wagon']?.toString(),
      seatNumber: place['numero']?.toString(),
      travelDate: DateTime.tryParse(voyage['date_depart']?.toString() ?? ''),
      quantity: int.tryParse(vente['quantite']?.toString() ?? '1'),
      baggageWeight: double.tryParse(
        vente['poids_bagage']?.toString() ?? '0.0',
      ),
      reference: vente['reference']?.toString(),
      voyageId: vente['voyage_id']?.toString(),
      voyageName: voyage['nom']?.toString(),
      modePaiementType: modePaiement['type']?.toString(),
      pointVenteType: pointVente['type']?.toString(),
      creatorName: vente['creator']?['name']?.toString(),
      statut: vente['statut']?.toString(),
      isSynced: false,
      modePaiementId: vente['mode_paiement_id'] as int?,
      pointVenteId: vente['point_vente_id'] as int?,
      classeWagonId: vente['classe_wagon_id'] as int?,
      demiTarif: vente['demi_tarif'] as bool?,
      bagage: vente['bagage'] as bool?,
      placeId: vente['place_id'] as int?,
      qrcode: vente['qrcode']?.toString(),
      qrcodeUrl: vente['qrcode_url']?.toString(),
      createdBy: vente['created_by'] as int?,
      updatedBy: vente['updated_by'] as int?,
      updatedAt: DateTime.tryParse(vente['updated_at']?.toString() ?? ''),
      deletedAt: DateTime.tryParse(vente['deleted_at']?.toString() ?? ''),
      total: double.tryParse(vente['total']?.toString() ?? '0.0'),
      isDemiTarif: vente['is_demi_tarif'] as bool?,
      hasBagage: vente['has_bagage'] as bool?,
      numeroVoyage: voyage['numero_voyage']?.toString(),
      ligneId: voyage['ligne_id'] as int?,
      dateArrivee: DateTime.tryParse(voyage['date_arrivee']?.toString() ?? ''),
      gareId: pointVente['gare_id'] as int?,
      actif: pointVente['actif'] as int?,
      nombreSieges: wagon['nombre_sieges'] as int?,
      siegesDisponibles: wagon['sieges_disponibles'] as int?,
      prixMultiplier: classeWagon['prix_multiplier']?.toString(),
      creatorUsername: vente['creator']?['username']?.toString(),
      creatorEmail: vente['creator']?['email']?.toString(),
      creatorEmailVerifiedAt: DateTime.tryParse(
        vente['creator']?['email_verified_at']?.toString() ?? '',
      ),
      qrCodeUrl: json['qr_code_url']?.toString(),
    );
  }

  Ticket copyWith({
    String? id,
    String? clientName,
    String? departure,
    String? destination,
    double? price,
    bool? isValidated,
    bool? hasPenalty,
    DateTime? createdAt,
    String? trainNumber,
    String? classType,
    String? wagon,
    String? seatNumber,
    DateTime? travelDate,
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
    return Ticket(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      departure: departure ?? this.departure,
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
}
