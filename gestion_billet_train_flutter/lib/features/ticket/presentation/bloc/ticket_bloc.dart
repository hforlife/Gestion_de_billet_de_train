import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/usecases/scan_ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/usecases/sell_ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_event.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_state.dart';

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
      (failure) => emit(TicketError(failure.message)),
      (ticket) => emit(TicketScanned(ticket)),
    );
  }

  void _onSellTicket(SellTicketEvent event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    final result = await sellTicket(event.ticket);
    result.fold(
      (failure) => emit(TicketError(failure.message)),
      (_) => emit(TicketSold()),
    );
  }
}
