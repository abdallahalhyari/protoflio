import 'package:flutter/material.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/presentation/utils/experience_period.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/features/experience/presentation/widgets/card/experience_card_content.dart';

/// One role on the career timeline: the period in a date gutter (desktop),
/// a node on the guilloche teal spine, and the role itself on an unboxed
/// band. The spine is the same one the Engineering diagram uses, so a
/// sequence reads the same way everywhere on the site.
///
/// The current role's node is a filled teal plate; past roles are open
/// rings. The selected role (tap, or arrow keys) gets a flat ink band.
class ExperienceCard extends StatefulWidget {
  final Experience exp;
  final ColorScheme scheme;
  final bool isDesktop;
  final bool isSelected;
  final VoidCallback? onSelect;

  /// Whether the spine runs above / below this role.
  final bool isFirst;
  final bool isLast;

  const ExperienceCard({
    super.key,
    required this.exp,
    required this.scheme,
    required this.isDesktop,
    this.isSelected = false,
    this.onSelect,
    this.isFirst = true,
    this.isLast = true,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _hover = false;

  static const double _bandTop = 14;
  static const double _gutterWidth = 148;
  static const double _spineWidth = 20;
  static const double _nodeSize = 10;

  @override
  Widget build(BuildContext context) {
    final exp = widget.exp;
    final isDark = context.isDarkMode;
    final isDesktop = widget.isDesktop;
    final isCurrent = isCurrentExperience(exp.period);
    final period = formatExperiencePeriod(context, exp.period);

    final spine = (isDark ? AppColors.tealLight : AppColors.teal)
        .withValues(alpha: isDark ? 0.45 : 0.55);
    final plate = isDark ? AppColors.tealLight : AppColors.teal;
    final band = context.onSurface.withValues(
      alpha: widget.isSelected
          ? (isDark ? 0.05 : 0.04)
          : (_hover ? (isDark ? 0.025 : 0.02) : 0.0),
    );

    Widget segment(bool visible) => Container(
          width: 1.5,
          color: visible ? spine : Colors.transparent,
        );

    // Level with the company name on desktop, the period line on mobile.
    final nodeTop = _bandTop + (isDesktop ? 9 : 3);

    final node = Container(
      width: _nodeSize,
      height: _nodeSize,
      decoration: BoxDecoration(
        color: isCurrent ? plate : context.cardGlass,
        borderRadius: BorderRadius.circular(
          isCurrent ? AppRadius.xxs : _nodeSize / 2,
        ),
        border: Border.all(color: isCurrent ? plate : spine, width: 1.5),
      ),
    );

    return Semantics(
      container: true,
      selected: widget.isSelected,
      label: AppLocalizations.of(context)!.expRoleAtCompany(
        exp.role,
        exp.company,
        exp.period,
      ),
      explicitChildNodes: true,
      child: GestureDetector(
        excludeFromSemantics: true,
        onTap: () {
          SoundService.instance.playClick();
          widget.onSelect?.call();
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isDesktop) ...[
                  SizedBox(
                    width: _gutterWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(top: _bandTop + 5),
                      child: Text(
                        period,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color:
                              isCurrent ? context.onSurface : context.mutedText,
                          fontSize: AppTypography.body,
                          fontWeight:
                              isCurrent ? FontWeight.w600 : FontWeight.w400,
                          height: 1.4,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                SizedBox(
                  width: _spineWidth,
                  child: Column(
                    children: [
                      SizedBox(
                        height: nodeTop,
                        child: segment(!widget.isFirst),
                      ),
                      node,
                      Expanded(child: segment(!widget.isLast)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: AnimatedContainer(
                    duration: AppMotion.snap,
                    padding: EdgeInsetsDirectional.fromSTEB(
                      isDesktop ? 16 : 12,
                      _bandTop,
                      isDesktop ? 16 : 12,
                      isDesktop ? 22 : 18,
                    ),
                    decoration: BoxDecoration(
                      color: band,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: CardContent(
                      exp: exp,
                      scheme: widget.scheme,
                      isDesktop: isDesktop,
                      period: isDesktop ? null : period,
                      isCurrent: isCurrent,
                      isDark: isDark,
                    ),
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
