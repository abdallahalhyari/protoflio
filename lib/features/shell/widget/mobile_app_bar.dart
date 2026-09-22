import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/locale/locale_event.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:profile/core/bloc/navigation/navigation_bloc.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/shared/widget/conditional_blur.dart';
import 'portfolio_nav.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Public constant so callers (mobile scroll snap, section anchors)
  /// can offset by the app bar's fixed height without magic numbers.
  static const double kBarHeight = 60;

  final VoidCallback onMenuPressed;
  final VoidCallback? onLogoPressed;

  const MobileAppBar({
    super.key,
    required this.onMenuPressed,
    this.onLogoPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kBarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final tight = AppBreakpoints.isCompact(context);
    final ultraTight = MediaQuery.sizeOf(context).width < 360;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    return RepaintBoundary(
      child: ConditionalBlur(
        sigma: 18,
        child: Container(
          height: 60 + MediaQuery.paddingOf(context).top,
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top,
            left: ultraTight ? AppSpacing.sm : AppSpacing.md,
            right: ultraTight ? AppSpacing.sm : AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.glassSurface,
            border: Border(
              bottom: BorderSide(
                color: primary.withValues(alpha: isDark ? 0.28 : 0.16),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? AppColors.shadowMedium : AppColors.shadowSoft,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Brand signature
              Semantics(
                button: true,
                label: 'Abdallah Alhyari — return to top',
                child: InkWell(
                  onTap: () {
                    SoundService.instance.playClick();
                    onLogoPressed?.call();
                  },
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Monogram badge
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            gradient: LinearGradient(
                              colors: [primary, secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    primary.withValues(alpha: AppAlpha.border),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontFamily: AppTypography.displayFont,
                                color: Colors.white,
                                fontSize: AppTypography.subtitle,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ABDALLAH',
                              style: TextStyle(
                                fontFamily: AppTypography.displayFont,
                                color: context.onSurface,
                                fontSize: AppTypography.small,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.4,
                                height: 1.1,
                              ),
                            ),
                            if (!tight) _buildSubBadge(context, isDark),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Quick Controls
              // Language (hidden under 400px — reachable via slide-out menu)
              if (!tight) ...[
                BlocBuilder<LocaleBloc, LocaleState>(
                  builder: (_, localeState) {
                    final loc = localeState.locale;
                    final code = loc.languageCode.toUpperCase();
                    return Semantics(
                      button: true,
                      label: 'Change language. Current: $code',
                      child: Tooltip(
                        message: 'Change language ($code)',
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                          onTap: () {
                            SoundService.instance.playClick();
                            context
                                .read<LocaleBloc>()
                                .add(const NextLocaleRequested());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : AppColors.slate100,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.chip),
                              border: Border.all(
                                color: context.divider,
                              ),
                            ),
                            child: Text(
                              code,
                              style: TextStyle(
                                color: context.onSurface,
                                fontSize: AppTypography.editorial,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 6),
              ],

              // Theme
              BlocBuilder<ThemeBloc, ThemeState>(
                buildWhen: (prev, curr) => prev.mode != curr.mode,
                builder: (_, themeState) {
                  final dark = themeState.isDark;
                  return Semantics(
                    button: true,
                    toggled: dark,
                    label:
                        dark ? 'Switch to light mode' : 'Switch to dark mode',
                    child: IconButton(
                      tooltip:
                          dark ? 'Switch to light mode' : 'Switch to dark mode',
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: Icon(
                        dark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: context.mutedText,
                      ),
                      onPressed: () {
                        SoundService.instance.playClick();
                        context.read<ThemeBloc>().add(const ThemeModeToggled());
                      },
                    ),
                  );
                },
              ),

              const SizedBox(width: 6),

              // Audio (omitted on ultra-compact < 360px screens to prevent header overflow)
              if (!ultraTight) ...[
                const SizedBox(width: 6),
                ValueListenableBuilder<bool>(
                  valueListenable: SoundService.instance.isEnabled,
                  builder: (_, enabled, __) {
                    return Semantics(
                      button: true,
                      toggled: enabled,
                      label: enabled
                          ? 'Mute ambient audio'
                          : 'Enable ambient audio',
                      child: IconButton(
                        tooltip: enabled
                            ? 'Mute ambient audio'
                            : 'Enable ambient audio',
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        icon: Icon(
                          enabled
                              ? Icons.volume_up_outlined
                              : Icons.volume_off_outlined,
                          color: enabled
                              ? AppColors.accentAmber
                              : (isDark ? Colors.white38 : AppColors.slate400),
                        ),
                        onPressed: () {
                          SoundService.instance.toggle();
                        },
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(width: 6),

              // Menu Pill
              Semantics(
                button: true,
                label: 'Open navigation menu',
                child: InkWell(
                  onTap: () {
                    SoundService.instance.playClick();
                    onMenuPressed();
                  },
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ultraTight ? 8 : 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: isDark ? 0.22 : 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: primary.withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_rounded, size: 14, color: primary),
                        const SizedBox(width: 4),
                        Text(
                          'MENU',
                          style: TextStyle(
                            color: isDark ? Colors.white : primary,
                            fontSize: AppTypography.editorial,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sub-row under the ABDALLAH monogram. Falls back to the AVAILABLE
  /// presence dot when no controller is in scope; otherwise renders a
  /// live "03 · Engineering" chip so mobile users always see where they
  /// are without opening the menu.
  Widget _buildSubBadge(BuildContext context, bool isDark) {
    try {
      final page =
          context.select((NavigationBloc bloc) => bloc.state.pageIndex);
      final pageCount =
          context.select((NavigationBloc bloc) => bloc.state.pageCount);
      if (page < 0) return _availableBadge(isDark);
      final labels = TopNav.getLabels(context);
      if (page >= labels.length) return _availableBadge(isDark);

      final ordinal = (page + 1).toString().padLeft(2, '0');
      final denom = ' / ${pageCount.toString().padLeft(2, '0')}';
      final label = labels[page].toUpperCase();

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$ordinal$denom',
            style: const TextStyle(
              fontFamily: AppTypography.monoFont,
              color: AppColors.accentIndigo,
              fontSize: AppTypography.editorialSm,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 1,
            height: 8,
            color: context.glassBorderStrong,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: AnimatedSwitcher(
              duration: AppMotion.chipHover,
              child: Text(
                label,
                key: ValueKey(label),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppColors.slate600,
                  fontSize: AppTypography.micro,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ),
        ],
      );
    } catch (_) {
      return _availableBadge(isDark);
    }
  }

  Widget _availableBadge(bool isDark) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.accentGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'AVAILABLE',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppColors.slate600,
              fontSize: AppTypography.micro,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      );
}
