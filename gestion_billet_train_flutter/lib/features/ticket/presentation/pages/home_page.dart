import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/features/auth/domain/repositories/auth_repository.dart'; // Ajouté pour utiliser Either
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_event.dart';
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
  String? userName;
  String? userRole; // Pour stocker le rôle ou un indicateur (ex. "controller")

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final authRepository = context
          .read<AuthRepository>(); // Utilisation de AuthRepository via BLoC
      final result = await authRepository.getUser();
      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              userName = 'Erreur de chargement';
              userRole = null;
            });
          }
        },
        (userData) {
          if (mounted) {
            setState(() {
              userName = userData['name'] as String? ?? 'Utilisateur';
              userRole =
                  userData['role'] as String? ??
                  'controller'; // Ajustez selon l'API
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          userName = 'Erreur de chargement';
          userRole = null;
        });
      }
    }
  }

  Future<void> _logout() async {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(LogoutEvent()); // Utiliser BLoC pour la déconnexion
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: THelperFunctions.screenHeight() * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(Iconsax.user, color: TColors.primary),
                  SizedBox(width: THelperFunctions.screenWidth() * 0.02),
                  Text(
                    userName ?? 'Chargement...',
                    style: TextStyle(color: TColors.primary),
                  ),
                  if (userRole != null) Text(' ($userRole)'),
                ],
              ),
              GestureDetector(
                onTap: _logout,
                child: Container(
                  width: THelperFunctions.screenWidth() * 0.1,
                  height: THelperFunctions.screenWidth() * 0.1,
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
                      backgroundColor: TColors.buttonPrimary.withAlpha(220),
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
                            fontSize: THelperFunctions.screenWidth() * 0.05,
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
                            fontSize: THelperFunctions.screenWidth() * 0.05,
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
    );
  }
}
