import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/domain/aes.dart';
import 'package:profile/features/about/domain/pbkdf2.dart';
import 'package:profile/features/about/presentation/widgets/about_card.dart';
import 'package:profile/features/about/presentation/widgets/hex_text.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Password to PBKDF2 key to AES-256-CBC, both directions, real code.
class AesDemo extends StatefulWidget {
  const AesDemo({super.key});

  @override
  State<AesDemo> createState() => _AesDemoState();
}

class _AesDemoState extends State<AesDemo> {
  final _message = TextEditingController(text: 'Claim 4821: approved');
  final _password = TextEditingController(text: 'correct horse battery');
  final _decryptPassword = TextEditingController(text: 'correct horse battery');

  ({List<int> iv, List<int> cipher})? _encrypted;
  String? _plain;
  bool _failed = false;
  bool _busy = false;

  @override
  void dispose() {
    _message.dispose();
    _password.dispose();
    _decryptPassword.dispose();
    super.dispose();
  }

  Future<Aes> _keyFor(String password) async {
    final key = await Pbkdf2.derive(
      password: password,
      salt: 'portfolio-demo-salt',
      iterations: 2000,
    );
    return Aes(key);
  }

  Future<void> _encrypt() async {
    SoundService.instance.playClick();
    setState(() => _busy = true);
    final aes = await _keyFor(_password.text);
    final r = aes.encryptCbc(utf8.encode(_message.text));
    if (!mounted) return;
    setState(() {
      _busy = false;
      _encrypted = r;
      _plain = null;
      _failed = false;
    });
  }

  Future<void> _decrypt() async {
    final enc = _encrypted;
    if (enc == null) return;
    SoundService.instance.playClick();
    setState(() => _busy = true);
    final aes = await _keyFor(_decryptPassword.text);
    String? plain;
    var failed = false;
    try {
      plain =
          utf8.decode(aes.decryptCbc(enc.cipher, enc.iv), allowMalformed: true);
    } on FormatException {
      failed = true;
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _plain = plain;
      _failed = failed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;
    final live = context.isDarkMode ? AppColors.tealLight : AppColors.tealDeep;
    final enc = _encrypted;

    InputDecoration deco(String label) =>
        InputDecoration(labelText: label, border: const OutlineInputBorder());
    final mono = TextStyle(
      fontFamily: AppTypography.monoFont,
      fontSize: AppTypography.body,
      color: context.onSurface,
    );

    final isDark = context.isDarkMode;

    return AboutCard(
      headerKicker: 'AES-256-CBC // CIPHER',
      headerTitle: 'SYMMETRIC ENCRYPTION ENGINE',
      engineStatus: _busy
          ? 'CIPHER_BUSY'
          : (_failed
              ? 'MAC_MISMATCH'
              : (enc != null ? 'CIPHER_ACTIVE' : 'IDLE')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.playAesTitle,
            style: TextStyle(
              fontSize: AppTypography.title,
              fontWeight: FontWeight.w700,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.playAesIntro,
            style: TextStyle(
              fontSize: AppTypography.body,
              height: 1.5,
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _message,
            textDirection: TextDirection.ltr,
            style: mono,
            decoration: deco(l10n.playAesMessage),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _password,
            textDirection: TextDirection.ltr,
            style: mono,
            decoration: deco(l10n.playAesPassword),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: _busy ? null : _encrypt,
            icon: const Icon(Icons.lock_outline_rounded, size: 16),
            label: Text(l10n.playAesEncrypt),
          ),
          if (enc != null) ...[
            MonoField(
                label: l10n.playAesIv,
                value: hexBytes(enc.iv),
                color: context.mutedText),
            MonoField(
                label: l10n.playAesCipher,
                value: hexBytes(enc.cipher),
                color: gold),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _decryptPassword,
              textDirection: TextDirection.ltr,
              style: mono,
              decoration: deco(l10n.playAesDecryptWith),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: _busy ? null : _decrypt,
              icon: const Icon(Icons.lock_open_rounded, size: 16),
              label: Text(l10n.playAesDecrypt),
            ),
            if (_failed)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.signalLight
                        .withValues(alpha: isDark ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: AppColors.signalLight
                          .withValues(alpha: isDark ? 0.35 : 0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 16, color: AppColors.signalLight),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.playAesWrongKey,
                          style: const TextStyle(
                            fontSize: AppTypography.body,
                            fontWeight: FontWeight.w600,
                            color: AppColors.signalLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_plain != null)
              MonoField(label: l10n.playAesPlain, value: _plain!, color: live),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.playAesNote,
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
