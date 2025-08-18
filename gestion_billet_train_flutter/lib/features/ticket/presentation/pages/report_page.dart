import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestion_billet_train_flutter/core/constants/api_constants.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String baseUrl = ApiConstants.baseUrl;
  DateTime selectedDate = DateTime.now();
  Future<Map<String, dynamic>>? _reportData;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'bearer_token');
  }

  @override
  void initState() {
    super.initState();
    _reportData = fetchReportData(selectedDate);
  }

  Future<Map<String, dynamic>> fetchReportData(DateTime date) async {
    String apiUrl = '$baseUrl/v1/venteByUser';
    // Assume AuthService provides the token; replace with your auth mechanism
    final token = await getToken();

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> sales = jsonData['data']['data'];

      // Calculate metrics
      int ticketsSold = 0;
      double totalRevenue = 0.0;
      int ticketsWithPenalties = 0;
      double penaltyRevenue = 0.0;
      int ticketsSoldToday = 0;

      final selectedDateStart = DateTime(date.year, date.month, date.day);
      final selectedDateEnd = selectedDateStart.add(const Duration(days: 1));
      final todayStart = DateTime.now();
      todayStart.copyWith(hour: 0, minute: 0, second: 0, microsecond: 0);

      for (var sale in sales) {
        final saleDate = DateTime.parse(sale['date_vente']);
        if (saleDate.isAfter(selectedDateStart) &&
            saleDate.isBefore(selectedDateEnd)) {
          ticketsSold += sale['quantite'] as int;
          totalRevenue += sale['total'] as num;
          if (sale['penalite'] > 0) {
            ticketsWithPenalties += sale['quantite'] as int;
            penaltyRevenue += sale['penalite'] as num;
          }
          // Check if sale is from today
          if (saleDate.day == todayStart.day &&
              saleDate.month == todayStart.month &&
              saleDate.year == todayStart.year) {
            ticketsSoldToday += sale['quantite'] as int;
          }
        }
      }

      // Note: Scanned tickets are not determinable from the API; assuming 0 for now
      const int scannedTickets = 0;

      return {
        'ticketsSold': ticketsSold,
        'scannedTickets': scannedTickets,
        'totalRevenue': totalRevenue,
        'ticketsWithPenalties': ticketsWithPenalties,
        'penaltyRevenue': penaltyRevenue,
        'ticketsSoldToday': ticketsSoldToday,
      };
    } else {
      throw Exception('Failed to load report data: ${response.statusCode}');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _reportData = fetchReportData(picked);
      });
    }
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'fr_FR');
    return formatter.format(date);
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'FCFA',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapport'),
        actions: [
          TextButton(
            onPressed: () => _selectDate(context),
            child: Text(
              _formatDate(selectedDate),
              style: TextStyle(color: TColors.primary, fontSize: TSizes.md),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _reportData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucune donnée disponible'));
          }

          final data = snapshot.data!;
          final ticketsSold = data['ticketsSold'] as int;
          final scannedTickets = data['scannedTickets'] as int;
          final totalRevenue = data['totalRevenue'] as double;
          final ticketsWithPenalties = data['ticketsWithPenalties'] as int;
          final penaltyRevenue = data['penaltyRevenue'] as double;
          final ticketsSoldToday = data['ticketsSoldToday'] as int;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                              SizedBox(
                                width: THelperFunctions.screenWidth() * 0.045,
                              ),
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
                              SizedBox(
                                width: THelperFunctions.screenWidth() * 0.035,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ticketsSold.toString(),
                                    style: TextStyle(
                                      fontSize: TSizes.md * 1.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Billets vendus",
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
                              SizedBox(
                                width: THelperFunctions.screenWidth() * 0.045,
                              ),
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
                              SizedBox(
                                width: THelperFunctions.screenWidth() * 0.035,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    scannedTickets.toString(),
                                    style: TextStyle(
                                      fontSize: TSizes.md * 1.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Billets scannés",
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
                                  _formatCurrency(totalRevenue),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Billets avec pénalités',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    ticketsWithPenalties.toString(),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Revenus des pénalités',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    _formatCurrency(penaltyRevenue),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Billets vendus aujourd'hui",
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    ticketsSoldToday.toString(),
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
