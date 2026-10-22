import 'package:flutter/material.dart';
import 'package:profile/core/services/boot_handoff.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/intro_cta_row.dart';
import 'package:profile/shared/widgets/scrollable_screen_shell.dart';

import 'package:profile/features/intro/presentation/widgets/hero/hero_statement.dart';
import 'package:profile/features/intro/presentation/widgets/hero/signal_trace.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';

/// Cover: what a recruiter screens for, in one view.
///   statement   name, one sentence about the work, availability, actions
///   trace       one NFC claim traced through every layer, as a live demo
/// Side by side on desktop, stacked on narrower screens. The name's reveal
/// is the cover's one motion; nothing drifts behind it. On a first visit
/// to the web build the boot screen has already shown the statement, so
/// only the trace card enters.
class IntroPage extends StatefulWidget {
  final VoidCallback onScrollDown;
  final VoidCallback? onViewWork;
  final VoidCallback? onDownloadResume;
  final bool isContinuousMobile;

  const IntroPage({
    super.key,
    required this.onScrollDown,
    this.onViewWork,
    this.onDownloadResume,
    this.isContinuousMobile = false,
  });

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  /// The cover's one scripted entrance. Plays once; revisits stay still.
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: AppMotion.coverEntrance,
  );

  /// The statement and actions were already on screen (the web boot
  /// screen's still of this cover): show them as they are.
  late final Animation<double> _statementReveal =
      bootScreenShowsCover() ? kAlwaysCompleteAnimation : _reveal;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _reveal.forward();
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.sizeOf(context);
    final isWide = AppBreakpoints.isDesktop(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statement = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroStatement(
          size: size,
          isDark: isDark,
          isWide: isWide,
          reveal: _statementReveal,
        ),
        SizedBox(
          height: isWide
              ? (size.height < 940 ? AppSpacing.md : AppSpacing.xl)
              : AppSpacing.lg,
        ),
        HeroStep(
          animation: _statementReveal,
          begin: 0.55,
          end: 0.95,
          child: IntroCtaRow(
            isDark: isDark,
            alignStart: true,
            onViewWork: widget.onViewWork ?? widget.onScrollDown,
            onDownloadResume: widget.onDownloadResume ?? widget.onScrollDown,
          ),
        ),
      ],
    );
    final credential = SignalTrace(
      isDark: isDark,
      isWide: isWide,
      reveal: _reveal,
    );

    final body = isWide
        ? Row(
            children: [
              Expanded(flex: 6, child: statement),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: credential,
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              statement,
              const SizedBox(height: AppSpacing.xl),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: credential,
              ),
            ],
          );

    return ScrollableAppScreenShell(
      maxWidth: 1200,
      isContinuousMobile: widget.isContinuousMobile,
      child: body,
    );
  }
}
