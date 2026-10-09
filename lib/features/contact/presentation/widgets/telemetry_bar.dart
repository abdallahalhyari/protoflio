import 'dart:async';

import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/editorial_chip.dart';
import 'package:profile/shared/widgets/pulsing_dot.dart';
import 'package:profile/l10n/app_localizations.dart';

class TelemetryBar extends StatefulWidget {
  const TelemetryBar({super.key});

  @override
  State<TelemetryBar> createState() => _TelemetryBarState();
}

class _TelemetryBarState extends State<TelemetryBar> {
  Timer? _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Amman time (UTC+3). _now is refreshed via a 10s Timer so the pill
    // ticks live with updated time and celestial phase.
    final ammanTime = _now.toUtc().add(const Duration(hours: 3));
    final hour = ammanTime.hour;
    final minute = ammanTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final isOfficeHours = hour >= 9 && hour < 19;
    final isDaytime = hour >= 6 && hour < 18;
    final isDark = context.isDarkMode;

    final dotColor = isDark ? AppColors.tealLight : AppColors.tealDeep;

    Widget pill({required Widget child, Color? border, Color? background}) =>
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: background ??
                (isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.white.withValues(alpha: 0.9)),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: border ?? context.glassBorder,
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        );

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.02)
              : AppColors.ink50.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : AppColors.ink200.withValues(alpha: 0.6),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            pill(
              border: dotColor.withValues(alpha: isDark ? 0.45 : 0.35),
              background: dotColor.withValues(alpha: isDark ? 0.08 : 0.05),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PulsingDot(color: dotColor),
                  const SizedBox(width: 7),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isOfficeHours
                            ? AppLocalizations.of(context)!.uiActiveHours
                            : AppLocalizations.of(context)!.uiStandbyAsync,
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          color: context.greenText,
                          fontSize: AppTypography.label,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            EditorialChip(
              label: 'AMMAN $displayHour:$minute $period (UTC+3)',
              icon: isDaytime
                  ? Icons.wb_sunny_rounded
                  : Icons.nights_stay_rounded,
              tone: isDaytime ? ChipTone.amber : ChipTone.indigo,
              variant: ChipVariant.glass,
            ),
          ],
        ),
      ),
    );
  }
}
