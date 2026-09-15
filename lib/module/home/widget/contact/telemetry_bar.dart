import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';
import '../editorial_chip.dart';
import '../pulsing_dot.dart';

class TelemetryBar extends StatefulWidget {
  final bool isDark;
  const TelemetryBar({super.key, required this.isDark});

  @override
  State<TelemetryBar> createState() => _TelemetryBarState();
}

class _TelemetryBarState extends State<TelemetryBar> {
  Timer? _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
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
    // Amman time (UTC+3). _now is refreshed via a 30s Timer so the pill
    // ticks live instead of freezing at first paint, without rebuilding ContactPage.
    final ammanTime = _now.toUtc().add(const Duration(hours: 3));
    final hour = ammanTime.hour;
    final minute = ammanTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final isOfficeHours = hour >= 9 && hour < 19;
    final isDark = widget.isDark;

    Widget pill({required Widget child, Color? border}) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color:
                  border ?? (isDark ? Colors.white12 : AppColors.slate200),
              width: 1,
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
            border: AppColors.accentGreen.withValues(alpha: 0.45),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PulsingDot(color: AppColors.accentGreen),
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isOfficeHours
                          ? 'ACTIVE WORKING HOURS'
                          : 'STANDBY · ASYNC',
                      style: const TextStyle(
                        color: AppColors.accentGreen,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          EditorialChip(
            label: 'AMMAN $displayHour:$minute $period (UTC+3)',
            icon: Icons.access_time_rounded,
            variant: ChipVariant.glass,
          ),
          const EditorialChip(
            label: 'RELOCATING BRNO 2027',
            icon: Icons.flight_takeoff_rounded,
            variant: ChipVariant.filled,
            tone: ChipTone.amber,
          ),
        ],
      ),
    );
  }
}
