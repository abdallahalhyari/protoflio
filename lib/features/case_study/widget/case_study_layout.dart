import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';

/// Responsive layout metrics for case studies.
class CaseStudyLayout {
  CaseStudyLayout._();

  /// Maximum comfortable reading width for longform case study prose.
  static const double maxContentWidth = 960.0;

  /// Responsive horizontal padding that caps the reading column to [maxContentWidth]
  /// and centers it on wide desktop displays, while providing comfortable margins
  /// on smaller screens.
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.tablet) {
      return math.max(48.0, (width - maxContentWidth) / 2);
    }
    if (width < 360) {
      return AppSpacing.md;
    }
    return AppSpacing.lg;
  }
}
