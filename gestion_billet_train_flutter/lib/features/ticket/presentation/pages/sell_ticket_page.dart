import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/core/constants/text_strings.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/setting_model.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

class SellTicketPage extends StatefulWidget {
  const SellTicketPage({super.key});

  @override
  State<SellTicketPage> createState() => _SellTicketPageState();
}

class _SellTicketPageState extends State<SellTicketPage> {
  String? departureId;
  String? arrivalId;
  String? paymentId;
  String? classeId;
  String? voyageId;
  String? clientName;
  String? seatNumber;
  String? quantity;
  String? bearerToken;

  bool hasPenalty = false;
  bool hasBaguage = false;

  double distance = 0.0;
  double price = 0.0;

  bool isCalculating = false;
  bool showReceipt = false;
  bool loading = false;

  Map<String, dynamic>? soldTicket;

  List<Map<String, dynamic>> locations = [];
  List<Map<String, dynamic>> voyages = [];
  List<Map<String, dynamic>> paiement = [];
  List<Map<String, dynamic>> classse = [];

  SettingModel? setting;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'bearer_token');
  }

  Future<void> fetchInitialData() async {
    setState(() => loading = true);
    try {
      final token = await getToken();
      if (token == null) throw Exception('Token non trouvé');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final responses = await Future.wait([
        http.get(
          Uri.parse('http://192.168.137.221:8000/api/v1/setting'),
          headers: headers,
        ),
        http.get(
          Uri.parse('http://192.168.137.221:8000/api/v1/gares'),
          headers: headers,
        ),
        http.get(
          Uri.parse('http://192.168.137.221:8000/api/v1/voyages'),
          headers: headers,
        ),
        http.get(
          Uri.parse('http://192.168.137.221:8000/api/v1/paiements'),
          headers: headers,
        ),
        http.get(
          Uri.parse('http://192.168.137.221:8000/api/v1/classes'),
          headers: headers,
        ),
      ]);

      if (responses[0].statusCode == 200) {
        final jsonData = jsonDecode(responses[0].body);
        if (jsonData['status'] == true && jsonData['setting'] != null) {
          setState(() => setting = SettingModel.fromJson(jsonData['setting']));
        }
      }
      if (responses[1].statusCode == 200) {
        final jsonData = jsonDecode(responses[1].body);
        if (jsonData['status'] == true && jsonData['gares'] != null) {
          setState(
            () =>
                locations = List<Map<String, dynamic>>.from(jsonData['gares']),
          );
        }
      }
      if (responses[2].statusCode == 200) {
        final jsonData = jsonDecode(responses[2].body);
        if (jsonData['status'] == true && jsonData['voyages'] != null) {
          setState(
            () =>
                voyages = List<Map<String, dynamic>>.from(jsonData['voyages']),
          );
        }
      }
      if (responses[3].statusCode == 200) {
        final jsonData = jsonDecode(responses[3].body);
        if (jsonData['status'] == true && jsonData['paiements'] != null) {
          setState(
            () => paiement = List<Map<String, dynamic>>.from(
              jsonData['paiements'],
            ),
          );
        }
      }
      if (responses[4].statusCode == 200) {
        final jsonData = jsonDecode(responses[4].body);
        if (jsonData['status'] == true && jsonData['classes'] != null) {
          setState(
            () =>
                classse = List<Map<String, dynamic>>.from(jsonData['classes']),
          );
        }
      }
    } catch (e) {
      print('Erreur fetch data: $e');
    }
    setState(() => loading = false);
  }

  double calculateDistanceFromGares(String? departureId, String? arrivalId) {
    if (departureId == null || arrivalId == null) return 0.0;
    final depart = locations.firstWhere(
      (loc) => loc['id'].toString() == departureId,
      orElse: () => {},
    );
    final arrivee = locations.firstWhere(
      (loc) => loc['id'].toString() == arrivalId,
      orElse: () => {},
    );
    if (depart.isEmpty || arrivee.isEmpty) return 0.0;
    final double distDepart =
        double.tryParse(depart['distance_km']?.toString() ?? '0') ?? 0;
    final double distArrivee =
        double.tryParse(arrivee['distance_km']?.toString() ?? '0') ?? 0;
    return (distDepart - distArrivee).abs();
  }

  double calculatePrice() {
    if (setting == null || classeId == null) return 0.0;
    final double tarifKm = setting!.tarifKilometrique;
    final double tarifMin = setting!.tarifMinimum;
    final double coefClasse = setting!.coefficientsClasses[classeId!] ?? 1.0;
    double basePrice = distance * tarifKm * coefClasse;
    if (basePrice < tarifMin) basePrice = tarifMin;
    if (hasPenalty) basePrice *= 1.2;
    return basePrice;
  }

  Future<void> sellTicket() async {
    final token = await getToken();
    if (token == null) return;

    final int? qty = int.tryParse(quantity ?? '1');
    if (qty == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quantité invalide')));
      return;
    }

    final ticket = TicketModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      departure:
          locations.firstWhere(
            (loc) => loc['id'].toString() == departureId!,
          )['nom'] ??
          '',
      destination:
          locations.firstWhere(
            (loc) => loc['id'].toString() == arrivalId!,
          )['nom'] ??
          '',
      price: price * qty, // Total price based on quantity
      isValidated: false,
      hasPenalty: hasPenalty,
      createdAt: DateTime.now(),
      trainNumber:
          voyages.firstWhere(
            (voy) => voy['id'].toString() == voyageId!,
          )['trainNumber'] ??
          '',
      classType:
          classse.firstWhere(
            (clas) => clas['id'].toString() == classeId!,
          )['classe'] ??
          '',
      wagon: 'A',
      seatNumber: seatNumber,
      travelDate: DateTime.now(),
      isSynced: false,
      clientName: clientName,
      quantity: qty,
    );

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse('http://192.168.137.221:8000/api/v1/tickets'),
      headers: headers,
      body: jsonEncode(ticket.toJson()),
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      setState(
        () => soldTicket = TicketModel.fromJson(jsonData['ticket']).toJson(),
      ); // Convert to Map
    } else {
      print('Erreur vente: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la vente: ${response.body}')),
      );
    }
  }

  void handleSellTicket() {
    if (departureId == null ||
        arrivalId == null ||
        departureId == arrivalId ||
        setting == null ||
        clientName == null ||
        seatNumber == null ||
        quantity == null) {
      return;
    }

    setState(() => isCalculating = true);
    final calculatedDistance = calculateDistanceFromGares(
      departureId,
      arrivalId,
    );
    final calculatedPrice = calculatePrice();
    setState(() {
      distance = calculatedDistance;
      price = calculatedPrice;
      isCalculating = false;
      showReceipt = true;
      soldTicket = {
        'departure':
            locations.firstWhere(
              (loc) => loc['id'].toString() == departureId!,
            )['nom'] ??
            '',
        'arrival':
            locations.firstWhere(
              (loc) => loc['id'].toString() == arrivalId!,
            )['nom'] ??
            '',
        'voyage':
            voyages.firstWhere(
              (voy) => voy['id'].toString() == voyageId!,
            )['name'] ??
            '',
        'paiement':
            paiement.firstWhere(
              (pay) => pay['id'].toString() == paymentId!,
            )['name'] ??
            '',
        'classse':
            classse.firstWhere(
              (clas) => clas['id'].toString() == classeId!,
            )['classe'] ??
            '',
        'distance': distance,
        'price': price,
        'hasPenalty': hasPenalty,
        'trainNumber':
            voyages.firstWhere(
              (voy) => voy['id'].toString() == voyageId!,
            )['trainNumber'] ??
            'T123',
        'wagonClass':
            classse.firstWhere(
              (clas) => clas['id'].toString() == classeId!,
            )['type'] ??
            '1ère',
        'wagon': 'A',
        'seat': seatNumber,
        'tripNumber': 'TRP_${DateTime.now().millisecondsSinceEpoch}',
        'saleDate': DateTime.now().toIso8601String(),
        'qrCode': 'QR_${DateTime.now().millisecondsSinceEpoch}',
        'clientName': clientName,
        'quantity': quantity,
      };
    });
    sellTicket();
  }

  void handleBackToSell() {
    setState(() {
      showReceipt = false;
      soldTicket = null;
      departureId = null;
      arrivalId = null;
      paymentId = null;
      classeId = null;
      voyageId = null;
      clientName = null;
      seatNumber = null;
      quantity = null;
      hasPenalty = false;
      hasBaguage = false;
      distance = 0.0;
      price = 0.0;
    });
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  bool get isFormValid =>
      departureId != null &&
      arrivalId != null &&
      departureId != arrivalId &&
      voyageId != null &&
      classeId != null &&
      paymentId != null &&
      clientName != null &&
      seatNumber != null &&
      quantity != null &&
      setting != null;

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
                                              soldTicket!['departure'],
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
                                              soldTicket!['arrival'],
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
                                    '${(soldTicket!['price'] * int.tryParse(soldTicket!['quantity'] ?? '1')).toStringAsFixed(2)} FCFA',
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
                                    soldTicket!['clientName'],
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
                                    '${soldTicket!['price'].toStringAsFixed(2)} FCFA',
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
                                    soldTicket!['voyage'],
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
                                    'Référence du ticket',
                                    style: TextStyle(fontSize: TSizes.md),
                                  ),
                                  Text(
                                    soldTicket!['tripNumber'],
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
                                    '${soldTicket!['distance'].toStringAsFixed(1)} km',
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
                                    formatDate(soldTicket!['saleDate']),
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
                                    soldTicket!['quantity'],
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
                              if (soldTicket!['hasPenalty'])
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
                                            soldTicket!['qrCode'],
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
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(THelperFunctions.screenWidth() * 0.08),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vendre un billet',
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(
                            color: TColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.03),
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
                      onChanged: (value) => setState(() => clientName = value),
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.02),
                    Text(
                      'Voyage',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: TColors.primary,
                        fontSize: TSizes.md,
                      ),
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                    DropdownButtonFormField<String>(
                      hint: const Text('Sélectionnez un voyage'),
                      value: voyageId,
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
                      items: voyages
                          .map(
                            (voy) => DropdownMenuItem<String>(
                              value: voy['id'].toString(),
                              child: Text(voy['name'] ?? "Pas de nom"),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => voyageId = value),
                    ),
                    if (setting?.modeVente == "par_kilometrage") ...[
                      SizedBox(height: THelperFunctions.screenHeight() * 0.02),
                      Text(
                        'Gare départ',
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
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
                        items: locations
                            .map(
                              (loc) => DropdownMenuItem<String>(
                                value: loc['id'].toString(),
                                child: Text(loc['nom'] ?? 'Gare sans nom'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => departureId = value),
                      ),
                      SizedBox(height: THelperFunctions.screenHeight() * 0.02),
                      Text(
                        'Gare d\'arrivée',
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
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
                        items: locations
                            .map(
                              (loc) => DropdownMenuItem<String>(
                                value: loc['id'].toString(),
                                child: Text(loc['nom'] ?? 'Gare sans nom'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() => arrivalId = value),
                      ),
                      SizedBox(height: THelperFunctions.screenHeight() * 0.02),
                    ],
                    SizedBox(height: THelperFunctions.screenHeight() * 0.02),
                    Text(
                      'Classe',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: TColors.primary,
                        fontSize: TSizes.md,
                      ),
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                    DropdownButtonFormField<String>(
                      hint: const Text('Sélectionnez une classe'),
                      value: classeId,
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
                      items: classse
                          .map(
                            (clas) => DropdownMenuItem<String>(
                              value: clas['id'].toString(),
                              child: Text(clas['classe'] ?? "Pas de classe"),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => classeId = value),
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.02),
                    if (departureId != null &&
                        arrivalId != null &&
                        departureId == arrivalId)
                      const Text(
                        'Les gares ne peuvent pas être identiques',
                        style: TextStyle(color: Colors.red),
                      ),
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
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.01,
                            ),
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
                                onChanged: (value) =>
                                    setState(() => quantity = value),
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
                            SizedBox(
                              height: THelperFunctions.screenHeight() * 0.01,
                            ),
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
                                onChanged: (value) =>
                                    setState(() => seatNumber = value),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.03),
                    Text(
                      'Méthode de paiment',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: TColors.primary,
                        fontSize: TSizes.md,
                      ),
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                    DropdownButtonFormField<String>(
                      hint: const Text('Sélectionnez une méthode'),
                      value: paymentId,
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
                      items: paiement
                          .map(
                            (pay) => DropdownMenuItem<String>(
                              value: pay['id'].toString(),
                              child: Text(pay['type'] ?? "Pas de type"),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => paymentId = value),
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.03),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: THelperFunctions.screenWidth() * 0.02,
                        vertical: THelperFunctions.screenHeight() * 0.005,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: TColors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Appliquer une pénalité (+20%)",
                            style: GoogleFonts.roboto(
                              fontSize: TSizes.fontSizeMd,
                            ),
                          ),
                          Switch(
                            value: hasPenalty,
                            onChanged: (value) =>
                                setState(() => hasPenalty = value),
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: THelperFunctions.screenWidth() * 0.02,
                        vertical: THelperFunctions.screenHeight() * 0.005,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: TColors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: THelperFunctions.screenWidth() * 0.02,
                              ),
                              Icon(Iconsax.bag_25),
                              Text(
                                "Baguage",
                                style: GoogleFonts.roboto(
                                  fontSize: TSizes.fontSizeMd,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: hasBaguage,
                            onChanged: (value) =>
                                setState(() => hasBaguage = value),
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    if (hasBaguage) ...[
                      SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.weight),
                          labelText: TTexts.baguage,
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
                    ],
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
                                  height:
                                      THelperFunctions.screenHeight() * 0.03,
                                ),
                                if (isCalculating)
                                  const CircularProgressIndicator(),
                                if (!isCalculating) ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    height:
                                        THelperFunctions.screenHeight() * 0.01,
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
                                    height:
                                        THelperFunctions.screenHeight() * 0.01,
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
                                        "$price FCFA",
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
                                    height:
                                        THelperFunctions.screenHeight() * 0.01,
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
                                        quantity ?? '1',
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
                                    height:
                                        THelperFunctions.screenHeight() * 0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Prix Total',
                                        style: TextStyle(
                                          fontSize: TSizes.md,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${(price * (int.tryParse(quantity ?? '1') ?? 1)).toStringAsFixed(2)} FCFA',
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
                          minimumSize: Size(
                            THelperFunctions.screenWidth() * 0.4,
                            50,
                          ),
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
