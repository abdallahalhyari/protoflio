import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/hats/bloc/hats_deck_bloc.dart';
import 'package:profile/features/hats/bloc/hats_deck_event.dart';
import 'package:profile/features/hats/bloc/hats_deck_state.dart';
import 'package:profile/features/hats/data/hats_data.dart';
import 'package:profile/features/hats/widget/continuous_mobile_hat_column.dart';
import 'package:profile/features/hats/widget/hat_bio_strip.dart';
import 'package:profile/features/hats/widget/hat_console_dock.dart';
import 'package:profile/features/hats/widget/hat_deck_header.dart';
import 'package:profile/features/hats/widget/hat_drag_hint.dart';
import 'package:profile/features/hats/widget/hat_playing_card.dart';
import 'package:profile/features/hats/widget/hat_role_pills.dart';
import 'package:profile/shared/widget/page_activity.dart';
import 'package:profile/shared/widget/screen_shell.dart';

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
      create: (_) => HatsDeckBloc(),
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
      _shuffleDeck(size);
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.keyR) {
      _resetSpread(size);
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

    final roleTitle = kHats[index].title;
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

  void _shuffleDeck(Size size) {
    SoundService.instance.playPageTurn();
    context.read<HatsDeckBloc>().add(HatDeckShuffled(size));
  }

  void _resetSpread(Size size) {
    SoundService.instance.playClick();
    context.read<HatsDeckBloc>().add(HatDeckSpreadReset(size));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < AppBreakpoints.tablet;

    return BlocBuilder<HatsDeckBloc, HatsDeckState>(
      builder: (context, deckState) {
        final selectedHatIndex = deckState.selectedHatIndex;
        final renderOrder = deckState.renderOrder;
        final cardPositions = deckState.cardPositions;
        final cardRotations = deckState.cardRotations;

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

        // Recompute the fan layout when the viewport size changes
        if (!isMobile &&
            (!deckState.isInitialized || _lastLayoutSize != size)) {
          _lastLayoutSize = size;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.read<HatsDeckBloc>().add(HatLayoutInitialized(size));
          });
        }

        return Focus(
          focusNode: _focusNode,
          onKeyEvent: (node, event) => _handleKeyEvent(node, event, size),
          child: SizedBox.expand(
            child: Stack(
              children: [
                // Enterprise Architectural Inlay Border
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.18),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // Cards Surface (Rendered first on felt)
                Positioned.fill(
                  top: 130,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      for (final i in renderOrder)
                        HatPlayingCard(
                          key: ValueKey('hat_card_${kHats[i].title}'),
                          hat: kHats[i],
                          index: i,
                          position: i < cardPositions.length
                              ? cardPositions[i]
                              : Offset.zero,
                          rotation:
                              i < cardRotations.length ? cardRotations[i] : 0.0,
                          onCardTap: () => _selectRole(i, size, false),
                          onDragStart: () => _bringToFront(i),
                          onDragEnd: (newPos) {
                            context
                                .read<HatsDeckBloc>()
                                .add(HatCardPositionSet(i, newPos));
                          },
                        ),
                    ],
                  ),
                ),

                // Header Toolbar & Role Selector
                Positioned(
                  top: isMobile ? 14 : (14 + kTopNavReserve),
                  left: isMobile ? 14 : 24,
                  right: isMobile ? 14 : 24,
                  child: SafeArea(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HatDeckHeader(
                              isMobile: isMobile,
                              onShuffle: () => _shuffleDeck(size),
                              onReset: () => _resetSpread(size),
                            ),
                            const SizedBox(height: AppSpacing.smd),
                            if (!isMobile) ...[
                              HatBioStrip(isMobile: isMobile),
                              const SizedBox(height: AppSpacing.smd),
                              const HatDragHint(),
                              const SizedBox(height: AppSpacing.sm),
                            ],
                            HatRolePills(
                              selectedIndex: selectedHatIndex,
                              isDesktop: !isMobile,
                              onSelectRole: (index) =>
                                  _selectRole(index, size, isMobile),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                      totalCount: kHats.length,
                      currentHat:
                          kHats[selectedHatIndex.clamp(0, kHats.length - 1)],
                      onPrev: () => _prevRole(size, false),
                      onNext: () => _nextRole(size, false),
                      onShuffle: () => _shuffleDeck(size),
                      onReset: () => _resetSpread(size),
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
