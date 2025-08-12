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
    final coeffsRaw = json['coefficients_classes'] as Map<String, dynamic>;
    final coeffs = coeffsRaw.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return SettingModel(
      id: json['id'],
      modeVente: json['mode_vente'],
      tarifKilometrique: double.parse(json['tarif_kilometrique']),
      tarifMinimum: double.parse(json['tarif_minimum']),
      coefficientsClasses: coeffs,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
