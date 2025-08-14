// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketModelAdapter extends TypeAdapter<TicketModel> {
  @override
  final int typeId = 0;

  @override
  TicketModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketModel(
      id: fields[0] as String,
      departure: fields[1] as String?,
      destination: fields[2] as String?,
      price: fields[3] as double,
      isValidated: fields[4] as bool,
      hasPenalty: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      trainNumber: fields[7] as String?,
      classType: fields[8] as String?,
      wagon: fields[9] as String?,
      seatNumber: fields[10] as String?,
      travelDate: fields[11] as DateTime?,
      clientName: fields[12] as String?,
      quantity: fields[13] as int?,
      baggageWeight: fields[14] as double?,
      reference: fields[15] as String?,
      voyageId: fields[16] as String?,
      voyageName: fields[17] as String?,
      modePaiementType: fields[18] as String?,
      pointVenteType: fields[19] as String?,
      creatorName: fields[20] as String?,
      statut: fields[21] as String?,
      isSynced: fields[22] as bool,
      modePaiementId: fields[23] as int?,
      pointVenteId: fields[24] as int?,
      classeWagonId: fields[25] as int?,
      demiTarif: fields[26] as bool?,
      bagage: fields[27] as bool?,
      placeId: fields[28] as int?,
      qrcode: fields[29] as String?,
      qrcodeUrl: fields[30] as String?,
      createdBy: fields[31] as int?,
      updatedBy: fields[32] as int?,
      updatedAt: fields[33] as DateTime?,
      deletedAt: fields[34] as DateTime?,
      total: fields[35] as double?,
      isDemiTarif: fields[36] as bool?,
      hasBagage: fields[37] as bool?,
      numeroVoyage: fields[38] as String?,
      ligneId: fields[39] as int?,
      dateArrivee: fields[40] as DateTime?,
      gareId: fields[41] as int?,
      actif: fields[42] as int?,
      nombreSieges: fields[43] as int?,
      siegesDisponibles: fields[44] as int?,
      prixMultiplier: fields[45] as String?,
      creatorUsername: fields[46] as String?,
      creatorEmail: fields[47] as String?,
      creatorEmailVerifiedAt: fields[48] as DateTime?,
      qrCodeUrl: fields[49] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TicketModel obj) {
    writer
      ..writeByte(50)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.departure)
      ..writeByte(2)
      ..write(obj.destination)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.isValidated)
      ..writeByte(5)
      ..write(obj.hasPenalty)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.trainNumber)
      ..writeByte(8)
      ..write(obj.classType)
      ..writeByte(9)
      ..write(obj.wagon)
      ..writeByte(10)
      ..write(obj.seatNumber)
      ..writeByte(11)
      ..write(obj.travelDate)
      ..writeByte(12)
      ..write(obj.clientName)
      ..writeByte(13)
      ..write(obj.quantity)
      ..writeByte(14)
      ..write(obj.baggageWeight)
      ..writeByte(15)
      ..write(obj.reference)
      ..writeByte(16)
      ..write(obj.voyageId)
      ..writeByte(17)
      ..write(obj.voyageName)
      ..writeByte(18)
      ..write(obj.modePaiementType)
      ..writeByte(19)
      ..write(obj.pointVenteType)
      ..writeByte(20)
      ..write(obj.creatorName)
      ..writeByte(21)
      ..write(obj.statut)
      ..writeByte(22)
      ..write(obj.isSynced)
      ..writeByte(23)
      ..write(obj.modePaiementId)
      ..writeByte(24)
      ..write(obj.pointVenteId)
      ..writeByte(25)
      ..write(obj.classeWagonId)
      ..writeByte(26)
      ..write(obj.demiTarif)
      ..writeByte(27)
      ..write(obj.bagage)
      ..writeByte(28)
      ..write(obj.placeId)
      ..writeByte(29)
      ..write(obj.qrcode)
      ..writeByte(30)
      ..write(obj.qrcodeUrl)
      ..writeByte(31)
      ..write(obj.createdBy)
      ..writeByte(32)
      ..write(obj.updatedBy)
      ..writeByte(33)
      ..write(obj.updatedAt)
      ..writeByte(34)
      ..write(obj.deletedAt)
      ..writeByte(35)
      ..write(obj.total)
      ..writeByte(36)
      ..write(obj.isDemiTarif)
      ..writeByte(37)
      ..write(obj.hasBagage)
      ..writeByte(38)
      ..write(obj.numeroVoyage)
      ..writeByte(39)
      ..write(obj.ligneId)
      ..writeByte(40)
      ..write(obj.dateArrivee)
      ..writeByte(41)
      ..write(obj.gareId)
      ..writeByte(42)
      ..write(obj.actif)
      ..writeByte(43)
      ..write(obj.nombreSieges)
      ..writeByte(44)
      ..write(obj.siegesDisponibles)
      ..writeByte(45)
      ..write(obj.prixMultiplier)
      ..writeByte(46)
      ..write(obj.creatorUsername)
      ..writeByte(47)
      ..write(obj.creatorEmail)
      ..writeByte(48)
      ..write(obj.creatorEmailVerifiedAt)
      ..writeByte(49)
      ..write(obj.qrCodeUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
