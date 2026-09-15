import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/skills_data.dart';
import '../widget/screen_shell.dart';
import '../widget/skills/bento_skill_tile.dart';

class SkillsPage extends StatefulWidget {
  final bool isContinuousMobile;

  const SkillsPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage>
    with AutomaticKeepAliveClientMixin {
  String _selectedCategory = 'ALL';

  @override
  bool get wantKeepAlive => true;

  final List<String> _categories = [
    'ALL',
    'Domain Expertise',
    'Mobile Systems',
    'Security & Protocols',
    'Architecture & State',
    'Cloud & Infrastructure',
    'Languages & Comm',
  ];

  List<Color> _getCategoryGradient(String category) {
    switch (category) {
      case 'Domain Expertise':
        return const [Color(0xFF8B5CF6), Color(0xFF6D28D9)];
      case 'Mobile Systems':
        return [const Color(0xFF38BDF8), Theme.of(context).colorScheme.primary];
      case 'Security & Protocols':
        return const [Color(0xFFFBBF24), Color(0xFFF59E0B)];
      case 'Architecture & State':
        return const [Color(0xFF34D399), Color(0xFF10B981)];
      case 'Cloud & Infrastructure':
        return const [Color(0xFFA78BFA), Color(0xFFEC4899)];
      case 'Languages & Comm':
        return const [Color(0xFFF472B6), Color(0xFFBE185D)];
      default:
        return [Theme.of(context).colorScheme.primary, const Color(0xFFC084FC)];
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Domain Expertise':
        return const Color(0xFF8B5CF6);
      case 'Mobile Systems':
        return const Color(0xFF38BDF8);
      case 'Security & Protocols':
        return const Color(0xFFFBBF24);
      case 'Architecture & State':
        return const Color(0xFF10B981);
      case 'Cloud & Infrastructure':
        return const Color(0xFFA78BFA);
      case 'Languages & Comm':
        return const Color(0xFFF472B6);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final loc = AppLocalizations.of(context)!;
    final isDesktop = size.width >= AppBreakpoints.tablet;

    final displayedSkills = _selectedCategory == 'ALL'
        ? kSkills
        : kSkills.where((s) => s.category == _selectedCategory).toList();

    final grid = displayedSkills.isEmpty
      ? _buildEmptyState(scheme)
      : GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 2 : 1, // Number of rows
            childAspectRatio: isDesktop ? 1.1 : 1.28, // Height / Width
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: displayedSkills.length,
          itemBuilder: (context, index) {
            final skill = displayedSkills[index];
            return RepaintBoundary(
              child: BentoSkillTile(
                skill: skill,
                categoryColor: _getCategoryColor(skill.category),
                categoryGradient: _getCategoryGradient(skill.category),
                isDesktop: isDesktop,
              ),
            );
          },
      );

    return AppScreenShell(
      maxWidth: 1400,
      verticalPadding: widget.isContinuousMobile ? AppSpacing.md : AppSpacing.md,
      reserveBottomNav: !widget.isContinuousMobile,
      reserveMobileTop: !widget.isContinuousMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(scheme, loc, size, isDesktop),
          const SizedBox(height: 12),
          _buildCategoryFilters(scheme, isDesktop),
          const SizedBox(height: 12),
          Container(height: 1, color: scheme.onSurface.withValues(alpha: 0.12)),
          const SizedBox(height: 16),
          if (widget.isContinuousMobile)
            // Vertical 2-column grid feeds parent scroll — no nested
            // horizontal-in-vertical scrolling. Fixed tile height keeps
            // rows uniform without a horizontal viewport.
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 12.0;
                final tileW = (constraints.maxWidth - spacing) / 2;
                const tileH = 180.0;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final skill in displayedSkills)
                      SizedBox(
                        width: tileW,
                        height: tileH,
                        child: RepaintBoundary(
                          child: BentoSkillTile(
                            skill: skill,
                            categoryColor: _getCategoryColor(skill.category),
                            categoryGradient:
                                _getCategoryGradient(skill.category),
                            isDesktop: false,
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
          else
            Expanded(child: grid),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme scheme, AppLocalizations loc, Size size, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(height: 2, color: scheme.primary.withValues(alpha: 0.9)),
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
                    isDesktop ? 'FEATURE 05 · ARCHITECTURAL MASTERY' : 'FEATURE 05 · CORE SKILLS',
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
                      loc.navSkills.toUpperCase(),
                      style: TextStyle(
                        fontFamily: AppTypography.displayFont,
                        color: scheme.onSurface,
                        fontSize: (size.width * 0.05).clamp(24.0, 48.0),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Disciplines and stack the work is built on · Tap any card to flip',
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: scheme.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('✦', style: TextStyle(color: AppColors.accentAmber, fontSize: 11)),
                    const SizedBox(width: 6),
                    Text(
                      '12 CORE DISCIPLINES',
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 10.5,
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
        Container(height: 0.75, color: scheme.primary.withValues(alpha: 0.5)),
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : AppColors.slate50,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : AppColors.slate200,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_outlined,
              size: 28,
              color: scheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.skillsEmptyTitle,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.slate900,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => setState(() => _selectedCategory = 'ALL'),
              child: Text(l10n.skillsEmptyShowAll,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(ColorScheme scheme, bool isDesktop) {
    if (!isDesktop) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < _categories.length; i++) ...[
              _buildFilterChip(_categories[i], scheme, false),
              if (i < _categories.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final cat in _categories) _buildFilterChip(cat, scheme, isDesktop),
      ],
    );
  }

  Widget _buildFilterChip(String cat, ColorScheme scheme, bool isDesktop) {
    final isDark = scheme.brightness == Brightness.dark;
    final isSelected = _selectedCategory == cat;
    final color = cat == 'ALL' ? scheme.primary : _getCategoryColor(cat);
    final count = cat == 'ALL' ? kSkills.length : kSkills.where((s) => s.category == cat).length;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$cat category, $count skills',
      child: InkWell(
        onTap: () {
          SoundService.instance.playClick();
          setState(() => _selectedCategory = cat);
        },
        borderRadius: BorderRadius.circular(AppRadius.sm),
        focusColor: color.withValues(alpha: 0.25),
        child: AnimatedContainer(
          duration: AppMotion.chipHover,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 16 : 10,
            vertical: isDesktop ? 10 : 7,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: isDark ? 0.18 : 0.12)
                : (isDark ? Colors.transparent : Colors.white.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isSelected
                  ? color
                  : (isDark ? scheme.onSurface.withValues(alpha: 0.15) : AppColors.slate300),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: isDark ? 0.25 : 0.15),
                      blurRadius: 12,
                    ),
                  ]
                : (isDark
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.slate900.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ]),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  cat.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: isSelected
                        ? (isDark ? color : (cat == 'ALL' ? scheme.primary : color))
                        : (isDark ? scheme.onSurface.withValues(alpha: 0.7) : AppColors.slate600),
                    fontSize: isDesktop ? 11 : 9.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '($count)',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: isSelected
                        ? color.withValues(alpha: 0.8)
                        : (isDark ? scheme.onSurface.withValues(alpha: 0.4) : AppColors.slate400),
                    fontSize: isDesktop ? 10 : 8.5,
                    fontWeight: FontWeight.w700,
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
