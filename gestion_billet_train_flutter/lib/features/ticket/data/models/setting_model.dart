class SettingModel {
  final int id;
  final String modeVente;
  final double tarifKilometrique;
  final double tarifMinimum;
  final Map<String, double> coefficientsClasses;
  final DateTime createdAt;
  final DateTime updatedAt;

  SettingModel({
    required this.id,
    required this.modeVente,
    required this.tarifKilometrique,
    required this.tarifMinimum,
    required this.coefficientsClasses,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    // Safely handle coefficients_classes
    final coeffsRaw = json['coefficients_classes'] as Map?;
    final coefficientsClasses = coeffsRaw != null
        ? coeffsRaw.map(
            (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
          )
        : <String, double>{}; // Default to empty map if null

    return SettingModel(
      id: json['id'] as int,
      modeVente: json['mode_vente'] as String,
      tarifKilometrique: double.parse(json['tarif_kilometrique'].toString()),
      tarifMinimum: double.parse(json['tarif_minimum'].toString()),
      coefficientsClasses: coefficientsClasses,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode_vente': modeVente,
      'tarif_kilometrique': tarifKilometrique,
      'tarif_minimum': tarifMinimum,
      'coefficients_classes': coefficientsClasses,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
