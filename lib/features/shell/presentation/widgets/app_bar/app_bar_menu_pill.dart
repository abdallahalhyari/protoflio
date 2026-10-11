import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

class AppBarMenuPill extends StatelessWidget {
  final bool tight;
  final bool isDark;
  final VoidCallback onMenuPressed;

  const AppBarMenuPill({
    super.key,
    required this.tight,
    required this.isDark,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      label: l10n.openNavigationMenu,
      child: GestureDetector(
        excludeFromSemantics: true,
        behavior: HitTestBehavior.opaque,
        onTap: () {
          SoundService.instance.playClick();
          onMenuPressed();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: InkWell(
            onTap: () {
              SoundService.instance.playClick();
              onMenuPressed();
            },
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: ExcludeSemantics(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: tight ? 8 : 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: isDark ? 0.22 : 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_rounded, size: 14, color: primary),
                    const SizedBox(width: 4),
                    Text(
                      l10n.menuLabel,
                      style: TextStyle(
                        color: isDark ? Colors.white : primary,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
