import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';

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

    return Semantics(
      button: true,
      label: 'Open navigation menu',
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
                      'MENU',
                      style: TextStyle(
                        color: isDark ? Colors.white : primary,
                        fontSize: AppTypography.editorial,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
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
