import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/locale/locale_event.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

class AppBarLanguageToggle extends StatelessWidget {
  const AppBarLanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (_, localeState) {
        final loc = localeState.locale;
        final code = loc.languageCode.toUpperCase();
        return Semantics(
          button: true,
          label: 'Change language. Current: $code',
          child: Tooltip(
            message: 'Change language ($code)',
            excludeFromSemantics: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.chip),
              onTap: () {
                SoundService.instance.playClick();
                context.read<LocaleBloc>().add(const NextLocaleRequested());
              },
              child: ExcludeSemantics(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.ink100,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    border: Border.all(
                      color: context.divider,
                    ),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      color: context.onSurface,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
