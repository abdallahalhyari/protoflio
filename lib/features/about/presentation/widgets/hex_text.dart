import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Space-separated uppercase hex.
String hexBytes(List<int> bytes) => bytes
    .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
    .join(' ');

/// Label above a selectable mono value; used by every playground demo.
class MonoField extends StatelessWidget {
  const MonoField(
      {super.key, required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final toneColor = color ?? context.onSurface;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: toneColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w600,
                    color: context.mutedText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.35)
                  : AppColors.ink100.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: isDark
                    ? toneColor.withValues(alpha: 0.22)
                    : context.glassBorderStrong,
                width: 0.8,
              ),
            ),
            child: SelectableText(
              value,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                fontSize: AppTypography.body,
                height: 1.5,
                color: toneColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
