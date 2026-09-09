import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/skills_data.dart';
import '../model/skill.dart';

class SkillsPage extends StatefulWidget {
  final PageController? controller;
  final int? pageIndex;

  const SkillsPage({super.key, this.controller, this.pageIndex});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  Offset _mousePos = Offset.zero;
  late Skill _hoveredSkill;
  String _selectedCategory = 'ALL';

  final List<String> _categories = [
    'ALL',
    'Mobile Systems',
    'Security & Protocols',
    'Architecture & State',
    'Cloud & Infrastructure',
  ];

  @override
  void initState() {
    super.initState();
    _hoveredSkill = kSkills.first; // Default to Flutter / Dart
    widget.controller?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  List<Color> _getCategoryGradient(String category) {
    switch (category) {
      case 'Mobile Systems':
        return const [Color(0xFF38BDF8), Color(0xFF818CF8)]; // Sky to Indigo
      case 'Security & Protocols':
        return const [Color(0xFFFBBF24), Color(0xFFF59E0B)]; // Amber to Gold
      case 'Architecture & State':
        return const [Color(0xFF34D399), Color(0xFF10B981)]; // Emerald to Mint
      case 'Cloud & Infrastructure':
        return const [Color(0xFFA78BFA), Color(0xFFEC4899)]; // Violet to Rose
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
    final isDesktop = size.width >= 960;

    double scrollProgress = 0.0;
    if (widget.controller != null &&
        widget.controller!.hasClients &&
        widget.controller!.position.haveDimensions &&
        widget.pageIndex != null) {
      scrollProgress = ((widget.controller!.page ?? 0.0) - widget.pageIndex!).clamp(-1.0, 1.0);
    }

    final displayedSkills = _selectedCategory == 'ALL'
        ? kSkills
        : kSkills.where((s) => s.category == _selectedCategory).toList();

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Blueprint Drafting Grid Background
          Positioned.fill(
            child: CustomPaint(
              painter: _DraftingGridPainter(color: scheme.primary),
            ),
          ),

          SafeArea(
            child: MouseRegion(
              onHover: (e) {
                final center = Offset(size.width / 2, size.height / 2);
                setState(() {
                  _mousePos = Offset(
                    ((e.position.dx - center.dx) / (size.width / 2)).clamp(-1.0, 1.0),
                    ((e.position.dy - center.dy) / (size.height / 2)).clamp(-1.0, 1.0),
                  );
                });
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? AppSpacing.xxl : AppSpacing.md,
                  AppSpacing.sm,
                  isDesktop ? AppSpacing.xxl : AppSpacing.md,
                  AppSpacing.xs,
                ),
                child: isDesktop
                    // DESKTOP: Split 2-Column (Zero nested vertical scroll!)
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Column: Header, Category Filter & Typographic Cloud
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildHeader(scheme, loc, size, isDesktop),
                                const SizedBox(height: 10),
                                _buildCategoryFilters(scheme, isDesktop),
                                const SizedBox(height: 10),
                                Container(height: 1, color: scheme.onSurface.withValues(alpha: 0.12)),
                                const SizedBox(height: 10),

                                // Kinetic Typographic Cloud (Fits on screen without nested scroll)
                                Expanded(
                                  child: Center(
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 20.0,
                                      runSpacing: 16.0,
                                      children: [
                                        for (int i = 0; i < displayedSkills.length; i++)
                                          _buildKineticWord(
                                            skill: displayedSkills[i],
                                            index: i,
                                            size: size,
                                            scrollProgress: scrollProgress,
                                            scheme: scheme,
                                            isDesktop: isDesktop,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),
                                _buildFootnote(scheme),
                              ],
                            ),
                          ),

                          const SizedBox(width: AppSpacing.xl),

                          // Right Column: Architectural Dossier Blueprint Card
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: _buildArchitecturalDossier(scheme, size, isDesktop),
                            ),
                          ),
                        ],
                      )
                    // MOBILE: Unified single-viewport layout (Zero nested scroll!)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(scheme, loc, size, isDesktop),
                          const SizedBox(height: 6),
                          _buildCategoryFilters(scheme, isDesktop),
                          const SizedBox(height: 6),
                          Container(height: 1, color: scheme.onSurface.withValues(alpha: 0.12)),
                          const SizedBox(height: 6),

                          // Mobile Kinetic Words (Responsive scale to prevent any inner scrollbar)
                          Expanded(
                            child: Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  for (int i = 0; i < displayedSkills.length; i++)
                                    _buildKineticWord(
                                      skill: displayedSkills[i],
                                      index: i,
                                      size: size,
                                      scrollProgress: scrollProgress,
                                      scheme: scheme,
                                      isDesktop: isDesktop,
                                    ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),
                          _buildArchitecturalDossier(scheme, size, isDesktop),
                          const SizedBox(height: 4),
                          _buildFootnote(scheme),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme scheme, AppLocalizations loc, Size size, bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 18, height: 2, color: scheme.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      isDesktop ? 'INDEX // ARCHITECTURAL MASTERY' : 'INDEX // SKILLS',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: scheme.primary,
                        fontSize: isDesktop ? 10.5 : 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: isDesktop ? 2 : 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                loc.navSkills.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Tenada',
                  color: scheme.onSurface,
                  fontSize: (size.width * 0.038).clamp(20.0, 36.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        if (isDesktop)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✦', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 11)),
                const SizedBox(width: 6),
                Text(
                  '12 CORE DISCIPLINES',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: scheme.primary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryFilters(ColorScheme scheme, bool isDesktop) {
    return Wrap(
      spacing: 5,
      runSpacing: 4,
      children: [
        for (final cat in _categories)
          _buildFilterChip(cat, scheme, isDesktop),
      ],
    );
  }

  Widget _buildFilterChip(String cat, ColorScheme scheme, bool isDesktop) {
    final isSelected = _selectedCategory == cat;
    final color = cat == 'ALL' ? scheme.primary : _getCategoryColor(cat);
    final count = cat == 'ALL'
        ? kSkills.length
        : kSkills.where((s) => s.category == cat).length;

    return InkWell(
      onTap: () {
        SoundService.instance.playClick();
        setState(() => _selectedCategory = cat);
      },
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 10 : 8,
          vertical: isDesktop ? 5 : 4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? color : scheme.onSurface.withValues(alpha: 0.15),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              cat.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Courier',
                color: isSelected ? color : scheme.onSurface.withValues(alpha: 0.7),
                fontSize: isDesktop ? 10.5 : 9.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '($count)',
              style: TextStyle(
                fontFamily: 'Courier',
                color: isSelected ? color.withValues(alpha: 0.8) : scheme.onSurface.withValues(alpha: 0.4),
                fontSize: isDesktop ? 9.5 : 8.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKineticWord({
    required Skill skill,
    required int index,
    required Size size,
    required double scrollProgress,
    required ColorScheme scheme,
    required bool isDesktop,
  }) {
    final bool isHovered = _hoveredSkill == skill;
    final bool isSameCategoryAsSelected = _hoveredSkill.category == skill.category;

    final catColor = _getCategoryColor(skill.category);
    final catGradient = _getCategoryGradient(skill.category);

    // Uniform responsive font sizing
    final double minClamp = isDesktop ? 18.0 : 14.0;
    final double maxClamp = isDesktop ? 26.0 : 18.0;
    double responsiveSize = isDesktop
        ? (24.0 * (size.width / 1300)).clamp(minClamp, maxClamp)
        : 16.0;

    // Slight reduction for very long names to fit, but not overly dramatic
    if (skill.name.length > 15) {
      responsiveSize = (responsiveSize * 0.85).clamp(14.0, isDesktop ? 22.0 : 16.0);
    }

    // Gentle kinetic drift
    final double driftFactor = (1.1 - skill.level) * 16.0 + (index % 3) * 4.0;
    final double driftX = _mousePos.dx * driftFactor + (scrollProgress * (index % 2 == 0 ? 10 : -10));
    final double driftY = _mousePos.dy * driftFactor + (math.sin(index) * 2);

    return Transform.translate(
      offset: Offset(driftX, driftY),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          SoundService.instance.playClick();
          setState(() {
            _hoveredSkill = skill;
          });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            SoundService.instance.playClick();
            setState(() => _hoveredSkill = skill);
          },
          child: AnimatedScale(
            scale: isHovered ? (isDesktop ? 1.10 : 1.05) : (isSameCategoryAsSelected ? 1.02 : 1.0),
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 12 : 8,
                vertical: isDesktop ? 6 : 4,
              ),
              decoration: BoxDecoration(
                color: isHovered
                    ? catColor.withValues(alpha: 0.18)
                    : (isSameCategoryAsSelected
                        ? catColor.withValues(alpha: 0.08)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isHovered
                      ? catColor.withValues(alpha: 0.85)
                      : (isSameCategoryAsSelected
                          ? catColor.withValues(alpha: 0.3)
                          : Colors.transparent),
                  width: isHovered ? 1.6 : 1.0,
                ),
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: catColor.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 480 : 300),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      skill.icon,
                      size: (responsiveSize * 0.44).clamp(12.0, 20.0),
                      color: isHovered ? catColor : scheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: ShaderMask(
                        blendMode: isHovered ? BlendMode.srcIn : BlendMode.dst,
                        shaderCallback: (bounds) => LinearGradient(
                          colors: catGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          skill.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Tenada',
                            fontSize: responsiveSize,
                            fontWeight: FontWeight.w900,
                            letterSpacing: isDesktop ? 1.5 : 0.8,
                            color: isHovered ? catColor : scheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isHovered ? catColor : catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '${(skill.level * 100).toInt()}%',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: (responsiveSize * 0.32).clamp(9.0, 11.5),
                        fontWeight: FontWeight.w900,
                        color: isHovered ? Colors.black : catColor,
                      ),
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

  Widget _buildArchitecturalDossier(ColorScheme scheme, Size size, bool isDesktop) {
    final skill = _hoveredSkill;
    final catColor = _getCategoryColor(skill.category);
    final catGradient = _getCategoryGradient(skill.category);

    return Container(
      constraints: BoxConstraints(maxWidth: isDesktop ? 620 : 960),
      decoration: BoxDecoration(
        color: const Color(0xFF0D121B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: catColor.withValues(alpha: 0.45), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: catColor.withValues(alpha: 0.12),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top console header gradient rule
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: catGradient),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 18 : 12,
                vertical: isDesktop ? 14 : 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header line: Icon + Name + Category badge + Proven in badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isDesktop ? 8 : 6),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: catColor.withValues(alpha: 0.4)),
                        ),
                        child: Icon(skill.icon, color: catColor, size: isDesktop ? 22 : 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: catColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    skill.category.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      color: catColor,
                                      fontSize: isDesktop ? 9.0 : 8.0,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'PROVEN: ${skill.provenIn.toUpperCase()}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Courier',
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: isDesktop ? 9.0 : 8.0,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              skill.name.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Tenada',
                                color: Colors.white,
                                fontSize: isDesktop ? 18 : 15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Mastery Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 8 : 6,
                          vertical: isDesktop ? 4 : 3,
                        ),
                        decoration: BoxDecoration(
                          color: catColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(skill.level * 100).toInt()}% MASTERY',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            color: Colors.black,
                            fontSize: isDesktop ? 10 : 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Animated Linear Progress Mastery Meter
                  Stack(
                    children: [
                      Container(
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            height: 3.5,
                            width: constraints.maxWidth * skill.level,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: catGradient),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: catColor.withValues(alpha: 0.6),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Production narrative description
                  Text(
                    skill.description,
                    maxLines: isDesktop ? 4 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 12.5 : 11.0,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  if (skill.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    // Specification Chips
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        for (final tag in skill.tags)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontFamily: 'Courier',
                                color: catColor.withValues(alpha: 0.9),
                                fontSize: isDesktop ? 9.5 : 8.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFootnote(ColorScheme scheme) {
    return Text(
      '✦ SELECT ANY ARCHITECTURAL DISCIPLINE TO LOAD PRODUCTION METRICS ✦',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Courier',
        color: scheme.onSurface.withValues(alpha: 0.5),
        fontSize: 9.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _DraftingGridPainter extends CustomPainter {
  final Color color;

  _DraftingGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    const double step = 60.0;
    const double crossSize = 3.5;

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawLine(
          Offset(x - crossSize, y),
          Offset(x + crossSize, y),
          paint,
        );
        canvas.drawLine(
          Offset(x, y - crossSize),
          Offset(x, y + crossSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DraftingGridPainter oldDelegate) => oldDelegate.color != color;
}
