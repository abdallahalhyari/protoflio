import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/bidi.dart';

class HighlightBullet extends StatelessWidget {
  const HighlightBullet({
    super.key,
    required this.text,
    required this.scheme,
  });

  final String text;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final int colonIndex = text.indexOf(':');
    final bool hasColon = colonIndex != -1;
    final isolate = needsLtrIsolate(context, text);
    final String open = isolate ? kLri : '';
    final String close = isolate ? kPdi : '';
    final String prefix =
        hasColon ? '$open${text.substring(0, colonIndex + 1)}' : '';
    final String rest = hasColon
        ? '${text.substring(colonIndex + 1)}$close'
        : '$open$text$close';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: context.adaptiveAccentText(scheme.primary),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: hasColon
                ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: prefix,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: context.adaptiveAccentText(scheme.primary),
                            fontSize: AppTypography.label,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: rest,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: context.onSurface,
                            fontSize: AppTypography.label,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    rest,
                    style: TextStyle(
                      color: context.onSurface,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
