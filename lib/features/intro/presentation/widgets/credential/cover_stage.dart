import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/credential/credential_faces.dart';
import 'package:profile/features/intro/presentation/widgets/credential/credential_painters.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/page_activity.dart';
import 'package:profile/shared/widgets/screen_shell.dart';

/// The stage is always issuer ink, in both themes: the one dark room on
/// the site, so the iris into the work reads as stepping into the light.
const Color _kStage = AppColors.ink950;

/// SELECT the eMRTD application, then READ BINARY four records.
const List<String> _kCommands = [
  '00 A4 04 0C 07 A0 00 00 02 47 10 01',
  '00 B0 81 00 00',
  '00 B0 82 00 00',
  '00 B0 83 00 00',
  '00 B0 84 00 00',
];

/// The cover: a full-bleed reader. The credential floats over a wall of
/// hex traffic, tilting toward the pointer under a holographic laminate.
/// Drag it onto the reader (or select it) and the exchange plays: the
/// card docks, commands stream and decode into results, `90 00` lands,
/// and an iris opens from the reader onto the work.
class CoverStage extends StatefulWidget {
  const CoverStage({
    super.key,
    required this.onUnlocked,
    required this.onViewWork,
    required this.onDownloadResume,
    this.isContinuousMobile = false,
  });

  /// Called once the iris has covered the stage.
  final VoidCallback onUnlocked;
  final VoidCallback onViewWork;
  final VoidCallback onDownloadResume;
  final bool isContinuousMobile;

  @override
  State<CoverStage> createState() => _CoverStageState();
}

class _CoverStageState extends State<CoverStage> with TickerProviderStateMixin {
  late final AnimationController _float =
      AnimationController(vsync: this, duration: AppMotion.coverFloat);
  late final AnimationController _read =
      AnimationController(vsync: this, duration: AppMotion.coverRead)
        ..addStatusListener(_onReadStatus);
  late final AnimationController _settle =
      AnimationController(vsync: this, duration: AppMotion.md);

  late final Animation<double> _dock =
      _interval(0.0, 0.14, Curves.easeInOutCubic);
  late final Animation<double> _pulse = _interval(0.12, 0.42, Curves.easeOut);
  late final Animation<double> _granted =
      _interval(0.76, 0.84, Curves.easeOutBack);
  late final Animation<double> _iris = _interval(0.84, 1.0, Curves.easeInCubic);

  Animation<double> _interval(double a, double b, Curve c) =>
      CurvedAnimation(parent: _read, curve: Interval(a, b, curve: c));

  final ValueNotifier<Offset?> _pointer = ValueNotifier(null);
  final GlobalKey _stageKey = GlobalKey();
  final GlobalKey _readerKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();

  Offset _tilt = Offset.zero;
  Offset _drag = Offset.zero;
  Offset _settleFrom = Offset.zero;
  Offset _irisCentre = Offset.zero;
  Timer? _resetTimer;

  bool get _reading => _read.value > 0;

  @override
  void initState() {
    super.initState();
    _settle.addListener(() {
      setState(() => _drag = Offset.lerp(
            _settleFrom,
            Offset.zero,
            Curves.easeOutBack.transform(_settle.value),
          )!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate = !AppMedia.reduceMotion(context) &&
        PageActivity.isActiveOf(context) &&
        !WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (animate && !_float.isAnimating) {
      _float.repeat();
    } else if (!animate && _float.isAnimating) {
      _float.stop();
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _float.dispose();
    _read.dispose();
    _settle.dispose();
    _pointer.dispose();
    super.dispose();
  }

  void _onReadStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    widget.onUnlocked();
    // Put the card back once the page has turned away.
    _resetTimer = Timer(AppMotion.xl, () {
      if (!mounted) return;
      _read.value = 0;
      setState(() => _drag = Offset.zero);
    });
  }

  void _startRead() {
    if (_reading) return;
    SoundService.instance.playSelection();
    final stage = _stageKey.currentContext?.findRenderObject() as RenderBox?;
    final reader = _readerKey.currentContext?.findRenderObject() as RenderBox?;
    if (stage != null && reader != null) {
      _irisCentre = stage.globalToLocal(
        reader.localToGlobal(reader.size.center(Offset.zero)),
      );
    }
    if (AppMedia.reduceMotion(context)) {
      // No travel: show the full exchange, then hand over.
      _read.value = 0.84;
      _resetTimer = Timer(AppMotion.xl * 2, () {
        if (mounted) _read.value = 1;
      });
      return;
    }
    _read.forward(from: 0);
  }

  void _onHover(PointerEvent e) {
    _pointer.value = e.localPosition;
    final card = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    final stage = _stageKey.currentContext?.findRenderObject() as RenderBox?;
    if (card == null || stage == null || _reading) return;
    final centre = stage.globalToLocal(
      card.localToGlobal(card.size.center(Offset.zero)),
    );
    final d = e.localPosition - centre;
    setState(() {
      _tilt = Offset(
        (d.dx / (stage.size.width / 2)).clamp(-1.0, 1.0),
        (d.dy / (stage.size.height / 2)).clamp(-1.0, 1.0),
      );
    });
  }

  void _onExit(PointerEvent _) {
    _pointer.value = null;
    setState(() => _tilt = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final wide = AppBreakpoints.isDesktop(context);
    final canDrag = wide && !widget.isContinuousMobile;
    final hPad = AppScreenShell.horizontalPadding(context);

    final cardH = wide
        ? (size.height - 500).clamp(200.0, 330.0)
        : ((size.width - hPad * 2) / 1.586).clamp(160.0, 260.0);
    final cardW = cardH * 1.586;
    final statementSize = wide
        ? (size.width * 0.036).clamp(AppTypography.display, 60.0)
        : AppTypography.heading + 2;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: loc.coverName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(text: loc.cardRole),
          ]),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.66),
            fontSize: wide ? AppTypography.lead : AppTypography.body,
          ),
        ),
        const SizedBox(height: AppSpacing.smd),
        Semantics(
          header: true,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Text(
              loc.coverStatement,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: statementSize,
                fontWeight: FontWeight.w600,
                height: 1.08,
                letterSpacing: -0.025 * statementSize,
              ),
            ),
          ),
        ),
        SizedBox(height: wide ? AppSpacing.xxl : AppSpacing.xl),
        _buildCard(cardW, cardH, canDrag),
        SizedBox(height: wide ? AppSpacing.lg : AppSpacing.md),
        _Reader(
          key: _readerKey,
          width: math.min(cardW * 1.18, size.width - hPad * 2),
          read: _read,
          granted: _granted,
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: math.min(cardW * 1.4, size.width - hPad * 2),
          height: wide ? 150 : 190,
          child: _LogOrActions(
            read: _read,
            hint: canDrag ? loc.coverHintDrag : loc.coverHintTap,
            onViewWork: widget.onViewWork,
            onDownloadResume: widget.onDownloadResume,
          ),
        ),
      ],
    );

    final stage = Stack(
      key: _stageKey,
      children: [
        const Positioned.fill(child: ColoredBox(color: _kStage)),
        Positioned.fill(
          child: _HexWall(pointer: _pointer, read: _read),
        ),
        // The stage content, centred under the nav.
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              hPad,
              (wide ? kTopNavReserve : kMobileTopReserve) + AppSpacing.md,
              hPad,
              (widget.isContinuousMobile || wide ? 0 : kBottomNavReserve) +
                  AppSpacing.md,
            ),
            child: Center(child: content),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: _GrantedFlash(granted: _granted, iris: _iris),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: IrisPainter(
                progress: _iris,
                centre: _irisCentre,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ],
    );

    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      // The ink is an ancestor of the copy (not just a sibling layer), so
      // contrast tooling and text-on-surface lookups see the real ground.
      child: DecoratedBox(
        decoration: const BoxDecoration(color: _kStage),
        child: widget.isContinuousMobile
            ? ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: stage,
              )
            : SizedBox.expand(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: size.height),
                    child: stage,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCard(double w, double h, bool canDrag) {
    final loc = AppLocalizations.of(context)!;
    final card = AnimatedBuilder(
      animation: Listenable.merge([_float, _read]),
      builder: (context, child) {
        final dock = _dock.value;
        final bob = math.sin(_float.value * math.pi * 2);
        final tilt = Offset.lerp(_tilt, Offset.zero, dock)!;
        final m = Matrix4.identity()
          ..setEntry(3, 2, 0.0012)
          // Docking: slide down into the reader's slot, a little smaller.
          ..translateByDouble(
            _drag.dx * (1 - dock),
            _drag.dy * (1 - dock) + bob * 6 * (1 - dock) + dock * h * 0.55,
            0,
            1,
          )
          ..scaleByDouble(1 - dock * 0.12, 1 - dock * 0.12, 1, 1)
          ..rotateX(-tilt.dy * 0.32 + dock * 0.9)
          ..rotateY(tilt.dx * 0.42)
          ..rotateZ(bob * 0.012 * (1 - dock));
        return Transform(
          alignment: Alignment.center,
          transform: m,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kCredentialRadius * w / 360),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5 * (1 - dock)),
                  blurRadius: 40,
                  offset: Offset(tilt.dx * -16, 24 + tilt.dy * -10),
                ),
                BoxShadow(
                  // A cool rim of reader light as it docks.
                  color: AppColors.tealLight.withValues(alpha: 0.35 * dock),
                  blurRadius: 30,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: SizedBox(
        key: _cardKey,
        width: w,
        height: h,
        child: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: FittedBox(
            child: Stack(
              children: [
                CredentialFront(pulse: _pulse),
                Positioned.fill(
                  child: IgnorePointer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kCredentialRadius),
                      child: CustomPaint(
                        painter: HoloFoilPainter(tilt: _tilt + _drag / 400),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      label: loc.cardSemantics,
      excludeSemantics: true,
      onTap: _startRead,
      child: FocusableActionDetector(
        mouseCursor:
            canDrag ? SystemMouseCursors.grab : SystemMouseCursors.click,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _startRead();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _startRead,
          onPanStart: canDrag
              ? (_) {
                  if (_reading) return;
                  _settle.stop();
                  SoundService.instance.playSnap(haptic: false);
                }
              : null,
          onPanUpdate: canDrag
              ? (d) {
                  if (_reading) return;
                  setState(() => _drag += d.delta);
                }
              : null,
          onPanEnd: canDrag
              ? (_) {
                  if (_reading) return;
                  // Dropped low enough to touch the reader: read it.
                  if (_drag.dy > h * 0.35) {
                    _startRead();
                  } else {
                    _settleFrom = _drag;
                    _settle.forward(from: 0);
                  }
                }
              : null,
          child: card,
        ),
      ),
    );
  }
}

/// The reader slab: a slot, the contactless mark, the standard it speaks,
/// and a status lamp (idle, reading, granted).
class _Reader extends StatelessWidget {
  const _Reader({
    super.key,
    required this.width,
    required this.read,
    required this.granted,
  });

  final double width;
  final Animation<double> read;
  final Animation<double> granted;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: read,
      builder: (context, _) {
        final reading = read.value > 0 && granted.value == 0;
        final blink = reading && (read.value * 40).floor().isEven;
        final lamp = granted.value > 0
            ? AppColors.tealLight
            : blink
                ? AppColors.goldSoft
                : Colors.white.withValues(alpha: 0.25);
        final slotGlow = reading || granted.value > 0
            ? (granted.value > 0 ? AppColors.tealLight : AppColors.gold)
            : Colors.white.withValues(alpha: 0.12);
        return Container(
          width: width,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.ink800, AppColors.ink900],
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 16,
                height: 20,
                child: CustomPaint(
                  painter: ContactlessPainter(
                    color: Colors.white.withValues(alpha: 0.8),
                    pulse: read,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.smd),
              // The slot.
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.ink950,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(color: slotGlow, blurRadius: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.smd),
              ExcludeSemantics(
                child: Text(
                  'ISO/IEC 14443',
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    fontSize: AppTypography.label,
                    color: Colors.white.withValues(alpha: 0.62),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.smd),
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: lamp,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: lamp, blurRadius: 8)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Under the reader: the instruction and the two plain actions while
/// idle; the scrolling APDU log once a read starts.
class _LogOrActions extends StatelessWidget {
  const _LogOrActions({
    required this.read,
    required this.hint,
    required this.onViewWork,
    required this.onDownloadResume,
  });

  final Animation<double> read;
  final String hint;
  final VoidCallback onViewWork;
  final VoidCallback onDownloadResume;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final decoded = [
      null,
      loc.cardRole,
      loc.cardOutcome1,
      loc.cardOutcome2,
      loc.cardOutcome3,
    ];

    final idle = Column(
      children: [
        Text(
          hint,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: AppTypography.body,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _StageButton(
              label: loc.viewMyWork,
              filled: true,
              onPressed: onViewWork,
            ),
            _StageButton(
              label: loc.downloadResume,
              icon: Icons.download_rounded,
              onPressed: onDownloadResume,
            ),
          ],
        ),
      ],
    );

    return AnimatedBuilder(
      animation: read,
      builder: (context, _) {
        final t = read.value;
        if (t == 0) return idle;
        final mono = TextStyle(
          fontFamily: AppTypography.monoFont,
          fontSize: AppTypography.body,
          height: 1.45,
          color: Colors.white.withValues(alpha: 0.5),
        );
        final lines = <Widget>[];
        for (var i = 0; i < _kCommands.length; i++) {
          final start = 0.16 + i * 0.12;
          if (t < start) break;
          final typed = ((t - start) / 0.06).clamp(0.0, 1.0);
          final cmd = _kCommands[i];
          lines.add(Text(
            '> ${cmd.substring(0, (cmd.length * typed).round())}',
            style: mono,
          ));
          if (t >= start + 0.08) {
            lines.add(Text.rich(
              TextSpan(children: [
                TextSpan(text: '< ', style: mono),
                if (decoded[i] != null)
                  TextSpan(
                    text: '${decoded[i]}  ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppTypography.body,
                      height: 1.45,
                    ),
                  ),
                TextSpan(
                  text: '90 00',
                  style: mono.copyWith(color: AppColors.tealLight),
                ),
              ]),
            ));
          }
        }
        // A terminal: newest at the bottom, older lines scroll off the top.
        return ExcludeSemantics(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.bottomLeft,
                maxHeight: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: lines,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StageButton extends StatelessWidget {
  const _StageButton({
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: AppTypography.body, fontWeight: FontWeight.w600),
      ),
      foregroundColor: WidgetStatePropertyAll(
        filled ? AppColors.ink950 : Colors.white,
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (s) => filled
            ? (s.contains(WidgetState.hovered)
                ? AppColors.goldSoft
                : AppColors.gold)
            : (s.contains(WidgetState.hovered)
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: filled ? AppColors.gold : Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
    void tap() {
      SoundService.instance.playClick();
      onPressed();
    }

    return icon == null
        ? TextButton(onPressed: tap, style: style, child: Text(label))
        : TextButton.icon(
            onPressed: tap,
            style: style,
            icon: Icon(icon, size: 18),
            label: Text(label),
          );
  }
}

/// The wall of traffic. A dim layer always; a bright copy revealed by a
/// spotlight under the pointer, and by a scan band while a read runs.
class _HexWall extends StatelessWidget {
  const _HexWall({required this.pointer, required this.read});

  final ValueNotifier<Offset?> pointer;
  final Animation<double> read;

  @override
  Widget build(BuildContext context) {
    final dim = RepaintBoundary(
      child: CustomPaint(
        painter: HexFieldPainter(
          color: AppColors.tealLight.withValues(alpha: 0.09),
        ),
      ),
    );
    final bright = RepaintBoundary(
      child: CustomPaint(
        painter: HexFieldPainter(
          color: AppColors.goldSoft.withValues(alpha: 0.75),
        ),
      ),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        dim,
        AnimatedBuilder(
          animation: Listenable.merge([pointer, read]),
          builder: (context, child) {
            final t = read.value;
            final p = pointer.value;
            if (p == null && (t == 0 || t > 0.84)) {
              return const SizedBox.shrink();
            }
            return ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (bounds) {
                if (t > 0 && t <= 0.84) {
                  // Scan band sweeping down the wall, three passes.
                  final pos = ((t - 0.1) / 0.7 * 3) % 1.0;
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Colors.transparent,
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: [
                      (pos - 0.08).clamp(0.0, 1.0),
                      pos,
                      (pos + 0.08).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds);
                }
                return RadialGradient(
                  center: Alignment(
                    p!.dx / bounds.width * 2 - 1,
                    p.dy / bounds.height * 2 - 1,
                  ),
                  radius: 180 / bounds.shortestSide,
                  colors: const [Colors.white, Colors.transparent],
                ).createShader(bounds);
              },
              child: child,
            );
          },
          child: bright,
        ),
      ],
    );
  }
}

/// `90 00` landing over the reader, then dissolving into the iris.
class _GrantedFlash extends StatelessWidget {
  const _GrantedFlash({required this.granted, required this.iris});

  final Animation<double> granted;
  final Animation<double> iris;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: Listenable.merge([granted, iris]),
      builder: (context, _) {
        final g = granted.value;
        if (g == 0) return const SizedBox.shrink();
        return Opacity(
          opacity: (1 - iris.value * 1.6).clamp(0.0, 1.0),
          child: Center(
            child: Transform.scale(
              scale: 0.7 + 0.3 * g,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '90 00',
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontSize: AppTypography.hero * 1.6,
                      color: AppColors.goldSoft,
                      height: 1,
                      shadows: [
                        Shadow(
                          color: AppColors.gold.withValues(alpha: 0.8),
                          blurRadius: 40,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    loc.coverGranted,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppTypography.title,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
