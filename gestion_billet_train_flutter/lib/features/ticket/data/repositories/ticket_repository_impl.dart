import 'package:dartz/dartz.dart';
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
      return Right(localTicket);
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
        await remoteDataSource.saveTicket(ticketModel);
        await localDataSource.markAsSynced(ticket.id);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAsSynced(String ticketId) async {
    try {
      await localDataSource.markAsSynced(ticketId);
      if (await networkInfo.isConnected) {
        await remoteDataSource.markAsSynced(ticketId);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Ticket>>> getUnsyncedTickets() async {
    try {
      final unsyncedTickets = await localDataSource.getUnsyncedTickets();
      if (await networkInfo.isConnected) {
        final remoteUnsynced = await remoteDataSource.getUnsyncedTickets();
        if (remoteUnsynced.isNotEmpty) {
          for (var ticket in remoteUnsynced) {
            await localDataSource.saveTicket(ticket);
          }
        }
      }
      return Right(unsyncedTickets);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Ticket>> scanTicket(String qrCode) async {
    try {
      final localTicket = await localDataSource.scanTicket(qrCode);
      if (localTicket != null) return Right(localTicket);
      if (await networkInfo.isConnected) {
        final remoteTicket = await remoteDataSource.scanTicket(qrCode);
        if (remoteTicket != null) {
          await localDataSource.saveTicket(remoteTicket);
          return Right(remoteTicket);
        }
      }
      return Left(CacheFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sellTicket(Ticket ticket) async {
    try {
      final ticketModel = TicketModel.fromEntity(ticket);
      await localDataSource.saveTicket(ticketModel);
      if (await networkInfo.isConnected) {
        await remoteDataSource.saveTicket(ticketModel);
        await localDataSource.markAsSynced(ticket.id);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<void> syncTickets() async {
    if (await networkInfo.isConnected) {
      final unsyncedTickets = await localDataSource.getUnsyncedTickets();
      for (var ticket in unsyncedTickets) {
        await remoteDataSource.saveTicket(ticket);
        await localDataSource.markAsSynced(ticket.id);
      }
    }
  }
}
