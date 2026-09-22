import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/shared/widget/app_toast.dart';
import 'package:profile/shared/widget/status_badge.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/engineering/model/architecture_topic.dart';

class ArchitectureTelemetryStrip extends StatelessWidget {
  final DiagramStep step;
  final Color accentColor;
  final bool isDesktop;

  const ArchitectureTelemetryStrip({
    super.key,
    required this.step,
    required this.accentColor,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final payload = step.telemetryPayload ?? 'NO PAYLOAD DATA';
    final status = step.telemetryStatus ?? 'OK';
    final latency = step.latencyBudget ?? '< 10ms';

    return Container(
      decoration: BoxDecoration(
        color: context.terminalSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Terminal bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.md)),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatusBadge.dot(status: BadgeStatus.critical),
                    SizedBox(width: 5),
                    StatusBadge.dot(status: BadgeStatus.warn),
                    SizedBox(width: 5),
                    StatusBadge.dot(status: BadgeStatus.ok),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'TELEMETRY BUFFER // ${step.layer}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontSize: AppTypography.micro,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Copy Telemetry Command',
                  child: InkWell(
                    onTap: () {
                      SoundService.instance.playClick();
                      Clipboard.setData(ClipboardData(text: payload));
                      AppToast.show(
                        context,
                        message: 'Copied telemetry: $payload',
                        status: ToastStatus.ok,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(Icons.copy_rounded,
                          size: 13, color: Colors.white.withValues(alpha: 0.6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Terminal payload
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '> ',
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        color: accentColor,
                        fontWeight: FontWeight.w900,
                        fontSize: isDesktop ? 12 : 11,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        payload,
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          color: AppColors.slate200,
                          fontSize: isDesktop ? 12 : 10.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _TelemetryBadge(
                      label: 'STATUS',
                      value: status,
                      color: AppColors.statusOkLight,
                    ),
                    _TelemetryBadge(
                      label: 'LATENCY',
                      value: latency,
                      color: accentColor,
                    ),
                    const _TelemetryBadge(
                      label: 'GATE',
                      value: 'STRICT_PASS',
                      color: AppColors.statusInfo,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TelemetryBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TelemetryBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppAlpha.hover),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: AppTypography.editorialSm,
              fontWeight: FontWeight.w700,
            ),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: color,
                fontSize: AppTypography.editorialSm,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
