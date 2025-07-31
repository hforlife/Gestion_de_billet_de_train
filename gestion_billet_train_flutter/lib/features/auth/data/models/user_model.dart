import 'package:gestion_billet_train_flutter/features/auth/domain/entities/user.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserModel extends User {
  @override
  @HiveField(0)
  final String username;
  @override
  @HiveField(1)
  final String token;

  const UserModel({required this.username, required this.token})
    : super(username: username, token: token);
}

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(username: fields[0] as String, token: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
