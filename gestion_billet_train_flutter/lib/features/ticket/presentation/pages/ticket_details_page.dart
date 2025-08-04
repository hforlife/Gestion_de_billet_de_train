import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart'; // Ajouté
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart'; // Ajouté
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_bloc.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/widgets/ticket_info_card.dart';
import 'package:iconsax/iconsax.dart'; // Ajouté pour les icônes

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
          padding: EdgeInsets.all(THelperFunctions.screenWidth() * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TicketInfoCard(ticket: ticket),
                SizedBox(
                  height: THelperFunctions.screenHeight() * 0.02,
                ), // Remplace le Spacer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<TicketBloc>().add(SellTicketEvent(ticket));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: TColors.white,
                        backgroundColor: TColors.buttonPrimary,
                        minimumSize: Size(
                          THelperFunctions.screenWidth() * 0.35,
                          THelperFunctions.screenHeight() * 0.08,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.shopping_cart, size: TSizes.iconMd),
                          SizedBox(
                            width: THelperFunctions.screenWidth() * 0.015,
                          ),
                          Text(
                            'Vendre le ticket',
                            style: TextStyle(fontSize: TSizes.md * 1.2),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: TColors.white,
                        backgroundColor: TColors.buttonSecondary,
                        minimumSize: Size(
                          THelperFunctions.screenWidth() * 0.35,
                          THelperFunctions.screenHeight() * 0.08,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Retour',
                        style: TextStyle(fontSize: TSizes.md * 1.2),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: THelperFunctions.screenHeight() * 0.01,
                ), // Espacement en bas
              ],
            ),
          ),
        ),
      ),
    );
  }
}
