import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/hats_data.dart';
import '../widget/hat_playing_card.dart';
import '../widget/hats/hat_bio_strip.dart';
import '../widget/hats/hat_drag_hint.dart';
import '../widget/hats/hat_pagination_row.dart';
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

  late List<Offset> _cardPositions;
  late List<double> _cardRotations;
  late List<int> _renderOrder;
  int _selectedHatIndex = 0;
  bool _isInitialized = false;
  Size? _lastLayoutSize;

  @override
  void initState() {
    super.initState();
    _cardPositions = List.filled(kHats.length, Offset.zero);
    _cardRotations = _fanRotations(kHats.length);
    _renderOrder = List.generate(kHats.length, (i) => i);
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
    // ignore: deprecated_member_use
    SemanticsService.announce(
      'Selected role: ${kHats[index].title}',
      Directionality.of(context),
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
    final loc = AppLocalizations.of(context)!;

    if (widget.isContinuousMobile) {
      return _buildMobileColumn(size);
    }

    if (isMobile) {
      return SingleChildScrollView(
        child: _buildMobileColumn(size),
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

    return SizedBox.expand(
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
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            // Cards Surface (Rendered first on felt)
            if (isMobile)
              // Mobile: Single centered 3D card showcase (Zero nested scroll!)
              // Desktop keeps the 140 offset baseline plus the TopNav reserve.
              Positioned.fill(
                top: isMobile ? 140 : (140 + kTopNavReserve),
                bottom: 12,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        HatBioStrip(isMobile: isMobile),
                        const SizedBox(height: AppSpacing.md),
                        // Centered Active 3D Card
                        Expanded(
                          child: Center(
                            child: HatPlayingCard(
                              key: ValueKey(
                                  'mobile_hat_card_$_selectedHatIndex'),
                              hat: kHats[_selectedHatIndex],
                              index: _selectedHatIndex,
                              position: Offset.zero,
                              isStandalone: true,
                              onCardTap: () => _bringToFront(_selectedHatIndex),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Mobile Role Pagination Bar
                        HatPaginationRow(
                          selectedIndex: _selectedHatIndex,
                          totalCount: kHats.length,
                          onPrev: () => _prevRole(size, true),
                          onNext: () => _nextRole(size, true),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'TAP THE CARD TO FLIP',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withValues(alpha: 0.72)
                                : AppColors.slate500,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Desktop: Draggable 3D cards on Felt Table with dynamic Z-index elevation
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
            // On desktop we shift the toolbar down past the floating TopNav pill so
            // they don't stack on the same top edge, and cap it at the shared
            // AppScreenShell max-content-width (1200) so it lines up with every
            // other page's centered content column instead of drifting to the
            // viewport edges on wide displays.
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      height: 2,
                                      color: Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.9)),
                                  const SizedBox(height: 6),
                                  Text(
                                    isMobile
                                        ? 'FEATURE 06 · 6 ROLES'
                                        : 'FEATURE 06 · MULTI-DISCIPLINARY LEADERSHIP',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ARCHITECTURAL PERSPECTIVES',
                                    style: TextStyle(
                                      fontFamily: AppTypography.displayFont,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : AppColors.slate900,
                                      fontSize: isMobile ? 24 : 40,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 4,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Six roles a senior engineer switches between',
                                    style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white.withValues(alpha: 0.75)
                                          : AppColors.slate600,
                                      fontSize: isMobile ? 11 : 12.5,
                                      fontStyle: FontStyle.italic,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Right-aligned action cluster. The old code padded
                            // this by a hardcoded `right: 150` to clear the
                            // theme/language toggles floating in the top-right
                            // of the app; we now let the top-right nav toggles
                            // reserve their own SafeArea corner and just let
                            // this Row hug the end.
                            if (!isMobile)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => _shuffleDeck(size),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Theme.of(context).brightness == Brightness.dark
                                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.35)
                                          : const Color(0xFF0284C7),
                                      side: BorderSide(
                                          color: Theme.of(context).colorScheme.primary
                                              .withValues(alpha: 0.6)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                    ),
                                    icon: const Icon(
                                        Icons.auto_awesome_motion_rounded,
                                        size: 15),
                                    label: Text(loc.spreadAction,
                                        style: const TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  OutlinedButton(
                                    onPressed: () => _resetSpread(size),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white70
                                          : AppColors.slate600,
                                      side: BorderSide(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white24
                                              : AppColors.slate300),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                    ),
                                    child: Text(loc.alignAction,
                                        style: const TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  // Reserve the top-right toggle cluster's
                                  // width so buttons don't slide under the
                                  // theme / language toggles.
                                  const SizedBox(width: 140),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.smd),
                        // About-the-engineer bio strip: gives the nav's "About"
                        // label real semantic weight (was pure role cards
                        // without any personal context before).
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
                          onSelectRole: (index) => _selectRole(index, size, isMobile),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
    );
  }



  Widget _buildMobileColumn(Size size) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 2,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 6),
          Text(
            'FEATURE 06 · LEADERSHIP ROLES',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ARCHITECTURAL PERSPECTIVES',
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              color: isDark ? Colors.white : AppColors.slate900,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          HatRolePills(
            selectedIndex: _selectedHatIndex,
            isDesktop: false,
            onSelectRole: (index) => _selectRole(index, size, true),
          ),
          const SizedBox(height: AppSpacing.md),
          const HatBioStrip(isMobile: true),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < -200) {
                  _nextRole(size, true);
                } else if (details.primaryVelocity! > 200) {
                  _prevRole(size, true);
                }
              }
            },
            child: SizedBox(
              height: 380,
              child: Center(
                child: AnimatedSwitcher(
                  duration: AppMotion.switcher,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.96, end: 1.0).animate(animation),
                      child: child,
                    ),
                  ),
                  child: HatPlayingCard(
                    key: ValueKey('mobile_hat_card_$_selectedHatIndex'),
                    hat: kHats[_selectedHatIndex],
                    index: _selectedHatIndex,
                    position: Offset.zero,
                    isStandalone: true,
                    onCardTap: () => _bringToFront(_selectedHatIndex),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          HatPaginationRow(
            selectedIndex: _selectedHatIndex,
            totalCount: kHats.length,
            onPrev: () => _prevRole(size, true),
            onNext: () => _nextRole(size, true),
          ),
          const SizedBox(height: 6),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.slate200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.touch_app_outlined, size: 12, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 5),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'TAP CARD TO FLIP · SWIPE TO CHANGE ROLE',
                        style: TextStyle(
                          color: isDark ? Colors.white.withValues(alpha: 0.72) : AppColors.slate500,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
