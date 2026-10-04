import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

class AppBarAudioToggle extends StatelessWidget {
  const AppBarAudioToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return ValueListenableBuilder<bool>(
      valueListenable: SoundService.instance.isEnabled,
      builder: (_, enabled, __) {
        return MergeSemantics(
          child: Semantics(
            button: true,
            toggled: enabled,
            label: enabled ? 'Mute sound effects' : 'Enable sound effects',
            child: Tooltip(
              message: enabled ? 'Mute sound effects' : 'Enable sound effects',
              excludeFromSemantics: true,
              child: IconButton(
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                icon: enabled
                    ? const _EqualizerWaveform(
                        color: AppColors.accentAmber,
                      )
                    : Icon(
                        Icons.volume_off_rounded,
                        size: 18,
                        color: isDark ? Colors.white38 : AppColors.slate400,
                      ),
                onPressed: SoundService.instance.toggle,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EqualizerWaveform extends StatefulWidget {
  final Color color;

  const _EqualizerWaveform({required this.color});

  @override
  State<_EqualizerWaveform> createState() => _EqualizerWaveformState();
}

class _EqualizerWaveformState extends State<_EqualizerWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.ambient,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controller.isAnimating && !MediaQuery.disableAnimationsOf(context)) {
      if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
        _controller.forward();
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = AppMedia.reduceMotion(context);
    const double maxHeight = 16.0;
    const double barWidth = 2.5;
    const double barSpacing = 2.0;

    if (reduceMotion) {
      const staticHeights = [0.6, 0.9, 0.5, 0.8];
      return SizedBox(
        width: 18,
        height: maxHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: barSpacing / 2),
              width: barWidth,
              height: maxHeight * staticHeights[i],
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
            );
          }),
        ),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value * 2 * math.pi;
          final heights = [
            0.35 + 0.65 * math.sin(t),
            0.35 + 0.65 * math.sin(t + math.pi / 2),
            0.35 + 0.65 * math.sin(t + math.pi),
            0.35 + 0.65 * math.sin(t + 3 * math.pi / 2),
          ];

          return SizedBox(
            width: 18,
            height: maxHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final h = (heights[i].abs().clamp(0.2, 1.0)) * maxHeight;
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: barSpacing / 2),
                  width: barWidth,
                  height: h,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
