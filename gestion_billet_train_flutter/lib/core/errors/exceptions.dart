abstract class Exception {
  final String message;

  Exception({this.message = "Une erreur s'est produite"});
}

class ServerException extends Exception {
  ServerException({super.message = "Erreur serveur"});
}

class CacheException extends Exception {
  CacheException({super.message = "Erreur de cache"});
}

class NetworkException extends Exception {
  NetworkException({super.message = "Aucune connexion internet"});
}
