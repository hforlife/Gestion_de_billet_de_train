import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simuler des données (remplacez par une logique réelle avec votre datasource)
    final double totalRevenue = 1500.50;
    final int ticketSold = 25;

    return Scaffold(
      appBar: AppBar(title: const Text('Rapport')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rapport des Ventes',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: TColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: THelperFunctions.screenHeight() * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                SizedBox(
                  height: THelperFunctions.screenHeight() * 0.09,
                  width: THelperFunctions.screenWidth() * 0.4,
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(width: THelperFunctions.screenWidth() * 0.045),
                        Container(
                          width: THelperFunctions.screenWidth() * 0.1,
                          height: THelperFunctions.screenWidth() * 0.1,
                          decoration: BoxDecoration(
                            color: TColors.primary.withAlpha(120),
                            borderRadius: BorderRadius.circular(
                              THelperFunctions.screenWidth() * 1,
                            ),
                          ),
                          child: Icon(
                            Iconsax.chart_214,
                            size: TSizes.md * 1.3,
                            color: TColors.primary,
                          ),
                        ),
                        SizedBox(width: THelperFunctions.screenWidth() * 0.035),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "1",
                              style: TextStyle(
                                fontSize: TSizes.md * 1.1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Billet vendus",
                              style: TextStyle(
                                fontSize: TSizes.sm * 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: THelperFunctions.screenHeight() * 0.09,
                  width: THelperFunctions.screenWidth() * 0.4,
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(width: THelperFunctions.screenWidth() * 0.045),
                        Container(
                          width: THelperFunctions.screenWidth() * 0.1,
                          height: THelperFunctions.screenWidth() * 0.1,
                          decoration: BoxDecoration(
                            color: TColors.primary.withAlpha(100),
                            borderRadius: BorderRadius.circular(
                              THelperFunctions.screenWidth() * 1,
                            ),
                          ),
                          child: Icon(
                            Iconsax.ticket,
                            size: TSizes.md * 1.35,
                            color: TColors.black,
                          ),
                        ),
                        SizedBox(width: THelperFunctions.screenWidth() * 0.035),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "5",
                              style: TextStyle(
                                fontSize: TSizes.md * 1.1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Billet scanner",
                              style: TextStyle(
                                fontSize: TSizes.sm * 1.4,
                                fontWeight: FontWeight.w500,
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
            SizedBox(
              height: THelperFunctions.screenHeight() * 0.09,
              child: Padding(
                padding: EdgeInsets.only(
                  left: THelperFunctions.screenWidth() * 0.04,
                  right: THelperFunctions.screenWidth() * 0.04,
                ),
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total Encaissement",
                            style: TextStyle(fontSize: TSizes.md * 1.2),
                          ),
                          Text(
                            "220,000 FCFA",
                            style: TextStyle(
                              fontSize: TSizes.md * 1.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: THelperFunctions.screenHeight() * 0.04),
            Text(
              'Détails des ventes',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: TColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: THelperFunctions.screenHeight() * 0.02),
            SizedBox(
              height: THelperFunctions.screenHeight() * 0.2,
              child: Padding(
                padding: EdgeInsets.only(
                  left: THelperFunctions.screenWidth() * 0.04,
                  right: THelperFunctions.screenWidth() * 0.04,
                ),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: THelperFunctions.screenWidth() * 0.04,
                      right: THelperFunctions.screenWidth() * 0.04,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Billet avec pénaliter',
                              style: TextStyle(fontSize: TSizes.md),
                            ),
                            Text(
                              "0",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: TColors.black,
                                    fontSize: TSizes.md,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Revenue penalités',
                              style: TextStyle(fontSize: TSizes.md),
                            ),
                            Text(
                              "10,000 FCFA",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: TColors.error,
                                    fontSize: TSizes.md,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Billet vendus aujourd'hui",
                              style: TextStyle(fontSize: TSizes.md),
                            ),
                            Text(
                              "0",
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: TColors.black,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
