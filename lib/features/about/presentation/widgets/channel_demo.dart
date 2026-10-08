import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/widgets/about_card.dart';
import 'package:profile/features/about/presentation/widgets/hex_text.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Shows the real bytes Flutter's StandardMethodCodec puts on the wire for
/// a platform-channel call, and what the native side decodes.
class ChannelDemo extends StatefulWidget {
  const ChannelDemo({super.key});

  @override
  State<ChannelDemo> createState() => _ChannelDemoState();
}

class _ChannelDemoState extends State<ChannelDemo> {
  static const _methods = ['readCard', 'signToken', 'enqueueSync'];
  static const _timeouts = [1000, 5000, 15000];

  String _method = _methods.first;
  int _timeout = 5000;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;
    final live = context.isDarkMode ? AppColors.tealLight : AppColors.tealDeep;

    final call =
        MethodCall(_method, {'technology': 'IsoDep', 'timeoutMs': _timeout});
    const codec = StandardMethodCodec();
    final data = codec.encodeMethodCall(call);
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final decoded = codec.decodeMethodCall(data);

    return AboutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.playChanTitle,
            style: TextStyle(
              fontSize: AppTypography.title,
              fontWeight: FontWeight.w700,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.playChanIntro,
            style: TextStyle(
              fontSize: AppTypography.body,
              height: 1.5,
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.playChanMethod,
              style: TextStyle(
                  fontSize: AppTypography.label, color: context.mutedText)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in _methods)
                ChoiceChip(
                  label: Text(m,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(fontFamily: AppTypography.monoFont)),
                  selected: _method == m,
                  onSelected: (_) {
                    SoundService.instance.playSelection();
                    setState(() => _method = m);
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.playChanTimeout,
              style: TextStyle(
                  fontSize: AppTypography.label, color: context.mutedText)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in _timeouts)
                ChoiceChip(
                  label: Text('$t'),
                  selected: _timeout == t,
                  onSelected: (_) => setState(() => _timeout = t),
                ),
            ],
          ),
          MonoField(
            label: l10n.playChanBytes(bytes.length),
            value: hexBytes(bytes),
            color: gold,
          ),
          MonoField(
            label: l10n.playChanDecoded,
            value: '${decoded.method}(${decoded.arguments})',
            color: live,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.playChanNote,
            style: TextStyle(
                fontSize: AppTypography.label, color: context.mutedText),
          ),
        ],
      ),
    );
  }
}
