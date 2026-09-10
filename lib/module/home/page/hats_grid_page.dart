import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/hats_data.dart';
import '../widget/hat_playing_card.dart';
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

class _HatsGridPageState extends State<HatsGridPage> {
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
    _cardRotations = [
      -0.12,
      -0.06,
      -0.02,
      0.03,
      0.08,
      0.14,
    ];
    _renderOrder = List.generate(kHats.length, (i) => i);
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
      _cardRotations = [
        -0.12,
        -0.06,
        -0.02,
        0.03,
        0.08,
        0.14,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < AppBreakpoints.tablet;

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
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.18),
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
                        _buildBioStrip(isMobile),
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
                        _buildPaginationRow(size),
                        const SizedBox(height: 4),
                        Text(
                          'TAP THE CARD TO FLIP',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withValues(alpha: 0.72)
                                : const Color(0xFF64748B),
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
                                      color: const Color(0xFF38BDF8)
                                          .withValues(alpha: 0.9)),
                                  const SizedBox(height: 6),
                                  Text(
                                    isMobile
                                        ? 'FEATURE 06 · 6 ROLES'
                                        : 'FEATURE 06 · MULTI-DISCIPLINARY LEADERSHIP',
                                    style: const TextStyle(
                                      color: Color(0xFF38BDF8),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ARCHITECTURAL PERSPECTIVES',
                                    style: TextStyle(
                                      fontFamily: 'Tenada',
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
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
                                          : const Color(0xFF475569),
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
                                          ? const Color(0xFF7DD3FC)
                                          : const Color(0xFF0284C7),
                                      side: BorderSide(
                                          color: const Color(0xFF38BDF8)
                                              .withValues(alpha: 0.6)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                    ),
                                    icon: const Icon(
                                        Icons.auto_awesome_motion_rounded,
                                        size: 15),
                                    label: const Text('SPREAD',
                                        style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800)),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  OutlinedButton(
                                    onPressed: () => _resetSpread(size),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white70
                                          : const Color(0xFF475569),
                                      side: BorderSide(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white24
                                              : const Color(0xFFCBD5E1)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                    ),
                                    child: const Text('ALIGN',
                                        style: TextStyle(
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
                          _buildBioStrip(isMobile),
                          const SizedBox(height: AppSpacing.smd),
                        ],
                        // Role Selector Pills (Zero inner scroll!)
                        _buildRolePills(size, !isMobile),
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

  Widget _buildBioStrip(bool isMobile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bio =
        'Senior mobile engineer with 4+ years shipping enterprise Flutter & '
        'Android systems at scale — offline-first pipelines, NFC + hardware-bound '
        'auth, RabbitMQ event flows, WorkManager sync. Based in Amman, relocating '
        'to Brno for 2027.';
    if (isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.black.withValues(alpha: 0.45) : Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          bio,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF334155),
            fontSize: 11.5,
            height: 1.45,
            letterSpacing: 0.2,
          ),
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.smd),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.accentSky, width: 3),
              ),
              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white.withValues(alpha: 0.85),
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
            ),
            child: Text(
              bio,
              style: TextStyle(
                color: isDark ? Colors.white.withValues(alpha: 0.92) : const Color(0xFF1E293B),
                fontSize: 13.5,
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bioMetaBlock('BASED', 'AMMAN · JORDAN', isDark),
              const SizedBox(height: 8),
              _bioMetaBlock('NEXT', 'BRNO · CZECH REPUBLIC · 2027', isDark),
              const SizedBox(height: 8),
              _bioMetaBlock('OPEN FOR', 'SENIOR ROLES · CONSULTING', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bioMetaBlock(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              color: isDark ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF64748B),
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.4,
            )),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            )),
      ],
    );
  }

  Widget _buildRolePills(Size size, bool isDesktop) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 6,
      runSpacing: 5,
      children: [
        for (int i = 0; i < kHats.length; i++)
          InkWell(
            onTap: () => _selectRole(i, size, !isDesktop),
            borderRadius: BorderRadius.circular(6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 9 : 7,
                vertical: isDesktop ? 4 : 3,
              ),
              decoration: BoxDecoration(
                color: _selectedHatIndex == i
                    ? const Color(0xFFC8A951).withValues(alpha: 0.28)
                    : (isDark ? Colors.black.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.85)),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _selectedHatIndex == i
                      ? AppColors.accentAmber
                      : (isDark ? const Color(0xFFC8A951).withValues(alpha: 0.4) : const Color(0xFFCBD5E1)),
                  width: _selectedHatIndex == i ? 1.6 : 1.0,
                ),
                boxShadow: _selectedHatIndex == i
                    ? [
                        BoxShadow(
                          color: AppColors.accentAmber.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: kHats[i].color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '0${i + 1} ${kHats[i].title.toUpperCase()}',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: _selectedHatIndex == i
                          ? AppColors.accentAmberSoft
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      fontSize: isDesktop ? 10.0 : 8.5,
                      fontWeight: _selectedHatIndex == i
                          ? FontWeight.w900
                          : FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPaginationRow(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: () => _prevRole(size, true),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accentAmberSoft,
            side: const BorderSide(color: Color(0xFFC8A951)),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            visualDensity: VisualDensity.compact,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.chevron_left, size: 14),
          label: const Text(
            'PREV',
            style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 9.5,
                fontWeight: FontWeight.w800),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'ROLE 0${_selectedHatIndex + 1} / 0${kHats.length}',
                style: const TextStyle(
                  fontFamily: 'Courier',
                  color: Color(0xFFFBBF24),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _nextRole(size, true),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accentAmberSoft,
            side: const BorderSide(color: Color(0xFFC8A951)),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            visualDensity: VisualDensity.compact,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.chevron_right, size: 14),
          label: const Text(
            'NEXT',
            style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 9.5,
                fontWeight: FontWeight.w800),
          ),
        ),
      ],
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
            color: const Color(0xFF38BDF8).withValues(alpha: 0.9),
          ),
          const SizedBox(height: 6),
          const Text(
            'FEATURE 06 · LEADERSHIP ROLES',
            style: TextStyle(
              color: Color(0xFF7DD3FC),
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ARCHITECTURAL PERSPECTIVES',
            style: TextStyle(
              fontFamily: 'Tenada',
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRolePills(size, false),
          const SizedBox(height: AppSpacing.md),
          _buildBioStrip(true),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
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
                  duration: const Duration(milliseconds: 280),
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
          _buildPaginationRow(size),
          const SizedBox(height: 6),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.touch_app_outlined, size: 12, color: Color(0xFFFBBF24)),
                  const SizedBox(width: 5),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'TAP CARD TO FLIP · SWIPE TO CHANGE ROLE',
                        style: TextStyle(
                          color: isDark ? Colors.white.withValues(alpha: 0.72) : const Color(0xFF64748B),
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
