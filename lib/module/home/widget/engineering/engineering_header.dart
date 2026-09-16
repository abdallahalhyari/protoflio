import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';

/// The top editorial header for the Systems Architecture / Engineering Expertise section.
class EngineeringHeader extends StatelessWidget {
  final bool isDesktop;

  const EngineeringHeader({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 2,
                color: scheme.primary.withValues(alpha: 0.9),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'FEATURE 03 · SYSTEMS ARCHITECTURE',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: isDesktop ? 11 : 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ENGINEERING EXPERTISE',
                            style: TextStyle(
                              fontFamily: AppTypography.displayFont,
                              color: scheme.onSurface,
                              fontSize: isDesktop ? 42 : 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Production-tested architectures behind the mobile suites',
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.75),
                            fontSize: isDesktop ? 12.5 : 11.5,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isDesktop)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: scheme.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.hub_outlined,
                              color: scheme.primary, size: 13),
                          const SizedBox(width: 6),
                          Text(
                            '4 ARCHITECTURES',
                            style: TextStyle(
                              color: scheme.primary,
                              fontSize: AppTypography.editorial,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 0.75,
                color: scheme.primary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
