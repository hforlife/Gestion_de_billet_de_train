import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/app_colors.dart';
import 'package:gestion_billet_train_flutter/core/constants/sizes.dart';

class TRoundedContainer extends StatelessWidget {
  const TRoundedContainer({
    super.key,
    this.child,
    this.width,
    this.heigth,
    this.margin,
    this.padding,
    this.showBorder = false,
    this.radius,
    this.backgroundColor = AppColors.white,
    this.borderColor = AppColors.borderPrimary,
  });

  final Widget? child;
  final double? width;
  final double? heigth;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool showBorder;
  final double? radius;
  final Color backgroundColor;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: heigth,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius ?? TSizes.cardRadiusLg),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
