import 'package:flutter/material.dart';
import 'package:gestion_billet_train_flutter/core/constants/custom_shape/curve_edges/curve_edge.dart';

class TCurveEdgetWidget extends StatelessWidget {
  const TCurveEdgetWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: TCustomCurvedEdges(), child: child);
  }
}
