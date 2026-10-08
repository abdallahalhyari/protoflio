import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/widgets/hood_tab.dart';
import 'package:profile/features/about/presentation/widgets/key_derivation_demo.dart';
import 'package:profile/features/about/presentation/widgets/offline_sync_demo.dart';
import 'package:profile/features/about/presentation/widgets/profile_tab.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/shared/widgets/scrollable_screen_shell.dart';
import 'package:profile/shared/widgets/section_masthead.dart';

/// About: the engineering profile, what sits under the hood, and a small
/// playground of things that actually run.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key, this.isContinuousMobile = false});

  final bool isContinuousMobile;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with AutomaticKeepAliveClientMixin {
  int _tab = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;

    final tabs = [
      l10n.aboutTabProfile,
      l10n.aboutTabHood,
      l10n.aboutTabPlayground,
    ];

    final body = switch (_tab) {
      0 => ProfileTab(isDesktop: isDesktop),
      1 => HoodTab(isDesktop: isDesktop),
      _ => isDesktop
          ? const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: KeyDerivationDemo()),
                SizedBox(width: AppSpacing.lg),
                Expanded(child: OfflineSyncDemo()),
              ],
            )
          : const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KeyDerivationDemo(),
                SizedBox(height: AppSpacing.md),
                OfflineSyncDemo(),
              ],
            ),
    };

    return ScrollableAppScreenShell(
      maxWidth: kSectionMaxWidth,
      isContinuousMobile: widget.isContinuousMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionMasthead(
            title: l10n.aboutTitle,
            subtitle: l10n.aboutSubtitle,
            isDesktop: isDesktop,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < tabs.length; i++)
                ChoiceChip(
                  label: Text(tabs[i]),
                  selected: _tab == i,
                  selectedColor: gold.withValues(alpha: 0.18),
                  onSelected: (_) => setState(() => _tab = i),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedSwitcher(
            duration: AppMotion.switcher,
            child: ConstrainedBox(
              key: ValueKey(_tab),
              // Same minimum height on every tab, so the header does not
              // jump when the content is shorter.
              constraints: const BoxConstraints(minHeight: 460),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
