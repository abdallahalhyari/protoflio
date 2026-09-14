import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../widget/primary_button.dart';
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

class _IntroPageState extends State<IntroPage> {
  // Backed by the shared AppColors palette so future rebrands propagate.
  static const _accent = AppColors.accentIndigo;
  static const _accentSoft = AppColors.accentIndigoSoft;
  static const _gold = AppColors.accentAmberSoft;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final isWide = size.width >= AppBreakpoints.tablet;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _issueStrip(size, isDark),
        SizedBox(height: isWide ? AppSpacing.md : AppSpacing.sm),
        _wordmark(size, isDark),
        SizedBox(height: isWide ? AppSpacing.smd : AppSpacing.xs),
        _subline(size, isWide, isDark),
        SizedBox(height: isWide ? AppSpacing.lg : AppSpacing.md),
        _roleBlock(size, isDark),
        SizedBox(height: isWide ? AppSpacing.lg : AppSpacing.md),
        _availabilityBanner(isDark, isWide),
        SizedBox(height: isWide ? AppSpacing.lg : AppSpacing.md),
        _ctaRow(isDark),
        SizedBox(height: isWide ? AppSpacing.xxl : AppSpacing.xl),
        _footerStrip(size, l10n, isDark),
        // Desktop scroll hint. Skipped on viewports under ~1000h so the
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
            decoration: const BoxDecoration(
              color: _accent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );

  Widget _wordmark(Size size, bool isDark) {
    return Semantics(
      header: true,
      label: AppLocalizations.of(context)!.semanticTitle,
      child: SizedBox(
        height: (size.height * 0.22).clamp(120.0, 260.0),
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
                      ? Colors.white.withValues(alpha: 0.28)
                      : AppColors.accentIndigoDeep.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _subline(Size size, bool isWide, bool isDark) {
    final letterSize = (size.width * 0.035).clamp(20.0, 40.0);
    final portraitSize = (size.width * 0.09).clamp(56.0, 96.0);
    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _portrait(portraitSize),
          SizedBox(width: portraitSize * 0.28),
          Text(
            'ALHYARI',
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              fontSize: letterSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 14,
              color: isDark ? Colors.white : AppColors.slate900,
              shadows: isDark
                  ? const [Shadow(color: Colors.black, blurRadius: 12)]
                  : const [Shadow(color: Colors.black12, blurRadius: 4)],
            ),
          ),
        ],
      );
    }
    return Column(
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
                ? const [Shadow(color: Colors.black, blurRadius: 12)]
                : const [Shadow(color: Colors.black12, blurRadius: 4)],
          ),
        ),
      ],
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
              _accent.withValues(alpha: 0.8),
              _gold.withValues(alpha: 0.4),
              _accent.withValues(alpha: 0.2),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: _accent.withValues(alpha: 0.25),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.5),
          child: Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: Image.asset(
              'assets/my_image.png',
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

  Widget _roleBlock(Size size, bool isDark) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: (size.width * 0.78).clamp(320.0, 700.0),
        ),
        child: Column(
          children: [
            _hairlineRow(
              isDark: isDark,
              child: const Text(
                '❖',
                style: TextStyle(color: _accent, fontSize: 13),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppLocalizations.of(context)!.introSeniorEngineer.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (size.width * 0.018).clamp(16.0, 22.0),
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
                fontSize: (size.width * 0.0115).clamp(12.5, 18.0),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: isDark ? _accentSoft : AppColors.accentIndigo600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppLocalizations.of(context)!.introTechStack,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (size.width * 0.011).clamp(11.5, 13.5),
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white.withValues(alpha: 0.82) : AppColors.slate600,
                height: 1.55,
                letterSpacing: 0.8,
              ),
            ),
          ],
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

  Widget _availabilityBanner(bool isDark, bool isWide) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? _accent.withValues(alpha: 0.1) : _accent.withValues(alpha: 0.05),
          border: Border.all(color: _accent.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flight_takeoff_outlined, color: _accent, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.introEuEligibility,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.slate900,
                  fontSize: isWide ? 13 : 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ctaRow(bool isDark) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        PrimaryButton(
          label: AppLocalizations.of(context)!.viewMyWork,
          onPressed: () {
            SoundService.instance.playClick();
            (widget.onViewWork ?? widget.onScrollDown)();
          },
        ),
        _ghostButton(
          label: AppLocalizations.of(context)!.downloadResume,
          icon: Icons.download_rounded,
          isDark: isDark,
          onPressed: () {
            SoundService.instance.playClick();
            (widget.onDownloadResume ?? widget.onScrollDown)();
          },
        ),
        _ghostButton(
          label: AppLocalizations.of(context)!.contactMe,
          icon: Icons.send_rounded,
          color: _accent,
          isDark: isDark,
          onPressed: () {
            SoundService.instance.playClick();
            (widget.onContactMe ?? widget.onScrollDown)();
          },
        ),
        _ghostButton(
          label: AppLocalizations.of(context)!.copyEmail,
          icon: Icons.content_copy_rounded,
          isDark: isDark,
          onPressed: () => _copyEmail(context),
        ),
      ],
    );
  }

  static const String _kEmail = 'alhyariabdallh@gmail.com';

  Future<void> _copyEmail(BuildContext context) async {
    SoundService.instance.playClick();
    await Clipboard.setData(const ClipboardData(text: _kEmail));
    if (!context.mounted) return;
    final loc = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: AppMotion.toast,
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.accentGreen, size: 16),
            const SizedBox(width: 8),
            Text(loc.emailCopied(_kEmail)),
          ],
        ),
      ),
    );
  }

  Widget _ghostButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    Color? color,
  }) {
    final effectiveColor = color ?? (isDark ? Colors.white70 : AppColors.slate700);
    final borderColor = isDark
        ? (color ?? Colors.white24)
        : (color ?? AppColors.slate300);

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: effectiveColor,
        side: BorderSide(color: borderColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }

  Widget _footerStrip(Size size, AppLocalizations l10n, bool isDark) {
    final isMobile = size.width < 640;

    Widget block(String label, String value, {Color? valueColor, VoidCallback? onTap, String? tooltip}) {
      final child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white.withValues(alpha: 0.72) : AppColors.slate500,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                Icon(Icons.arrow_outward, size: 9, color: valueColor ?? (isDark ? Colors.white70 : AppColors.slate500)),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? (isDark ? Colors.white : AppColors.slate900),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ],
      );

      if (onTap == null) return child;

      return Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          onTap: () {
            SoundService.instance.playClick();
            onTap();
          },
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: child,
        ),
      );
    }

    Widget divider() => Container(
          width: 1,
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.slate300,
        );

    final blocks = [
      block(AppLocalizations.of(context)!.introBasedIn, AppLocalizations.of(context)!.introLocation.toUpperCase(), valueColor: isDark ? _gold : const Color(0xFFB45309)),
      block(
        AppLocalizations.of(context)!.introStatus,
        AppLocalizations.of(context)!.introOpenForRoles,
        valueColor: isDark ? _accentSoft : AppColors.accentIndigo600,
        onTap: widget.onContactMe,
        tooltip: 'Jump to Contact',
      ),
      block(
        AppLocalizations.of(context)!.introDiscipline,
        AppLocalizations.of(context)!.introMobileArch,
        onTap: widget.onViewWork,
        tooltip: 'Jump to Work',
      ),
    ];

    return Column(
      children: [
        Row(children: [
          Expanded(child: Container(height: 1, color: isDark ? Colors.white24 : AppColors.slate300)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              AppLocalizations.of(context)!.introMasthead,
              style: TextStyle(
                color: isDark ? Colors.white.withValues(alpha: 0.7) : AppColors.slate500,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: isDark ? Colors.white24 : AppColors.slate300)),
        ]),
        const SizedBox(height: AppSpacing.md),
        if (isMobile)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              for (final b in blocks)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.slate200,
                    ),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: b,
                ),
            ],
          )
        else
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              blocks[0],
              divider(),
              blocks[1],
              divider(),
              blocks[2],
            ],
          ),
      ],
    );
  }
}
