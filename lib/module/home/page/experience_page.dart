import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/experience_data.dart';
import '../model/experience.dart';
import '../widget/screen_shell.dart';

const _kNowAccent = Color(0xFF10B981); // Emerald green for "Present"
const _kGlassBorder = Color(0x33FFFFFF);

class ExperiencePage extends StatefulWidget {
  final PageController? controller;
  final int? pageIndex;
  final bool isContinuousMobile;

  const ExperiencePage({
    super.key,
    this.controller,
    this.pageIndex,
    this.isContinuousMobile = false,
  });

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  // Stagger animation state
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.isContinuousMobile) {
      _isVisible = true;
    } else {
      _checkVisibility();
      widget.controller?.addListener(_checkVisibility);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    if (!mounted) return;
    if (widget.controller == null ||
        !widget.controller!.hasClients ||
        widget.controller!.positions.length != 1) {
      if (!_isVisible) setState(() => _isVisible = true);
      return;
    }
    
    // Trigger animation when the page comes into view
    final page = widget.controller!.page ?? widget.controller!.initialPage.toDouble();
    final isFocused = (page - (widget.pageIndex ?? 0)).abs() < 0.3;
    
    if (isFocused && !_isVisible) {
      setState(() => _isVisible = true);
    } else if (!isFocused && _isVisible && (page - (widget.pageIndex ?? 0)).abs() > 0.8) {
      // Optional: reset visibility when scrolling far away to replay animation when returning
      setState(() => _isVisible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    
    return AppScreenShell(
      maxWidth: 1600, // Wider for horizontal scroll
      verticalPadding: widget.isContinuousMobile ? AppSpacing.md : AppSpacing.md,
      reserveBottomNav: !widget.isContinuousMobile,
      reserveMobileTop: !widget.isContinuousMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? AppSpacing.xl : AppSpacing.md),
            child: _buildHeader(scheme, size, isDesktop),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Timeline Grid
          if (widget.isContinuousMobile)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: _buildContinuousMobileList(scheme),
            )
          else
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? AppSpacing.xl : AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: isDesktop 
                    ? _buildDesktopGrid(scheme)
                    : _buildMobileList(scheme),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContinuousMobileList(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < kExperience.length; i++) ...[
          _buildExperienceNode(kExperience[i], i, scheme, false),
          const SizedBox(height: AppSpacing.md),
        ],
        _buildCredentialsBento(scheme, false),
      ],
    );
  }

  Widget _buildHeader(ColorScheme scheme, Size size, bool isDesktop) {
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
                    isDesktop ? 'FEATURE 04 · CAREER TRAJECTORY' : 'FEATURE 04 · EXPERIENCE',
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
                      'CAREER TRAJECTORY',
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
                    'Multi-year development of enterprise mobile systems',
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      '4 ROLES · ENTERPRISE IMPACT',
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

  Widget _buildDesktopGrid(ColorScheme scheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Column 1: Experiences 0 and 1
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 5, child: _buildExperienceNode(kExperience[0], 0, scheme, true)),
              const SizedBox(height: AppSpacing.lg),
              Expanded(flex: 4, child: _buildExperienceNode(kExperience[1], 1, scheme, true)),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        
        // Column 2: Experiences 2 and 3
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 5, child: _buildExperienceNode(kExperience[2], 2, scheme, true)),
              const SizedBox(height: AppSpacing.lg),
              Expanded(flex: 4, child: _buildExperienceNode(kExperience[3], 3, scheme, true)),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        
        // Column 3: Credentials Bento
        Expanded(
          flex: 4,
          child: _buildCredentialsBento(scheme, true),
        ),
      ],
    );
  }

  Widget _buildMobileList(ColorScheme scheme) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      primary: false,
      physics: const ClampingScrollPhysics(),
      itemCount: kExperience.length + 1,
      itemBuilder: (context, index) {
        if (index == kExperience.length) {
          return _buildCredentialsBento(scheme, false);
        }
        return _buildExperienceNode(kExperience[index], index, scheme, false);
      },
    );
  }

  Widget _buildExperienceNode(Experience exp, int index, ColorScheme scheme, bool isDesktop) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      opacity: _isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        offset: _isVisible ? Offset.zero : (isDesktop ? const Offset(0.2, 0) : const Offset(0, 0.2)),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: isDesktop ? 0 : AppSpacing.lg,
          ),
          child: _ExperienceCard(exp: exp, scheme: scheme, isDesktop: isDesktop),
        ),
      ),
    );
  }

  Widget _buildCredentialsBento(ColorScheme scheme, bool isDesktop) {
    final isDark = scheme.brightness == Brightness.dark;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      opacity: _isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        offset: _isVisible ? Offset.zero : (isDesktop ? const Offset(0.2, 0) : const Offset(0, 0.2)),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: isDesktop ? 0 : AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isDark ? scheme.primary.withValues(alpha: 0.3) : const Color(0xFFCBD5E1),
              width: isDark ? 1.5 : 1.0,
            ),
            color: isDark ? scheme.surface.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.90),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: RepaintBoundary(
            child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Builder(
                builder: (context) {
                  final content = Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('ACADEMIC ANNEX', scheme),
                        const SizedBox(height: 12),
                        ...kEducation.map((edu) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(edu.degree, style: TextStyle(color: scheme.onSurface, fontSize: 14.5, fontWeight: FontWeight.w900)),
                              Text('${edu.institution} · ${edu.period}', style: TextStyle(color: scheme.primary, fontSize: 12.5, fontWeight: FontWeight.w700)),
                              if (edu.note != null)
                                Text(edu.note!, style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.7), fontSize: 12.0)),
                            ],
                          ),
                        )),
                        const SizedBox(height: AppSpacing.md),
                        _buildSectionHeader('CERTIFICATION STAMPS', scheme),
                        const SizedBox(height: 12),
                        ...kCertifications.map((cert) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('❖ ', style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706))),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(cert, style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.9), fontSize: 13, height: 1.4)),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  );

                  return isDesktop
                      ? SingleChildScrollView(primary: false, child: content)
                      : content;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: scheme.primary, width: 2))),
      child: Text(
        title,
        style: TextStyle(fontFamily: 'Tenada', color: scheme.onSurface, fontSize: 16, letterSpacing: 2),
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final Experience exp;
  final ColorScheme scheme;
  final bool isDesktop;

  const _ExperienceCard({required this.exp, required this.scheme, required this.isDesktop});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hover = false;

  bool get _isCurrent => widget.exp.period.toLowerCase().contains('present');

  // Extract a single large year to act as a watermark (e.g. "2024" or "PRESENT")
  String get _watermark {
    if (_isCurrent) return 'NOW';
    final parts = widget.exp.period.split(' ');
    if (parts.isNotEmpty) {
      final last = parts.last;
      if (last.length == 4) return last; // likely a year
    }
    return widget.exp.company.isNotEmpty ? widget.exp.company.substring(0, 1).toUpperCase() : '';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = widget.scheme;
    final isDark = scheme.brightness == Brightness.dark;
    final reduce = MediaQuery.of(context).disableAnimations;
    final hovered = _hover && !reduce;

    return GestureDetector(
      onTap: () {
        SoundService.instance.playClick();
        setState(() => _hover = !_hover);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedScale(
          scale: hovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: hovered
                  ? scheme.primary.withValues(alpha: isDark ? 0.6 : 0.8)
                  : (isDark ? _kGlassBorder : const Color(0xFFE2E8F0)),
              width: hovered ? 1.5 : 1.0,
            ),
            boxShadow: hovered
                ? [
                    BoxShadow(color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.12), blurRadius: 20, spreadRadius: 2),
                    BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.4) : const Color(0xFF0F172A).withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 8)),
                  ]
                : [
                    BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.2) : const Color(0xFF0F172A).withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
          ),
          child: RepaintBoundary(
            child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Stack(
                children: [
                  // Glass background fill
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: isDark
                          ? (hovered ? scheme.surface.withValues(alpha: 0.35) : scheme.surface.withValues(alpha: 0.2))
                          : (hovered ? Colors.white.withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.88)),
                    ),
                  ),
                  
                  // Watermark
                  Positioned(
                    right: -10,
                    bottom: -20,
                    child: Text(
                      _watermark,
                      style: TextStyle(
                        fontFamily: 'Tenada',
                        fontSize: widget.isDesktop ? 160 : 90,
                        color: scheme.onSurface.withValues(alpha: 0.04),
                        height: 1.0,
                      ),
                    ),
                  ),
                  
                  // Content
                  Builder(
                    builder: (context) {
                      final content = Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row: Period and Latest Dispatch
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: scheme.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    widget.exp.period.toUpperCase(),
                                    style: TextStyle(color: scheme.primary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                                  ),
                                ),
                                if (_isCurrent) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _kNowAccent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: _kNowAccent.withValues(alpha: 0.5)),
                                    ),
                                    child: const Text(
                                      'LATEST DISPATCH',
                                      style: TextStyle(color: _kNowAccent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                            const SizedBox(height: 14),
                            
                            // Role & Company
                            Text(
                              widget.exp.company,
                              style: TextStyle(
                                fontFamily: 'Tenada',
                                color: scheme.onSurface,
                                fontSize: widget.isDesktop ? 28 : 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.exp.role.toUpperCase(),
                              style: TextStyle(
                                color: scheme.primary,
                                fontSize: widget.isDesktop ? 14 : 12.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Highlights
                            ...widget.exp.highlights.map((h) => _buildHighlight(h, scheme)),
                          ],
                        ),
                      );

                      return widget.isDesktop
                          ? SingleChildScrollView(primary: false, child: content)
                          : content;
                    },
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

  Widget _buildHighlight(String highlight, ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final int colonIndex = highlight.indexOf(':');
    final bool hasColon = colonIndex != -1;
    final String prefix = hasColon ? highlight.substring(0, colonIndex + 1) : '';
    final String rest = hasColon ? highlight.substring(colonIndex + 1) : highlight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: hasColon
                ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: prefix,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isDark ? scheme.onSurface : const Color(0xFF0F172A),
                            fontSize: 13.5,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: rest,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: isDark ? scheme.onSurface.withValues(alpha: 0.85) : const Color(0xFF334155),
                            fontSize: 13.5,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    highlight,
                    style: TextStyle(
                      color: isDark ? scheme.onSurface.withValues(alpha: 0.85) : const Color(0xFF334155),
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
