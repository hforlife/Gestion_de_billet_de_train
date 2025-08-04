import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/core/constants/text_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart'; // Ajustez selon votre projet

class SellTicketPage extends StatefulWidget {
  const SellTicketPage({super.key});

  @override
  State<SellTicketPage> createState() => _SellTicketPageState();
}

class _SellTicketPageState extends State<SellTicketPage> {
  String? departureId;
  String? arrivalId;
  bool hasPenalty = false;
  double distance = 0.0;
  double price = 0.0;
  bool isCalculating = false;
  bool showReceipt = false;
  Map<String, dynamic>? soldTicket;

  // Données simulées (remplacez par vos données réelles)
  final List<Map<String, dynamic>> locations = [
    {'id': 'loc1', 'name': 'Gare A'},
    {'id': 'loc2', 'name': 'Gare B'},
  ];

  double calculateDistance(double lat1, lon1, double lat2, lon2) {
    // Simplification : formule approximative
    const double earthRadius = 6371; // km
    final double dLat = (lat2 - lat1) * (3.14159 / 180);
    final double dLon = (lon2 - lon1) * (3.14159 / 180);
    final double a =
        dLat * dLat +
        dLon * dLon * cos(lat1 * 3.14159 / 180) * cos(lat2 * 3.14159 / 180);
    return earthRadius * 2 * asin(sqrt(a));
  }

  double calculatePrice(double distance, bool hasPenalty) {
    double basePrice = distance * 0.5; // 0.5 € par km (exemple)
    return hasPenalty ? basePrice * 1.2 : basePrice; // +20% avec pénalité
  }

  void handleSellTicket() {
    if (departureId == null || arrivalId == null || departureId == arrivalId) {
      return;
    }

    setState(() => isCalculating = true);
    final departure = locations.firstWhere((loc) => loc['id'] == departureId);
    final arrival = locations.firstWhere((loc) => loc['id'] == arrivalId);
    // Simuler des coordonnées (ajoutez-les dans locations si besoin)
    final calculatedDistance = calculateDistance(
      48.8566,
      2.3522,
      48.8584,
      2.2945,
    ); // Exemple
    final calculatedPrice = calculatePrice(calculatedDistance, hasPenalty);

    setState(() {
      distance = calculatedDistance;
      price = calculatedPrice;
      isCalculating = false;
      showReceipt = true;
      soldTicket = {
        'departure': departure['name'],
        'arrival': arrival['name'],
        'distance': distance,
        'price': price,
        'hasPenalty': hasPenalty,
        'trainNumber': 'T123', // Simulé
        'wagonClass': '1ère', // Simulé
        'wagon': 'A', // Simulé
        'seat': '1', // Simulé
        'tripNumber': 'TRP001', // Simulé
        'saleDate': DateTime.now().toIso8601String(), // Simulé
        'qrCode': 'QR_CODE_123', // Simulé
      };
    });
  }

  void handleBackToSell() {
    setState(() {
      showReceipt = false;
      soldTicket = null;
      departureId = null;
      arrivalId = null;
      hasPenalty = false;
    });
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool get isFormValid =>
      departureId != null && arrivalId != null && departureId != arrivalId;

  @override
  Widget build(BuildContext context) {
    if (showReceipt && soldTicket != null) {
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
                  width: THelperFunctions.screenWidth() * 2,
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
                                              "Gare de Bamako",
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
                                          THelperFunctions.screenHeight() *
                                          0.015,
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                      height:
                                          THelperFunctions.screenHeight() *
                                          0.02,
                                    ),
                                    SizedBox(
                                      height:
                                          THelperFunctions.screenHeight() *
                                          0.015,
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
                                              "Gare de Koulikoro",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Prix Total',
                                    style: TextStyle(
                                      fontSize: TSizes.md,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '65.000 FCFA',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Nom du client',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    "Amadou Diarra",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Prix unitaire',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    "15.000 FCFA",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Numéro du voyage',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    "TR-2024-001234",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Réference du ticket',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    "REF-2024-001234",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Distance',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    "462.2 km",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date vente/voyage',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    "30/07/2025, 18:18",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Quantité',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    "5",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pénalité',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    "Appliquer",
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
                                width: THelperFunctions.screenWidth() * 0.9,
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
                                            style: TextStyle(
                                              fontSize: TSizes.md,
                                            ),
                                          ),
                                          Text(
                                            "QT123456ABCDEF",
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
                          const SnackBar(
                            content: Text('Impression en cours...'),
                          ),
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
                          SizedBox(
                            width: THelperFunctions.screenWidth() * 0.015,
                          ),
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

    return Scaffold(
      appBar: AppBar(title: const Text('Vente de Ticket')),
      body: Padding(
        padding: EdgeInsets.all(THelperFunctions.screenWidth() * 0.08),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vendre un billet',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: TColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.04),
              Text(
                'Nom du client',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: TColors.primary,
                  fontSize: TSizes.md,
                ),
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.01),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.user),
                  labelText: TTexts.nomClient,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6B8DC8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: TColors.primary,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.03),
              Text(
                'Gare départ',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: TColors.primary,
                  fontSize: TSizes.md,
                ),
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.01),
              DropdownButtonFormField<String>(
                hint: const Text('Sélectionnez une gare'),
                value: departureId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: TColors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: TColors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
                icon: const Icon(Iconsax.arrow_down_1),
                items: locations.map((loc) {
                  return DropdownMenuItem<String>(
                    value: loc['id'],
                    child: Text(loc['name']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => departureId = value),
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.03),
              Text(
                "Gare d'arrivée",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: TColors.primary,
                  fontSize: TSizes.md,
                ),
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.01),
              DropdownButtonFormField<String>(
                hint: const Text('Sélectionnez une gare'),
                value: arrivalId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: TColors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: TColors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
                icon: const Icon(Iconsax.arrow_down_1),

                items: locations.map((loc) {
                  return DropdownMenuItem<String>(
                    value: loc['id'],
                    child: Text(loc['name']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => arrivalId = value),
              ),
              if (departureId != null &&
                  arrivalId != null &&
                  departureId == arrivalId)
                const Text(
                  'Les gares ne peuvent pas être identiques',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quantité",
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: TColors.primary,
                              fontSize: TSizes.md,
                            ),
                      ),
                      SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                      SizedBox(
                        width: THelperFunctions.screenWidth() * 0.4,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: TTexts.quantite,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF6B8DC8),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: TColors.primary,
                                width: 2.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Numéro de place",
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: TColors.primary,
                              fontSize: TSizes.md,
                            ),
                      ),
                      SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                      SizedBox(
                        width: THelperFunctions.screenWidth() * 0.4,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: TTexts.numPlace,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF6B8DC8),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: TColors.primary,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.03),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: THelperFunctions.screenWidth() * 0.02,
                  vertical: THelperFunctions.screenHeight() * 0.005,
                ), // optionnel
                decoration: BoxDecoration(
                  border: Border.all(
                    color: TColors.grey, // 💙 Couleur de la bordure
                    width: 2, // 🌟 Épaisseur de la bordure
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Appliquer une pénalité (+20%)",
                      style: GoogleFonts.roboto(fontSize: TSizes.fontSizeMd),
                    ),
                    Switch(
                      value: hasPenalty,
                      onChanged: (value) => setState(() => hasPenalty = value),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: THelperFunctions.screenHeight() * 0.02),
              if (isFormValid) ...[
                SizedBox(
                  height: THelperFunctions.screenHeight() * 0.36,
                  width: THelperFunctions.screenWidth() * 0.9,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Résumé',
                            style: TextStyle(
                              fontSize: TSizes.lg,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: THelperFunctions.screenHeight() * 0.03,
                          ),
                          if (isCalculating) const CircularProgressIndicator(),
                          if (!isCalculating) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Distance',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  "$distance km",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: TColors.black,
                                        fontSize: TSizes.md * 1.2,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.01,
                            ),
                            if (hasPenalty)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pénalité',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    "20%",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: TColors.error,
                                          fontSize: TSizes.md * 1.2,
                                        ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Prix unitaire',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  "15.000 FCFA",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: TColors.black,
                                        fontSize: TSizes.md * 1.2,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quantité',
                                  style: TextStyle(fontSize: TSizes.md),
                                ),
                                Text(
                                  "35",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: TColors.black,
                                        fontSize: TSizes.md * 1.2,
                                      ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                              height: THelperFunctions.screenHeight() * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Prix Total',
                                  style: TextStyle(
                                    fontSize: TSizes.md,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$price FCFA',
                                  style: TextStyle(
                                    fontSize: TSizes.md * 1.2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: THelperFunctions.screenHeight() * 0.02),
              SizedBox(
                height: THelperFunctions.screenHeight() * 0.07,
                width: THelperFunctions.screenWidth() * 0.9,
                child: ElevatedButton(
                  onPressed: isFormValid ? handleSellTicket : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: isFormValid
                        ? TColors.buttonSecondary
                        : TColors.buttonPrimary.withAlpha(200),
                    minimumSize: Size(THelperFunctions.screenWidth() * 0.4, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Valider la Vente',
                    style: TextStyle(fontSize: TSizes.md),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
