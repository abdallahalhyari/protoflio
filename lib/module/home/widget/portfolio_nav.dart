import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';

class TopNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  final VoidCallback onResume;

  static List<String> getLabels(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return [
      l.navHome,
      l.navWork,
      l.navEngineering,
      l.navExperience,
      l.navStack,
      l.navAbout,
      l.navContact,
    ];
  }

  const TopNav({
    super.key,
    required this.current,
    required this.onTap,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Section navigation',
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: math.max(0.0, MediaQuery.sizeOf(context).width - AppSpacing.xl),
          ),
          child: RepaintBoundary(
            child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                margin: const EdgeInsets.only(top: AppSpacing.smd),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.42)
                      : Colors.white.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.32 : 0.22),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0xFF8B5CF6).withValues(alpha: 0.12)
                          : Colors.black.withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _EdgeFadeScroller(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < getLabels(context).length; i++)
                        NavItem(
                          label: getLabels(context)[i],
                          active: current == i,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            onTap(i);
                          },
                        ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 1,
                        height: 18,
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Semantics(
                        button: true,
                        label: 'Download Resume PDF',
                        child: OutlinedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            onResume();
                          },
                          icon: const Icon(Icons.download_rounded, size: 14),
                          label: Text(
                            AppLocalizations.of(context)!.navResume.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? const Color(0xFFFDE68A) : const Color(0xFF6366F1),
                            side: BorderSide(
                              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF6366F1),
                              width: 1.2,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
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
        ),
      ),
    );
  }
}

class MobileNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  final VoidCallback onResume;

  const MobileNav({
    super.key,
    required this.current,
    required this.onTap,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: math.max(0.0, MediaQuery.sizeOf(context).width - AppSpacing.lg),
        ),
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.52)
                      : Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.black.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.35)
                          : Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < TopNav.getLabels(context).length; i++)
                        _MobileNavItem(
                          label: TopNav.getLabels(context)[i],
                          active: current == i,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            onTap(i);
                          },
                        ),
                      const SizedBox(width: 4),
                      Container(
                        width: 1,
                        height: 16,
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        tooltip: 'Download Resume',
                        icon: Icon(
                          Icons.download_rounded,
                          size: 16,
                          color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF6366F1),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          onResume();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: AppMotion.sm,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.28 : 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: active
              ? Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.45 : 0.35),
                  width: 1)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active
                ? (isDark ? const Color(0xFFE9D5FF) : const Color(0xFF6366F1))
                : (isDark ? Colors.white70 : const Color(0xFF475569)),
            fontSize: 11.5,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      selected: active,
      label: 'Go to $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: AnimatedContainer(
          duration: AppMotion.sm,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.smd, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.22 : 0.14)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: active
                ? Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.4 : 0.3),
                    width: 1)
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active
                  ? (isDark ? const Color(0xFFE9D5FF) : const Color(0xFF6366F1))
                  : (isDark ? Colors.white : const Color(0xFF475569)),
              fontSize: AppTypography.small,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal scroller with a left/right gradient mask that appears only
/// when the child actually overflows. Signals to keyboard/mouse users that
/// the TopNav has more items off-screen on narrow desktops.
class _EdgeFadeScroller extends StatefulWidget {
  const _EdgeFadeScroller({required this.child});
  final Widget child;

  @override
  State<_EdgeFadeScroller> createState() => _EdgeFadeScrollerState();
}

class _EdgeFadeScrollerState extends State<_EdgeFadeScroller> {
  final ScrollController _controller = ScrollController();
  bool _fadeLeft = false;
  bool _fadeRight = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_recompute);
    WidgetsBinding.instance.addPostFrameCallback((_) => _recompute());
  }

  @override
  void dispose() {
    _controller.removeListener(_recompute);
    _controller.dispose();
    super.dispose();
  }

  void _recompute() {
    if (!_controller.hasClients) return;
    final pos = _controller.position;
    final left = pos.pixels > 2;
    final right = pos.pixels < pos.maxScrollExtent - 2;
    if (left != _fadeLeft || right != _fadeRight) {
      setState(() {
        _fadeLeft = left;
        _fadeRight = right;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scroller = SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: widget.child,
    );

    if (!_fadeLeft && !_fadeRight) return scroller;

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [
            Colors.transparent,
            Colors.black,
            Colors.black,
            Colors.transparent,
          ],
          stops: [
            0.0,
            _fadeLeft ? 0.05 : 0.0,
            _fadeRight ? 0.95 : 1.0,
            1.0,
          ],
        ).createShader(rect);
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (_) {
          _recompute();
          return false;
        },
        child: scroller,
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int current;
  final ValueChanged<int> onTap;

  const PageIndicator({
    super.key,
    required this.count,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labels = TopNav.getLabels(context);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (i) {
        final active = i == current;
        final label = i < labels.length ? labels[i] : 'Page ${i + 1}';
        return Tooltip(
          message: label,
          preferBelow: false,
          child: Semantics(
            button: true,
            selected: active,
            label: 'Go to $label',
            child: SizedBox(
              width: 44,
              height: 44,
              child: InkResponse(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(i);
                },
                radius: 22,
                child: Center(
                  child: AnimatedContainer(
                    duration: AppMotion.sm,
                    width: active ? 12 : 8,
                    height: active ? 12 : 8,
                    decoration: BoxDecoration(
                      color: active
                          ? (isDark ? Colors.white : const Color(0xFF6366F1))
                          : (isDark ? Colors.white70 : const Color(0xFF94A3B8)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.black45 : Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      ),
    );
  }
}
