import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// The NatHealth system as a flow: NFC hardware, the native Kotlin APDU
/// channel, the Flutter UI, the offline queue and encrypted cache side by
/// side, then the TPA backend. A row where the nodes stay legible; a
/// column on narrow screens, where a scaled-down row became unreadable.
class NfcArchitectureDiagram extends StatelessWidget {
  final bool isDesktop;
  final bool isDark;

  /// Off where a heading above already names the diagram (case studies).
  final bool showTitle;

  const NfcArchitectureDiagram({
    super.key,
    required this.isDesktop,
    required this.isDark,
    this.showTitle = true,
  });

  /// Below this width the row would have to shrink its text; stack instead.
  static const double _rowMinWidth = 640;

  static const _source = (
    'NFC Hardware\n(ISO-7816)',
    Icons.nfc_rounded,
  );
  static const _channel = (
    'Native Kotlin\nAPDU Channel',
    Icons.android_rounded,
  );
  static const _ui = ('Flutter UI\n(Clean Arch)', Icons.layers_rounded);
  static const _queue = ('WorkManager\n(Offline Queue)', Icons.sync_rounded);
  static const _cache = ('SQLite DB\n(Encrypted Cache)', Icons.storage_rounded);
  static const _backend = ('TPA Backend\n(REST API)', Icons.cloud_done_rounded);

  @override
  Widget build(BuildContext context) {
    final line = isDark ? AppColors.tealLight : AppColors.tealDeep;

    return Semantics(
      container: true,
      label: 'NatHealth architecture: NFC hardware to native Kotlin APDU '
          'channel to Flutter UI, then WorkManager offline queue and '
          'encrypted SQLite cache, to the TPA backend',
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(isDesktop ? AppSpacing.md : AppSpacing.smd),
        decoration: BoxDecoration(
          color: context.onSurface.withValues(alpha: isDark ? 0.03 : 0.02),
          borderRadius: BorderRadius.circular(AppRadius.smd),
          border: Border.all(color: context.divider),
        ),
        child: ExcludeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showTitle) ...[
                Text(
                  'System architecture topology',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.mutedText,
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              LayoutBuilder(
                builder: (context, c) => c.maxWidth >= _rowMinWidth
                    ? _row(context, line)
                    : _column(context, line),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, Color line) {
    Widget arrow() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.arrow_forward_rounded, size: 16, color: line),
        );
    return Row(
      children: [
        Expanded(child: _node(context, _source, line)),
        arrow(),
        Expanded(child: _node(context, _channel, line)),
        arrow(),
        Expanded(child: _node(context, _ui, line)),
        arrow(),
        Expanded(
          child: Column(
            children: [
              _node(context, _queue, line),
              const SizedBox(height: 6),
              _node(context, _cache, line),
            ],
          ),
        ),
        arrow(),
        Expanded(child: _node(context, _backend, line)),
      ],
    );
  }

  Widget _column(BuildContext context, Color line) {
    Widget arrow() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Icon(Icons.arrow_downward_rounded, size: 16, color: line),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _node(context, _source, line, inline: true),
        arrow(),
        _node(context, _channel, line, inline: true),
        arrow(),
        _node(context, _ui, line, inline: true),
        arrow(),
        // The queue and the cache work side by side.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _node(context, _queue, line, inline: true)),
              const SizedBox(width: 6),
              Expanded(child: _node(context, _cache, line, inline: true)),
            ],
          ),
        ),
        arrow(),
        _node(context, _backend, line, inline: true),
      ],
    );
  }

  /// One box. [inline] puts the icon beside the label (stacked layout);
  /// otherwise above it (row layout).
  Widget _node(
    BuildContext context,
    (String, IconData) node,
    Color line, {
    bool inline = false,
  }) {
    final (label, icon) = node;
    final text = Text(
      label,
      textAlign: inline ? TextAlign.start : TextAlign.center,
      style: TextStyle(
        fontSize: AppTypography.label,
        fontWeight: FontWeight.w600,
        color: context.onSurface.withValues(alpha: 0.85),
        height: 1.3,
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: context.divider),
      ),
      child: inline
          ? Row(
              children: [
                Icon(icon, size: 16, color: line),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: text),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: line),
                const SizedBox(height: 4),
                text,
              ],
            ),
    );
  }
}
