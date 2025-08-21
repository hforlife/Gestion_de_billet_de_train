import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/core/constants/text_strings.dart';
import 'package:gestion_billet_train_flutter/di/injection_container.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:gestion_billet_train_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_bloc.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/report_page.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/scan_page.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/sell_ticket_page.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/pages/ticket_details_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? qrText;
  final TicketBloc ticketBloc = sl<TicketBloc>();
  DateTime? _lastScanTime;
  late Box<String> _scannedTicketsBox;
  static const MethodChannel _channel = MethodChannel(
    'com.sopafer.dev/datawedge',
  );

  @override
  void initState() {
    super.initState();
    _scannedTicketsBox = sl<Box<String>>();
    _channel.setMethodCallHandler(_handleScan);
    print('HomePage: Initialized, MethodChannel handler set');
  }

  Future<void> _handleScan(MethodCall call) async {
    print(
      'HomePage: Received MethodChannel call: ${call.method}, Arguments: ${call.arguments}',
    );
    if (call.method == 'onScanResult' && mounted) {
      final String? scannedCode = call.arguments as String?;
      print('HomePage: Scanned code: $scannedCode');
      if (scannedCode != null) {
        final now = DateTime.now();
        if (_lastScanTime == null ||
            now.difference(_lastScanTime!).inMilliseconds > 200) {
          print('HomePage: Processing scan: $scannedCode');
          setState(() {
            qrText = scannedCode;
            ticketBloc.add(ScanTicketEvent(scannedCode));
            _scannedTicketsBox.put(scannedCode, now.toIso8601String());
            _lastScanTime = now;
          });
        } else {
          print('HomePage: Scan ignored (debounce): $scannedCode');
        }
      } else {
        print('HomePage: No scan data received');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: ticketBloc)],
      child: BlocListener<TicketBloc, TicketState>(
        listener: (context, state) {
          print('HomePage: Bloc state: $state');
          if (state is TicketScanned) {
            print(
              'HomePage: Navigating to TicketDetailsPage for ticket: ${state.ticket}',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TicketDetailsPage(ticket: state.ticket),
              ),
            ).then((_) {
              if (mounted) {
                setState(() {
                  qrText = null;
                });
              }
            });
          } else if (state is TicketError) {
            print('HomePage: Error: ${state.message}');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            setState(() {
              qrText = null;
            });
          } else if (state is TicketLoading) {
            setState(() {
              qrText = 'Traitement en cours...';
            });
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            String? userName;
            String? userRole;

            if (authState is AuthAuthenticated) {
              userName = authState.user.name;
              userRole = 'controller';
            } else if (authState is AuthUnauthenticated ||
                authState is AuthError) {
              userName = 'Erreur de chargement';
              userRole = null;
            }

            return Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  print('HomePage: Report FAB pressed');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportPage()),
                  );
                },
                backgroundColor: TColors.white,
                icon: Icon(
                  Iconsax.chart_1,
                  size: TSizes.md,
                  color: TColors.black,
                ),
                label: Text(
                  TTexts.rapport,
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
                              print('HomePage: Logout pressed');
                              context.read<AuthBloc>().add(LogoutEvent());
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
                        TTexts.appName,
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
                        TTexts.appUnderDescription,
                        style: TextStyle(
                          color: TColors.primary,
                          fontSize: TSizes.fontSizeSm,
                        ),
                      ),
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.3),
                    if (qrText != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: THelperFunctions.screenWidth() * 0.15,
                        ),
                        child: Text(
                          qrText!,
                          style: TextStyle(
                            fontSize: TSizes.md,
                            color: TColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
                                backgroundColor: TColors.buttonPrimary
                                    .withAlpha(220),
                                minimumSize: Size(
                                  THelperFunctions.screenWidth() * 0.4,
                                  50,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                print('HomePage: Scan button pressed');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => ScanPage()),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Iconsax.scan_barcode,
                                    size: TSizes.xl,
                                    color: TColors.white,
                                  ),
                                  Text(
                                    TTexts.scanTicket,
                                    style: GoogleFonts.roboto(
                                      fontSize:
                                          THelperFunctions.screenWidth() * 0.05,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: THelperFunctions.screenWidth() * 0.05,
                          ),
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
                                print('HomePage: Sell button pressed');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SellTicketPage(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Iconsax.ticket,
                                    size: TSizes.xl,
                                    color: TColors.white,
                                  ),
                                  Text(
                                    TTexts.vendreBillet,
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
        ),
      ),
    );
  }
}
