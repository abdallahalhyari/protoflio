import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/about/presentation/about_navigation.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

/// The cover's signature: one NFC claim traced through every layer of a
/// mobile system, Flutter UI to backend. A packet travels the path and each
/// layer lights as it arrives; hovering or focusing a layer pauses the
/// packet and says what happens there.
///
/// The header carries the recruiter facts (who, where, availability), so the
/// first screen answers "who is this and can I hire them" before the trace
/// is even touched.
class SignalTrace extends StatefulWidget {
  final bool isDark;
  final bool isWide;
  final Animation<double> reveal;
  final VoidCallback? onContactMe;

  const SignalTrace({
    super.key,
    required this.isDark,
    required this.isWide,
    required this.reveal,
    this.onContactMe,
  });

  @override
  State<SignalTrace> createState() => _SignalTraceState();
}

class _SignalTraceState extends State<SignalTrace>
    with SingleTickerProviderStateMixin {
  static const double _rowHeight = 66;
  static const int _steps = 5;

  late final AnimationController _run = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 6200),
  );

  int? _pinned;
  bool _started = false;
  bool _resumeOnUnpin = false;

  @override
  void initState() {
    super.initState();
    widget.reveal.addStatusListener(_onReveal);
    _run.addListener(_onTick);
    _run.addStatusListener((_) {
      if (mounted) setState(() {});
    });
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  void _onReveal(AnimationStatus status) {
    if (status != AnimationStatus.completed || _started || !mounted) return;
    _started = true;
    if (AppMedia.reduceMotion(context)) {
      _run.value = 1;
    } else {
      _run.forward(from: 0);
    }
  }

  @override
  void dispose() {
    widget.reveal.removeStatusListener(_onReveal);
    _run.dispose();
    super.dispose();
  }

  // Stage 0 dwells on the tap; every later stage is a hop then a dwell.
  ({int active, double y}) _position() {
    final t = _run.value;
    if (t <= 0) return (active: -1, y: _center(0));
    final s = (t * _steps).clamp(0.0, _steps - 0.0001);
    final k = s.floor();
    final f = s - k;
    if (k == 0) return (active: 0, y: _center(0));
    final hop = Curves.easeInOutCubic.transform((f / 0.55).clamp(0.0, 1.0));
    final y = _center(k - 1) + (_center(k) - _center(k - 1)) * hop;
    final arrived = f >= 0.5 || t >= 1;
    return (active: arrived ? k : k - 1, y: t >= 1 ? _center(_steps - 1) : y);
  }

  double _center(int i) => _rowHeight * i + _rowHeight / 2;

  void _pin(int? index) {
    if (_pinned == index) return;
    if (index != null && _pinned == null) {
      _resumeOnUnpin = _run.isAnimating;
      _run.stop();
    }
    if (index == null && _resumeOnUnpin && _run.value < 1) {
      _run.forward();
      _resumeOnUnpin = false;
    }
    setState(() => _pinned = index);
  }

  void _replay() {
    SoundService.instance.playClick();
    _started = true;
    _pinned = null;
    if (AppMedia.reduceMotion(context)) {
      _run.value = 1;
    } else {
      _run.forward(from: 0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = widget.isDark;
    final rule = context.glassBorderStrong;
    final gold = isDark ? AppColors.goldSoft : AppColors.goldDeep;
    final live = isDark ? AppColors.tealLight : AppColors.tealDeep;
    final muted = context.mutedText;

    final steps = [
      (l10n.traceStepFlutter, 'onTap() -> readCard()', l10n.traceDetailFlutter),
      (
        l10n.traceStepChannel,
        'MethodChannel.invokeMethod("readCard")',
        l10n.traceDetailChannel
      ),
      (
        l10n.traceStepNative,
        'IsoDep.transceive(SELECT, READ)',
        l10n.traceDetailNative
      ),
      (
        l10n.traceStepSecurity,
        'Keystore.sign(jwt) · WorkManager.enqueue()',
        l10n.traceDetailSecurity
      ),
      (
        l10n.traceStepBackend,
        'POST /claims -> 200 OK',
        l10n.traceDetailBackend
      ),
    ];

    final pos = _position();
    final shown = _pinned ?? (pos.active >= 0 ? pos.active : null);
    final finished = _run.value >= 1 && _pinned == null;
    final running = _run.isAnimating;

    final detail = shown == null ? l10n.traceHint : steps[shown].$3;

    final mono = TextStyle(
      fontFamily: AppTypography.monoFont,
      fontSize: AppTypography.label,
      height: 1.3,
    );

    Widget stepRow(int i) {
      final active = shown == i;
      final reached = pos.active >= i;
      final titleColor =
          active ? context.onSurface : (reached ? context.onSurface : muted);
      return SizedBox(
        height: _rowHeight,
        child: MouseRegion(
          onEnter: (_) => _pin(i),
          onExit: (_) => _pin(null),
          child: Semantics(
            button: true,
            label: '${steps[i].$1}. ${steps[i].$3}',
            excludeSemantics: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () => _pin(_pinned == i ? null : i),
              onFocusChange: (focused) => _pin(focused ? i : null),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 44, end: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i].$1,
                        style: TextStyle(
                          fontSize: AppTypography.lead,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        steps[i].$2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                        style: mono.copyWith(
                          color: active ? gold : muted.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: rule),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.teal.withValues(alpha: 0.5),
                        AppColors.gold.withValues(alpha: 0.35),
                      ]
                    : [
                        AppColors.tealLight.withValues(alpha: 0.55),
                        AppColors.goldSoft.withValues(alpha: 0.65),
                      ],
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Semantics(
              image: true,
              label: l10n.semanticPortrait,
              excludeSemantics: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Hero(
                  tag: 'abdallah_avatar_headshot',
                  child: RetryingAssetImage(
                    'assets/my_image.webp',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    cacheWidth: 192,
                    filterQuality: FilterQuality.high,
                    semanticLabel: l10n.semanticPortrait,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Abdallah Alhyari',
                  style: TextStyle(
                    fontSize: AppTypography.lead,
                    fontWeight: FontWeight.w700,
                    color: context.onSurface,
                  ),
                ),
                Text(
                  l10n.heroFactBasedValue,
                  style: TextStyle(
                    fontSize: AppTypography.label,
                    color: muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final availability = DecoratedBox(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: rule))),
      child: Semantics(
        button: widget.onContactMe != null,
        child: InkWell(
          onTap: widget.onContactMe == null
              ? null
              : () {
                  SoundService.instance.playClick();
                  widget.onContactMe!();
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 10),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration:
                            BoxDecoration(color: live, shape: BoxShape.circle),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.heroFactAvailableValue,
                        style: TextStyle(
                          fontSize: AppTypography.body,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          color: live,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 18),
                  child: Text(
                    l10n.heroFactPermitValue,
                    style: TextStyle(
                      fontSize: AppTypography.label,
                      height: 1.4,
                      color: muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final trace = Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
      child: SizedBox(
        height: _rowHeight * _steps,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _TracePainter(
                  steps: _steps,
                  rowHeight: _rowHeight,
                  active: pos.active,
                  packetY: _run.value > 0 ? pos.y : null,
                  rule: rule,
                  gold: gold,
                  live: live,
                  rtl: Directionality.of(context) == TextDirection.rtl,
                ),
              ),
            ),
            Column(children: [for (var i = 0; i < _steps; i++) stepRow(i)]),
          ],
        ),
      ),
    );

    final footer = Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSize(
            duration: AppMotion.snap,
            alignment: Alignment.topLeft,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 64),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: rule),
                color: context.onSurface.withValues(alpha: 0.04),
              ),
              child: Text(
                finished ? l10n.traceDone : detail,
                key: ValueKey(finished ? 'done' : detail),
                style: TextStyle(
                  fontSize: AppTypography.body,
                  height: 1.45,
                  color: finished ? live : context.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: running ? null : _replay,
                style: OutlinedButton.styleFrom(
                  foregroundColor: gold,
                  side: BorderSide(color: gold.withValues(alpha: 0.7)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                child: Text(
                  running
                      ? l10n.traceRunning
                      : (_run.value >= 1 ? l10n.traceAgain : l10n.traceCta),
                  style: const TextStyle(
                    fontSize: AppTypography.body,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  SoundService.instance.playClick();
                  aboutTabRequest.value = 2;
                  HomeController.maybeOf(context)?.goTo(5);
                },
                child: Text(
                  l10n.traceOpenPlayground,
                  style: TextStyle(
                    fontSize: AppTypography.body,
                    fontWeight: FontWeight.w600,
                    color: context.mutedText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.traceNote,
            style: TextStyle(
              fontSize: AppTypography.label,
              height: 1.4,
              color: muted,
            ),
          ),
        ],
      ),
    );

    return HeroStep(
      animation: widget.reveal,
      begin: 0.3,
      end: 1.0,
      rise: 0.06,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.cardStock,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: rule),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [header, availability, trace, footer],
          ),
        ),
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  _TracePainter({
    required this.steps,
    required this.rowHeight,
    required this.active,
    required this.packetY,
    required this.rule,
    required this.gold,
    required this.live,
    required this.rtl,
  });

  final int steps;
  final double rowHeight;
  final int active;
  final double? packetY;
  final Color rule;
  final Color gold;
  final Color live;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    final x = rtl ? size.width - 14 : 14.0;
    double c(int i) => rowHeight * i + rowHeight / 2;

    final base = Paint()
      ..color = rule
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(x, c(0)), Offset(x, c(steps - 1)), base);

    if (packetY != null) {
      final lit = Paint()
        ..color = gold.withValues(alpha: 0.85)
        ..strokeWidth = 1.5;
      canvas.drawLine(Offset(x, c(0)), Offset(x, packetY!), lit);
    }

    for (var i = 0; i < steps; i++) {
      final center = Offset(x, c(i));
      final reached = active >= i;
      if (i == active) {
        canvas.drawCircle(
          center,
          11,
          Paint()
            ..color = gold.withValues(alpha: 0.28)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
        );
      }
      canvas.drawCircle(
        center,
        reached ? 6 : 4,
        Paint()..color = reached ? gold : rule,
      );
    }

    final p = packetY;
    if (p != null) {
      canvas.drawCircle(
        Offset(x, p),
        9,
        Paint()
          ..color = live.withValues(alpha: 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.drawCircle(Offset(x, p), 4, Paint()..color = live);
    }
  }

  @override
  bool shouldRepaint(_TracePainter old) =>
      old.active != active ||
      old.packetY != packetY ||
      old.rule != rule ||
      old.gold != gold ||
      old.live != live ||
      old.rtl != rtl;
}
