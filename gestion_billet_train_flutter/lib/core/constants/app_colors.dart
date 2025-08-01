import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1E3A8A);
  static const secondary = Color(0xFF10B981);
  static const background = Color(0xFFF9FAFB);
  static const card = Color(0xFFF3F4F6);

  static const Color borderPrimary = Color.fromARGB(
    183,
    30,
    59,
    138,
  ); // Rouge pastel
  static const Color borderSecondary = Color(0xFF90CAF9); // Bleu pastel

  // ✅ États (Erreurs, avertissements, succès)
  static const Color error = Color(0xFFB71C1C); // Rouge foncé
  static const Color success = Color(0xFF388E3C); // Vert foncé
  static const Color warning = Color(0xFFFFA000); // Orange pour alerte
  static const Color info = Color(0xFF1976D2); // Bleu pour informations

  // ⚫ Nuances neutres (Adaptées au mode sombre & clair)
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
