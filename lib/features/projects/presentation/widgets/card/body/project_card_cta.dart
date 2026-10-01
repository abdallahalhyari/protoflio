import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

class ReadCaseStudyCta extends StatelessWidget {
  const ReadCaseStudyCta({
    super.key,
    required this.projectName,
    required this.scheme,
    required this.isHovered,
    required this.isDesktop,
    required this.isDark,
    required this.onTap,
    required this.onFocusChange,
  });

  final String projectName;
  final ColorScheme scheme;
  final bool isHovered;
  final bool isDesktop;
  final bool isDark;
  final VoidCallback onTap;
  final ValueChanged<bool> onFocusChange;

  @override
  Widget build(BuildContext context) {
    final ctaColor = isDark ? scheme.primary : AppColors.accentIndigoDeepText;

    return Semantics(
      button: true,
      label: 'Read case study for $projectName',
      child: InkWell(
        onTap: onTap,
        onFocusChange: onFocusChange,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: ExcludeSemantics(
          child: AnimatedSlide(
            offset:
                isHovered && isDesktop ? const Offset(0.05, 0) : Offset.zero,
            duration: AppMotion.cardHover,
            curve: AppMotion.emphasized,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.uiReadCaseStudy,
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      color: ctaColor,
                      fontSize: AppTypography.caption,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 14, color: ctaColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
