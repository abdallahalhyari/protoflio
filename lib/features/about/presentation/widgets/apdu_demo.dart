import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/widgets/about_card.dart';
import 'package:profile/features/about/presentation/widgets/hex_text.dart';
import 'package:profile/l10n/app_localizations.dart';

class _Exchange {
  const _Exchange(this.command, this.data, this.sw);
  final List<int> command;
  final List<int> data;
  final int sw;
}

/// A simulated card answering real ISO 7816-4 command APDUs.
class ApduDemo extends StatefulWidget {
  const ApduDemo({super.key});

  @override
  State<ApduDemo> createState() => _ApduDemoState();
}

class _ApduDemoState extends State<ApduDemo> {
  // Application identifier of the NFC Forum Type 4 tag application.
  static const _aid = [0xD2, 0x76, 0x00, 0x00, 0x85, 0x01, 0x01];

  static final _exchanges = [
    const _Exchange([0x00, 0xA4, 0x04, 0x00, 0x07, ..._aid, 0x00], [], 0x9000),
    _Exchange(const [0x00, 0xB0, 0x00, 0x00, 0x10],
        'claim-token-0001'.codeUnits, 0x9000),
    const _Exchange([
      0x00, 0xA4, 0x04, 0x00, 0x07, 0xA0, 0x00, 0x00, 0x00, 0x03, 0x10, 0x10, //
      0x00,
    ], [], 0x6A82),
    const _Exchange([0x80, 0xB0, 0x00, 0x00, 0x10], [], 0x6E00),
  ];

  int _selected = 0;

  String _swMeaning(AppLocalizations l10n, int sw) => switch (sw) {
        0x9000 => l10n.apduSw9000,
        0x6A82 => l10n.apduSw6A82,
        _ => l10n.apduSw6E00,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;
    final live = context.isDarkMode ? AppColors.tealLight : AppColors.tealDeep;
    final labels = [
      l10n.playApduSelect,
      l10n.playApduRead,
      l10n.playApduUnknown,
      l10n.playApduBadClass,
    ];
    final ex = _exchanges[_selected];
    final c = ex.command;
    final ok = ex.sw == 0x9000;

    // CLA INS P1 P2 [Lc data] [Le]
    final hasData = c.length > 5 && c[4] != 0 && c.length >= 5 + c[4];
    final lc = hasData ? c[4] : null;
    final body = hasData ? c.sublist(5, 5 + c[4]) : <int>[];
    final le = hasData
        ? (c.length > 5 + c[4] ? c[5 + c[4]] : null)
        : (c.length > 4 ? c[4] : null);

    Widget field(String name, List<int> bytes, Color color) => Padding(
          padding: const EdgeInsets.only(right: 12, bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  fontSize: AppTypography.label,
                  color: context.mutedText,
                ),
              ),
              Text(
                hexBytes(bytes),
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  fontSize: AppTypography.body,
                  color: color,
                ),
              ),
            ],
          ),
        );

    return AboutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.playApduTitle,
            style: TextStyle(
              fontSize: AppTypography.title,
              fontWeight: FontWeight.w700,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.playApduIntro,
            style: TextStyle(
              fontSize: AppTypography.body,
              height: 1.5,
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < labels.length; i++)
                ChoiceChip(
                  label: Text(labels[i]),
                  selected: _selected == i,
                  onSelected: (_) {
                    SoundService.instance.playSelection();
                    setState(() => _selected = i);
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.playApduCommand,
            style: TextStyle(
                fontSize: AppTypography.label, color: context.mutedText),
          ),
          const SizedBox(height: 4),
          Wrap(
            children: [
              field('CLA', [c[0]], gold),
              field('INS', [c[1]], gold),
              field('P1', [c[2]], gold),
              field('P2', [c[3]], gold),
              if (lc != null) field('Lc', [lc], gold),
              if (body.isNotEmpty) field('Data', body, context.onSurface),
              if (le != null) field('Le', [le], gold),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.playApduResponse,
            style: TextStyle(
                fontSize: AppTypography.label, color: context.mutedText),
          ),
          const SizedBox(height: 4),
          Wrap(
            children: [
              if (ex.data.isNotEmpty) ...[
                field('Data', ex.data, context.onSurface),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '"${String.fromCharCodes(ex.data)}"',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontSize: AppTypography.body,
                      color: context.mutedText,
                    ),
                  ),
                ),
              ],
              field('SW1 SW2', [ex.sw >> 8, ex.sw & 0xFF],
                  ok ? live : AppColors.signalLight),
            ],
          ),
          Text(
            '${l10n.playApduStatus}: ${_swMeaning(l10n, ex.sw)}',
            style: TextStyle(
              fontSize: AppTypography.body,
              fontWeight: FontWeight.w700,
              color: ok ? live : AppColors.signalLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.playApduNote,
            style: TextStyle(
                fontSize: AppTypography.label, color: context.mutedText),
          ),
        ],
      ),
    );
  }
}
