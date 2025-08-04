import 'package:gestion_billet_train_flutter/features/auth/domain/entities/user.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserModel extends User {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String username;
  @HiveField(4)
  final String token;
  @HiveField(5)
  final String? role; // Champ optionnel pour le rôle

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.token,
    this.role,
  }) : super(id: id, name: name, email: email);

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'username': username,
    'token': token,
    'role': role ?? 'controller', // Valeur par défaut si non spécifiée
  };

  // Méthode pour Hive
  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, username: $username, token: $token, role: $role)';
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
    return UserModel(
      id: fields[0] as int,
      name: fields[1] as String,
      email: fields[2] as String,
      username: fields[3] as String,
      token: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(5) // Nombre de champs
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
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
