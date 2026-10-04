import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/hats/domain/entities/hat_info.dart';
import 'package:profile/features/hats/presentation/bloc/hats_deck_bloc.dart';
import 'package:profile/features/hats/presentation/bloc/hats_deck_event.dart';
import 'package:profile/features/hats/presentation/bloc/hats_deck_state.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';
import 'package:profile/features/hats/presentation/widgets/continuous_mobile_hat_column.dart';
import 'package:profile/features/hats/presentation/widgets/hat_bio_strip.dart';
import 'package:profile/features/hats/presentation/widgets/hat_console_dock.dart';
import 'package:profile/features/hats/presentation/widgets/hat_deck_header.dart';
import 'package:profile/features/hats/presentation/widgets/hat_drag_hint.dart';
import 'package:profile/features/hats/presentation/widgets/hat_playing_card.dart';
import 'package:profile/features/hats/presentation/widgets/hat_role_pills.dart';
import 'package:profile/shared/widgets/page_activity.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/features/hats/presentation/utils/hat_labels.dart';

/// Height the fan needs at full scale: one card, the fan arc, and room
/// for the tilted corners and hover lift above and below it.
const double _kFeltMinHeight = kCardH + kFanArcHeight + 48;

/// Viewports shorter than this drop the bio strip from the header.
const double _kBioMinViewportHeight = 760;

/// Space kept free under the felt for the console dock (24px inset plus
/// the dock itself).
const double _kDockReserve = 88;

class HatsGridPage extends StatelessWidget {
  final bool isContinuousMobile;

  const HatsGridPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    HatsDeckBloc? bloc;
    try {
      bloc = context.read<HatsDeckBloc>();
    } catch (_) {
      bloc = null;
    }

    if (bloc != null) {
      return _HatsGridPageView(isContinuousMobile: isContinuousMobile);
    }

    return BlocProvider<HatsDeckBloc>(
      create: (ctx) => HatsDeckBloc(repository: ctx.read<HatRepository>()),
      child: _HatsGridPageView(isContinuousMobile: isContinuousMobile),
    );
  }
}

class _HatsGridPageView extends StatefulWidget {
  final bool isContinuousMobile;

  const _HatsGridPageView({required this.isContinuousMobile});

  @override
  State<_HatsGridPageView> createState() => _HatsGridPageViewState();
}

class _HatsGridPageViewState extends State<_HatsGridPageView>
    with AutomaticKeepAliveClientMixin, ActivePageFocusMixin {
  @override
  bool get wantKeepAlive => true;

  late final FocusNode _focusNode;

  /// Unscaled size of the card felt the fan is laid out in — the space
  /// between the header block and the console dock, divided by the
  /// scale the felt is drawn at. Shuffle / reset lay cards out in it.
  Size _feltSize = Size.zero;
  Size? _lastLayoutSize;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'HatsGridFocus');
  }

  // `autofocus` only wins when nothing in the enclosing scope already has
  // focus — DesktopKeyboardNav's app-wide Focus claims it first, so this
  // page's arrow/A-D/S/R shortcuts would otherwise never fire. The mixin
  // requests focus explicitly whenever this page becomes the visible one.
  @override
  FocusNode get pageFocusNode => _focusNode;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event, Size size) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final k = event.logicalKey;
    if (k == LogicalKeyboardKey.arrowLeft || k == LogicalKeyboardKey.keyA) {
      _prevRole(size, false);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.arrowRight || k == LogicalKeyboardKey.keyD) {
      _nextRole(size, false);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyS) {
      _shuffleDeck();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyR) {
      _resetSpread();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _bringToFront(int index) {
    context.read<HatsDeckBloc>().add(HatCardBroughtToFront(index));
  }

  void _selectRole(int index, Size size, bool isMobile) {
    SoundService.instance.playPageTurn();
    context.read<HatsDeckBloc>().add(HatRoleSelected(index));

    final hats = context.read<HatRepository>().getHats();
    final roleTitle =
        hatTitleLabel(AppLocalizations.of(context)!, hats[index].title);
    final announcement =
        AppLocalizations.of(context)?.selectedRoleAnnouncement(roleTitle) ??
            'Selected role: $roleTitle';
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        announcement,
        Directionality.of(context),
      ),
    );
  }

  void _nextRole(Size size, bool isMobile) {
    SoundService.instance.playPageTurn();
    context.read<HatsDeckBloc>().add(const HatNextRole());
  }

  void _prevRole(Size size, bool isMobile) {
    SoundService.instance.playPageTurn();
    context.read<HatsDeckBloc>().add(const HatPrevRole());
  }

  void _shuffleDeck() {
    if (_feltSize.isEmpty) return;
    SoundService.instance.playPageTurn();
    context.read<HatsDeckBloc>().add(HatDeckShuffled(_feltSize));
  }

  void _resetSpread() {
    if (_feltSize.isEmpty) return;
    SoundService.instance.playClick();
    context.read<HatsDeckBloc>().add(HatDeckSpreadReset(_feltSize));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < AppBreakpoints.tablet;

    final repo = context.read<HatRepository>();
    final hats = repo.getHats();

    return BlocBuilder<HatsDeckBloc, HatsDeckState>(
      builder: (context, deckState) {
        final selectedHatIndex = deckState.selectedHatIndex;

        if (widget.isContinuousMobile) {
          return ContinuousMobileHatColumn(
            selectedHatIndex: selectedHatIndex,
            onSelectRole: (index) => _selectRole(index, size, true),
            onNextRole: () => _nextRole(size, true),
            onPrevRole: () => _prevRole(size, true),
            onCardTap: () => _bringToFront(selectedHatIndex),
          );
        }

        if (isMobile) {
          return SingleChildScrollView(
            child: ContinuousMobileHatColumn(
              selectedHatIndex: selectedHatIndex,
              onSelectRole: (index) => _selectRole(index, size, true),
              onNextRole: () => _nextRole(size, true),
              onPrevRole: () => _prevRole(size, true),
              onCardTap: () => _bringToFront(selectedHatIndex),
            ),
          );
        }

        final header = _DesktopHeader(
          selectedHatIndex: selectedHatIndex,
          size: size,
          onShuffle: _shuffleDeck,
          onReset: _resetSpread,
          onSelectRole: (index) => _selectRole(index, size, false),
        );

        // The fan lives in the space left between the header block and
        // the console dock, and is drawn scaled down when that space is
        // shorter than a card. Laying it out against the whole viewport
        // made it paint over the header and under the dock on 13-14"
        // laptop viewports (~650px tall).
        final felt = _CardFeltLayer(
          deckState: deckState,
          hats: hats,
          size: size,
          onLayoutInitialized: (feltSize) {
            _feltSize = feltSize;
            if (!deckState.isInitialized || _lastLayoutSize != feltSize) {
              _lastLayoutSize = feltSize;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                context
                    .read<HatsDeckBloc>()
                    .add(HatLayoutInitialized(feltSize));
              });
            }
          },
          onSelectRole: (index) => _selectRole(index, size, false),
          onBringToFront: _bringToFront,
        );

        return Focus(
          focusNode: _focusNode,
          onKeyEvent: (node, event) => _handleKeyEvent(node, event, size),
          child: SizedBox.expand(
            child: Stack(
              children: [
                const _EnterpriseBorder(),

                // Header, then the card felt in whatever height is left
                // above the console dock. On a viewport too short for the
                // header plus a minimum-size felt, the two scroll together
                // under the dock instead of overflowing.
                Positioned.fill(
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: header),
                      SliverLayoutBuilder(
                        builder: (context, constraints) {
                          // Scroll-independent: viewport minus the header,
                          // so the felt doesn't resize while scrolling.
                          final remaining = constraints.viewportMainAxisExtent -
                              constraints.precedingScrollExtent -
                              _kDockReserve;
                          final height = remaining < _kFeltMinHeight * 0.6
                              ? _kFeltMinHeight * 0.6
                              : remaining;
                          return SliverToBoxAdapter(
                            child: SizedBox(height: height, child: felt),
                          );
                        },
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: _kDockReserve),
                      ),
                    ],
                  ),
                ),

                // Interactive Bottom Console Dock (Desktop)
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: SafeArea(
                    top: false,
                    child: HatConsoleDock(
                      selectedIndex: selectedHatIndex,
                      totalCount: hats.length,
                      currentHat:
                          hats[selectedHatIndex.clamp(0, hats.length - 1)],
                      onPrev: () => _prevRole(size, false),
                      onNext: () => _nextRole(size, false),
                      onShuffle: _shuffleDeck,
                      onReset: _resetSpread,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  final int selectedHatIndex;
  final Size size;
  final VoidCallback onShuffle;
  final VoidCallback onReset;
  final void Function(int) onSelectRole;

  const _DesktopHeader({
    required this.selectedHatIndex,
    required this.size,
    required this.onShuffle,
    required this.onReset,
    required this.onSelectRole,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14 + kTopNavReserve, 24, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                HatDeckHeader(
                  isMobile: false,
                  onShuffle: onShuffle,
                  onReset: onReset,
                ),
                const SizedBox(height: AppSpacing.smd),
                if (size.height >= _kBioMinViewportHeight) ...[
                  const HatBioStrip(isMobile: false),
                  const SizedBox(height: AppSpacing.smd),
                ],
                const HatDragHint(),
                const SizedBox(height: AppSpacing.sm),
                HatRolePills(
                  selectedIndex: selectedHatIndex,
                  isDesktop: true,
                  onSelectRole: onSelectRole,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardFeltLayer extends StatelessWidget {
  final HatsDeckState deckState;
  final List<HatInfo> hats;
  final Size size;
  final void Function(Size) onLayoutInitialized;
  final void Function(int) onSelectRole;
  final void Function(int) onBringToFront;

  const _CardFeltLayer({
    required this.deckState,
    required this.hats,
    required this.size,
    required this.onLayoutInitialized,
    required this.onSelectRole,
    required this.onBringToFront,
  });

  @override
  Widget build(BuildContext context) {
    final renderOrder = deckState.renderOrder;
    final cardPositions = deckState.cardPositions;
    final cardRotations = deckState.cardRotations;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.biggest;
        final scale = (available.height / _kFeltMinHeight).clamp(0.5, 1.0);
        final feltSize = available / scale;

        onLayoutInitialized(feltSize);

        return FittedBox(
          fit: BoxFit.fill,
          child: SizedBox.fromSize(
            size: feltSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (final i in renderOrder)
                  HatPlayingCard(
                    key: ValueKey('hat_card_${hats[i].title}'),
                    hat: hats[i],
                    index: i,
                    position: i < cardPositions.length
                        ? cardPositions[i]
                        : Offset.zero,
                    rotation: i < cardRotations.length ? cardRotations[i] : 0.0,
                    onCardTap: () => onSelectRole(i),
                    onDragStart: () => onBringToFront(i),
                    onDragEnd: (newPos) {
                      context
                          .read<HatsDeckBloc>()
                          .add(HatCardPositionSet(i, newPos));
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EnterpriseBorder extends StatelessWidget {
  const _EnterpriseBorder();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
