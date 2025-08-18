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
  String filterType = 'Jour'; // Default filter: Day
  Future<Map<String, dynamic>>? _reportData;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _reportData = fetchReportData(selectedDate, filterType);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'bearer_token');
  }

  Future<Map<String, dynamic>> fetchReportData(
    DateTime date,
    String filterType,
  ) async {
    String apiUrl = '$baseUrl/v1/venteByUser';
    final token = await getToken();

    List<dynamic> allSales = [];
    String? nextUrl = apiUrl;

    // Fetch all pages
    while (nextUrl != null) {
      final response = await http.get(
        Uri.parse(nextUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        allSales.addAll(jsonData['data']['data']);
        nextUrl = jsonData['data']['next_page_url'];
      } else {
        throw Exception('Failed to load report data: ${response.statusCode}');
      }
    }

    // Define date range based on filterType
    DateTime startDate;
    DateTime endDate;
    if (filterType == 'Jour') {
      startDate = DateTime(date.year, date.month, date.day);
      endDate = startDate.add(const Duration(days: 1));
    } else if (filterType == 'Mois') {
      startDate = DateTime(date.year, date.month, 1);
      endDate = DateTime(date.year, date.month + 1, 1);
    } else {
      // 'Année'
      startDate = DateTime(date.year, 1, 1);
      endDate = DateTime(date.year + 1, 1, 1);
    }

    int ticketsSold = 0;
    int totalSales = 0;
    double totalRevenue = 0.0;
    int ticketsWithPenalties = 0;
    double penaltyRevenue = 0.0;
    int ticketsSoldToday = 0;

    final todayStart = DateTime.now().copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      microsecond: 0,
    );
    final todayEnd = todayStart.add(const Duration(days: 1));

    for (var sale in allSales) {
      final saleDate = DateTime.parse(sale['date_vente']);
      if (saleDate.isAfter(startDate) && saleDate.isBefore(endDate)) {
        totalSales += 1;
        ticketsSold += sale['quantite'] as int;
        totalRevenue += (sale['total'] as num).toDouble();
        if (sale['penalite'] > 0) {
          ticketsWithPenalties += sale['quantite'] as int;
          penaltyRevenue += (sale['penalite'] as num).toDouble();
        }
        if (saleDate.isAfter(todayStart) && saleDate.isBefore(todayEnd)) {
          ticketsSoldToday += sale['quantite'] as int;
        }
      }
    }

    return {
      'ticketsSold': ticketsSold,
      'totalSales': totalSales,
      'totalRevenue': totalRevenue,
      'ticketsWithPenalties': ticketsWithPenalties,
      'penaltyRevenue': penaltyRevenue,
      'ticketsSoldToday': ticketsSoldToday,
    };
  }

  Future<void> _selectDate(BuildContext context) async {
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar;
    if (filterType == 'Mois') {
      initialEntryMode = DatePickerEntryMode.calendarOnly;
    } else if (filterType == 'Année') {
      initialEntryMode = DatePickerEntryMode.calendarOnly;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
      initialEntryMode: initialEntryMode,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: TColors.primary,
              headerForegroundColor: TColors.white,
              surfaceTintColor: TColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      DateTime newSelectedDate;
      if (filterType == 'Jour') {
        newSelectedDate = picked;
      } else if (filterType == 'Mois') {
        newSelectedDate = DateTime(picked.year, picked.month, 1);
      } else {
        // 'Année'
        newSelectedDate = DateTime(picked.year, 1, 1);
      }

      if (newSelectedDate != selectedDate) {
        setState(() {
          selectedDate = newSelectedDate;
          _reportData = fetchReportData(newSelectedDate, filterType);
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    if (filterType == 'Jour') {
      final formatter = DateFormat('dd MMMM yyyy', 'fr_FR');
      return formatter.format(date);
    } else if (filterType == 'Mois') {
      final formatter = DateFormat('MMMM yyyy', 'fr_FR');
      return formatter.format(date);
    } else {
      // 'Année'
      final formatter = DateFormat('yyyy', 'fr_FR');
      return formatter.format(date);
    }
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
          DropdownButton<String>(
            value: filterType,
            items: ['Jour', 'Mois', 'Année']
                .map(
                  (type) =>
                      DropdownMenuItem<String>(value: type, child: Text(type)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  filterType = value;
                  _reportData = fetchReportData(selectedDate, value);
                });
              }
            },
          ),
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
          final totalSales = data['totalSales'] as int;
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
                        width: THelperFunctions.screenWidth() * 0.45,
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
                                    "Tickets vendus",
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
                        width: THelperFunctions.screenWidth() * 0.45,
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
                                    totalSales.toString(),
                                    style: TextStyle(
                                      fontSize: TSizes.md * 1.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Ventes Total",
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
                    height: THelperFunctions.screenHeight() * 0.15,
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
