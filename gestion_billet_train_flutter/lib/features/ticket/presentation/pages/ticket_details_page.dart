// lib/features/ticket/presentation/pages/ticket_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/widgets/custom_button.dart';
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_bloc.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/widgets/ticket_info_card.dart';

class TicketDetailsPage extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailsPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du billet')),
      body: BlocListener<TicketBloc, TicketState>(
        listener: (context, state) {
          if (state is TicketSold) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ticket vendu avec succès')),
            );
            Navigator.pop(context);
          } else if (state is TicketError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TicketInfoCard(ticket: ticket),
              const Spacer(),
              CustomButton(
                text: 'Vendre le ticket',
                color: AppColors.primary,
                onPressed: () {
                  context.read<TicketBloc>().add(
                    SellTicketEvent(ticket),
                  ); // Correction ici
                },
              ),
              CustomButton(
                text: 'Retour',
                color: AppColors.secondary,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
