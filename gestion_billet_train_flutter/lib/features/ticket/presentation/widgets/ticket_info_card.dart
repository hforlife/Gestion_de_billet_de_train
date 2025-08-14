import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart'; // Ajouté pour utiliser THelperFunctions
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart'; // Ajouté pour utiliser TSizes
import 'package:gestion_billet_train_flutter/features/ticket/domain/entities/ticket.dart';
import 'package:iconsax/iconsax.dart';

class TicketInfoCard extends StatelessWidget {
  final Ticket ticket;

  const TicketInfoCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(THelperFunctions.screenWidth() * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "BILLET TRANSPORT",
                    style: TextStyle(
                      fontSize: TSizes.md * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: THelperFunctions.screenWidth() * 0.08,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withAlpha(200),
                      borderRadius: BorderRadius.circular(
                        THelperFunctions.screenWidth() * 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        THelperFunctions.screenWidth() * 0.015,
                      ),
                      child: Text(
                        "Validé",
                        style: TextStyle(
                          fontSize: TSizes.md,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.015),
              SizedBox(
                height: THelperFunctions.screenHeight() * 0.24,
                width: THelperFunctions.screenWidth() * 0.9,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(
                      THelperFunctions.screenWidth() * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.cd),
                            SizedBox(
                              width: THelperFunctions.screenHeight() * 0.015,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Départ",
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  ticket.departure ?? "non trouver",
                                  style: TextStyle(
                                    fontSize: TSizes.md * 1.2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.015,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                          height: THelperFunctions.screenHeight() * 0.02,
                        ),
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.015,
                        ),
                        Row(
                          children: [
                            Icon(Iconsax.location, color: TColors.secondary),
                            SizedBox(
                              width: THelperFunctions.screenHeight() * 0.015,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Arrivée",
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  ticket.destination ?? "non trouver",
                                  style: TextStyle(
                                    fontSize: TSizes.md * 1.2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: THelperFunctions.screenHeight() * 0.08,
                width: THelperFunctions.screenWidth() * 0.9,
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Prix Total',
                        style: TextStyle(
                          fontSize: TSizes.md,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${ticket.price.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                          fontSize: TSizes.md * 1.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: THelperFunctions.screenHeight() * 0.268,
                width: THelperFunctions.screenWidth() * 0.9,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(
                      THelperFunctions.screenWidth() * 0.05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Numéro de train',
                              style: TextStyle(fontSize: TSizes.md),
                            ),
                            Text(
                              "${ticket.trainNumber}",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: TColors.black,
                                    fontSize: TSizes.md,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.025,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Classe',
                              style: TextStyle(fontSize: TSizes.md),
                            ),
                            Text(
                              "${ticket.classType}",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: TColors.black,
                                    fontSize: TSizes.md,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.025,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Wagon',
                              style: TextStyle(fontSize: TSizes.md),
                            ),
                            Text(
                              "${ticket.wagon}",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: TColors.black,
                                    fontSize: TSizes.md,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.025,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Place',
                              style: TextStyle(fontSize: TSizes.md),
                            ),
                            Text(
                              "${ticket.seatNumber}",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: TColors.black,
                                    fontSize: TSizes.md,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.025,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.025),
              ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Détails supplémentaires',
                      style: TextStyle(fontSize: TSizes.md),
                    ),
                    const Icon(Iconsax.arrow_down_1),
                  ],
                ),
                showTrailingIcon: false,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nom & Prénom',
                        style: TextStyle(fontSize: TSizes.md),
                      ),
                      Text(
                        ticket.clientName ?? "pas de nom",
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: TColors.black,
                              fontSize: TSizes.md,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: THelperFunctions.screenHeight() * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Numéro du voyage',
                        style: TextStyle(fontSize: TSizes.md),
                      ),
                      Text(
                        ticket.numeroVoyage ?? "pas de numéro",
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: TColors.black,
                              fontSize: TSizes.md,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: THelperFunctions.screenHeight() * 0.025),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date de vente',
                        style: TextStyle(fontSize: TSizes.md),
                      ),
                      Text(
                        "${ticket.createdAt}",
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: TColors.black,
                              fontSize: TSizes.sm * 1.6,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: THelperFunctions.screenHeight() * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date de voyage',
                        style: TextStyle(fontSize: TSizes.md),
                      ),
                      Text(
                        "${ticket.createdAt}",
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: TColors.black,
                              fontSize: TSizes.sm * 1.6,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: THelperFunctions.screenHeight() * 0.02),

                  SizedBox(
                    height: THelperFunctions.screenHeight() * 0.080,
                    width: THelperFunctions.screenWidth() * 0.9,
                    child: Card(
                      child: Row(
                        children: [
                          SizedBox(
                            width: THelperFunctions.screenWidth() * 0.045,
                          ),
                          Icon(Iconsax.scan_barcode),
                          SizedBox(
                            width: THelperFunctions.screenWidth() * 0.035,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                ticket.reference ?? "pas de reference",
                                style: TextStyle(fontSize: TSizes.md),
                              ),
                              Text(
                                ticket.id,
                                style: TextStyle(
                                  fontSize: TSizes.md,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
