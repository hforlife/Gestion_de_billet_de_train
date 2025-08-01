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
      departure: fields[1] as String,
      destination: fields[2] as String,
      price: fields[3] as double,
      isValidated: fields[4] as bool,
      hasPenalty: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      isSynced: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TicketModel obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.isSynced);
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
