// lib/features/ticket/presentation/bloc/ticket_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/usecases/scan_ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/usecases/sell_ticket.dart';

abstract class TicketEvent {}

class ScanTicketEvent extends TicketEvent {
  final String qrCode;
  ScanTicketEvent(this.qrCode);
}

class SellTicketEvent extends TicketEvent {
  final Ticket ticket;
  SellTicketEvent(this.ticket);
}

abstract class TicketState {}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketScanned extends TicketState {
  final Ticket ticket;
  TicketScanned({required this.ticket});
}

class TicketSold extends TicketState {}

class TicketError extends TicketState {
  final String message;
  TicketError({required this.message});
}

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final ScanTicket scanTicket;
  final SellTicket sellTicket;

  TicketBloc({required this.scanTicket, required this.sellTicket})
    : super(TicketInitial()) {
    on<ScanTicketEvent>(_onScanTicket);
    on<SellTicketEvent>(_onSellTicket);
  }

  void _onScanTicket(ScanTicketEvent event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    final result = await scanTicket(event.qrCode);
    result.fold(
      (failure) => emit(TicketError(message: failure.message)),
      (ticket) => emit(TicketScanned(ticket: ticket)),
    );
  }

  void _onSellTicket(SellTicketEvent event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    final result = await sellTicket(event.ticket);
    result.fold(
      (failure) => emit(TicketError(message: failure.message)),
      (_) => emit(TicketSold()),
    );
  }
}
