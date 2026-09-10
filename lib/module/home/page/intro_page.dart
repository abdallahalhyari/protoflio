import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../widget/primary_button.dart';
import '../widget/screen_shell.dart';

/// Intro reimagined as a premium magazine cover:
///   [issue strip]      TOP — small caps run + registration marks
///   ABDALLAH           HERO — outlined Tenada wordmark, full-bleed
///   ALHYARI • portrait  SUB — solid subline sitting next to a boxed portrait
///   [role kicker]      MID — role tagline stack over hairline rules
///   [CTA row]          BODY — 3 CTAs (view work / resume / contact)
///   [footer strip]     BASE — 3-column masthead footer: location · status · disciplines
class IntroPage extends StatefulWidget {
  final VoidCallback onScrollDown;
  final PageController controller;
  final int pageIndex;
  final VoidCallback? onViewWork;
  final VoidCallback? onDownloadResume;
  final VoidCallback? onContactMe;

  const IntroPage({
    super.key,
    required this.onScrollDown,
    required this.controller,
    required this.pageIndex,
    this.onViewWork,
    this.onDownloadResume,
    this.onContactMe,
    this.isContinuousMobile = false,
  });

  final bool isContinuousMobile;

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
        _ctaRow(isDark),
        SizedBox(height: isWide ? AppSpacing.xxl : AppSpacing.xl),
        _footerStrip(size, l10n, isDark),
      ],
    );

    return AppScreenShell(
      maxWidth: 1200,
      verticalPadding: widget.isContinuousMobile ? AppSpacing.md : AppSpacing.lg,
      reserveBottomNav: !widget.isContinuousMobile,
      reserveMobileTop: !widget.isContinuousMobile,
      child: widget.isContinuousMobile
          ? body
          : SingleChildScrollView(
              primary: false,
              physics: const ClampingScrollPhysics(),
              child: body,
            ),
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
              'ISSUE 01 · PORTFOLIO EDITION · MMXXVI',
              style: TextStyle(
                color: isDark ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF475569),
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
      label: 'Abdallah Alhyari, Senior Mobile Engineer',
      child: SizedBox(
        height: (size.height * 0.22).clamp(120.0, 260.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'ABDALLAH',
              style: TextStyle(
                fontFamily: 'Tenada',
                fontSize: 220,
                fontWeight: FontWeight.w900,
                letterSpacing: 10,
                height: 0.9,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = isDark
                      ? Colors.white.withValues(alpha: 0.28)
                      : const Color(0xFF6366F1).withValues(alpha: 0.25),
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
              fontFamily: 'Tenada',
              fontSize: letterSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 14,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
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
            fontFamily: 'Tenada',
            fontSize: letterSize,
            fontWeight: FontWeight.w800,
            letterSpacing: 10,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
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
      label: 'Portrait of Abdallah Alhyari',
      image: true,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
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
              filterQuality: FilterQuality.high,
              semanticLabel: 'Portrait of Abdallah Alhyari',
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
              'SENIOR FLUTTER & ANDROID ENGINEER',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (size.width * 0.018).clamp(16.0, 22.0),
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'BUILDS COMPLEX, RELIABLE, SCALABLE MOBILE SYSTEMS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (size.width * 0.0115).clamp(12.5, 18.0),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: isDark ? _accentSoft : const Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Flutter · Android · Architecture · Offline-first · NFC · Security · Real-time systems',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (size.width * 0.011).clamp(11.5, 13.5),
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white.withValues(alpha: 0.82) : const Color(0xFF475569),
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
    final ruleColor = isDark ? Colors.white24 : const Color(0xFFCBD5E1);
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: ruleColor)),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: child),
        Expanded(child: Container(height: 1, color: ruleColor)),
      ],
    );
  }

  Widget _ctaRow(bool isDark) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        PrimaryButton(
          label: 'VIEW MY WORK',
          onPressed: () {
            SoundService.instance.playClick();
            (widget.onViewWork ?? widget.onScrollDown)();
          },
        ),
        _ghostButton(
          label: 'DOWNLOAD RESUME',
          icon: Icons.download_rounded,
          isDark: isDark,
          onPressed: () {
            SoundService.instance.playClick();
            (widget.onDownloadResume ?? widget.onScrollDown)();
          },
        ),
        _ghostButton(
          label: 'CONTACT ME',
          icon: Icons.send_rounded,
          color: _accent,
          isDark: isDark,
          onPressed: () {
            SoundService.instance.playClick();
            (widget.onContactMe ?? widget.onScrollDown)();
          },
        ),
      ],
    );
  }

  Widget _ghostButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    Color? color,
  }) {
    final effectiveColor = color ?? (isDark ? Colors.white70 : const Color(0xFF334155));
    final borderColor = isDark
        ? (color ?? Colors.white24)
        : (color ?? const Color(0xFFCBD5E1));

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
                  color: isDark ? Colors.white.withValues(alpha: 0.72) : const Color(0xFF64748B),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                Icon(Icons.arrow_outward, size: 9, color: valueColor ?? (isDark ? Colors.white70 : const Color(0xFF64748B))),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
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
          borderRadius: BorderRadius.circular(8),
          child: child,
        ),
      );
    }

    Widget divider() => Container(
          width: 1,
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          color: isDark ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFCBD5E1),
        );

    final blocks = [
      block('BASED IN', l10n.introLocation.toUpperCase(), valueColor: isDark ? _gold : const Color(0xFFB45309)),
      block(
        'STATUS',
        'OPEN FOR SENIOR ROLES',
        valueColor: isDark ? _accentSoft : const Color(0xFF4F46E5),
        onTap: widget.onContactMe,
        tooltip: 'Jump to Contact',
      ),
      block(
        'DISCIPLINE',
        'MOBILE ARCHITECTURE',
        onTap: widget.onViewWork,
        tooltip: 'Jump to Work',
      ),
    ];

    return Column(
      children: [
        Row(children: [
          Expanded(child: Container(height: 1, color: isDark ? Colors.white24 : const Color(0xFFCBD5E1))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '// MASTHEAD',
              style: TextStyle(
                color: isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF64748B),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: isDark ? Colors.white24 : const Color(0xFFCBD5E1))),
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
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE2E8F0),
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
