import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/report_page.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/scan_page.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/sell_ticket_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? userName;
        String? userRole;

        if (state is AuthAuthenticated) {
          userName = state.user.name;
          userRole =
              'controller'; // Remplacez par la logique réelle si disponible
        } else if (state is AuthUnauthenticated || state is AuthError) {
          userName = 'Erreur de chargement';
          userRole = null;
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReportPage()),
              );
            },
            backgroundColor: TColors.white,
            icon: Icon(Iconsax.chart_1, size: TSizes.md, color: TColors.black),
            label: Text(
              'Rapport',
              style: GoogleFonts.roboto(
                fontSize: THelperFunctions.screenWidth() * 0.04,
                color: TColors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: THelperFunctions.screenHeight() * 0.05),
                Padding(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Iconsax.user, color: TColors.primary),
                            SizedBox(
                              width: THelperFunctions.screenWidth() * 0.02,
                            ),
                            Text(
                              userName ?? 'Chargement...',
                              style: TextStyle(color: TColors.primary),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (userRole != null) Text(' ($userRole)'),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final authBloc = context.read<AuthBloc>();
                          authBloc.add(LogoutEvent());
                        },
                        child: Container(
                          width: THelperFunctions.screenWidth() * 0.08,
                          height: THelperFunctions.screenWidth() * 0.08,
                          decoration: BoxDecoration(
                            color: TColors.error.withAlpha(25),
                            borderRadius: BorderRadius.circular(
                              THelperFunctions.screenWidth() * 0.03,
                            ),
                          ),
                          child: Icon(
                            Icons.logout,
                            size: TSizes.lg,
                            color: TColors.error.withAlpha(120),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: THelperFunctions.screenHeight() * 0.015),
                Padding(
                  padding: EdgeInsets.only(
                    left: THelperFunctions.screenWidth() * 0.085,
                  ),
                  child: Text(
                    "SOPAFER",
                    style: TextStyle(
                      color: TColors.primary,
                      fontSize: THelperFunctions.screenWidth() * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: THelperFunctions.screenWidth() * 0.085,
                  ),
                  child: Text(
                    "Scannez ou vendre des billets",
                    style: TextStyle(
                      color: TColors.primary,
                      fontSize: TSizes.fontSizeSm,
                    ),
                  ),
                ),
                SizedBox(height: THelperFunctions.screenHeight() * 0.3),
                Padding(
                  padding: EdgeInsets.only(
                    left: THelperFunctions.screenWidth() * 0.15,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: THelperFunctions.screenHeight() * 0.11,
                        width: THelperFunctions.screenWidth() * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: TColors.buttonPrimary.withAlpha(
                              220,
                            ),
                            minimumSize: Size(
                              THelperFunctions.screenWidth() * 0.4,
                              50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ScanPage()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Iconsax.scan_barcode,
                                size: TSizes.xl,
                                color: TColors.white,
                              ),
                              Text(
                                'Scanner un billet',
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      THelperFunctions.screenWidth() * 0.05,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: THelperFunctions.screenWidth() * 0.05),
                      SizedBox(
                        height: THelperFunctions.screenHeight() * 0.11,
                        width: THelperFunctions.screenWidth() * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: TColors.buttonSecondary,
                            minimumSize: Size(
                              THelperFunctions.screenWidth() * 0.4,
                              50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SellTicketPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Iconsax.ticket,
                                size: TSizes.xl,
                                color: TColors.white,
                              ),
                              Text(
                                'Vendre un billet',
                                style: GoogleFonts.roboto(
                                  fontSize:
                                      THelperFunctions.screenWidth() * 0.05,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
