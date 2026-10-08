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
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.label,
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: 3),
          SelectableText(
            value,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              fontSize: AppTypography.body,
              height: 1.5,
              color: color ?? context.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
