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

    Widget pill({required Widget child, Color? border}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: border ?? context.glassBorder,
            ),
          ),
          child: child,
        );

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          pill(
            border: (isDark ? AppColors.teal : AppColors.tealDeep)
                .withValues(alpha: 0.45),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PulsingDot(color: isDark ? AppColors.teal : AppColors.tealDeep),
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isOfficeHours
                          ? AppLocalizations.of(context)!.uiActiveHours
                          : AppLocalizations.of(context)!.uiStandbyAsync,
                      style: TextStyle(
                        color: context.greenText,
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          EditorialChip(
            label: 'AMMAN $displayHour:$minute $period (UTC+3)',
            icon:
                isDaytime ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
            tone: isDaytime ? ChipTone.amber : ChipTone.indigo,
            variant: ChipVariant.glass,
          ),
          EditorialChip(
            label: AppLocalizations.of(context)!.uiRelocating,
            icon: Icons.flight_takeoff_rounded,
            tone: ChipTone.amber,
          ),
        ],
      ),
    );
  }
}
