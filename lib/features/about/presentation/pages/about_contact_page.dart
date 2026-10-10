import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/about/presentation/widgets/playground_grid.dart';
import 'package:profile/features/about/presentation/widgets/profile_tab.dart';
import 'package:profile/features/contact/presentation/widgets/contact_portal.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/page_activity.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/shared/widgets/scrollable_screen_shell.dart';
import 'package:profile/shared/widgets/section_masthead.dart';
import 'package:profile/shared/widgets/text_tabs.dart';

/// Unified Executive About & Direct Reach Out Screen.
/// Built from scratch with Linear/Raycast design aesthetics.
/// Merges Executive Profile & Credentials, Live Interactive Hardware/Crypto Lab,
/// and Direct Outreach Portal into a seamless 3-tab experience.
class AboutContactPage extends StatefulWidget {
  final bool isContinuousMobile;
  final int? initialTab;

  const AboutContactPage({
    super.key,
    this.isContinuousMobile = false,
    this.initialTab,
  });

  @override
  State<AboutContactPage> createState() => _AboutContactPageState();
}

class _AboutContactPageState extends State<AboutContactPage>
    with AutomaticKeepAliveClientMixin, ActivePageFocusMixin {
  final FocusNode _focusNode = FocusNode(debugLabel: 'AboutContactFocus');
  late int _tab;

  @override
  FocusNode get pageFocusNode => _focusNode;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tab = (widget.initialTab ?? AboutTabs.profile).clamp(0, 2);
    aboutTabRequest.addListener(_consumeRequest);
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumeRequest());
  }

  @override
  void dispose() {
    aboutTabRequest.removeListener(_consumeRequest);
    _focusNode.dispose();
    super.dispose();
  }

  void _consumeRequest() {
    final requested = aboutTabRequest.value;
    if (requested == null || !mounted) return;
    aboutTabRequest.value = null;
    setState(() => _tab = requested.clamp(0, 2));
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final k = event.logicalKey;
    if (k == LogicalKeyboardKey.arrowRight) {
      setState(() => _tab = (_tab + 1) % 3);
      return KeyEventResult.handled;
    } else if (k == LogicalKeyboardKey.arrowLeft) {
      setState(() => _tab = (_tab - 1 + 3) % 3);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final isDark = context.isDarkMode;
    final gold = isDark ? AppColors.goldSoft : AppColors.goldDeep;

    if (widget.isContinuousMobile) {
      return Focus(
        focusNode: _focusNode,
        child: ScrollableAppScreenShell(
          isContinuousMobile: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ContactPortal(isDesktop: false),
              const SizedBox(height: AppSpacing.xxl),
              ProfileTab(isDesktop: false),
              const SizedBox(height: AppSpacing.xxl),
              const PlaygroundGrid(),
            ],
          ),
        ),
      );
    }

    final tabs = <String>[
      l10n.aboutTabProfile,
      l10n.aboutTabPlayground,
      'Get In Touch',
    ];

    final Widget body = switch (_tab) {
      AboutTabs.playground => const PlaygroundGrid(),
      AboutTabs.contact => ContactPortal(isDesktop: isDesktop),
      _ => ProfileTab(isDesktop: isDesktop),
    };

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _onKey,
      child: ScrollableAppScreenShell(
        maxWidth: kSectionMaxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionMasthead(
              kicker: switch (_tab) {
                AboutTabs.playground =>
                  '06 · INTERACTIVE HARDWARE & CRYPTO LAB',
                AboutTabs.contact => '06 · DISPATCH & DIRECT CHANNELS',
                _ => '06 · EXECUTIVE CREDENTIALS & DOSSIER',
              },
              title: l10n.aboutTitle,
              subtitle: switch (_tab) {
                AboutTabs.playground =>
                  'Hands-on interactive simulators executing smart-card APDU exchanges, PBKDF2 key derivation, AES-GCM cryptography, and offline sync in real-time.',
                AboutTabs.contact => l10n.contactHeaderSubtitle,
                _ => l10n.aboutSubtitle,
              },
              isDesktop: isDesktop,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextTabs(
              labels: tabs,
              selected: _tab,
              accent: gold,
              onSelect: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: AppSpacing.md),
            AnimatedSwitcher(
              duration: AppMotion.switcher,
              child: ConstrainedBox(
                key: ValueKey(_tab),
                constraints: const BoxConstraints(minHeight: 460),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
