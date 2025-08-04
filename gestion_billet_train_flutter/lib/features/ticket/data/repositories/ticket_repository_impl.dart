// lib/features/ticket/data/repositories/ticket_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:gestion_billet_train_flutter/core/errors/exceptions.dart';
import 'package:gestion_billet_train_flutter/core/errors/failures.dart';
import 'package:gestion_billet_train_flutter/core/network/network_info.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/datasources/ticket_local_datasource.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/datasources/ticket_remote_datasource.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketLocalDataSource localDataSource;
  final TicketRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TicketRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Ticket>> getTicket(String ticketId) async {
    try {
      final localTicket = await localDataSource.getTicket(ticketId);
      return Right(localTicket!.toEntity());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveTicket(Ticket ticket) async {
    try {
      final ticketModel = TicketModel.fromEntity(ticket);
      await localDataSource.saveTicket(ticketModel);
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.saveTicket(ticketModel);
          await localDataSource.markAsSynced(ticket.id);
        } on ServerException {
          return const Right(null); // Local réussi, réseau échoué
        }
      }
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Ticket>> scanTicket(String qrCode) async {
    try {
      final localTicket = await localDataSource.scanTicket(qrCode);
      if (localTicket != null) return Right(localTicket.toEntity());
      if (await networkInfo.isConnected) {
        try {
          final remoteTicket = await remoteDataSource.scanTicket(qrCode);
          if (remoteTicket != null) {
            await localDataSource.saveTicket(remoteTicket);
            return Right(remoteTicket.toEntity());
          }
        } on ServerException {
          return Left(ServerFailure());
        }
      }
      return Left(NotFoundFailure()); // Si rien n'est trouvé
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAsSynced(String ticketId) async {
    try {
      await localDataSource.markAsSynced(ticketId);
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.markAsSynced(ticketId);
        } on ServerException {
          return const Right(null); // Local réussi, réseau échoué
        }
      }
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Ticket>>> getUnsyncedTickets() async {
    try {
      final unsyncedTickets = await localDataSource.getUnsyncedTickets();
      return Right(unsyncedTickets.map((t) => t.toEntity()).toList());
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sellTicket(Ticket ticket) async {
    try {
      final ticketModel = TicketModel.fromEntity(ticket);
      ticketModel.isValidated = true; // Marque comme vendu
      await localDataSource.saveTicket(ticketModel);
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.saveTicket(ticketModel);
          await localDataSource.markAsSynced(ticket.id);
        } on ServerException {
          return const Right(null); // Local réussi, réseau échoué
        }
      }
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
