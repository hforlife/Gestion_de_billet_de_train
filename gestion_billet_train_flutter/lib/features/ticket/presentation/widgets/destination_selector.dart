import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';

class DestinationSelector extends StatelessWidget {
  final Function(String?) onDepartureChanged;
  final Function(String?) onDestinationChanged;

  DestinationSelector({
    super.key,
    required this.onDepartureChanged,
    required this.onDestinationChanged,
  });

  final List<String> cities = ['Bamako', 'Koulikoro'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Lieu de départ',
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          items: cities
              .map((city) => DropdownMenuItem(value: city, child: Text(city)))
              .toList(),
          onChanged: onDepartureChanged,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Lieu d\'arrivée',
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          items: cities
              .map((city) => DropdownMenuItem(value: city, child: Text(city)))
              .toList(),
          onChanged: onDestinationChanged,
        ),
      ],
    );
  }
}
