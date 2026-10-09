import 'dart:async';

import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/widgets/about_card.dart';
import 'package:profile/l10n/app_localizations.dart';

enum _ClaimState { queued, sending, retry, synced }

class _Claim {
  _Claim(this.number);
  final int number;
  _ClaimState state = _ClaimState.queued;
  int attempts = 0;
  int retrySeconds = 0;
}

/// A small simulation of the offline-first pipeline: claims queue on the
/// device while offline, then drain when connectivity returns, retrying a
/// flaky network with exponential backoff. No network is used.
class OfflineSyncDemo extends StatefulWidget {
  const OfflineSyncDemo({super.key});

  @override
  State<OfflineSyncDemo> createState() => _OfflineSyncDemoState();
}

class _OfflineSyncDemoState extends State<OfflineSyncDemo> {
  final List<_Claim> _claims = [];
  bool _online = false;
  bool _flaky = false;
  bool _draining = false;
  int _next = 1;

  @override
  void dispose() {
    _draining = false;
    super.dispose();
  }

  void _submit() {
    SoundService.instance.playClick();
    setState(() => _claims.add(_Claim(_next++)));
    _drain();
  }

  void _setOnline(bool online) {
    SoundService.instance.playSelection();
    setState(() => _online = online);
    if (online) _drain();
  }

  Future<void> _drain() async {
    if (_draining || !_online) return;
    _draining = true;
    try {
      while (mounted && _online) {
        final pending = _claims.where((c) => c.state != _ClaimState.synced);
        if (pending.isEmpty) break;
        final claim = pending.first;
        setState(() => claim.state = _ClaimState.sending);
        await Future<void>.delayed(AppMotion.xl);
        if (!mounted) return;
        if (!_online) {
          setState(() => claim.state = _ClaimState.queued);
          break;
        }
        // A flaky network fails the first two attempts; backoff doubles.
        if (_flaky && claim.attempts < 2) {
          claim.attempts++;
          final wait = 1 << (claim.attempts - 1);
          for (var s = wait; s > 0; s--) {
            if (!mounted) return;
            setState(() {
              claim.state = _ClaimState.retry;
              claim.retrySeconds = s;
            });
            await Future<void>.delayed(const Duration(seconds: 1));
            if (!_online) break;
          }
          if (!_online) {
            setState(() => claim.state = _ClaimState.queued);
            break;
          }
          continue;
        }
        setState(() => claim.state = _ClaimState.synced);
      }
    } finally {
      _draining = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final live = context.isDarkMode ? AppColors.tealLight : AppColors.tealDeep;
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;

    String label(_Claim c) => switch (c.state) {
          _ClaimState.queued => l10n.playSyncQueued,
          _ClaimState.sending => l10n.playSyncSending,
          _ClaimState.retry => l10n.playSyncRetry(c.retrySeconds),
          _ClaimState.synced => l10n.playSyncSynced,
        };
    Color color(_Claim c) => switch (c.state) {
          _ClaimState.queued => context.mutedText,
          _ClaimState.sending => gold,
          _ClaimState.retry => AppColors.signalLight,
          _ClaimState.synced => live,
        };

    final isDark = context.isDarkMode;

    return AboutCard(
      headerKicker: 'OFFLINE-FIRST // PIPELINE',
      headerTitle: 'EXPONENTIAL BACKOFF REPLICATION',
      engineStatus: _draining
          ? 'DRAINING_QUEUE'
          : (_online ? 'ONLINE_IDLE' : 'OFFLINE_BUFFERING'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.playSyncTitle,
            style: TextStyle(
              fontSize: AppTypography.title,
              fontWeight: FontWeight.w700,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.playSyncIntro,
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
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ChoiceChip(
                label: Text(l10n.playSyncOffline),
                selected: !_online,
                onSelected: (_) => _setOnline(false),
              ),
              ChoiceChip(
                label: Text(l10n.playSyncOnline),
                selected: _online,
                onSelected: (_) => _setOnline(true),
              ),
              FilterChip(
                label: Text(l10n.playSyncFlaky),
                selected: _flaky,
                onSelected: (v) => setState(() => _flaky = v),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.add_task_rounded, size: 16),
            label: Text(l10n.playSyncSubmit),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_claims.isEmpty)
            Text(
              l10n.playSyncEmpty,
              style: TextStyle(
                fontSize: AppTypography.body,
                color: context.mutedText,
              ),
            )
          else
            for (final c in _claims.reversed.take(5))
              Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.02)
                      : AppColors.ink50,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: color(c).withValues(alpha: isDark ? 0.3 : 0.2),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: AppMotion.snap,
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color(c),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color(c).withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.playSyncClaim(c.number),
                        style: TextStyle(
                          fontSize: AppTypography.body,
                          fontWeight: FontWeight.w600,
                          color: context.onSurface,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        label(c),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          fontSize: AppTypography.label,
                          fontWeight: FontWeight.w700,
                          color: color(c),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.playSyncNote,
            style: TextStyle(
              fontSize: AppTypography.label,
              color: context.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
