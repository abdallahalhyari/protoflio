import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Languages the excerpt knows. Each maps to a palette slot used as the
/// 4px left accent bar — language identity without a chrome chip.
enum CodeLanguage {
  dart('Dart', AppColors.gold, AppColors.goldDeep),
  kotlin('Kotlin', AppColors.teal, AppColors.tealDeep),
  swift('Swift', AppColors.signal, AppColors.signalDeep),
  java('Java', AppColors.goldDeep, AppColors.goldDeep),
  dartJson('JSON', AppColors.teal, AppColors.tealDeep),
  shell('Shell', AppColors.signal, AppColors.signalDeep);

  const CodeLanguage(this.label, this.accentDark, this.accentLight);
  final String label;
  final Color accentDark;
  final Color accentLight;
}

/// A code snippet rendered with language-keyed accent + optional focus
/// range. One mono family, three syntax tones, no chrome chips. The 4px
/// left bar is the only language signal in the header.
class CodeExcerpt extends StatelessWidget {
  const CodeExcerpt({
    super.key,
    required this.code,
    required this.language,
    this.highlight,
    this.copyable = true,
  });

  final String code;
  final CodeLanguage language;

  /// 1-indexed inclusive line range to spotlight with a secondary gutter
  /// bar. Nothing block-highlights — reading flow stays uniform.
  final (int, int)? highlight;

  final bool copyable;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final accent = isDark ? language.accentDark : language.accentLight;
    final lines = code.split('\n');
    final gutterWidth = _gutterFor(lines.length);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.ink950 : AppColors.ink50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.glassBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(
              language: language,
              accent: accent,
              code: code,
              copyable: copyable),
          Container(height: 1, color: context.divider),
          _Body(
            lines: lines,
            accent: accent,
            gutterWidth: gutterWidth,
            highlight: highlight,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  double _gutterFor(int lineCount) {
    // Width scales so the biggest line number sits snug.
    final digits = lineCount.toString().length;
    return 20.0 + digits * 7.0;
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.language,
    required this.accent,
    required this.code,
    required this.copyable,
  });

  final CodeLanguage language;
  final Color accent;
  final String code;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(width: 4, color: accent),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Text(
                language.label.toLowerCase(),
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  color: accent,
                  fontSize: AppTypography.label,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (copyable) _CopyButton(code: code, accent: accent),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.code, required this.accent});
  final String code;
  final Color accent;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(AppMotion.toast);
    if (!mounted) return;
    setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: _copied ? 'Code copied' : 'Copy code',
      child: InkWell(
        onTap: _copy,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Icon(
            _copied ? Icons.check_rounded : Icons.content_copy_rounded,
            size: 14,
            color: widget.accent,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.lines,
    required this.accent,
    required this.gutterWidth,
    required this.highlight,
    required this.isDark,
  });

  final List<String> lines;
  final Color accent;
  final double gutterWidth;
  final (int, int)? highlight;
  final bool isDark;

  bool _inHighlight(int oneBased) {
    final h = highlight;
    if (h == null) return false;
    return oneBased >= h.$1 && oneBased <= h.$2;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < lines.length; i++)
              _Line(
                number: i + 1,
                raw: lines[i],
                accent: accent,
                gutterWidth: gutterWidth,
                focus: _inHighlight(i + 1),
                isDark: isDark,
              ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.number,
    required this.raw,
    required this.accent,
    required this.gutterWidth,
    required this.focus,
    required this.isDark,
  });

  final int number;
  final String raw;
  final Color accent;
  final double gutterWidth;
  final bool focus;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: gutterWidth,
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Text(
              '$number',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: context.subtleText,
                fontSize: AppTypography.label,
                height: 1.6,
              ),
            ),
          ),
        ),
        Container(
          width: 2,
          color: focus ? accent : Colors.transparent,
          margin: const EdgeInsets.only(right: AppSpacing.sm),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: _SyntaxText(raw: raw, isDark: isDark),
        ),
      ],
    );
  }
}

/// Minimal syntax tinting — no full tokenizer. Catches comments, strings,
/// numbers, and a seed keyword set. Enough for a portfolio excerpt
/// without pulling in a heavy highlighter.
class _SyntaxText extends StatelessWidget {
  const _SyntaxText({required this.raw, required this.isDark});
  final String raw;
  final bool isDark;

  static const _keywords = {
    'class',
    'const',
    'final',
    'var',
    'void',
    'if',
    'else',
    'for',
    'while',
    'return',
    'await',
    'async',
    'import',
    'package',
    'extends',
    'implements',
    'with',
    'static',
    'this',
    'super',
    'new',
    'enum',
    'switch',
    'case',
    'default',
    'break',
    'continue',
    'true',
    'false',
    'null',
    'fun',
    'val',
    'func',
    'let',
    'struct',
    'protocol',
    'guard',
    'throws',
    'try',
    'catch',
  };

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontFamily: AppTypography.monoFont,
      fontSize: AppTypography.cardBody,
      color: context.onSurface,
      height: 1.6,
    );
    final comment =
        base.copyWith(color: context.subtleText, fontStyle: FontStyle.italic);
    final keyword = base.copyWith(
      color: isDark ? AppColors.tealLight : AppColors.tealDeep,
      fontWeight: FontWeight.w700,
    );
    final str =
        base.copyWith(color: isDark ? AppColors.goldSoft : AppColors.goldDeep);
    final num = base.copyWith(
        color: isDark ? AppColors.signalLight : AppColors.signalDeep);

    // Whole-line comment path.
    final trimmed = raw.trimLeft();
    if (trimmed.startsWith('//') || trimmed.startsWith('#')) {
      return Text(raw, style: comment);
    }

    final spans = <TextSpan>[];
    final pattern = RegExp(
      // Strings (single or double), numbers, identifiers, everything else.
      r'("[^"]*")|(' // strings
      r"'[^']*')|" // strings single
      r'(\b\d+\.?\d*\b)|' // numbers
      r'(\b[A-Za-z_][A-Za-z0-9_]*\b)|' // identifiers
      r'([^A-Za-z0-9_"'
      "'"
      r']+)',
    );
    for (final m in pattern.allMatches(raw)) {
      final text = m.group(0)!;
      if (m.group(1) != null || m.group(2) != null) {
        spans.add(TextSpan(text: text, style: str));
      } else if (m.group(3) != null) {
        spans.add(TextSpan(text: text, style: num));
      } else if (m.group(4) != null) {
        if (_keywords.contains(text)) {
          spans.add(TextSpan(text: text, style: keyword));
        } else {
          spans.add(TextSpan(text: text, style: base));
        }
      } else {
        spans.add(TextSpan(text: text, style: base));
      }
    }

    return Text.rich(TextSpan(style: base, children: spans), softWrap: false);
  }
}
