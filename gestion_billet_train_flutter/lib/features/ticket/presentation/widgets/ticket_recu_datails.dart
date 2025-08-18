import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketRecuDatails extends StatelessWidget {
  final Map<String, dynamic> soldTicket;
  final VoidCallback handleBackToSell;

  const TicketRecuDatails({
    super.key,
    required this.soldTicket,
    required this.handleBackToSell,
  });

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString; // Fallback to original string if parsing fails
    }
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
                              height: THelperFunctions.screenWidth() * 0.09,
                              width: THelperFunctions.screenWidth() * 0.15,
                              decoration: BoxDecoration(
                                color: TColors.secondary.withAlpha(200),
                                borderRadius: BorderRadius.circular(
                                  THelperFunctions.screenWidth() * 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  soldTicket['statut']?.toString() ?? "Vendu",
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
                          height: THelperFunctions.screenHeight() * 0.27,
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
                                        width:
                                            THelperFunctions.screenWidth() *
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
                                            soldTicket['departure'] ?? 'N/A',
                                            style: TextStyle(
                                              fontSize: TSizes.md * 1.2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 0.5,
                                    height:
                                        THelperFunctions.screenHeight() * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.location,
                                        color: TColors.secondary,
                                      ),
                                      SizedBox(
                                        width:
                                            THelperFunctions.screenWidth() *
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
                                            soldTicket['arrival'] ?? 'N/A',
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
                                  '${(double.tryParse(soldTicket['price']?.toString() ?? '0.0') ?? 0.0 * (int.tryParse(soldTicket['quantity'] ?? '1') ?? 1)).toStringAsFixed(2)} FCFA',
                                  style: TextStyle(
                                    fontSize: TSizes.md * 1.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (soldTicket['qrCode'] != null)
                          Center(
                            child: QrImageView(
                              data: soldTicket['qrCode'],
                              version: QrVersions.auto,
                              size: THelperFunctions.screenWidth() * 0.5,
                            ),
                          )
                        else
                          const Center(child: Text('QR Code non disponible')),
                        ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Détails supplémentaires',
                                style: TextStyle(fontSize: TSizes.md * 1.1),
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
                                  soldTicket['clientName'] ?? 'N/A',
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
                                  'Prix unitaire',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  '${(double.tryParse(soldTicket['price']?.toString() ?? '0.0') ?? 0.0).toStringAsFixed(2)} FCFA',
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
                            if (soldTicket['voyage']?.isNotEmpty ?? false) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            ],
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
                                    '${(soldTicket['distance'] as num).toStringAsFixed(1)} km',
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
                                  'Référence',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  soldTicket['qrCode'] ?? 'N/A',
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
                                  'Date vente',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  formatDate(
                                    soldTicket['saleDate'] ??
                                        DateTime.now().toIso8601String(),
                                  ),
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
                                  soldTicket['quantity']?.toString() ?? '1',
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
                            if (soldTicket['hasPenalty'] == true) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pénalité',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    '+20%',
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
                            ],
                            if (soldTicket['isDemiTarif'] == true) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Demi-tarif',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    '-50%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: TColors.success,
                                          fontSize: TSizes.md,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                            if (soldTicket['hasBagage'] == true &&
                                (soldTicket['baggageWeight'] ?? 0) > 0) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Poids des bagages',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    '${(soldTicket['baggageWeight'] as num).toStringAsFixed(1)} kg',
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
                            if (soldTicket['classse']?.isNotEmpty ?? false) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Classe',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    soldTicket['classse'],
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
                            if (soldTicket['seat']?.isNotEmpty ?? false) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Place',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    soldTicket['seat'],
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
                            if (soldTicket['trainNumber']?.isNotEmpty ??
                                false) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Numéro de train',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    soldTicket['trainNumber'],
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
                            if (soldTicket['wagon']?.isNotEmpty ?? false) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Wagon',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    soldTicket['wagon'],
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
                            if (soldTicket['paiement']?.isNotEmpty ??
                                false) ...[
                              SizedBox(
                                height: THelperFunctions.screenHeight() * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Méthode de paiement',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    soldTicket['paiement'],
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
                          style: TextStyle(fontSize: TSizes.md * 1.1),
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
                        THelperFunctions.screenWidth() * 0.3,
                        THelperFunctions.screenHeight() * 0.08,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Nouvelle Vente',
                      style: TextStyle(fontSize: TSizes.md * 1.1),
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
