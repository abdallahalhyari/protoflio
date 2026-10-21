import 'package:flutter/material.dart';

import 'package:profile/core/config/profile_links.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/shared/utils/career_facts.dart';
import 'package:profile/shared/utils/mrz.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

/// Which half of the sheet to show. Phones list About and Contact as two
/// sections, so each gets its own half instead of the whole sheet twice.
enum CredentialSheetPart { full, holder, reach }

/// The reverse of the site's credential: one sheet with the ways to reach
/// the holder, the holder's data fields, and a machine-readable zone.
///
/// Reach comes first because it is the page's job. Gold marks only what can
/// be tapped; teal draws the guilloche rules; nothing moves on its own.
class CredentialSheet extends StatelessWidget {
  const CredentialSheet({
    super.key,
    required this.isDesktop,
    required this.onSendEmail,
    required this.onCopyEmail,
    required this.onOpenUrl,
    required this.onOpenCv,
    this.part = CredentialSheetPart.full,
  });

  final bool isDesktop;
  final VoidCallback onSendEmail;
  final VoidCallback onCopyEmail;
  final ValueChanged<String> onOpenUrl;
  final VoidCallback onOpenCv;
  final CredentialSheetPart part;

  @override
  Widget build(BuildContext context) {
    final pad = isDesktop ? AppSpacing.xl : AppSpacing.lg;
    final reach = _Reach(
      isDesktop: isDesktop,
      onSendEmail: onSendEmail,
      onCopyEmail: onCopyEmail,
      onOpenUrl: onOpenUrl,
      onOpenCv: onOpenCv,
    );
    final holder = _Holder(isDesktop: isDesktop);

    if (part != CredentialSheetPart.full) {
      final isHolder = part == CredentialSheetPart.holder;
      return _Sheet(
        children: [
          Padding(
            padding: EdgeInsets.all(pad),
            child: isHolder ? holder : reach,
          ),
          if (isHolder) _MachineReadableZone(isDesktop: isDesktop),
        ],
      );
    }

    return _Sheet(
      children: [
        Padding(
          padding: EdgeInsets.all(pad),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: reach),
                    SizedBox(width: pad),
                    // The column rule is the holder's start border, so it
                    // grows with the content and mirrors under RTL.
                    Expanded(
                      flex: 5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            start: BorderSide(color: _guillocheColor(context)),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: pad),
                          child: holder,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    reach,
                    const SizedBox(height: AppSpacing.lg),
                    const _Guilloche(),
                    const SizedBox(height: AppSpacing.lg),
                    holder,
                  ],
                ),
        ),
        _MachineReadableZone(isDesktop: isDesktop),
      ],
    );
  }
}

/// The card stock itself: one surface, one border, square content inside.
class _Sheet extends StatelessWidget {
  const _Sheet({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: context.glassBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.container),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

Color _guillocheColor(BuildContext context) =>
    (context.isDarkMode ? AppColors.tealLight : AppColors.teal)
        .withValues(alpha: AppAlpha.border);

/// Hairline in guilloche teal — the security-print line of a credential.
class _Guilloche extends StatelessWidget {
  const _Guilloche();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 1,
        child: ColoredBox(color: _guillocheColor(context)),
      );
}

/// Small field label, the way a credential names its fields.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: AppTypography.label,
          fontWeight: FontWeight.w500,
          color: context.mutedText,
          height: 1.3,
        ),
      );
}

Color _tapGold(BuildContext context) =>
    context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;

class _Reach extends StatelessWidget {
  const _Reach({
    required this.isDesktop,
    required this.onSendEmail,
    required this.onCopyEmail,
    required this.onOpenUrl,
    required this.onOpenCv,
  });

  final bool isDesktop;
  final VoidCallback onSendEmail;
  final VoidCallback onCopyEmail;
  final ValueChanged<String> onOpenUrl;
  final VoidCallback onOpenCv;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final headingSize = isDesktop ? AppTypography.heading : AppTypography.title;
    final gold = _tapGold(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.contactHeaderTitle,
            style: TextStyle(
              fontSize: headingSize,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.02 * headingSize,
              height: 1.15,
              color: context.onSurface,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          // ~65 characters at body/lead size.
          constraints: const BoxConstraints(maxWidth: 540),
          child: Text(
            ltrContent(context, l10n.contactHeaderSubtitle),
            style: TextStyle(
              fontSize: isDesktop ? AppTypography.lead : AppTypography.body,
              height: 1.55,
              color: context.mutedText,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _FieldLabel(l10n.contactHeroEyebrow),
        const SizedBox(height: AppSpacing.xs),
        SelectableText(
          ltrAlways(context, ProfileLinks.email),
          style: TextStyle(
            fontSize: AppTypography.title,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: context.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.smd),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: onSendEmail,
              icon: const Icon(Icons.send_rounded, size: 16),
              label: Text(l10n.contactSendEmailBtn),
              style: FilledButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                textStyle: const TextStyle(
                  fontSize: AppTypography.body,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onCopyEmail,
              icon: const Icon(Icons.content_copy_rounded, size: 16),
              label: Text(l10n.contactCopyAddressBtn),
              style: TextButton.styleFrom(
                foregroundColor: gold,
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                textStyle: const TextStyle(
                  fontSize: AppTypography.body,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.contactReplyWindow,
          style: TextStyle(
            fontSize: AppTypography.label,
            height: 1.4,
            color: context.mutedText,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const _Guilloche(),
        _ChannelRow(
          label: l10n.contactLinkedin,
          value: ProfileLinks.linkedInHandle,
          action: l10n.contactViewProfile,
          icon: Icons.open_in_new_rounded,
          onTap: () => onOpenUrl(ProfileLinks.linkedIn),
        ),
        // One number, two ways to use it: one row, two actions.
        _ChannelRow(
          label: l10n.contactPhone,
          value: ProfileLinks.phoneDisplay,
          action: l10n.contactWhatsapp,
          actionSemantics:
              l10n.contactMessageWhatsapp(ProfileLinks.phoneDisplay),
          icon: Icons.open_in_new_rounded,
          onTap: () => onOpenUrl(ProfileLinks.whatsApp),
          secondAction: l10n.contactCall,
          secondActionSemantics:
              l10n.contactCallNumber(ProfileLinks.phoneDisplay),
          secondIcon: Icons.call_rounded,
          onSecondTap: () => onOpenUrl('tel:${ProfileLinks.phoneRaw}'),
        ),
        _ChannelRow(
          label: l10n.navResume,
          value: l10n.contactPdfSize,
          action: l10n.contactDownload,
          icon: Icons.download_rounded,
          onTap: onOpenCv,
          isLast: true,
        ),
      ],
    );
  }
}

/// One way to reach the holder: the trailing gold word says what happens.
/// With one action the whole row is the tap target; with a second action
/// (the phone number: WhatsApp or call) each word is its own button.
class _ChannelRow extends StatelessWidget {
  const _ChannelRow({
    required this.label,
    required this.value,
    required this.action,
    required this.icon,
    required this.onTap,
    this.actionSemantics,
    this.secondAction,
    this.secondActionSemantics,
    this.secondIcon,
    this.onSecondTap,
    this.isLast = false,
  });

  final String label;
  final String value;
  final String action;
  final String? actionSemantics;
  final IconData icon;
  final VoidCallback onTap;
  final String? secondAction;
  final String? secondActionSemantics;
  final IconData? secondIcon;
  final VoidCallback? onSecondTap;
  final bool isLast;

  bool get _hasTwoActions => secondAction != null && onSecondTap != null;

  @override
  Widget build(BuildContext context) {
    final gold = _tapGold(context);

    Widget actionWord(String text, IconData glyph) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w600,
                color: gold,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(glyph, size: 14, color: gold),
          ],
        );

    // Each action its own button, padded to a usable target.
    Widget actionButton(
      String text,
      String? semantics,
      IconData glyph,
      VoidCallback tap,
    ) =>
        Semantics(
          button: true,
          label: semantics ?? text,
          excludeSemantics: true,
          child: InkWell(
            onTap: tap,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.sm,
              ),
              child: actionWord(text, glyph),
            ),
          ),
        );

    final row = Container(
      constraints: const BoxConstraints(minHeight: 52),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(color: context.divider),
              ),
            ),
      child: LayoutBuilder(
        builder: (context, c) {
          // A phone number cut to "+962-78-…" is useless, so the value
          // scales down rather than truncating.
          final valueText = FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              ltrAlways(context, value),
              maxLines: 1,
              style: TextStyle(
                fontSize: AppTypography.body,
                fontWeight: FontWeight.w500,
                color: context.onSurface,
              ),
            ),
          );
          // Narrow rows stack the label over the value, like the
          // holder's fields, so the action words keep their room.
          final stacked =
              c.maxWidth < 340 || (_hasTwoActions && c.maxWidth < 420);
          // Two actions on a narrow row stack at the row's end, one over
          // the other, where every other row keeps its action word.
          if (_hasTwoActions && stacked) {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_FieldLabel(label), valueText],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    actionButton(action, actionSemantics, icon, onTap),
                    actionButton(
                      secondAction!,
                      secondActionSemantics,
                      secondIcon ?? icon,
                      onSecondTap!,
                    ),
                  ],
                ),
              ],
            );
          }
          return Row(
            children: [
              if (stacked)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_FieldLabel(label), valueText],
                    ),
                  ),
                )
              else ...[
                SizedBox(width: 92, child: _FieldLabel(label)),
                Expanded(child: valueText),
              ],
              const SizedBox(width: AppSpacing.sm),
              if (_hasTwoActions) ...[
                actionButton(action, actionSemantics, icon, onTap),
                const SizedBox(width: AppSpacing.sm),
                actionButton(
                  secondAction!,
                  secondActionSemantics,
                  secondIcon ?? icon,
                  onSecondTap!,
                ),
              ] else
                actionWord(action, icon),
            ],
          );
        },
      ),
    );

    if (_hasTwoActions) return row;

    return MergeSemantics(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: row,
        ),
      ),
    );
  }
}

class _Holder extends StatelessWidget {
  const _Holder({required this.isDesktop});
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final portraitWidth = isDesktop ? 96.0 : 84.0;

    final facts = [
      // Field-length values: a document field is a phrase, not a
      // sentence. Each date appears once.
      (l10n.heroFactAvailableLabel, l10n.cardFactAvailableValue),
      (l10n.heroFactBasedLabel, l10n.cardFactBasedValue),
      (l10n.heroFactStudyLabel, l10n.cardFactStudyValue),
      (l10n.heroFactPermitLabel, l10n.cardFactPermitValue),
      (l10n.heroFactLanguagesLabel, l10n.heroFactLanguagesValue),
      (
        l10n.aboutExperienceLabel,
        l10n.aboutExperienceValue(CareerFacts.yearsOfExperience()),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Passport-photo proportions (35 × 45), not an avatar circle.
            Container(
              width: portraitWidth,
              height: portraitWidth * 45 / 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: context.glassBorderStrong),
                color: context.isDarkMode
                    ? AppColors.darkSurface
                    : AppColors.paper,
              ),
              clipBehavior: Clip.antiAlias,
              child: RetryingAssetImage(
                'assets/my_image.webp',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                filterQuality: FilterQuality.high,
                cacheWidth: 288,
                semanticLabel: l10n.semanticPortrait,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NameField(
                    label: l10n.cardFieldSurname,
                    value: l10n.cardSurname,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _NameField(
                    label: l10n.cardFieldGiven,
                    value: l10n.cardGivenName,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _Fact(label: l10n.cardFieldRole, value: l10n.cardRole),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.aboutStoryShort,
          style: TextStyle(
            fontSize: AppTypography.body,
            height: 1.55,
            color: context.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 360 ? 2 : 1;
            const gap = AppSpacing.md;
            final w = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: AppSpacing.smd,
              children: [
                for (final f in facts)
                  SizedBox(
                    width: w,
                    child: _Fact(label: f.$1, value: f.$2),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldLabel(label),
            Text(
              value,
              style: TextStyle(
                fontSize: AppTypography.title,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: context.onSurface,
              ),
            ),
          ],
        ),
      );
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldLabel(label),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: AppTypography.body,
                height: 1.45,
                color: context.onSurface,
              ),
            ),
          ],
        ),
      );
}

/// The credential's machine-readable zone: three real ICAO 9303 TD1 lines
/// (career start 2021-07, Brno from 2027-02) with correct check digits.
/// Pure texture for a sighted reader, so it stays out of the semantics tree;
/// every fact in it is already stated in words above.
class _MachineReadableZone extends StatelessWidget {
  const _MachineReadableZone({required this.isDesktop});
  final bool isDesktop;

  static final List<String> _lines = Mrz.td1(
    documentCode: 'I',
    issuingState: 'JOR',
    documentNumber: 'MOBILEENG',
    optional1: 'FLUTTER<ANDROID',
    birthDate: '210701',
    sex: '<',
    expiryDate: '270201',
    nationality: 'JOR',
    optional2: 'BRNO<CZE',
    surname: 'ALHYARI',
    givenNames: 'ABDALLAH',
  );

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return ExcludeSemantics(
      child: Container(
        color: isDark ? AppColors.darkSurface : AppColors.paper,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.xl : AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        // Always left-to-right: an MRZ is read by machines in one direction.
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isDesktop ? 460 : 360),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  _lines.join('\n'),
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    fontSize: AppTypography.cardMrz,
                    height: 1.5,
                    letterSpacing: 2.2,
                    color: context.subtleText,
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
