import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/credential/credential_faces.dart';
import 'package:profile/l10n/app_localizations.dart';

/// The cover's credential: an ID-1 smart card with a gold contact plate.
///
/// Selecting it "reads the chip" — the contactless arcs pulse, a SELECT
/// command and its `90 00` success reply print under the card, and the card
/// turns over to show three results. Selecting it again turns it back.
/// This is the site's one orchestrated motion; with reduced motion the
/// card simply swaps faces.
class CredentialCard extends StatefulWidget {
  const CredentialCard({super.key, required this.width});

  final double width;

  @override
  State<CredentialCard> createState() => _CredentialCardState();
}

/// SELECT by AID for the ICAO eMRTD application — the first command a
/// reader sends to an electronic ID.
const String _kApduCommand = '> 00 A4 04 0C 07 A0 00 00 02 47 10 01';
const String _kApduReply = '< 90 00';

class _CredentialCardState extends State<CredentialCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _read = AnimationController(
    vsync: this,
    duration: AppMotion.credentialRead,
    reverseDuration: AppMotion.credentialEject,
  );

  // Forward timeline: pulse → command → reply → turn over. Ejecting runs
  // the turn across the whole (shorter) reverse.
  late final Animation<double> _pulse = CurvedAnimation(
    parent: _read,
    curve: const Interval(0.0, 0.38, curve: Curves.easeOut),
  );
  late final Animation<double> _command = CurvedAnimation(
    parent: _read,
    curve: const Interval(0.06, 0.40),
  );
  late final Animation<double> _reply = CurvedAnimation(
    parent: _read,
    curve: const Interval(0.44, 0.50),
  );
  late final Animation<double> _turn = CurvedAnimation(
    parent: _read,
    curve: const Interval(0.55, 1.0, curve: Curves.easeInOutCubic),
    reverseCurve: Curves.easeInOutCubic,
  );

  bool _showingBack = false;
  bool _hovered = false;

  @override
  void dispose() {
    _read.dispose();
    super.dispose();
  }

  void _toggle() {
    SoundService.instance.playClick();
    setState(() => _showingBack = !_showingBack);
    if (AppMedia.reduceMotion(context)) {
      _read.value = _showingBack ? 1 : 0;
    } else if (_showingBack) {
      _read.forward();
    } else {
      _read.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final height = widget.width / (85.60 / 53.98);
    final isTouch = Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS;

    final card = SizedBox(
      width: widget.width,
      height: height,
      // The card is an object, scaled whole: system text size would only
      // push its fields out of the fixed face. Everything on it is also
      // in the page copy and in the semantics label.
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: AnimatedBuilder(
          animation: _turn,
          builder: (context, _) {
            final angle = _turn.value * math.pi;
            final back = angle > math.pi / 2;
            // Lifts off the page as it turns, settles flat at either face.
            final lift = math.sin(angle);
            final face = FittedBox(
              child: back
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: const CredentialBack(),
                    )
                  : CredentialFront(pulse: _pulse),
            );
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0011)
                ..translateByDouble(0, _hovered ? -3 : 0, 0, 1)
                ..scaleByDouble(1 + lift * 0.05, 1 + lift * 0.05, 1, 1)
                ..rotateY(angle),
              child: AnimatedContainer(
                duration: AppMotion.cardHover,
                curve: AppMotion.standard,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    kCredentialRadius * widget.width / 360,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _hovered || lift > 0.1
                          ? AppColors.shadowDeep
                          : AppColors.shadowMedium,
                      blurRadius: 18 + 20 * lift + (_hovered ? 8 : 0),
                      offset: Offset(0, 8 + 10 * lift + (_hovered ? 4 : 0)),
                    ),
                  ],
                ),
                child: face,
              ),
            );
          },
        ),
      ),
    );

    final interactive = Semantics(
      button: true,
      label: loc.cardSemantics,
      value: _showingBack
          ? [loc.cardOutcome1, loc.cardOutcome2, loc.cardOutcome3].join('. ')
          : null,
      excludeSemantics: true,
      onTap: _toggle,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _toggle();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: card,
        ),
      ),
    );

    final hint = _showingBack
        ? (isTouch ? loc.cardHintTurnBackTap : loc.cardHintTurnBackClick)
        : (isTouch ? loc.cardHintTap : loc.cardHintClick);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        interactive,
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: widget.width,
          child: _ReaderLog(
            hint: hint,
            command: _command,
            reply: _reply,
          ),
        ),
      ],
    );
  }
}

/// What the reader prints: the instruction while idle, then the command
/// as it is sent and the card's reply. Fixed height, so nothing below
/// moves while it runs.
class _ReaderLog extends StatelessWidget {
  const _ReaderLog({
    required this.hint,
    required this.command,
    required this.reply,
  });

  final String hint;
  final Animation<double> command;
  final Animation<double> reply;

  @override
  Widget build(BuildContext context) {
    final mono = TextStyle(
      fontFamily: AppTypography.monoFont,
      fontSize: AppTypography.body,
      height: 1.5,
      color: context.mutedText,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSwitcher(
          duration: AppMotion.sm,
          child: Text(
            hint,
            key: ValueKey(hint),
            style: TextStyle(
              color: context.mutedText,
              fontSize: AppTypography.body,
              height: 1.5,
            ),
          ),
        ),
        ExcludeSemantics(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AnimatedBuilder(
              animation: Listenable.merge([command, reply]),
              builder: (context, _) {
                final shown = (_kApduCommand.length * command.value).round();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _kApduCommand.substring(0, shown),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.clip,
                      style: mono,
                    ),
                    Opacity(
                      opacity: reply.value,
                      child: Text(
                        _kApduReply,
                        style: mono.copyWith(
                          color: context.isDarkMode
                              ? AppColors.tealLight
                              : AppColors.tealDeep,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
