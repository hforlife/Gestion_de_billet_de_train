import 'package:equatable/equatable.dart';

class SettingModel extends Equatable {
  final int? id;
  final String? modeVente;
  final double? tarifKilometrique;
  final double? bagage_kg;
  final double? penalite;
  final double? tarifMinimum;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Alias for bagage_kg to match SellTicketPage usage
  double? get baguageTarif => bagage_kg;

  SettingModel({
    this.id,
    this.modeVente,
    this.tarifKilometrique,
    this.bagage_kg,
    this.penalite,
    this.tarifMinimum,
    this.createdAt,
    this.updatedAt,
  });

  factory SettingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SettingModel();

    return SettingModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      modeVente: json['mode_vente']?.toString(),
      tarifKilometrique: json['tarif_kilometrique'] != null
          ? double.tryParse(json['tarif_kilometrique'].toString())
          : null,
      tarifMinimum: json['tarif_minimum'] != null
          ? double.tryParse(json['tarif_minimum'].toString())
          : null,
      bagage_kg: json['bagage_kg'] != null
          ? double.tryParse(json['bagage_kg']?.toString() ?? '')
          : null,
      penalite: json['penalite'] != null
          ? double.tryParse(json['penalite']?.toString() ?? '')
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode_vente': modeVente,
      'tarif_kilometrique': tarifKilometrique,
      'tarif_minimum': tarifMinimum,
      'bagage_kg': bagage_kg,
      'penalite': penalite,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    modeVente,
    tarifKilometrique,
    bagage_kg,
    penalite,
    tarifMinimum,
    createdAt,
    updatedAt,
  ];
}
