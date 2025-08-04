import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;

  const Failure({this.message = "Une erreur s'est produite"});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = "Erreur serveur"});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = "Pas trouver"});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = "Erreur de cache"});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = "Aucune connexion internet"});
}
