import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/widgets/about_card.dart';
import 'package:profile/l10n/app_localizations.dart';

class _Capability {
  const _Capability(this.mono, this.title, this.tag, this.detail, this.where,
      {this.hasDemo = false});
  final bool hasDemo;
  final String mono;
  final String title;
  final String tag;
  final String detail;
  final String where;
}

/// The capabilities behind the architectures: the kinds of problem I solve. Hover or tap a
/// capability to read what it means and where I used it.
class CapabilitiesView extends StatefulWidget {
  const CapabilitiesView({super.key, required this.isDesktop, this.onTryDemo});

  final bool isDesktop;

  /// Opens the Playground, for the capabilities that have a live demo.
  final VoidCallback? onTryDemo;

  @override
  State<CapabilitiesView> createState() => _CapabilitiesViewState();
}

class _CapabilitiesViewState extends State<CapabilitiesView> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;

    final items = [
      _Capability('ISO 7816 · APDU', l10n.hoodNfcTitle, l10n.hoodNfcTag,
          l10n.hoodNfcDetail, l10n.hoodNfcWhere,
          hasDemo: true),
      _Capability('RSA · AES · PBKDF2', l10n.hoodCryptoTitle,
          l10n.hoodCryptoTag, l10n.hoodCryptoDetail, l10n.hoodCryptoWhere,
          hasDemo: true),
      _Capability(
          'WorkManager',
          l10n.hoodBackgroundTitle,
          l10n.hoodBackgroundTag,
          l10n.hoodBackgroundDetail,
          l10n.hoodBackgroundWhere),
      _Capability('queue · retry · sync', l10n.hoodOfflineTitle,
          l10n.hoodOfflineTag, l10n.hoodOfflineDetail, l10n.hoodOfflineWhere,
          hasDemo: true),
      _Capability('MethodChannel', l10n.hoodNativeTitle, l10n.hoodNativeTag,
          l10n.hoodNativeDetail, l10n.hoodNativeWhere,
          hasDemo: true),
      _Capability(
          'HIS · ERP · LMS',
          l10n.hoodEnterpriseTitle,
          l10n.hoodEnterpriseTag,
          l10n.hoodEnterpriseDetail,
          l10n.hoodEnterpriseWhere),
    ];

    Widget tile(int i) {
      final c = items[i];
      final on = i == _selected;
      return MouseRegion(
        onEnter: (_) {
          if (widget.isDesktop && !on) setState(() => _selected = i);
        },
        child: Semantics(
          button: true,
          selected: on,
          label: '${c.title}. ${c.tag}',
          excludeSemantics: true,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.card),
            onTap: () {
              SoundService.instance.playSelection();
              setState(() => _selected = i);
            },
            child: AnimatedContainer(
              duration: AppMotion.snap,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.card),
                color: on ? gold.withValues(alpha: 0.10) : context.cardGlass,
                border: Border.all(
                  color: on ? gold.withValues(alpha: 0.8) : context.glassBorder,
                  width: on ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    c.title,
                    style: TextStyle(
                      fontSize: AppTypography.lead,
                      fontWeight: FontWeight.w700,
                      color: context.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    c.mono,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontSize: AppTypography.label,
                      color: on ? gold : context.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final sel = items[_selected];
    final detail = AboutCard(
      child: AnimatedSwitcher(
        duration: AppMotion.switcher,
        child: Column(
          key: ValueKey(_selected),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sel.title,
              style: TextStyle(
                fontSize: AppTypography.heading,
                fontWeight: FontWeight.w700,
                height: 1.15,
                color: context.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sel.tag,
              style: TextStyle(
                fontSize: AppTypography.lead,
                height: 1.4,
                color: gold,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              sel.detail,
              style: TextStyle(
                fontSize: AppTypography.lead,
                height: 1.6,
                color: context.onSurface.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.aboutWhereLabel,
              style: TextStyle(
                fontSize: AppTypography.label,
                color: context.mutedText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sel.where,
              style: TextStyle(
                fontSize: AppTypography.body,
                fontWeight: FontWeight.w700,
                color: context.onSurface,
              ),
            ),
            if (sel.hasDemo && widget.onTryDemo != null) ...[
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: widget.onTryDemo,
                child: Text(l10n.aboutTryIt),
              ),
            ],
          ],
        ),
      ),
    );

    final grid = LayoutBuilder(builder: (context, c) {
      final cols = widget.isDesktop ? 2 : (c.maxWidth >= 520 ? 2 : 1);
      const gap = 12.0;
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (var i = 0; i < items.length; i++)
            SizedBox(width: w, height: 92, child: tile(i)),
        ],
      );
    });

    if (!widget.isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.aboutHoodHint,
            style: TextStyle(
              fontSize: AppTypography.body,
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          grid,
          const SizedBox(height: AppSpacing.md),
          detail,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.aboutHoodHint,
                style: TextStyle(
                  fontSize: AppTypography.body,
                  color: context.mutedText,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              grid,
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(flex: 5, child: detail),
      ],
    );
  }
}
