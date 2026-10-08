import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// ISO 7816-4 command APDU (CLA INS P1 P2 Lc data... Le).
class ApduCommand {
  const ApduCommand({
    required this.cla,
    required this.ins,
    required this.p1,
    required this.p2,
    this.data,
    this.le,
  });

  final int cla;
  final int ins;
  final int p1;
  final int p2;
  final List<int>? data;
  final int? le;
}

/// Response APDU — payload bytes plus the two-byte status word.
class ApduResponse {
  const ApduResponse({
    this.data,
    required this.sw1,
    required this.sw2,
  });

  final List<int>? data;
  final int sw1;
  final int sw2;

  int get sw => (sw1 << 8) | sw2;
}

/// A single command/response pairing with elapsed round-trip latency.
class ApduExchange {
  const ApduExchange({
    required this.command,
    required this.response,
    required this.elapsed,
    this.label,
  });

  final ApduCommand command;
  final ApduResponse response;
  final Duration elapsed;
  final String? label;
}

/// Visualizes an APDU exchange. Byte groups are tinted by their ISO 7816
/// field role (header / data / Le); the response status word colors by
/// range (9000 → ok, 61xx → warn, 6xxx → critical).
///
/// No eyebrow labels. Field names surface on long-press via tooltip.
class ApduTraceStrip extends StatelessWidget {
  const ApduTraceStrip({
    super.key,
    required this.exchange,
  });

  final ApduExchange exchange;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final (swTone, _, swLabel) = _statusWordTone(exchange.response.sw);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.ink950 : AppColors.ink50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: swTone.withValues(alpha: AppAlpha.border)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CommandRow(cmd: exchange.command, label: exchange.label),
          _LatencyGauge(elapsed: exchange.elapsed),
          _ResponseRow(
            rsp: exchange.response,
            swTone: swTone,
            swLabel: swLabel,
          ),
        ],
      ),
    );
  }

  static (Color, Color, String) _statusWordTone(int sw) {
    if (sw == 0x9000) {
      return (AppColors.statusOk, AppColors.tealLight, 'ok');
    }
    if ((sw & 0xFF00) == 0x6100) {
      return (AppColors.statusWarn, AppColors.goldSoft, 'more data');
    }
    if ((sw & 0xFF00) == 0x6200 || (sw & 0xFF00) == 0x6300) {
      return (AppColors.statusWarn, AppColors.goldSoft, 'warning');
    }
    return (AppColors.statusCritical, AppColors.signalLight, 'error');
  }
}

class _CommandRow extends StatelessWidget {
  const _CommandRow({required this.cmd, required this.label});
  final ApduCommand cmd;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              '>',
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: context.subtleText,
                fontSize: AppTypography.label,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label ?? 'cmd',
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: context.mutedText,
                fontSize: AppTypography.label,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        _ByteStrip(bytes: _commandBytes(cmd), roles: _commandRoles(cmd)),
      ],
    );
  }

  List<int> _commandBytes(ApduCommand c) {
    final out = <int>[c.cla, c.ins, c.p1, c.p2];
    if (c.data != null && c.data!.isNotEmpty) {
      out.add(c.data!.length);
      out.addAll(c.data!);
    }
    if (c.le != null) {
      out.add(c.le!);
    }
    return out;
  }

  List<_ByteRole> _commandRoles(ApduCommand c) {
    final roles = [
      _ByteRole.cla,
      _ByteRole.ins,
      _ByteRole.p1p2,
      _ByteRole.p1p2,
    ];
    if (c.data != null && c.data!.isNotEmpty) {
      roles.add(_ByteRole.length);
      for (var i = 0; i < c.data!.length; i++) {
        roles.add(_ByteRole.data);
      }
    }
    if (c.le != null) {
      roles.add(_ByteRole.le);
    }
    return roles;
  }
}

class _ResponseRow extends StatelessWidget {
  const _ResponseRow({
    required this.rsp,
    required this.swTone,
    required this.swLabel,
  });

  final ApduResponse rsp;
  final Color swTone;
  final String swLabel;

  @override
  Widget build(BuildContext context) {
    final bytes = <int>[
      if (rsp.data != null) ...rsp.data!,
      rsp.sw1,
      rsp.sw2,
    ];
    final roles = <_ByteRole>[
      if (rsp.data != null)
        for (final _ in rsp.data!) _ByteRole.data,
      _ByteRole.sw,
      _ByteRole.sw,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              '<',
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: context.subtleText,
                fontSize: AppTypography.label,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              rsp.sw.toRadixString(16).padLeft(4, '0').toUpperCase(),
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: swTone,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              swLabel,
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: context.mutedText,
                fontSize: AppTypography.label,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        _ByteStrip(bytes: bytes, roles: roles, swTone: swTone),
      ],
    );
  }
}

enum _ByteRole { cla, ins, p1p2, length, data, le, sw }

class _ByteStrip extends StatelessWidget {
  const _ByteStrip({
    required this.bytes,
    required this.roles,
    this.swTone,
  });

  final List<int> bytes;
  final List<_ByteRole> roles;
  final Color? swTone;

  Color _toneFor(_ByteRole role, bool isDark) {
    switch (role) {
      case _ByteRole.cla:
        return isDark ? AppColors.tealLight : AppColors.tealDeep;
      case _ByteRole.ins:
        return isDark ? AppColors.goldSoft : AppColors.goldDeep;
      case _ByteRole.p1p2:
        return isDark ? AppColors.signalLight : AppColors.signalDeep;
      case _ByteRole.length:
      case _ByteRole.le:
        return isDark ? AppColors.ink200 : AppColors.ink600;
      case _ByteRole.data:
        return isDark ? Colors.white.withValues(alpha: 0.78) : AppColors.ink700;
      case _ByteRole.sw:
        return swTone ?? AppColors.statusOk;
    }
  }

  String _fieldName(_ByteRole role) => switch (role) {
        _ByteRole.cla => 'CLA — class',
        _ByteRole.ins => 'INS — instruction',
        _ByteRole.p1p2 => 'P1/P2 — parameters',
        _ByteRole.length => 'Lc — command length',
        _ByteRole.data => 'data',
        _ByteRole.le => 'Le — expected length',
        _ByteRole.sw => 'SW1 SW2 — status word',
      };

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < bytes.length; i++) ...[
            Tooltip(
              message: _fieldName(roles[i]),
              child: Text(
                bytes[i].toRadixString(16).padLeft(2, '0').toUpperCase(),
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  color: _toneFor(roles[i], isDark),
                  fontSize: AppTypography.lead,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (i < bytes.length - 1) const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _LatencyGauge extends StatelessWidget {
  const _LatencyGauge({required this.elapsed});
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final ms = elapsed.inMicroseconds / 1000.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(Icons.arrow_downward_rounded,
              size: 14, color: context.subtleText),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${ms.toStringAsFixed(1)} ms',
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              color: context.subtleText,
              fontSize: AppTypography.label,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
