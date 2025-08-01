import 'package:equatable/equatable.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketScanned extends TicketState {
  final Ticket ticket;

  const TicketScanned(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class TicketSold extends TicketState {}

class TicketValidated extends TicketState {}

class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object> get props => [message];
}
