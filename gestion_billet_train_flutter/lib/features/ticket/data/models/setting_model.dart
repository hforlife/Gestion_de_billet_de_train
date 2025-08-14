class SettingModel {
  final int? id;
  final String? modeVente;
  final double? tarifKilometrique;
  final double? baguageTarif;
  final double? tarifMinimum;
  final Map<String, double>? coefficientsClasses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SettingModel({
    this.id,
    this.modeVente,
    this.tarifKilometrique,
    this.baguageTarif,
    this.tarifMinimum,
    this.coefficientsClasses,
    this.createdAt,
    this.updatedAt,
  });

  static SettingModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    Map<String, double>? coeffs;
    final coeffsRaw = json['coefficients_classes'];
    if (coeffsRaw != null && coeffsRaw is Map) {
      coeffs = coeffsRaw.map(
        (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
      );
    }

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
      coefficientsClasses: coeffs,
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
      'coefficients_classes': coefficientsClasses,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
