import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// One technology on a Work card. A plain label: the card itself is the
/// thing to tap.
class CardTechTagChip extends StatelessWidget {
  final String tag;

  const CardTechTagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: context.divider),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: context.mutedText,
          fontSize: AppTypography.label,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
