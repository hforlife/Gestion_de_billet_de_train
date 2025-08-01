import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/widgets/custom_button.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_bloc.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_state.dart'
    as ticket_state;
import 'package:gestion_billet_train_flutter/features/ticket/presentation/widgets/ticket_info_card.dart';

class TicketDetailsPage extends StatelessWidget {
  const TicketDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails du billet')),
      body: BlocConsumer<TicketBloc, ticket_state.TicketState>(
        listener: (context, state) {
          if (state is ticket_state.TicketError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ticket_state.TicketScanned) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TicketInfoCard(ticket: state.ticket),
                  const Spacer(),
                  CustomButton(
                    text: 'Retour',
                    color: AppColors.secondary,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
