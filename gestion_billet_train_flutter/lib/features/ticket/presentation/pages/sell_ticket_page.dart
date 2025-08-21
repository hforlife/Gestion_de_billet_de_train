import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestion_billet_train_flutter/core/constants/api_constants.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/helper_functions.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';
import 'package:gestion_billet_train_flutter/core/constants/text_strings.dart';
import 'package:gestion_billet_train_flutter/core/network/network_info.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/datasources/ticket_local_datasource.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/datasources/ticket_remote_datasource.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/setting_model.dart';
import 'package:gestion_billet_train_flutter/features/ticket/data/models/ticket_model.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/bloc/ticket_bloc.dart';
import 'package:gestion_billet_train_flutter/features/ticket/presentation/widgets/ticket_recu_datails.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
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
  double baggageWeight = 0;
  String? quantity;
  bool hasPenalty = false;
  bool hasBaguage = false;
  bool demiTarif = false;
  int nombreEnfants = 0;

  double distance = 0.0;
  double price = 0.0;

  bool isCalculating = false;
  bool showReceipt = false;
  bool loading = false;
  String baseUrl = ApiConstants.baseUrl;

  Map<String, dynamic>? soldTicket;

  List<Map<String, dynamic>> locations = [];
  List<Map<String, dynamic>> voyages = [];
  List<Map<String, dynamic>> paiement = [];
  List<Map<String, dynamic>> tarifs = [];
  List<Map<String, dynamic>> classse = [];

  SettingModel? setting;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late Box _dataBox;
  final TicketLocalDataSource _localDataSource =
      GetIt.instance<TicketLocalDataSource>();
  final TicketRemoteDataSource _remoteDataSource =
      GetIt.instance<TicketRemoteDataSource>();
  final TicketBloc _ticketBloc = GetIt.instance<TicketBloc>();
  final NetworkInfo _networkInfo = GetIt.instance<NetworkInfo>();
  final http.Client _httpClient = http.Client();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }

  Future<void> _init() async {
    await _openHiveBox();
    await fetchInitialData();
  }

  Future<void> _openHiveBox() async {
    _dataBox = await Hive.openBox('initialData');
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'bearer_token');
  }

  Future<void> fetchInitialData() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final token = await getToken();
      if (token == null) throw Exception('Token non trouvé');

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      if (await _networkInfo.isConnected) {
        final responseSettings = await _httpClient.get(
          Uri.parse('$baseUrl/v1/setting'),
          headers: headers,
        );

        if (!mounted) return;

        if (responseSettings.statusCode == 200) {
          final responseBody =
              jsonDecode(responseSettings.body) as Map<String, dynamic>;
          print('API Response (Settings): $responseBody');
          if (responseBody['status'] == true) {
            final settingRaw = responseBody['setting'];
            final SettingModel? newSetting = settingRaw != null
                ? SettingModel.fromJson(Map<String, dynamic>.from(settingRaw))
                : SettingModel(
                    modeVente: "par_kilometrage",
                    tarifKilometrique: 20.32,
                    tarifMinimum: 3050.0,
                    bagage_kg: 500.0,
                    penalite: 5.0,
                  );
            print('New Setting: $newSetting');
            await _dataBox.put('setting', newSetting?.toJson());
            if (!mounted) return;
            setState(() => setting = newSetting);
          } else {
            await _dataBox.put(
              'setting',
              SettingModel(
                modeVente: "par_kilometrage",
                tarifKilometrique: 20.32,
                tarifMinimum: 3050.0,
                bagage_kg: 500.0,
                penalite: 5.0,
              ).toJson(),
            );
            if (!mounted) return;
            setState(
              () => setting = SettingModel(
                modeVente: "par_kilometrage",
                tarifKilometrique: 20.32,
                tarifMinimum: 3050.0,
                bagage_kg: 500.0,
                penalite: 5.0,
              ),
            );
          }
        } else {
          print(
            'Non-200 Status Code: ${responseSettings.statusCode}, Body: ${responseSettings.body}',
          );
          await _dataBox.put(
            'setting',
            SettingModel(
              modeVente: "par_kilometrage",
              tarifKilometrique: 20.32,
              tarifMinimum: 3050.0,
              bagage_kg: 500.0,
              penalite: 5.0,
            ).toJson(),
          );
          if (!mounted) return;
          setState(
            () => setting = SettingModel(
              modeVente: "par_kilometrage",
              tarifKilometrique: 20.32,
              tarifMinimum: 3050.0,
              bagage_kg: 500.0,
              penalite: 5.0,
            ),
          );
        }

        final responseVoyages = await _httpClient.get(
          Uri.parse('$baseUrl/v1/voyages'),
          headers: headers,
        );
        if (responseVoyages.statusCode == 200) {
          final jsonData = jsonDecode(responseVoyages.body);
          if (jsonData['status'] == true && jsonData['voyages'] != null) {
            voyages = (jsonData['voyages'] as List)
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
            await _dataBox.put('voyages', voyages);
          }
        }

        final responseLocations = await _httpClient.get(
          Uri.parse('$baseUrl/v1/gares'),
          headers: headers,
        );
        if (responseLocations.statusCode == 200) {
          final jsonData = jsonDecode(responseLocations.body);
          if (jsonData['status'] == true && jsonData['gares'] != null) {
            locations = (jsonData['gares'] as List)
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
            await _dataBox.put('locations', locations);
          }
        }

        final responseTarifs = await _httpClient.get(
          Uri.parse('$baseUrl/v1/tarifGare'),
          headers: headers,
        );
        if (responseTarifs.statusCode == 200) {
          final jsonData = jsonDecode(responseTarifs.body);
          if (jsonData['status'] == true && jsonData['tarifs'] != null) {
            tarifs = (jsonData['tarifs'] as List)
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
            await _dataBox.put('tarifs', tarifs);
          }
        }

        final responsePaiement = await _httpClient.get(
          Uri.parse('$baseUrl/v1/paiements'),
          headers: headers,
        );
        if (responsePaiement.statusCode == 200) {
          final jsonData = jsonDecode(responsePaiement.body);
          if (jsonData['paiements'] != null) {
            paiement = (jsonData['paiements'] as List)
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
            await _dataBox.put('paiement', paiement);
          }
        }

        final responseClasse = await _httpClient.get(
          Uri.parse('$baseUrl/v1/classes'),
          headers: headers,
        );
        if (responseClasse.statusCode == 200) {
          final jsonData = jsonDecode(responseClasse.body);
          if (jsonData['classes'] != null) {
            classse = (jsonData['classes'] as List)
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
            await _dataBox.put('classse', classse);
          }
        }

        await syncTickets();
      } else {
        final storedSetting = _dataBox.get('setting');
        if (!mounted) return;
        setState(() {
          setting = storedSetting != null
              ? SettingModel.fromJson(Map<String, dynamic>.from(storedSetting))
              : SettingModel(
                  modeVente: "par_kilometrage",
                  tarifKilometrique: 20.32,
                  tarifMinimum: 3050.0,
                  bagage_kg: 500.0,
                  penalite: 5.0,
                );
        });

        voyages =
            (_dataBox.get('voyages') as List?)
                ?.map((item) => Map<String, dynamic>.from(item))
                .toList() ??
            [];
        locations =
            (_dataBox.get('locations') as List?)
                ?.map((item) => Map<String, dynamic>.from(item))
                .toList() ??
            [];
        tarifs =
            (_dataBox.get('tarifs') as List?)
                ?.map((item) => Map<String, dynamic>.from(item))
                .toList() ??
            [];
        paiement =
            (_dataBox.get('paiement') as List?)
                ?.map((item) => Map<String, dynamic>.from(item))
                .toList() ??
            [];
        classse =
            (_dataBox.get('classse') as List?)
                ?.map((item) => Map<String, dynamic>.from(item))
                .toList() ??
            [];
      }
      print(
        'Data loaded: Voyages: ${voyages.length}, Locations: ${locations.length}, Tarifs: ${tarifs.length}, Paiement: ${paiement.length}, Classse: ${classse.length}',
      );
    } catch (e) {
      print('Erreur fetch data: $e');
      final storedSetting = _dataBox.get('setting');
      if (!mounted) return;
      setState(() {
        setting = storedSetting != null
            ? SettingModel.fromJson(Map<String, dynamic>.from(storedSetting))
            : SettingModel(
                modeVente: "par_kilometrage",
                tarifKilometrique: 20.32,
                tarifMinimum: 3050.0,
                bagage_kg: 500.0,
                penalite: 5.0,
              );
      });
      voyages =
          (_dataBox.get('voyages') as List?)
              ?.map((item) => Map<String, dynamic>.from(item))
              .toList() ??
          [];
      locations =
          (_dataBox.get('locations') as List?)
              ?.map((item) => Map<String, dynamic>.from(item))
              .toList() ??
          [];
      tarifs =
          (_dataBox.get('tarifs') as List?)
              ?.map((item) => Map<String, dynamic>.from(item))
              .toList() ??
          [];
      paiement =
          (_dataBox.get('paiement') as List?)
              ?.map((item) => Map<String, dynamic>.from(item))
              .toList() ??
          [];
      classse =
          (_dataBox.get('classse') as List?)
              ?.map((item) => Map<String, dynamic>.from(item))
              .toList() ??
          [];
      print(
        'Data loaded (offline): Voyages: ${voyages.length}, Locations: ${locations.length}, Tarifs: ${tarifs.length}, Paiement: ${paiement.length}, Classse: ${classse.length}',
      );
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  double calculateDistanceFromGares(String? departureId, String? arrivalId) {
    if (departureId == null || arrivalId == null || locations.isEmpty) {
      print('Invalid departureId, arrivalId, or empty locations');
      return 0.0;
    }
    final depart = locations.firstWhere(
      (loc) => loc['id'].toString() == departureId,
      orElse: () => {'distance_km': '0'},
    );
    final arrivee = locations.firstWhere(
      (loc) => loc['id'].toString() == arrivalId,
      orElse: () => {'distance_km': '0'},
    );
    final double distDepart =
        double.tryParse(depart['distance_km']?.toString() ?? '0') ?? 0;
    final double distArrivee =
        double.tryParse(arrivee['distance_km']?.toString() ?? '0') ?? 0;
    final dist = (distDepart - distArrivee).abs();
    print(
      'Calculated distance: $dist km, depart: $distDepart, arrivee: $distArrivee',
    );
    return dist;
  }

  double calculatePrice() {
    double basePrice = 0.0;
    double qty = double.tryParse(quantity ?? '1') ?? 1.0;
    double baggageCost = 0.0;
    int childTickets = demiTarif ? nombreEnfants : 0;
    double adultTickets = qty - childTickets;

    print(
      'Calculating price: modeVente=${setting?.modeVente}, voyageId=$voyageId, classeId=$classeId, departureId=$departureId, arrivalId=$arrivalId, quantity=$qty, hasPenalty=$hasPenalty, hasBaguage=$hasBaguage, baggageWeight=$baggageWeight, demiTarif=$demiTarif, nombreEnfants=$childTickets, adultTickets=$adultTickets',
    );

    if (setting == null) {
      print('Error: setting is null');
      return 0.0;
    }

    if (setting!.modeVente == "par_voyage") {
      if (voyageId != null && classeId != null && tarifs.isNotEmpty) {
        try {
          final now = DateTime.now();
          final selectedTarif = tarifs.firstWhere((tarif) {
            final dateEffet =
                DateTime.tryParse(tarif['date_effet']?.toString() ?? '') ??
                DateTime(1970);
            final dateExpiration =
                DateTime.tryParse(tarif['date_expiration']?.toString() ?? '') ??
                DateTime(9999);
            return tarif['voyage_id'].toString() == voyageId &&
                tarif['classe_wagon_id'].toString() == classeId &&
                dateEffet.isBefore(now) &&
                dateExpiration.isAfter(now);
          }, orElse: () => {'prix': '0.0'});
          basePrice =
              double.tryParse(selectedTarif['prix']?.toString() ?? '0.0') ??
              0.0;
          print(
            'par_voyage: Selected tarif=$selectedTarif, basePrice=$basePrice',
          );
        } catch (e) {
          print('Error in par_voyage tariff lookup: $e');
        }
      } else {
        print('par_voyage: Missing voyageId, classeId, or tariffs empty');
      }
    } else if (setting!.modeVente == "par_kilometrage") {
      if (departureId != null &&
          arrivalId != null &&
          classeId != null &&
          classse.isNotEmpty) {
        try {
          final double tarifKm = setting!.tarifKilometrique ?? 20.32;
          final double tarifMin = setting!.tarifMinimum ?? 3050.0;
          final selectedClass = classse.firstWhere(
            (clas) => clas['id'].toString() == classeId,
            orElse: () => {'prix_multiplier': '1.0'},
          );
          final prixMultiplier =
              double.tryParse(
                selectedClass['prix_multiplier']?.toString() ?? '1.0',
              ) ??
              1.0;
          distance = calculateDistanceFromGares(departureId, arrivalId);
          basePrice = distance * tarifKm * prixMultiplier;
          if (basePrice < tarifMin) basePrice = tarifMin;
          print(
            'par_kilometrage: distance=$distance, tarifKm=$tarifKm, prixMultiplier=$prixMultiplier, tarifMin=$tarifMin, basePrice=$basePrice',
          );
        } catch (e) {
          print('Error in par_kilometrage calculation: $e');
        }
      } else {
        print(
          'par_kilometrage: Missing data (departureId=$departureId, arrivalId=$arrivalId, classeId=$classeId, classse=${classse.length})',
        );
      }
    } else {
      print('Unknown modeVente: ${setting!.modeVente}');
    }

    if (hasPenalty && (setting!.penalite != null)) {
      basePrice *= (1 + (setting!.penalite! / 100));
      print('Applied penalty: ${setting!.penalite}% basePrice=$basePrice');
    }

    if (hasBaguage && baggageWeight > 10 && setting!.baguageTarif != null) {
      baggageCost = (baggageWeight - 10) * setting!.baguageTarif!;
      print(
        'Baggage cost: $baggageCost, baguageTarif=${setting!.baguageTarif}',
      );
    }

    final double childPrice = demiTarif ? basePrice * 0.5 : basePrice;
    final finalPrice =
        (adultTickets * basePrice) + (childTickets * childPrice) + baggageCost;
    print(
      'Final price: $finalPrice, adultTickets=$adultTickets, childTickets=$childTickets, baggageCost=$baggageCost',
    );
    return finalPrice;
  }

  void handleSellTicket() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs requis'),
        ),
      );
      return;
    }

    setState(() => isCalculating = true);
    try {
      final calculatedDistance = (departureId != null && arrivalId != null)
          ? calculateDistanceFromGares(departureId, arrivalId)
          : 0.0;
      final calculatedPrice = calculatePrice();

      final postData = {
        'voyage_id': voyageId,
        'client_nom': clientName,
        'mode_paiement_id': paymentId,
        'classe_wagon_id': classeId,
        'quantite': quantity,
        'demi_tarif': demiTarif && nombreEnfants > 0 ? '1' : '0',
        'nombre_enfants': nombreEnfants.toString(),
        'prix': calculatedPrice.toStringAsFixed(2),
        'bagage': hasBaguage ? '1' : '0',
        if (hasBaguage) 'poids_bagage': baggageWeight.toStringAsFixed(2),
        'statut': 'payé',
        'quantite_demi_tarif': nombreEnfants,
        'penalite': hasPenalty,
      };

      print('Starting sell for ticket: $postData');

      final ticket = TicketModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        departure: setting!.modeVente == "par_voyage" && voyageId != null
            ? locations.firstWhere(
                    (loc) =>
                        loc['id'].toString() ==
                        voyages
                            .firstWhere(
                              (voy) => voy['id'].toString() == voyageId,
                              orElse: () => {'gare_depart_id': ''},
                            )['gare_depart_id']
                            .toString(),
                    orElse: () => {'nom': ''},
                  )['nom'] ??
                  ''
            : (departureId != null
                  ? locations.firstWhere(
                          (loc) => loc['id'].toString() == departureId,
                          orElse: () => {'nom': ''},
                        )['nom'] ??
                        ''
                  : ''),
        destination: setting!.modeVente == "par_voyage" && voyageId != null
            ? locations.firstWhere(
                    (loc) =>
                        loc['id'].toString() ==
                        voyages
                            .firstWhere(
                              (voy) => voy['id'].toString() == voyageId,
                              orElse: () => {'gare_arrivee_id': ''},
                            )['gare_arrivee_id']
                            .toString(),
                    orElse: () => {'nom': ''},
                  )['nom'] ??
                  ''
            : (arrivalId != null
                  ? locations.firstWhere(
                          (loc) => loc['id'].toString() == arrivalId,
                          orElse: () => {'nom': ''},
                        )['nom'] ??
                        ''
                  : ''),
        price: calculatedPrice,
        quantite_demi_tarif: nombreEnfants,
        isValidated: false,
        hasPenalty: hasPenalty,
        createdAt: DateTime.now(),
        trainNumber: voyageId != null
            ? voyages.firstWhere(
                    (voy) => voy['id'].toString() == voyageId,
                    orElse: () => {'trainNumber': 'T123'},
                  )['trainNumber'] ??
                  'T123'
            : 'T123',
        penalite: hasPenalty,
        classType: classeId != null
            ? classse.firstWhere(
                    (clas) => clas['id'].toString() == classeId,
                    orElse: () => {'classe': ''},
                  )['classe'] ??
                  ''
            : '',
        classeWagonId: int.tryParse(classeId ?? ''),
        wagon: 'A',
        seatNumber: seatNumber,
        travelDate: DateTime.now(),
        isSynced: false,
        clientName: clientName,
        quantity: int.tryParse(quantity ?? '1') ?? 1,
        baggageWeight: hasBaguage ? baggageWeight : 0.0,
        hasBagage: hasBaguage,
        isDemiTarif: demiTarif && nombreEnfants > 0,
        modePaiementId: int.tryParse(paymentId ?? ''),
        statut: 'payé',
        voyageId: voyageId,
      );

      setState(() {
        distance = calculatedDistance;
        price = calculatedPrice;
        soldTicket = {
          'departure': ticket.departure,
          'arrival': ticket.destination,
          'voyage': voyageId != null
              ? voyages.firstWhere(
                      (voy) => voy['id'].toString() == voyageId,
                      orElse: () => {'nom': ''},
                    )['nom'] ??
                    ''
              : '',
          'paiement': paymentId != null
              ? paiement.firstWhere(
                      (pay) => pay['id'].toString() == paymentId,
                      orElse: () => {'type': ''},
                    )['type'] ??
                    ''
              : '',
          'classse': ticket.classType,
          'distance': distance,
          'price': price,
          'hasPenalty': hasPenalty,
          'demiTarif': demiTarif && nombreEnfants > 0,
          'nombreEnfants': nombreEnfants,
          'trainNumber': ticket.trainNumber,
          'wagon': ticket.wagon,
          'seat': ticket.seatNumber,
          'qrCode': ticket.reference ?? 'Pending',
          'qrcodeUrl': ticket.qrcodeUrl,
          'clientName': ticket.clientName,
          'quantity': ticket.quantity.toString(),
          'baggageWeight': ticket.baggageWeight,
          'hasBagage': ticket.hasBagage,
          'statut': ticket.statut,
          'saleDate':
              ticket.createdAt.toIso8601String() ??
              DateTime.now().toIso8601String(),
        };
      });

      bool isConnected = await _networkInfo.isConnected;
      if (isConnected) {
        try {
          final updatedTicket = await _remoteDataSource.saveTicket(ticket);
          setState(() {
            showReceipt = true;
            isCalculating = false;
            soldTicket = {
              ...soldTicket!,
              'qrCode': updatedTicket.reference,
              'qrcodeUrl': updatedTicket.qrcodeUrl,
              'seat': updatedTicket.seatNumber ?? ticket.seatNumber,
              'price': updatedTicket.price,
              'quantity': updatedTicket.quantity.toString(),
              'hasBagage': updatedTicket.hasBagage,
              'baggageWeight': updatedTicket.baggageWeight,
              'demiTarif': demiTarif && nombreEnfants > 0,
              'nombreEnfants': nombreEnfants,
              'statut': updatedTicket.statut,
              'saleDate':
                  updatedTicket.createdAt.toIso8601String() ??
                  DateTime.now().toIso8601String(),
            };
          });
        } catch (e, stackTrace) {
          print('Error saving ticket online: $e');
          print('Stack trace: $stackTrace');
          await _localDataSource.saveTicket(ticket);
          _ticketBloc.add(SellTicketEvent(ticket.toEntity()));
          setState(() {
            showReceipt = true;
            isCalculating = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Billet enregistré localement en raison d\'une erreur réseau: $e',
              ),
            ),
          );
        }
      } else {
        await _localDataSource.saveTicket(ticket);
        _ticketBloc.add(SellTicketEvent(ticket.toEntity()));
        setState(() {
          showReceipt = true;
          isCalculating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Billet enregistré localement, synchronisation en attente',
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Error in handleSellTicket: $e');
      print('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la vente du billet: $e')),
      );
      setState(() => isCalculating = false);
    }
  }

  Future<void> syncTickets() async {
    if (!await _networkInfo.isConnected) {
      print('No network connection, skipping sync');
      return;
    }

    final unsyncedTickets = await _localDataSource.getUnsyncedTickets();
    if (unsyncedTickets.isEmpty) {
      print('No unsynced tickets to sync');
      return;
    }

    for (final ticket in unsyncedTickets) {
      try {
        final updatedTicket = await _remoteDataSource.saveTicket(ticket);
        await _localDataSource.saveTicket(updatedTicket);
        await _localDataSource.markAsSynced(ticket.id);
        print('Ticket ${ticket.id} synced successfully');
      } catch (e) {
        print('Sync failed for ticket ${ticket.id}: $e');
      }
    }

    if (unsyncedTickets.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Synchronisation des billets terminée')),
      );
    }
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
      demiTarif = false;
      nombreEnfants = 0;
      distance = 0.0;
      price = 0.0;
    });
  }

  bool get isFormValid =>
      clientName != null &&
      clientName!.isNotEmpty &&
      paymentId != null &&
      classeId != null &&
      voyageId != null &&
      quantity != null &&
      int.tryParse(quantity!) != null &&
      int.parse(quantity!) >= 1 &&
      int.parse(quantity!) <= 10 &&
      (!demiTarif || (demiTarif && nombreEnfants <= int.parse(quantity!))) &&
      (setting?.modeVente == "par_kilometrage"
          ? (departureId != null &&
                arrivalId != null &&
                departureId != arrivalId &&
                departureId!.isNotEmpty &&
                arrivalId!.isNotEmpty)
          : true);

  bool get canShowSummary =>
      (voyageId != null && classeId != null) ||
      (setting?.modeVente == "par_kilometrage" &&
          departureId != null &&
          arrivalId != null &&
          classeId != null &&
          departureId != arrivalId);

  @override
  Widget build(BuildContext context) {
    if (showReceipt && soldTicket != null) {
      return TicketRecuDatails(
        soldTicket: soldTicket!,
        handleBackToSell: handleBackToSell,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Vente de Ticket')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
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
                        prefixIcon: const Icon(Iconsax.user),
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
                      onChanged: (value) {
                        try {
                          setState(() {
                            clientName = value;
                            price = calculatePrice();
                          });
                        } catch (e) {
                          print('Error in clientName input: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Erreur lors de la saisie du nom du client',
                              ),
                            ),
                          );
                        }
                      },
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
                      items: voyages.isNotEmpty
                          ? voyages
                                .map(
                                  (voy) => DropdownMenuItem<String>(
                                    value: voy['id'].toString(),
                                    child: Text(voy['nom'] ?? "Pas de nom"),
                                  ),
                                )
                                .toList()
                          : [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Aucun voyage disponible'),
                              ),
                            ],
                      onChanged: (value) {
                        try {
                          setState(() {
                            voyageId = value;
                            price = calculatePrice();
                          });
                        } catch (e) {
                          print('Error in voyage dropdown: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Erreur lors de la sélection du voyage',
                              ),
                            ),
                          );
                        }
                      },
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
                        items: locations.isNotEmpty
                            ? locations
                                  .map(
                                    (loc) => DropdownMenuItem<String>(
                                      value: loc['id'].toString(),
                                      child: Text(
                                        loc['nom'] ?? 'Gare sans nom',
                                      ),
                                    ),
                                  )
                                  .toList()
                            : [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Aucune gare disponible'),
                                ),
                              ],
                        onChanged: (value) {
                          try {
                            setState(() {
                              departureId = value;
                              distance = calculateDistanceFromGares(
                                departureId,
                                arrivalId,
                              );
                              price = calculatePrice();
                            });
                          } catch (e) {
                            print('Error in departure dropdown: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Erreur lors de la sélection de la gare de départ',
                                ),
                              ),
                            );
                          }
                        },
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
                        items: locations.isNotEmpty
                            ? locations
                                  .map(
                                    (loc) => DropdownMenuItem<String>(
                                      value: loc['id'].toString(),
                                      child: Text(
                                        loc['nom'] ?? 'Gare sans nom',
                                      ),
                                    ),
                                  )
                                  .toList()
                            : [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Aucune gare disponible'),
                                ),
                              ],
                        onChanged: (value) {
                          try {
                            setState(() {
                              arrivalId = value;
                              distance = calculateDistanceFromGares(
                                departureId,
                                arrivalId,
                              );
                              price = calculatePrice();
                            });
                          } catch (e) {
                            print('Error in arrival dropdown: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Erreur lors de la sélection de la gare d\'arrivée',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      if (departureId != null &&
                          arrivalId != null &&
                          departureId == arrivalId) ...[
                        SizedBox(
                          height: THelperFunctions.screenHeight() * 0.02,
                        ),
                        const Text(
                          'Les gares ne peuvent pas être identiques',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
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
                      items: classse.isNotEmpty
                          ? classse
                                .map(
                                  (clas) => DropdownMenuItem<String>(
                                    value: clas['id'].toString(),
                                    child: Text(
                                      clas['classe'] ?? "Pas de classe",
                                    ),
                                  ),
                                )
                                .toList()
                          : [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Aucune classe disponible'),
                              ),
                            ],
                      onChanged: (value) {
                        try {
                          setState(() {
                            classeId = value;
                            if (setting?.modeVente == "par_kilometrage" &&
                                departureId != null &&
                                arrivalId != null) {
                              distance = calculateDistanceFromGares(
                                departureId,
                                arrivalId,
                              );
                            }
                            price = calculatePrice();
                          });
                        } catch (e) {
                          print('Error in classe dropdown: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Erreur lors de la sélection de la classe',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.02),
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
                                onChanged: (value) {
                                  try {
                                    setState(() {
                                      quantity = value;
                                      if (demiTarif &&
                                          int.tryParse(value) != null &&
                                          nombreEnfants > int.parse(value)) {
                                        nombreEnfants = int.parse(value);
                                      }
                                      price = calculatePrice();
                                    });
                                  } catch (e) {
                                    print('Error in quantity input: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Erreur lors de la saisie de la quantité',
                                        ),
                                      ),
                                    );
                                  }
                                },
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
                                onChanged: (value) {
                                  try {
                                    setState(() => seatNumber = value);
                                  } catch (e) {
                                    print('Error in seat number input: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Erreur lors de la saisie du numéro de place',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: THelperFunctions.screenHeight() * 0.03),
                    Text(
                      'Méthode de paiement',
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
                      items: paiement.isNotEmpty
                          ? paiement
                                .map(
                                  (pay) => DropdownMenuItem<String>(
                                    value: pay['id'].toString(),
                                    child: Text(pay['type'] ?? "Pas de type"),
                                  ),
                                )
                                .toList()
                          : [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Aucune méthode disponible'),
                              ),
                            ],
                      onChanged: (value) {
                        try {
                          setState(() => paymentId = value);
                        } catch (e) {
                          print('Error in payment dropdown: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Erreur lors de la sélection de la méthode de paiement',
                              ),
                            ),
                          );
                        }
                      },
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
                            "Appliquer une pénalité (+${(setting?.penalite ?? 5.0)}%)",
                            style: GoogleFonts.roboto(
                              fontSize: TSizes.fontSizeMd,
                            ),
                          ),
                          Switch(
                            value: hasPenalty,
                            onChanged: (value) {
                              try {
                                setState(() {
                                  hasPenalty = value;
                                  price = calculatePrice();
                                });
                              } catch (e) {
                                print('Error in penalty switch: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Erreur lors de l\'application de la pénalité',
                                    ),
                                  ),
                                );
                              }
                            },
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
                              const Icon(Iconsax.bag_25),
                              Text(
                                "Bagage",
                                style: GoogleFonts.roboto(
                                  fontSize: TSizes.fontSizeMd,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: hasBaguage,
                            onChanged: (value) {
                              try {
                                setState(() {
                                  hasBaguage = value;
                                  price = calculatePrice();
                                });
                              } catch (e) {
                                print('Error in baggage switch: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Erreur lors de la sélection du bagage',
                                    ),
                                  ),
                                );
                              }
                            },
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    if (hasBaguage) ...[
                      SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                      Text(
                        'Poids des bagages (kg)',
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: TColors.primary,
                              fontSize: TSizes.md,
                            ),
                      ),
                      SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.weight),
                          labelText: 'Poids',
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
                        onChanged: (value) {
                          try {
                            final weight = double.tryParse(value) ?? 0.0;
                            if (weight > 30) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Le poids des bagages ne peut pas dépasser 30 kg',
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              baggageWeight = weight;
                              price = calculatePrice();
                            });
                          } catch (e) {
                            print('Error in baggage weight input: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Erreur lors de la saisie du poids des bagages',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
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
                          Text(
                            "Appliquer le demi-tarif (-50%)",
                            style: GoogleFonts.roboto(
                              fontSize: TSizes.fontSizeMd,
                            ),
                          ),
                          Switch(
                            value: demiTarif,
                            onChanged: (value) {
                              try {
                                setState(() {
                                  demiTarif = value;
                                  if (!demiTarif) nombreEnfants = 0;
                                  price = calculatePrice();
                                });
                              } catch (e) {
                                print('Error in demi-tarif switch: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Erreur lors de l\'application du demi-tarif',
                                    ),
                                  ),
                                );
                              }
                            },
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    if (demiTarif) ...[
                      SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                      Text(
                        'Nombre d\'enfants',
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: TColors.primary,
                              fontSize: TSizes.md,
                            ),
                      ),
                      SizedBox(height: THelperFunctions.screenHeight() * 0.01),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.user),
                          labelText: 'Nombre d\'enfants',
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
                        onChanged: (value) {
                          try {
                            final enfants = int.tryParse(value) ?? 0;
                            final qty = int.tryParse(quantity ?? '1') ?? 1;
                            if (enfants > qty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Le nombre d\'enfants ne peut pas dépasser la quantité de billets',
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              nombreEnfants = enfants;
                              price = calculatePrice();
                            });
                          } catch (e) {
                            print('Error in nombre enfants input: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Erreur lors de la saisie du nombre d\'enfants',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                    SizedBox(height: THelperFunctions.screenHeight() * 0.02),
                    if (canShowSummary) ...[
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
                                  const CircularProgressIndicator()
                                else ...[
                                  if (setting!.modeVente == "par_kilometrage" &&
                                      distance > 0) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Distance',
                                          style: TextStyle(fontSize: TSizes.md),
                                        ),
                                        Text(
                                          '${distance.toStringAsFixed(1)} km',
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
                                          THelperFunctions.screenHeight() *
                                          0.01,
                                    ),
                                  ],
                                  if (hasPenalty) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Pénalité',
                                          style: TextStyle(fontSize: TSizes.md),
                                        ),
                                        Text(
                                          '+${(setting?.penalite ?? 5.0)}%',
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
                                          THelperFunctions.screenHeight() *
                                          0.01,
                                    ),
                                  ],
                                  if (hasBaguage && baggageWeight > 10) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Frais de bagage',
                                          style: TextStyle(fontSize: TSizes.md),
                                        ),
                                        Text(
                                          '${((baggageWeight - 10) * (setting!.baguageTarif ?? 500.0)).toStringAsFixed(2)} FCFA',
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
                                          THelperFunctions.screenHeight() *
                                          0.01,
                                    ),
                                  ],
                                  if (demiTarif && nombreEnfants > 0) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Billets enfants (demi-tarif)',
                                          style: TextStyle(fontSize: TSizes.md),
                                        ),
                                        Text(
                                          '$nombreEnfants (-50%)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                color: TColors.black,
                                                fontSize: TSizes.md * 1.1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          THelperFunctions.screenHeight() *
                                          0.01,
                                    ),
                                  ],
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Prix total',
                                        style: TextStyle(fontSize: TSizes.md),
                                      ),
                                      Text(
                                        '${price.toStringAsFixed(2)} FCFA',
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
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: THelperFunctions.screenHeight() * 0.03),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isFormValid && !isCalculating
                            ? handleSellTicket
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          foregroundColor: TColors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: TSizes.lg * 1.2,
                            horizontal: TSizes.defaultSpace,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: GoogleFonts.roboto(
                            fontSize: TSizes.fontSizeMd,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Vendre le billet'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
