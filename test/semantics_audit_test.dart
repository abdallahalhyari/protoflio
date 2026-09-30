import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/features/case_study/case_study_nathealth.dart';
import 'package:profile/features/contact/page/contact_page.dart';
import 'package:profile/features/engineering/page/engineering_page.dart';
import 'package:profile/features/experience/presentation/pages/experience_page.dart';
import 'package:profile/features/hats/page/hats_grid_page.dart';
import 'package:profile/features/projects/presentation/pages/projects_page.dart';
import 'package:profile/features/skills/presentation/pages/skills_page.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/main.dart';
import 'package:profile/theme/app_theme.dart';

/// What a screen reader announces for each control, section by section.
///
/// Flutter builds the web accessibility tree from these nodes, so the
/// checks below are what a VoiceOver / NVDA / TalkBack user hears:
///  * no control inside another control (read twice, one of them dead);
///  * no label saying the same thing twice ("Go to Home Home");
///  * every control has a name, and is reachable by keyboard focus (so a
///    screen reader follows Tab to it).

String _norm(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ')
    .trim();

/// A phrase of [minWords]+ words, or one longer word, that appears twice.
String? _repeat(String label) {
  final words = _norm(label).split(' ').where((w) => w.isNotEmpty).toList();
  for (var n = words.length ~/ 2; n >= 1; n--) {
    final seen = <String>{};
    for (var i = 0; i + n <= words.length; i++) {
      final gram = words.sublist(i, i + n).join(' ');
      // Single short words ("to", "of", "1") repeat legitimately, and in
      // a sentence-length name so can a longer one.
      if (n == 1 && (gram.length < 5 || words.length > 8)) continue;
      if (!seen.add(gram)) return gram;
    }
  }
  return null;
}

List<String> _audit(WidgetTester tester) {
  final problems = <String>{};
  final root = tester.binding.rootPipelineOwner;
  SemanticsNode? rootNode;
  void findRoot(PipelineOwner owner) {
    rootNode ??= owner.semanticsOwner?.rootSemanticsNode;
    owner.visitChildren(findRoot);
  }

  findRoot(root);
  // Anything announced as a button, or that a tap activates.
  bool isControl(SemanticsData d) =>
      d.flagsCollection.isButton || d.hasAction(SemanticsAction.tap);

  void walk(SemanticsNode node, SemanticsNode? controlAncestor) {
    final data = node.getSemanticsData();
    if (data.flagsCollection.isHidden) return;
    // Folded into its parent's announcement (MergeSemantics): not a node
    // of its own for the screen reader.
    if (node.isMergedIntoParent) return;
    var ancestor = controlAncestor;
    if (isControl(data)) {
      final label = data.label.replaceAll('\n', ' ').trim();
      if (label.isEmpty && data.tooltip.isEmpty) {
        final parent = node.parent?.getSemanticsData();
        problems.add('unnamed control at ${node.rect} '
            '(actions ${data.actions}, in "${parent?.label ?? ''}")');
      }
      // Short names only: a long one is a card's worth of content, where
      // a word can fairly come up twice.
      final rep = label.split(' ').length <= 20 ? _repeat(label) : null;
      if (rep != null) problems.add('says "$rep" twice: "$label"');
      // Keyboard users reach it, and screen readers follow as they do.
      if (data.hasAction(SemanticsAction.tap) &&
          data.flagsCollection.isFocused == Tristate.none &&
          !data.flagsCollection.isLink) {
        problems.add('not keyboard-focusable: "$label"');
      }
      if (controlAncestor != null) {
        problems.add('control "$label" inside control '
            '"${controlAncestor.getSemanticsData().label.replaceAll('\n', ' ')}"');
      }
      ancestor = node;
    }
    node.visitChildren((child) {
      walk(child, ancestor);
      return true;
    });
  }

  if (rootNode != null) walk(rootNode!, null);
  return problems.toList();
}

void main() {
  for (final size in const [Size(1440, 900), Size(390, 844)]) {
    testWidgets('controls announce cleanly @ ${size.width.toInt()}',
        (tester) async {
      final handle = tester.ensureSemantics();
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(PortfolioApp(
          projectRepo: TestProjectRepository(),
          experienceRepo: TestExperienceRepository(),
          hatRepo: TestHatRepository(),
          skillRepo: TestSkillRepository(),
        ));
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      final problems = <String>{..._audit(tester)};
      if (size.width > 1000) {
        // Visit every section; each mounts its own controls.
        for (final key in [
          LogicalKeyboardKey.digit2,
          LogicalKeyboardKey.digit3,
          LogicalKeyboardKey.digit4,
          LogicalKeyboardKey.digit5,
          LogicalKeyboardKey.digit6,
          LogicalKeyboardKey.digit7,
        ]) {
          await tester.sendKeyEvent(key);
          for (var i = 0; i < 10; i++) {
            await tester.pump(const Duration(milliseconds: 200));
          }
          problems.addAll(_audit(tester));
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n'));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 2));
      handle.dispose();
    });
  }

  // Sections on their own on a very tall screen, so content below the fold
  // (built lazily in the app) is laid out and audited too.
  final pages = <String, Widget Function()>{
    'Experience': () =>
        ExperiencePage(controller: PageController(), pageIndex: 1),
    'Work': () => const ProjectsPage(),
    'Skills': () => const SkillsPage(),
    'Engineering': () => const EngineeringPage(),
    'Perspectives': () => const HatsGridPage(),
    'Contact': () => const ContactPage(),
    'Case study': () => const NatHealthCaseStudy(),
  };
  for (final entry in pages.entries) {
    testWidgets('${entry.key}, below the fold too', (tester) async {
      final handle = tester.ensureSemantics();
      tester.view.physicalSize = const Size(1440, 5000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
          BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: entry.value()),
        ),
      ));
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      final problems = _audit(tester);
      expect(problems, isEmpty, reason: problems.join('\n'));
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      handle.dispose();
    });
  }
}
