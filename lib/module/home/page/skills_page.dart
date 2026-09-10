import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/skills_data.dart';
import '../model/skill.dart';
import '../widget/screen_shell.dart';
import '../widget/swipe_affordance.dart';

class SkillsPage extends StatefulWidget {
  final PageController? controller;
  final int? pageIndex;
  final bool isContinuousMobile;

  const SkillsPage({
    super.key,
    this.controller,
    this.pageIndex,
    this.isContinuousMobile = false,
  });

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  String _selectedCategory = 'ALL';

  final List<String> _categories = [
    'ALL',
    'Mobile Systems',
    'Security & Protocols',
    'Architecture & State',
    'Cloud & Infrastructure',
  ];

  List<Color> _getCategoryGradient(String category) {
    switch (category) {
      case 'Mobile Systems':
        return const [Color(0xFF38BDF8), Color(0xFF818CF8)];
      case 'Security & Protocols':
        return const [Color(0xFFFBBF24), Color(0xFFF59E0B)];
      case 'Architecture & State':
        return const [Color(0xFF34D399), Color(0xFF10B981)];
      case 'Cloud & Infrastructure':
        return const [Color(0xFFA78BFA), Color(0xFFEC4899)];
      default:
        return const [Color(0xFF818CF8), Color(0xFFC084FC)];
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Mobile Systems':
        return const Color(0xFF38BDF8);
      case 'Security & Protocols':
        return const Color(0xFFFBBF24);
      case 'Architecture & State':
        return const Color(0xFF10B981);
      case 'Cloud & Infrastructure':
        return const Color(0xFFA78BFA);
      default:
        return const Color(0xFF818CF8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final loc = AppLocalizations.of(context)!;
    final isDesktop = size.width >= AppBreakpoints.tablet;

    final displayedSkills = _selectedCategory == 'ALL'
        ? kSkills
        : kSkills.where((s) => s.category == _selectedCategory).toList();

    final grid = displayedSkills.isEmpty 
      ? const Center(child: Text("No skills found in this category."))
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
              child: _BentoSkillTile(
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
          if (widget.isContinuousMobile) ...[
            SizedBox(
              height: 300,
              child: grid,
            ),
            const SizedBox(height: 8),
            _buildMobileSwipeHint(scheme, displayedSkills.length),
          ] else
            Expanded(child: grid),
        ],
      ),
    );
  }

  Widget _buildMobileSwipeHint(ColorScheme scheme, int count) {
    return Center(
      child: SwipeAffordance(
        icon: Icons.touch_app_outlined,
        label: 'SWIPE TO BROWSE $count SKILLS · TAP CARDS TO FLIP',
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
                        fontFamily: 'Tenada',
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
        borderRadius: BorderRadius.circular(8),
        focusColor: color.withValues(alpha: 0.25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 16 : 10,
            vertical: isDesktop ? 10 : 7,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: isDark ? 0.18 : 0.12)
                : (isDark ? Colors.transparent : Colors.white.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? color
                  : (isDark ? scheme.onSurface.withValues(alpha: 0.15) : const Color(0xFFCBD5E1)),
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
                          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
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
                        : (isDark ? scheme.onSurface.withValues(alpha: 0.7) : const Color(0xFF475569)),
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
                        : (isDark ? scheme.onSurface.withValues(alpha: 0.4) : const Color(0xFF94A3B8)),
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

class _BentoSkillTile extends StatefulWidget {
  final Skill skill;
  final Color categoryColor;
  final List<Color> categoryGradient;
  final bool isDesktop;

  const _BentoSkillTile({
    required this.skill,
    required this.categoryColor,
    required this.categoryGradient,
    required this.isDesktop,
  });

  @override
  State<_BentoSkillTile> createState() => _BentoSkillTileState();
}

class _BentoSkillTileState extends State<_BentoSkillTile> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late final Animation<double> _flipAnim = CurvedAnimation(parent: _c, curve: Curves.easeOutBack);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (isHovered == _isHovered) return;
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _c.forward();
    } else {
      _c.reverse();
    }
  }
  
  String _masteryLabel(double level) {
    if (level >= 0.9) return 'LEAD';
    if (level >= 0.75) return 'CORE';
    if (level >= 0.55) return 'SOLID';
    return 'GROWING';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          SoundService.instance.playClick();
          _onHover(!_isHovered);
        },
        child: AnimatedBuilder(
          animation: _flipAnim,
          builder: (context, child) {
            final isBack = _flipAnim.value >= 0.5;
            final angle = _flipAnim.value * math.pi;
            
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);
              
            return Transform(
              alignment: Alignment.center,
              transform: transform,
              child: isBack
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _buildBack(),
                    )
                  : _buildFront(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFront() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D121B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.categoryColor.withValues(alpha: isDark ? 0.3 : 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? widget.categoryColor.withValues(alpha: 0.1)
                : const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: widget.categoryGradient),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(widget.isDesktop ? 16.0 : 12.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.all(widget.isDesktop ? 12 : 6),
                        decoration: BoxDecoration(
                          color: widget.categoryColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: widget.categoryColor.withValues(alpha: 0.3)),
                        ),
                        child: Icon(widget.skill.icon, color: widget.categoryColor, size: widget.isDesktop ? 36 : 20),
                      ),
                      SizedBox(height: widget.isDesktop ? 16 : 8),
                      Text(
                        widget.skill.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Tenada',
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: widget.isDesktop ? 22 : 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: widget.isDesktop ? 8 : 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: widget.categoryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _masteryLabel(widget.skill.level),
                          style: TextStyle(
                            fontFamily: 'Courier',
                            color: widget.categoryColor,
                            fontSize: widget.isDesktop ? 11 : 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: widget.isDesktop ? 10 : 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : const Color(0xFFCBD5E1),
                            width: 0.8,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.touch_app_outlined,
                                size: 11,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'TAP TO FLIP ↺',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.6)
                                      : const Color(0xFF64748B),
                                  fontSize: widget.isDesktop ? 9.5 : 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131A26) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.categoryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? widget.categoryColor.withValues(alpha: 0.3)
                : const Color(0xFF0F172A).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: widget.categoryGradient),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(widget.isDesktop ? 16.0 : 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(widget.skill.icon, color: widget.categoryColor, size: widget.isDesktop ? 20 : 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.skill.name.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Tenada',
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: widget.isDesktop ? 16 : 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.categoryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flip_to_front_rounded, size: 10, color: widget.categoryColor),
                              const SizedBox(width: 3),
                              Text(
                                'FLIP',
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  color: widget.categoryColor,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: widget.isDesktop ? 12 : 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.skill.description,
                          style: TextStyle(
                            color: isDark ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF334155),
                            fontSize: widget.isDesktop ? 12 : 10.5,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    if (widget.skill.tags.isNotEmpty) ...[
                      SizedBox(height: widget.isDesktop ? 12 : 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          for (final tag in widget.skill.tags)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: isDark ? Colors.white24 : const Color(0xFFE2E8F0)),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  color: isDark ? widget.categoryColor.withValues(alpha: 0.9) : const Color(0xFF4338CA),
                                  fontSize: widget.isDesktop ? 9.5 : 8.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
