import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_nav_sheet.dart';

/// One section in the menu: its number, title and what's in it. The
/// section on screen is marked in teal, the site's colour for position.
class NavSectionRow extends StatelessWidget {
  const NavSectionRow({
    super.key,
    required this.item,
    required this.isActive,
    required this.onSelect,
  });

  final NavSectionItem item;
  final bool isActive;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final here = context.isDarkMode ? AppColors.tealLight : AppColors.tealDeep;

    return Semantics(
      selected: isActive,
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.smd,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    item.number,
                    style: TextStyle(
                      fontSize: AppTypography.body,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: isActive ? here : context.mutedText,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: AppTypography.lead,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                          color: isActive ? here : context.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: AppTypography.label + 1,
                          height: 1.4,
                          color: context.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
