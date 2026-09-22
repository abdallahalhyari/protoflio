import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guardrails against token drift.
///
/// Every raw hex color, font size, or millisecond duration in
/// `lib/features/**` / `lib/shared/**` is a leak from the design system.
/// The audit swept the codebase clean; this test keeps it that way.
///
/// Adding a new violation? Route it through a token in `lib/theme/**`.
/// Genuinely bespoke value? Add it to the allow list below with a
/// one-line justification.
void main() {
  group('Design token lint', () {
    final scanRoots = ['lib/features', 'lib/shared'];

    test('no raw Color(0x...) hex literals outside theme/', () {
      final rx = RegExp(r'Color\(0x[0-9A-Fa-f]{8}\)');
      final hits = _scan(scanRoots, rx, allowList: const {});
      expect(hits, isEmpty,
          reason:
              'Raw hex colors must route through AppColors. Offenders:\n${hits.join('\n')}');
    });

    test('no raw fontSize numeric literals outside theme/', () {
      final rx = RegExp(r'fontSize:\s*[0-9]+\.?[0-9]*[,)]');
      final hits = _scan(scanRoots, rx, allowList: const {});
      expect(hits, isEmpty,
          reason:
              'Raw fontSize must route through AppTypography. Offenders:\n${hits.join('\n')}');
    });

    test('no raw Duration(milliseconds: N) outside theme/', () {
      final rx = RegExp(r'Duration\(milliseconds:\s*[0-9]+\)');
      // Bespoke interaction cadences with no shared intent match.
      // Keep these named locally instead of inflating AppMotion.
      final allow = <String>{
        'lib/features/shell/widget/desktop_scroll_interceptor.dart', // wheel cooldown, 320ms
        'lib/features/case_study/widget/case_study_reading_companion.dart', // typewriter tick, 60ms
        'lib/features/engineering/bloc/architecture_simulator_bloc.dart', // simulation ticker, 2200ms
      };
      final hits = _scan(scanRoots, rx, allowList: allow);
      expect(hits, isEmpty,
          reason:
              'Raw Durations must route through AppMotion. Offenders:\n${hits.join('\n')}');
    });
  });
}

List<String> _scan(
  List<String> roots,
  RegExp pattern, {
  required Set<String> allowList,
}) {
  final hits = <String>[];
  for (final root in roots) {
    final dir = Directory(root);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true, followLinks: false)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final relPath = entity.path;
      if (allowList.contains(relPath)) continue;
      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        // Skip full-line comments to keep documentation examples free.
        final trimmed = line.trimLeft();
        if (trimmed.startsWith('//') || trimmed.startsWith('///')) continue;
        if (pattern.hasMatch(line)) {
          hits.add('$relPath:${i + 1}: ${line.trim()}');
        }
      }
    }
  }
  return hits;
}
