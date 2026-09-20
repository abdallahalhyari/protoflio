import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/widget/editorial_chip.dart';

class ExpressPresetsBar extends StatelessWidget {
  final void Function(String subject, String body) onSelectPreset;

  const ExpressPresetsBar({
    super.key,
    required this.onSelectPreset,
  });

  static const List<(String, String, String)> presets = [
    (
      '💼 Senior Role',
      '[Role Opportunity] Senior Mobile Architect - Abdallah Alhyari',
      'Hi Abdallah,\n\nI reviewed your portfolio and would like to discuss a Senior Mobile Architect / Engineering role at our company...',
    ),
    (
      '📐 Architecture Audit',
      '[Architecture Review] Mobile Codebase Audit - Abdallah Alhyari',
      'Hi Abdallah,\n\nWe are looking for a deep architectural review of our existing mobile application...',
    ),
    (
      '⚡ Production App',
      '[App Project Inquiry] Enterprise Mobile App - Abdallah Alhyari',
      'Hi Abdallah,\n\nWe are planning to build a high-performance cross-platform application and want your expertise...',
    ),
    (
      '☕ Advisory & Chat',
      '[Connect] Tech Advisory & Coffee - Abdallah Alhyari',
      'Hi Abdallah,\n\nI’d love to connect for a 20-minute chat regarding mobile engineering and technology...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final accentSoft = accent.withValues(alpha: 0.35);
    final isDark = context.isDarkMode;

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : AppColors.slate100,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.slate200,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bolt_rounded,
                  size: 16,
                  color: context.amberText,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'ONE-TAP EXPRESS REACH-OUT PRESETS',
                      style: TextStyle(
                        color: context.amberText,
                        fontSize: AppTypography.editorial,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in presets)
                  EditorialChip(
                    label: p.$1,
                    variant: ChipVariant.glass,
                    tone: ChipTone.primary,
                    trailing: Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: isDark ? accentSoft : accent,
                    ),
                    onTap: () => onSelectPreset(p.$2, p.$3),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
