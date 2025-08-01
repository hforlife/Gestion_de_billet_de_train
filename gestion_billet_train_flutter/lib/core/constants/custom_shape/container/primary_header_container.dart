import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/custom_shape/container/circular_container.dart';
import 'package:gestion_billet_train_flutter/core/constants/custom_shape/curve_edges/curve_edges_widget.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurveEdgetWidget(
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -250,
              child: TCircularContainer(
                backgroundColor: AppColors.background.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: TCircularContainer(
                backgroundColor: AppColors.background.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
