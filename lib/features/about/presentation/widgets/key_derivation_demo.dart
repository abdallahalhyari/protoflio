import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/domain/pbkdf2.dart';
import 'package:profile/features/about/presentation/widgets/about_card.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Real PBKDF2-HMAC-SHA256 running on the visitor's device, timed.
class KeyDerivationDemo extends StatefulWidget {
  const KeyDerivationDemo({super.key});

  @override
  State<KeyDerivationDemo> createState() => _KeyDerivationDemoState();
}

class _KeyDerivationDemoState extends State<KeyDerivationDemo> {
  static const _counts = [1000, 10000, 50000, 100000];

  final _password = TextEditingController(text: 'correct horse battery');
  int _iterations = 10000;
  bool _running = false;
  double _progress = 0;
  String? _hex;
  int? _ms;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    SoundService.instance.playClick();
    setState(() {
      _running = true;
      _progress = 0;
      _hex = null;
    });
    final watch = Stopwatch()..start();
    final key = await Pbkdf2.derive(
      password: _password.text,
      salt: 'portfolio-demo-salt',
      iterations: _iterations,
      onProgress: (p) {
        if (mounted) setState(() => _progress = p);
      },
    );
    watch.stop();
    if (!mounted) return;
    setState(() {
      _running = false;
      _hex = Pbkdf2.hex(key);
      _ms = watch.elapsedMilliseconds;
    });
  }

  String _fmt(int n) {
    final s = n.toString();
    return s.length > 3
        ? '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}'
        : s;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;
    final live = context.isDarkMode ? AppColors.tealLight : AppColors.tealDeep;

    return AboutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.playKdfTitle,
            style: TextStyle(
              fontSize: AppTypography.title,
              fontWeight: FontWeight.w700,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.playKdfIntro,
            style: TextStyle(
              fontSize: AppTypography.body,
              height: 1.5,
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _password,
            enabled: !_running,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              fontSize: AppTypography.body,
              color: context.onSurface,
            ),
            decoration: InputDecoration(
              labelText: l10n.playKdfPassword,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.playKdfIterations,
            style: TextStyle(
              fontSize: AppTypography.label,
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in _counts)
                ChoiceChip(
                  label: Text(_fmt(c)),
                  selected: _iterations == c,
                  onSelected:
                      _running ? null : (_) => setState(() => _iterations = c),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: _running ? null : _run,
            child: Text(_running ? l10n.playKdfRunning : l10n.playKdfRun),
          ),
          if (_running) ...[
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: _progress, color: gold),
          ],
          if (_hex != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.playKdfResult,
              style: TextStyle(
                fontSize: AppTypography.label,
                color: context.mutedText,
              ),
            ),
            const SizedBox(height: 4),
            SelectableText(
              _hex!,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                fontSize: AppTypography.body,
                height: 1.5,
                color: gold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.playKdfTime(_ms ?? 0),
              style: TextStyle(
                fontSize: AppTypography.label,
                color: live,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.playKdfNote,
            style: TextStyle(
              fontSize: AppTypography.label,
              height: 1.4,
              color: context.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
