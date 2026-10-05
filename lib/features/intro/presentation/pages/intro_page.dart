import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/credential/credential_card.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/mailto.dart';
import 'package:profile/shared/widgets/primary_button.dart';
import 'package:profile/shared/widgets/scrollable_screen_shell.dart';

/// The cover: an issued credential beside one plain statement.
///
///   ┌──────────────┐   Abdallah Alhyari
///   │ ▣▣  Alhyari  │   Mobile apps that work offline,
///   │ [ ] Abdallah │   read smart cards and keep
///   │ I<JOR<AMMAN… │   patient data safe.
///   └──────────────┘   I'm a senior Flutter …
///   Tap the card…      [See the work]  [Download CV]
///                      Or email alhyariabdallh@gmail.com
///
/// The card is the one bold element; everything else stays quiet. Below
/// the tablet breakpoint the card stacks above the text.
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

const String _kEmail = 'alhyariabdallh@gmail.com';

class _IntroPageState extends State<IntroPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollableAppScreenShell(
      maxWidth: 1160,
      isContinuousMobile: widget.isContinuousMobile,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= AppBreakpoints.tablet;
          final statement = _CoverStatement(
            wide: wide,
            onViewWork: widget.onViewWork ?? widget.onScrollDown,
            onDownloadResume: widget.onDownloadResume ?? widget.onScrollDown,
          );
          if (wide) {
            final cardWidth = (constraints.maxWidth * 0.44).clamp(360.0, 520.0);
            return Row(
              children: [
                RepaintBoundary(child: CredentialCard(width: cardWidth)),
                const SizedBox(width: AppSpacing.xxl + AppSpacing.md),
                Expanded(child: statement),
              ],
            );
          }
          final cardWidth = constraints.maxWidth.clamp(0.0, 420.0);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              RepaintBoundary(child: CredentialCard(width: cardWidth)),
              const SizedBox(height: AppSpacing.lg),
              statement,
            ],
          );
        },
      ),
    );
  }
}

class _CoverStatement extends StatelessWidget {
  const _CoverStatement({
    required this.wide,
    required this.onViewWork,
    required this.onDownloadResume,
  });

  final bool wide;
  final VoidCallback onViewWork;
  final VoidCallback onDownloadResume;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final statementSize = wide
        ? (width * 0.034).clamp(AppTypography.display, 52.0)
        : AppTypography.heading + 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          loc.coverName,
          style: TextStyle(
            color: scheme.onSurface,
            fontSize: wide ? AppTypography.title : AppTypography.lead,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.smd),
        Semantics(
          header: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              loc.coverStatement,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: statementSize,
                fontWeight: FontWeight.w600,
                height: 1.12,
                letterSpacing: -0.022 * statementSize,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Text(
            loc.coverLead,
            style: TextStyle(
              color: context.mutedText,
              fontSize: wide ? AppTypography.lead + 1 : AppTypography.lead,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.smd,
          runSpacing: AppSpacing.smd,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            PrimaryButton(
              label: loc.viewMyWork,
              size: PrimaryButtonSize.lg,
              onPressed: () {
                SoundService.instance.playClick();
                onViewWork();
              },
            ),
            OutlinedButton.icon(
              onPressed: () {
                SoundService.instance.playClick();
                onDownloadResume();
              },
              icon: const Icon(Icons.download_rounded, size: 18),
              label: Text(loc.downloadResume),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.onSurface,
                side: BorderSide(color: context.glassBorderStrong),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                textStyle: const TextStyle(
                  fontSize: AppTypography.lead,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '${loc.coverEmailPrefix} ',
              style: TextStyle(
                color: context.mutedText,
                fontSize: AppTypography.body,
              ),
            ),
            _EmailLink(color: scheme.primary),
          ],
        ),
      ],
    );
  }
}

class _EmailLink extends StatefulWidget {
  const _EmailLink({required this.color});

  final Color color;

  @override
  State<_EmailLink> createState() => _EmailLinkState();
}

class _EmailLinkState extends State<_EmailLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => _open(),
          ),
        },
        child: GestureDetector(
          onTap: _open,
          child: Text(
            _kEmail,
            style: TextStyle(
              color: widget.color,
              fontSize: AppTypography.body,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor:
                  widget.color.withValues(alpha: _hovered ? 1 : 0.4),
              decorationThickness: _hovered ? 2 : 1,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _open() async {
    SoundService.instance.playClick();
    await launchUrl(mailtoUri(_kEmail));
  }
}
