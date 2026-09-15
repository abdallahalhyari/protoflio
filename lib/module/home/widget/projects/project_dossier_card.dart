import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';

/// A card displaying a specific architectural dossier aspect (e.g. Core Problem,
/// Architecture, Engineering Solution, Decision, Lesson Learned).
class ProjectDossierCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;
  final bool isDesktop;
  final bool isDark;

  const ProjectDossierCard({
    super.key,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.isDesktop,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 12 : 10),
        decoration: BoxDecoration(
          color: isDark ? accentColor.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.90),
          borderRadius: BorderRadius.circular(AppRadius.smd),
          border: Border.all(color: accentColor.withValues(alpha: isDark ? 0.28 : 0.4), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: isDark ? 0.05 : 0.04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.api_rounded, size: 12, color: accentColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: accentColor,
                    fontSize: isDesktop ? 10.0 : 9.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white.withValues(alpha: 0.95) : AppColors.slate800,
                fontSize: isDesktop ? 12.5 : 11.0,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A bullet highlight row formatted with section prefix and colored category marker.
class ProjectHighlightRow extends StatelessWidget {
  final String highlight;
  final bool isDesktop;
  final bool isDark;

  const ProjectHighlightRow({
    super.key,
    required this.highlight,
    required this.isDesktop,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colonIndex = highlight.indexOf(':');
    final hasColon = colonIndex != -1;
    final prefix = hasColon ? highlight.substring(0, colonIndex + 1) : '';
    final rest = hasColon ? highlight.substring(colonIndex + 1) : highlight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '§ ',
            style: TextStyle(
              fontFamily: 'Courier',
              color: scheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: isDesktop ? 12.5 : 11.0,
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (hasColon)
                    TextSpan(
                      text: '$prefix ',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: isDark ? const Color(0xFFFDE68A) : const Color(0xFFB45309),
                        fontWeight: FontWeight.w800,
                        fontSize: isDesktop ? 12.0 : 10.5,
                      ),
                    ),
                  TextSpan(
                    text: rest.trim(),
                    style: TextStyle(
                      color: isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.slate700,
                      fontSize: isDesktop ? 12.0 : 10.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
