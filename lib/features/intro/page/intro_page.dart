import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/features/intro/widget/intro_availability_banner.dart';
import 'package:profile/features/intro/widget/intro_cta_row.dart';
import 'package:profile/features/intro/widget/intro_footer_strip.dart';
import 'package:profile/shared/widget/scrollable_screen_shell.dart';
import 'package:profile/features/shell/widget/scroll_explore_hint.dart';
import 'package:profile/features/intro/widget/intro_constellation.dart';

import 'package:profile/features/intro/widget/hero/hero_issue_strip.dart';
import 'package:profile/features/intro/widget/hero/hero_wordmark.dart';
import 'package:profile/features/intro/widget/hero/hero_subline.dart';
import 'package:profile/features/intro/widget/hero/hero_role_block.dart';

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
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final AnimationController _rimController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _rimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMedia.reduceMotion(context)) {
      _rimController.stop();
    } else {
      _rimController.forward();
    }
  }

  @override
  void dispose() {
    _rimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.sizeOf(context);
    final isWide = AppBreakpoints.isDesktop(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompactH = isWide && size.height < 920;

    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeroIssueStrip(size: size, isDark: isDark),
        SizedBox(
            height:
                isCompactH ? 8.0 : (isWide ? AppSpacing.md : AppSpacing.sm)),
        HeroWordmark(
            size: size, isDark: isDark, isCompactH: isCompactH, isWide: isWide),
        SizedBox(
            height:
                isCompactH ? 8.0 : (isWide ? AppSpacing.smd : AppSpacing.xs)),
        HeroSubline(
            size: size,
            isWide: isWide,
            isDark: isDark,
            isCompactH: isCompactH,
            rimAnimation: _rimController),
        SizedBox(
            height:
                isCompactH ? 12.0 : (isWide ? AppSpacing.lg : AppSpacing.md)),
        HeroRoleBlock(size: size, isDark: isDark, isCompactH: isCompactH),
        SizedBox(
            height:
                isCompactH ? 12.0 : (isWide ? AppSpacing.lg : AppSpacing.md)),
        IntroAvailabilityBanner(isDark: isDark, isWide: isWide),
        SizedBox(
            height:
                isCompactH ? 12.0 : (isWide ? AppSpacing.lg : AppSpacing.md)),
        IntroCtaRow(
          isDark: isDark,
          onViewWork: widget.onViewWork ?? widget.onScrollDown,
          onDownloadResume: widget.onDownloadResume ?? widget.onScrollDown,
          onContactMe: widget.onContactMe ?? widget.onScrollDown,
        ),
        SizedBox(
            height:
                isCompactH ? 16.0 : (isWide ? AppSpacing.xxl : AppSpacing.xl)),
        IntroFooterStrip(
          isDark: isDark,
          onContactMe: widget.onContactMe,
          onViewWork: widget.onViewWork,
        ),
        if (isWide && !widget.isContinuousMobile && size.height >= 1000) ...[
          const SizedBox(height: AppSpacing.md),
          ScrollExploreHint(
            onTap: () {
              SoundService.instance.playClick();
              widget.onScrollDown();
            },
          ),
        ],
      ],
    );

    return IntroConstellation(
      isDark: isDark,
      child: ScrollableAppScreenShell(
        maxWidth: 1200,
        isContinuousMobile: widget.isContinuousMobile,
        child: body,
      ),
    );
  }
}
