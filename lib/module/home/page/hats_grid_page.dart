import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/hats_data.dart';
import '../widget/hat_playing_card.dart';
import '../widget/hats/continuous_mobile_hat_column.dart';
import '../widget/hats/hat_bio_strip.dart';
import '../widget/hats/hat_console_dock.dart';
import '../widget/hats/hat_deck_header.dart';
import '../widget/hats/hat_drag_hint.dart';
import '../widget/hats/hat_role_pills.dart';
import '../widget/screen_shell.dart';

class HatsGridPage extends StatefulWidget {
  final bool isContinuousMobile;

  const HatsGridPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  State<HatsGridPage> createState() => _HatsGridPageState();
}

// Layout constants for the poker-fan card spread. Kept here so
// _layoutCards / _shuffleDeck / _selectRole all reference one source of
// truth instead of re-declaring `cardW`/`cardH` per method.
const double _kCardW = 255;
const double _kCardH = 370;
const double _kEdgeInset = 16;
const double _kTopInset = 80;
const double _kFanSideReserve = 200; // px reserved on each side for the fan
const double _kFanArcHeight = 30;
const double _kShuffleSpread = 260; // horizontal jitter range
const double _kShuffleDrop = 100; // vertical jitter range

class _HatsGridPageState extends State<HatsGridPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final FocusNode _focusNode;
  late List<Offset> _cardPositions;
  late List<double> _cardRotations;
  late List<int> _renderOrder;
  int _selectedHatIndex = 0;
  bool _isInitialized = false;
  Size? _lastLayoutSize;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'HatsGridFocus');
    _cardPositions = List.filled(kHats.length, Offset.zero);
    _cardRotations = _fanRotations(kHats.length);
    _renderOrder = List.generate(kHats.length, (i) => i);
  }

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

  /// Even spread from -0.14 to 0.14 radians so the fan stays symmetric
  /// regardless of how many hats exist. Was previously a fixed 6-element
  /// literal that would go out-of-range the moment another hat was added.
  static List<double> _fanRotations(int count) {
    if (count <= 1) return const [0.0];
    const double spread = 0.28; // ~16° total fan
    return List<double>.generate(count, (i) {
      final t = i / (count - 1);
      return -spread / 2 + spread * t;
    });
  }

  void _bringToFront(int index) {
    if (_renderOrder.isNotEmpty && _renderOrder.last == index) return;
    setState(() {
      _renderOrder.remove(index);
      _renderOrder.add(index);
    });
  }

  void _selectRole(int index, Size size, bool isMobile) {
    SoundService.instance.playPageTurn();
    setState(() {
      _selectedHatIndex = index;
      _bringToFront(index);
      // Intentionally do NOT rewrite _cardPositions[index] or
      // _cardRotations[index] here — a click / tap keeps the card
      // exactly where it was dealt. Use SPREAD / ALIGN to reset
      // positions.
    });
    // Announce the selection to screen readers so keyboard / SR users
    // hear the role change instead of getting only visual feedback.
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
    _selectRole((_selectedHatIndex + 1) % kHats.length, size, isMobile);
  }

  void _prevRole(Size size, bool isMobile) {
    _selectRole(
        (_selectedHatIndex - 1 + kHats.length) % kHats.length, size, isMobile);
  }

  void _layoutCards(Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2 + 30;

    // Arrange in an elegant arc / poker fan across the felt table.
    final int count = kHats.length;
    final double availableWidth = size.width - _kFanSideReserve * 2;
    final double spacing = (availableWidth / (count - 1)).clamp(80.0, 170.0);
    final double totalW = spacing * (count - 1);
    final double startX = centerX - totalW / 2 - _kCardW / 2;

    for (int i = 0; i < count; i++) {
      final double progress = (i - (count - 1) / 2) / ((count - 1) / 2);
      final double arcY = progress * progress * _kFanArcHeight;
      _cardPositions[i] = Offset(
        (startX + i * spacing)
            .clamp(_kEdgeInset * 2, size.width - _kCardW - _kEdgeInset * 3),
        (centerY - _kCardH / 2 + arcY)
            .clamp(_kTopInset, size.height - _kCardH - _kEdgeInset),
      );
    }
    _isInitialized = true;
    _lastLayoutSize = size;
  }

  void _shuffleDeck(Size size) {
    SoundService.instance.playPageTurn();
    final random = math.Random();

    setState(() {
      for (int i = 0; i < kHats.length; i++) {
        final double rx = (size.width / 2 - _kCardW / 2) +
            (random.nextDouble() * _kShuffleSpread - _kShuffleSpread / 2);
        final double ry = (size.height / 2 - _kCardH / 2 + 30) +
            (random.nextDouble() * _kShuffleDrop - _kShuffleDrop / 2);
        _cardPositions[i] = Offset(
          rx.clamp(_kEdgeInset, size.width - _kCardW - _kEdgeInset),
          ry.clamp(_kTopInset, size.height - _kCardH - _kEdgeInset),
        );
        _cardRotations[i] = (random.nextDouble() * 0.36) - 0.18;
      }
    });
  }

  void _resetSpread(Size size) {
    SoundService.instance.playClick();
    setState(() {
      _isInitialized = false;
      _renderOrder = List.generate(kHats.length, (i) => i);
      _layoutCards(size);
      _cardRotations = _fanRotations(kHats.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < AppBreakpoints.tablet;

    if (widget.isContinuousMobile) {
      return ContinuousMobileHatColumn(
        selectedHatIndex: _selectedHatIndex,
        onSelectRole: (index) => _selectRole(index, size, true),
        onNextRole: () => _nextRole(size, true),
        onPrevRole: () => _prevRole(size, true),
        onCardTap: () => _bringToFront(_selectedHatIndex),
      );
    }

    if (isMobile) {
      return SingleChildScrollView(
        child: ContinuousMobileHatColumn(
          selectedHatIndex: _selectedHatIndex,
          onSelectRole: (index) => _selectRole(index, size, true),
          onNextRole: () => _nextRole(size, true),
          onPrevRole: () => _prevRole(size, true),
          onCardTap: () => _bringToFront(_selectedHatIndex),
        ),
      );
    }

    // Recompute the fan layout when the viewport size changes (first
    // frame, or user resizes their browser window) — schedule it for
    // after this frame so we don't mutate state during build.
    if (!isMobile && (!_isInitialized || _lastLayoutSize != size)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_isInitialized && _lastLayoutSize == size) return;
        setState(() => _layoutCards(size));
      });
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
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
                  for (final i in _renderOrder)
                    HatPlayingCard(
                      key: ValueKey('hat_card_${kHats[i].title}'),
                      hat: kHats[i],
                      index: i,
                      position: _cardPositions[i],
                      rotation: _cardRotations[i],
                      onCardTap: () => _selectRole(i, size, false),
                      onDragStart: () => _bringToFront(i),
                      onDragEnd: (newPos) {
                        setState(() {
                          _cardPositions[i] = newPos;
                        });
                      },
                    ),
                ],
              ),
            ),

            // Header Toolbar & Role Selector (Rendered on top so pills/buttons are interactive).
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
                        // Role Selector Pills (Zero inner scroll!)
                        HatRolePills(
                          selectedIndex: _selectedHatIndex,
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
                  selectedIndex: _selectedHatIndex,
                  totalCount: kHats.length,
                  currentHat: kHats[_selectedHatIndex],
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
  }
}
