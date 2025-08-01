import 'package:equatable/equatable.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object> get props => [];
}

class ScanTicketEvent extends TicketEvent {
  final String qrCode;

  const ScanTicketEvent(this.qrCode);

  @override
  List<Object> get props => [qrCode];
}

class SellTicketEvent extends TicketEvent {
  final Ticket ticket;

  const SellTicketEvent(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class ValidateTicketEvent extends TicketEvent {
  final String ticketId;

  const ValidateTicketEvent(this.ticketId);

  @override
  List<Object> get props => [ticketId];
}
