// features/auth/domain/entities/user.dart
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': 'controller', // Ajoutez un rôle par défaut si nécessaire
  };

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}
