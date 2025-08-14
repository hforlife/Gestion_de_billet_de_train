import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class TicketRecuDatails extends StatelessWidget {
  final Map<String, dynamic> soldTicket;
  final VoidCallback handleBackToSell;

  const TicketRecuDatails({
    super.key,
    required this.soldTicket,
    required this.handleBackToSell,
  });

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.grey,
      appBar: AppBar(title: const Text('Reçu de Vente')),
      body: Padding(
        padding: EdgeInsets.all(THelperFunctions.screenWidth() * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: THelperFunctions.screenHeight() * 0.02),
              SizedBox(
                width: THelperFunctions.screenWidth() * 0.9, // Fixed width
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(
                      THelperFunctions.screenWidth() * 0.05,
                    ),
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
                                color: TColors.secondary.withAlpha(200),
                                borderRadius: BorderRadius.circular(
                                  THelperFunctions.screenWidth() * 0.5,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  THelperFunctions.screenWidth() * 0.015,
                                ),
                                child: Text(
                                  "Vendu",
                                  style: TextStyle(
                                    fontSize: TSizes.md,
                                    color: TColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.015,
                        ),
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.24,
                          width: THelperFunctions.screenWidth() * 0.8,
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
                                        width:
                                            THelperFunctions.screenHeight() *
                                            0.015,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Départ",
                                            style: TextStyle(
                                              fontSize: TSizes.md,
                                            ),
                                          ),
                                          Text(
                                            soldTicket['departure'],
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
                                    height:
                                        THelperFunctions.screenHeight() * 0.015,
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 0.5,
                                    height:
                                        THelperFunctions.screenHeight() * 0.02,
                                  ),
                                  SizedBox(
                                    height:
                                        THelperFunctions.screenHeight() * 0.015,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.location,
                                        color: TColors.secondary,
                                      ),
                                      SizedBox(
                                        width:
                                            THelperFunctions.screenHeight() *
                                            0.015,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Arrivée",
                                            style: TextStyle(
                                              fontSize: TSizes.md,
                                            ),
                                          ),
                                          Text(
                                            soldTicket['arrival'],
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
                        ),
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.08,
                          width: THelperFunctions.screenWidth() * 0.8,
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
                                  '${(soldTicket['price'] * (int.tryParse(soldTicket['quantity'] ?? '1') ?? 1)).toStringAsFixed(2)} FCFA',
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
                          height: THelperFunctions.screenHeight() * 0.025,
                        ),
                        ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Détails supplémentaires',
                                style: TextStyle(fontSize: TSizes.md),
                              ),
                              Icon(Iconsax.arrow_down_1),
                            ],
                          ),
                          showTrailingIcon: false,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Nom du client',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  soldTicket['clientName'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
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
                                  'Prix unitaire',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  '${soldTicket['price'].toStringAsFixed(2)} FCFA',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: TColors.black,
                                        fontSize: TSizes.md,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Nom de voyage',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  soldTicket['voyage'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: TColors.black,
                                        fontSize: TSizes.md,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            if (soldTicket['distance'] != null &&
                                soldTicket['distance'] > 0) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Distance',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    '${soldTicket['distance'].toStringAsFixed(1)} km',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: TColors.black,
                                          fontSize: TSizes.md,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Référence du ticket',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  soldTicket['tripNumber'],
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .copyWith(
                                        color: TColors.black,
                                        fontSize: TSizes.md,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date vente/voyage',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  formatDate(soldTicket['saleDate']),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: TColors.black,
                                        fontSize: TSizes.md,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quantité',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  soldTicket['quantity'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: TColors.black,
                                        fontSize: TSizes.md,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.02,
                            ),
                            if (soldTicket['hasPenalty'])
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pénalité',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    'Appliquer',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: TColors.error,
                                          fontSize: TSizes.md,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.02,
                            ),
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.080,
                              width: THelperFunctions.screenWidth() * 0.8,
                              child: Card(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          THelperFunctions.screenWidth() *
                                          0.045,
                                    ),
                                    Icon(Iconsax.scan_barcode),
                                    SizedBox(
                                      width:
                                          THelperFunctions.screenWidth() *
                                          0.035,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Code QR",
                                          style: TextStyle(fontSize: TSizes.md),
                                        ),
                                        Text(
                                          soldTicket['qrCode'],
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
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Impression en cours...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: TColors.buttonPrimary,
                      minimumSize: Size(
                        THelperFunctions.screenWidth() * 0.4,
                        THelperFunctions.screenHeight() * 0.08,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.printer, size: TSizes.iconMd),
                        SizedBox(width: THelperFunctions.screenWidth() * 0.015),
                        Text(
                          'Imprimer',
                          style: TextStyle(fontSize: TSizes.md * 1.2),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: handleBackToSell,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: TColors.buttonSecondary,
                      minimumSize: Size(
                        THelperFunctions.screenWidth() * 0.4,
                        THelperFunctions.screenHeight() * 0.08,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Nouvelle Vente',
                      style: TextStyle(fontSize: TSizes.md * 1.2),
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
