import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../theme/tokens.dart';
import '../home_controller.dart';
import 'portfolio_nav.dart' show TopNav;

/// Desktop bottom-left "05 / 07 · SKILLS" folio bar. Reads pageIndex
/// + pageCount from the ambient [HomeController]; labels via
/// `TopNav.getLabels`.
class FolioBar extends StatelessWidget {
  const FolioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = HomeController.of(context);
    final labels = TopNav.getLabels(context);

    return ValueListenableBuilder<int>(
      valueListenable: controller.pageIndex,
      builder: (context, page, _) {
        final currentLabel = (page >= 0 && page < labels.length)
            ? labels[page].toUpperCase()
            : '';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(
              color: isDark ? Colors.white12 : AppColors.slate200,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.folioIndicator(
                  (page + 1).toString().padLeft(2, '0'),
                  controller.pageCount.toString().padLeft(2, '0'),
                ),
                style: TextStyle(
                  color: isDark ? Colors.white70 : AppColors.slate500,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1,
                height: 10,
                color: isDark ? Colors.white24 : AppColors.slate300,
              ),
              const SizedBox(width: 8),
              Text(
                currentLabel,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.slate900,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
