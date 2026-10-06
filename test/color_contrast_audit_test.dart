import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/features/case_study/presentation/pages/case_study_nathealth.dart';
import 'package:profile/features/contact/presentation/pages/contact_page.dart';
import 'package:profile/features/engineering/presentation/pages/engineering_page.dart';
import 'package:profile/features/experience/presentation/pages/experience_page.dart';
import 'package:profile/features/hats/presentation/pages/hats_grid_page.dart';
import 'package:profile/features/intro/presentation/pages/intro_page.dart';
import 'package:profile/features/projects/presentation/pages/projects_page.dart';
import 'package:profile/features/skills/presentation/pages/skills_page.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/core/theme/tokens.dart';

/// Text drawn on a solid fill must meet WCAG AA: 4.5:1, or 3:1 for large
/// text. Lighthouse cannot check this here (Flutter paints to a canvas),
/// so walk the render tree instead: for every paragraph, composite the
/// fills behind it up to the first opaque one and compare.
///
/// Only solid fills are judged. Text over images, blurs or gradients with
/// transparent stops is out of reach and skipped rather than guessed at.

class _Finding {
  _Finding(this.text, this.ratio, this.needed, this.fg, this.bg);
  final String text;
  final double ratio;
  final double needed;
  final Color fg;
  final Color bg;

  String _hex(Color c) =>
      c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2);

  @override
  String toString() => '"$text" ${ratio.toStringAsFixed(2)}:1 '
      '(needs $needed) #${_hex(fg)} on #${_hex(bg)}';
}

Color _over(Color top, Color bottom) => Color.alphaBlend(top, bottom);

/// Fills behind [node], nearest first, stopping at the first opaque one.
/// A gradient layer contributes each of its stops as an alternative. Null
/// when a fill we cannot judge (image, translucent gradient) is in the way.
List<List<Color>>? _fillsBehind(RenderObject node) {
  final fills = <List<Color>>[];
  RenderObject child = node;
  RenderObject? current = node.parent;
  while (current != null) {
    // Text laid over a photo in a Stack: the fills further up are hidden
    // behind the image, so they say nothing about what the text sits on.
    if (current is RenderStack && _imageBelow(current, child)) return null;
    List<Color>? fill;
    if (current is RenderDecoratedBox &&
        current.position == DecorationPosition.background) {
      final decoration = current.decoration;
      if (decoration is BoxDecoration) {
        if (decoration.image != null) return null;
        final gradient = decoration.gradient;
        if (gradient != null) {
          // Judged at every stop; a translucent one lets unknown content
          // through.
          if (gradient.colors.any((c) => c.a < 1)) return null;
          fill = gradient.colors;
        } else if (decoration.color != null) {
          fill = [decoration.color!];
        }
      }
    } else if (current is RenderPhysicalShape) {
      fill = [current.color];
    } else if (current is RenderPhysicalModel) {
      fill = [current.color];
    }
    if (fill != null && fill.any((c) => c.a > 0)) {
      fills.add(fill);
      if (fill.every((c) => c.a >= 1)) return fills;
    }
    child = current;
    current = current.parent;
  }
  return fills;
}

/// Whether [stack] paints an image beneath its child [above].
bool _imageBelow(RenderStack stack, RenderObject above) {
  var found = false;
  var reached = false;
  bool containsImage(RenderObject node) {
    if (node is RenderImage) return true;
    var any = false;
    node.visitChildren((c) => any = any || containsImage(c));
    return any;
  }

  stack.visitChildren((c) {
    if (reached) return;
    if (identical(c, above)) {
      reached = true;
    } else if (containsImage(c)) {
      found = true;
    }
  });
  return found;
}

/// Every run of visible text in [paragraph] with its resolved style.
Iterable<(String, TextStyle)> _runs(RenderParagraph paragraph) sync* {
  final out = <(String, TextStyle)>[];
  void visit(InlineSpan span, TextStyle inherited) {
    final style = inherited.merge(span.style);
    if (span is TextSpan) {
      final text = span.text?.trim() ?? '';
      if (text.isNotEmpty) out.add((text, style));
      for (final child in span.children ?? const <InlineSpan>[]) {
        visit(child, style);
      }
    }
  }

  visit(paragraph.text, const TextStyle());
  yield* out;
}

bool _isLarge(TextStyle style, double textScale) {
  final size = (style.fontSize ?? 14) * textScale;
  final bold = (style.fontWeight ?? FontWeight.w400).value >= 700;
  // WCAG "large": 18pt (24px), or 14pt (18.66px) bold.
  return size >= 24 || (bold && size >= 18.66);
}

/// Opacity applied to [node] by its ancestors, 0 when hidden.
double _inheritedOpacity(RenderObject node) {
  var opacity = 1.0;
  RenderObject? current = node.parent;
  while (current != null) {
    if (current is RenderOpacity) opacity *= current.opacity;
    if (current is RenderAnimatedOpacity) {
      opacity *= current.opacity.value;
    }
    if (current is RenderOffstage && current.offstage) return 0;
    current = current.parent;
  }
  return opacity;
}

List<_Finding> _audit(WidgetTester tester, Color page) {
  final findings = <_Finding>[];
  final seen = <String>{};
  final root = tester.binding.rootElement!.renderObject!;
  void walk(RenderObject node) {
    if (node is RenderParagraph && node.hasSize && node.attached) {
      final opacity = _inheritedOpacity(node);
      // Hidden text, and text faded on purpose as decoration (watermarks),
      // is not content a reader is expected to read.
      if (opacity >= 0.99) {
        final fills = _fillsBehind(node);
        if (fills != null) {
          var backgrounds = [page];
          for (final layer in fills.reversed) {
            backgrounds = [
              for (final bg in backgrounds)
                for (final fill in layer) _over(fill, bg),
            ];
          }
          for (final (text, style) in _runs(node)) {
            final color = style.color;
            if (color == null || color.a < 0.3) continue;
            final isIcon = style.fontFamily == 'MaterialIcons';
            // Separators ("·", "/") carry no content of their own.
            if (!isIcon &&
                !RegExp(r'[\p{L}\p{N}]', unicode: true).hasMatch(text)) {
              continue;
            }
            // Icons are graphics: WCAG asks 3:1 of them, as of large text.
            final needed =
                isIcon || _isLarge(style, node.textScaler.scale(1)) ? 3.0 : 4.5;
            for (final bg in backgrounds) {
              final fg = _over(color, bg);
              final ratio = AppColors.contrastRatio(fg, bg);
              final key = '$text|${fg.toARGB32()}|${bg.toARGB32()}';
              if (ratio < needed && seen.add(key)) {
                final label = isIcon
                    ? 'icon U+${text.runes.first.toRadixString(16)}'
                    : text;
                findings.add(_Finding(label, ratio, needed, fg, bg));
              }
            }
          }
        }
      }
    }
    node.visitChildren(walk);
  }

  walk(root);
  return findings;
}

Widget _app(Widget child, Brightness brightness) {
  final mode = brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  final base =
      brightness == Brightness.dark ? AppTheme.dark() : AppTheme.light();
  return MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(create: (_) => ThemeBloc(initialMode: mode)),
      BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
    ],
    child: MaterialApp(
      theme: base,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  // One accent across the site, so every section is audited under the
  // same theme.
  final sections = <String, Widget Function()>{
    'Intro': () => IntroPage(onScrollDown: () {}),
    'Work': () => const ProjectsPage(),
    'Engineering': () => const EngineeringPage(),
    'Experience': () =>
        ExperiencePage(controller: PageController(), pageIndex: 3),
    'Skills': () => const SkillsPage(),
    'Perspectives': () => const HatsGridPage(),
    'Contact': () => const ContactPage(),
    'Case study': () => const NatHealthCaseStudy(),
  };

  for (final brightness in Brightness.values) {
    for (final size in const [Size(1280, 900), Size(390, 844)]) {
      for (final entry in sections.entries) {
        final build = entry.value;
        testWidgets(
            '${entry.key} text contrast, ${brightness.name} '
            '@ ${size.width.toInt()}', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.pumpWidget(_app(build(), brightness));
          // Let entrance animations settle.
          for (var i = 0; i < 20; i++) {
            await tester.pump(const Duration(milliseconds: 100));
          }
          final theme = brightness == Brightness.dark
              ? AppTheme.dark()
              : AppTheme.light();
          final findings = _audit(tester, theme.scaffoldBackgroundColor);
          expect(findings, isEmpty, reason: findings.join('\n'));
          await tester.pumpWidget(const SizedBox());
          await tester.pump(const Duration(seconds: 1));
        });
      }
    }
  }
}
