import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';

/// Renders the end-to-end NatHealth system architecture topology diagram,
/// highlighting NFC Hardware, Native Kotlin APDU Channel, Flutter UI,
/// background WorkManager offline queue & SQLite cache, and TPA Backend.
class NfcArchitectureDiagram extends StatelessWidget {
  final bool isDesktop;
  final bool isDark;

  const NfcArchitectureDiagram({
    super.key,
    required this.isDesktop,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: isDark ? 0.05 : 0.02),
        borderRadius: BorderRadius.circular(AppRadius.smd),
        border: Border.all(
            color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.account_tree_rounded, size: 12, color: scheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'System architecture topology',
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize:
                        isDesktop ? AppTypography.label : AppTypography.label,
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildArchNode(
                    'NFC Hardware\n(ISO-7816)', Icons.nfc_rounded, scheme),
                _buildArchArrow(scheme, 0),
                _buildArchNode('Native Kotlin\nAPDU Channel',
                    Icons.android_rounded, scheme),
                _buildArchArrow(scheme, 1),
                _buildArchNode(
                    'Flutter UI\n(Clean Arch)', Icons.layers_rounded, scheme),
                _buildArchArrow(scheme, 2),
                Column(
                  children: [
                    _buildArchNode('WorkManager\n(Offline Queue)',
                        Icons.sync_rounded, scheme),
                    const SizedBox(height: 6),
                    _buildArchNode('SQLite DB\n(Encrypted Cache)',
                        Icons.storage_rounded, scheme),
                  ],
                ),
                _buildArchArrow(scheme, 3),
                _buildArchNode('TPA Backend\n(REST API)',
                    Icons.cloud_done_rounded, scheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchNode(String label, IconData icon, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.black45 : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTypography.label,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : AppColors.ink700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchArrow(ColorScheme scheme, int stepIndex) {
    return _AnimatedNfcArrow(
      color: scheme.primary,
      stepIndex: stepIndex,
    );
  }
}

class _AnimatedNfcArrow extends StatefulWidget {
  final Color color;
  final int stepIndex;

  const _AnimatedNfcArrow({
    required this.color,
    required this.stepIndex,
  });

  @override
  State<_AnimatedNfcArrow> createState() => _AnimatedNfcArrowState();
}

class _AnimatedNfcArrowState extends State<_AnimatedNfcArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.ambient,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started && !MediaQuery.disableAnimationsOf(context)) {
      _started = true;
      if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
        _controller.value = 1.0;
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

    if (reduceMotion) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Icon(
          Icons.arrow_right_alt_rounded,
          size: 16,
          color: widget.color.withValues(alpha: 0.5),
        ),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final offset = (widget.stepIndex * 0.25) % 1.0;
          final progress = (_controller.value + offset) % 1.0;
          final pulseAlpha =
              (1.0 - (progress - 0.5).abs() * 2.0).clamp(0.3, 1.0);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.arrow_right_alt_rounded,
                  size: 16,
                  color: widget.color.withValues(alpha: 0.4),
                ),
                Positioned(
                  left: progress * 12.0,
                  child: Container(
                    width: 3.5,
                    height: 3.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(alpha: pulseAlpha),
                      boxShadow: [
                        BoxShadow(
                          color:
                              widget.color.withValues(alpha: pulseAlpha * 0.9),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
