import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/widgets/aes_demo.dart';
import 'package:profile/features/about/presentation/widgets/apdu_demo.dart';
import 'package:profile/features/about/presentation/widgets/channel_demo.dart';
import 'package:profile/features/about/presentation/widgets/key_derivation_demo.dart';
import 'package:profile/features/about/presentation/widgets/offline_sync_demo.dart';

/// The five interactive simulators: two columns on wide screens, one column otherwise.
class PlaygroundGrid extends StatelessWidget {
  const PlaygroundGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = AppSpacing.lg;
    final demos = <Widget>[
      const ChannelDemo(),
      const ApduDemo(),
      const KeyDerivationDemo(),
      const AesDemo(),
      const OfflineSyncDemo(),
    ];

    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 900 ? 2 : 1;
      final columns = [
        for (var i = 0; i < cols; i++)
          [for (var j = i; j < demos.length; j += cols) (j, demos[j])],
      ];

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < columns.length; i++) ...[
            if (i > 0) const SizedBox(width: gap),
            Expanded(
              child: Column(
                children: [
                  for (var j = 0; j < columns[i].length; j++) ...[
                    if (j > 0) const SizedBox(height: gap),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(
                        milliseconds:
                            500 + (columns[i][j].$1 * 100).clamp(0, 500),
                      ),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: columns[i][j].$2,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    });
  }
}
