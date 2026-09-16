import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../widget/intro/intro_availability_banner.dart';
import '../widget/intro/intro_cta_row.dart';
import '../widget/intro/intro_footer_strip.dart';
import '../widget/intro/hero_motion.dart';
import '../widget/scrollable_screen_shell.dart';
import '../widget/scroll_explore_hint.dart';

/// Intro reimagined as a premium magazine cover:
///   [issue strip]      TOP — small caps run + registration marks
///   ABDALLAH           HERO — outlined Tenada wordmark, full-bleed
///   ALHYARI • portrait  SUB — solid subline sitting next to a boxed portrait
///   [role kicker]      MID — role tagline stack over hairline rules
///   [CTA row]          BODY — 3 CTAs (view work / resume / contact)
///   [footer strip]     BASE — 3-column masthead footer: location · status · disciplines
class IntroPage extends StatefulWidget {
  final VoidCallback onScrollDown;
  final VoidCallback? onViewWork;
  final VoidCallback? onDownloadResume;
  final VoidCallback? onContactMe;
  final bool isContinuousMobile;

  const IntroPage({
    super.key,
    required this.onScrollDown,
    this.onViewWork,
    this.onDownloadResume,
    this.onContactMe,
    this.isContinuousMobile = false,
  });

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with AutomaticKeepAliveClientMixin {
  Color get _accent => Theme.of(context).colorScheme.primary;
  static const _gold = AppColors.accentAmberSoft;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= AppBreakpoints.tablet;
    final isDark = context.isDarkMode;
    final isCompactH = isWide && size.height < 920;

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _issueStrip(size, isDark),
        SizedBox(height: isCompactH ? 8.0 : (isWide ? AppSpacing.md : AppSpacing.sm)),
        _wordmark(size, isDark, isCompactH, isWide),
        SizedBox(height: isCompactH ? 8.0 : (isWide ? AppSpacing.smd : AppSpacing.xs)),
        _subline(size, isWide, isDark, isCompactH),
        SizedBox(height: isCompactH ? 12.0 : (isWide ? AppSpacing.lg : AppSpacing.md)),
        _roleBlock(size, isDark, isCompactH),
        SizedBox(height: isCompactH ? 12.0 : (isWide ? AppSpacing.lg : AppSpacing.md)),
        IntroAvailabilityBanner(isDark: isDark, isWide: isWide),
        SizedBox(height: isCompactH ? 12.0 : (isWide ? AppSpacing.lg : AppSpacing.md)),
        IntroCtaRow(
          isDark: isDark,
          onViewWork: widget.onViewWork ?? widget.onScrollDown,
          onDownloadResume: widget.onDownloadResume ?? widget.onScrollDown,
          onContactMe: widget.onContactMe ?? widget.onScrollDown,
        ),
        SizedBox(height: isCompactH ? 16.0 : (isWide ? AppSpacing.xxl : AppSpacing.xl)),
        IntroFooterStrip(
          isDark: isDark,
          onContactMe: widget.onContactMe,
          onViewWork: widget.onViewWork,
        ),
        // Desktop scroll hint. Skipped on compact viewports so the
        // intro column doesn't overflow and steal the outer wheel-scroll
        // gesture from the PageView (see _canInnerScroll in home_screen).
        if (isWide && !widget.isContinuousMobile && size.height >= 1000) ...[
          const SizedBox(height: AppSpacing.md),
          ScrollExploreHint(
            isDark: isDark,
            onTap: () {
              SoundService.instance.playClick();
              widget.onScrollDown();
            },
          ),
        ],
      ],
    );

    return ScrollableAppScreenShell(
      maxWidth: 1200,
      isContinuousMobile: widget.isContinuousMobile,
      child: body,
    );
  }

  // ---- Cover elements ----

  Widget _issueStrip(Size size, bool isDark) {
    final fs = (size.width * 0.011).clamp(10.0, 13.0);
    Widget rule() =>
        Container(width: 32, height: 1, color: _accent.withValues(alpha: 0.7));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _cornerMark(),
        const Spacer(),
        rule(),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              AppLocalizations.of(context)!.introIssueStrip,
              style: TextStyle(
                color: isDark ? Colors.white.withValues(alpha: 0.85) : AppColors.slate600,
                fontSize: fs,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        rule(),
        const Spacer(),
        _cornerMark(),
      ],
    );
  }

  Widget _cornerMark() => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _accent.withValues(alpha: 0.7), width: 1),
        ),
        child: Center(
          child: Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              color: _accent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );

  Widget _wordmark(Size size, bool isDark, bool isCompactH, bool isWide) {
    final wordmarkHeight = isCompactH
        ? (size.height * 0.17).clamp(95.0, 165.0)
        : (isWide ? (size.height * 0.21).clamp(120.0, 240.0) : (size.height * 0.16).clamp(85.0, 160.0));
    return SnappyEntrance(
      delayMs: 0,
      child: Semantics(
        header: true,
        label: AppLocalizations.of(context)!.semanticTitle,
        child: SizedBox(
          height: wordmarkHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'ABDALLAH',
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  fontSize: 220,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 10,
                  height: 0.9,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = isDark
                        ? Colors.white.withValues(alpha: 0.38)
                        : _accent.withValues(alpha: 0.40),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _subline(Size size, bool isWide, bool isDark, bool isCompactH) {
    final letterSize = isCompactH
        ? (size.width * 0.03).clamp(18.0, 32.0)
        : (size.width * 0.035).clamp(20.0, 40.0);
    final portraitSize = isCompactH
        ? (size.height * 0.082).clamp(52.0, 78.0)
        : (isWide ? (size.height * 0.095).clamp(60.0, 96.0) : (size.width * 0.12).clamp(56.0, 80.0));

    final content = isWide
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _portrait(portraitSize),
              SizedBox(width: portraitSize * 0.26),
              Text(
                'ALHYARI',
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  fontSize: letterSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 12,
                  color: isDark ? Colors.white : AppColors.slate900,
                  shadows: isDark
                      ? const [
                          Shadow(color: Colors.black, blurRadius: 16),
                          Shadow(color: Color(0x666366F1), blurRadius: 24),
                        ]
                      : const [Shadow(color: Colors.black12, blurRadius: 4)],
                ),
              ),
            ],
          )
        : Column(
            children: [
              _portrait(portraitSize),
              const SizedBox(height: AppSpacing.smd),
              Text(
                'ALHYARI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  fontSize: letterSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 10,
                  color: isDark ? Colors.white : AppColors.slate900,
                  shadows: isDark
                      ? const [
                          Shadow(color: Colors.black, blurRadius: 16),
                          Shadow(color: Color(0x666366F1), blurRadius: 24),
                        ]
                      : const [Shadow(color: Colors.black12, blurRadius: 4)],
                ),
              ),
            ],
          );

    return SnappyEntrance(
      delayMs: 30,
      child: isWide ? HeroParallax(child: content) : content,
    );
  }

  Widget _portrait(double size) {
    return Semantics(
      label: AppLocalizations.of(context)!.semanticPortrait,
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _accent,
              _gold.withValues(alpha: 0.8),
              _accent.withValues(alpha: 0.4),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: _accent.withValues(alpha: 0.40),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.5),
          child: Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: Image.asset(
              'assets/my_image.webp',
              fit: BoxFit.cover,
              cacheWidth: 280,
              cacheHeight: 280,
              filterQuality: FilterQuality.high,
              semanticLabel: AppLocalizations.of(context)!.semanticPortrait,
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleBlock(Size size, bool isDark, bool isCompactH) {
    return SnappyEntrance(
      delayMs: 60,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: (size.width * 0.78).clamp(320.0, 700.0),
          ),
          child: Column(
            children: [
              _hairlineRow(
                isDark: isDark,
                child: Text(
                  '❖',
                  style: TextStyle(color: _accent, fontSize: AppTypography.small),
                ),
              ),
              SizedBox(height: isCompactH ? 6.0 : AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.introSeniorEngineer.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompactH
                      ? (size.width * 0.016).clamp(15.0, 19.0)
                      : (size.width * 0.018).clamp(16.0, 22.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: isDark ? Colors.white : AppColors.slate900,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppLocalizations.of(context)!.introBuildsComplex,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompactH
                      ? (size.width * 0.0105).clamp(12.0, 15.0)
                      : (size.width * 0.0115).clamp(12.5, 18.0),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: isDark ? const Color(0xFFA5B4FC) : _accent,
                ),
              ),
              SizedBox(height: isCompactH ? 6.0 : AppSpacing.sm),
              Text(
                AppLocalizations.of(context)!.introTechStack,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompactH
                      ? (size.width * 0.01).clamp(11.0, 12.5)
                      : (size.width * 0.011).clamp(11.5, 13.5),
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white.withValues(alpha: 0.82) : AppColors.slate600,
                  height: 1.45,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hairlineRow({required Widget child, required bool isDark}) {
    final ruleColor = isDark ? Colors.white24 : AppColors.slate300;
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: ruleColor)),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: child),
        Expanded(child: Container(height: 1, color: ruleColor)),
      ],
    );
  }


}
