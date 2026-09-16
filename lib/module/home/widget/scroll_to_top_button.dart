import 'package:flutter/material.dart';

import '../../../service/sound_service.dart';
import '../../../theme/tokens.dart';

/// Circular arrow-up button anchored bottom-right on the mobile
/// continuous scroll layout. Parent owns the scroll controller and
/// wires it up via [onPressed].
class ScrollToTopButton extends StatelessWidget {
  const ScrollToTopButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: 'Scroll to top',
      child: Tooltip(
        message: 'Scroll to top',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              SoundService.instance.playClick();
              onPressed();
            },
            borderRadius: BorderRadius.circular(22),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.slate800.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.accentIndigo
                      .withValues(alpha: isDark ? 0.5 : 0.4),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: isDark ? Colors.white : AppColors.accentIndigo600,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
