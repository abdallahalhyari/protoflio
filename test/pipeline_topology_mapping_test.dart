import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/projects/data/models/project_model.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/presentation/widgets/pipeline_topology_diagram.dart';

/// The shipped project data, so a renamed project or company breaks here
/// instead of silently dropping a hand-drawn pipeline.
List<Project> _shippedProjects() {
  final raw = jsonDecode(File('assets/data/projects.json').readAsStringSync())
      as List<dynamic>;
  return raw
      .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<void> _pump(WidgetTester tester, Project p) => tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: PipelineTopologyDiagram(
              project: p,
              isDesktop: true,
              isDark: true,
            ),
          ),
        ),
      ),
    );

void main() {
  final projects = _shippedProjects();
  Project byCompany(String c) => projects.firstWhere((p) => p.company == c);

  testWidgets('NatHealth and ESKADENIA render their hand-drawn pipelines',
      (tester) async {
    await _pump(tester, byCompany('NatHealth'));
    expect(find.text('NFC APDU'), findsOneWidget);

    await _pump(tester, byCompany('ESKADENIA Software'));
    expect(find.text('Hospital REST'), findsOneWidget);
  });

  testWidgets('other projects show their own stack, never fleet stages',
      (tester) async {
    final solutions = byCompany('Solutions Now IT');
    await _pump(tester, solutions);
    expect(find.text(solutions.stack.first), findsOneWidget);
    for (final wrong in ['GPS Stream', 'Fleet Command', 'Inspection Form']) {
      expect(find.text(wrong), findsNothing, reason: wrong);
    }
  });

  test('Solutions Now IT is filed under its real domain', () {
    expect(byCompany('Solutions Now IT').domain, 'Consumer & Social');
  });
}
