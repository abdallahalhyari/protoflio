import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../../../service/sound_service.dart';
import '../data/hats_data.dart';
import '../widget/hat_playing_card.dart';

class HatsGridPage extends StatefulWidget {
  const HatsGridPage({super.key});

  @override
  State<HatsGridPage> createState() => _HatsGridPageState();
}

class _HatsGridPageState extends State<HatsGridPage> {
  late List<Offset> _cardPositions;
  late List<double> _cardRotations;
  late List<int> _renderOrder;
  int _selectedHatIndex = 0;
  bool _isInitialized = false;

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
      if (!isMobile) {
        final double cardW = 255;
        final double cardH = 370;
        _cardPositions[index] = Offset(
          size.width / 2 - cardW / 2,
          size.height / 2 - cardH / 2 + 25,
        );
        _cardRotations[index] = 0.0;
      }
    });
  }

  void _nextRole(Size size, bool isMobile) {
    _selectRole((_selectedHatIndex + 1) % kHats.length, size, isMobile);
  }

  void _prevRole(Size size, bool isMobile) {
    _selectRole((_selectedHatIndex - 1 + kHats.length) % kHats.length, size, isMobile);
  }

  void _layoutCards(Size size) {
    if (_isInitialized) return;
    final double cardW = 255;
    final double cardH = 370;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2 + 30;

    // Arrange in an elegant arc / poker fan across the felt table
    // Extra margins to prevent edge clipping
    final int count = kHats.length;
    final double availableWidth = size.width - 400; // Reserve 200px each side for safety
    final double spacing = (availableWidth / (count - 1)).clamp(80.0, 170.0);
    final double totalW = spacing * (count - 1);
    final double startX = centerX - totalW / 2 - cardW / 2;

    for (int i = 0; i < count; i++) {
      final double progress = (i - (count - 1) / 2) / ((count - 1) / 2); // -1.0 to 1.0
      final double arcY = progress * progress * 30; // Gentle dip
      _cardPositions[i] = Offset(
        (startX + i * spacing).clamp(32.0, size.width - cardW - 48.0),
        (centerY - cardH / 2 + arcY).clamp(80.0, size.height - cardH - 16.0),
      );
    }
    _isInitialized = true;
  }

  void _shuffleDeck(Size size) {
    SoundService.instance.playPageTurn();
    final random = math.Random();
    final double cardW = 255;
    final double cardH = 370;

    setState(() {
      for (int i = 0; i < kHats.length; i++) {
        // Cluster towards center then disperse randomly
        final double rx = (size.width / 2 - cardW / 2) + (random.nextDouble() * 260 - 130);
        final double ry = (size.height / 2 - cardH / 2 + 30) + (random.nextDouble() * 100 - 50);
        _cardPositions[i] = Offset(
          rx.clamp(16.0, size.width - cardW - 16.0),
          ry.clamp(80.0, size.height - cardH - 16.0),
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
    final isMobile = size.width < 800;

    if (!isMobile && !_isInitialized) {
      _layoutCards(size);
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        // Deep Casino Emerald Felt Gradient
        gradient: RadialGradient(
          center: Alignment(0.0, 0.1),
          radius: 1.1,
          colors: [
            Color(0xFF0F3823), // Rich emerald center
            Color(0xFF071F14), // Deep forest edge
            Color(0xFF030D08), // Dark midnight perimeter
          ],
        ),
      ),
      child: Stack(
        children: [
          // Tabletop Felt Rules & Gold Inlay Border
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: const Color(0xFFC8A951).withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Cards Surface (Rendered first on felt)
          if (isMobile)
            // Mobile: Single centered 3D card showcase (Zero nested scroll!)
            Positioned.fill(
              top: 140,
              bottom: 12,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Centered Active 3D Card
                      Expanded(
                        child: Center(
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
                      const SizedBox(height: 8),
                      // Mobile Role Pagination Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _prevRole(size, true),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFDE68A),
                              side: const BorderSide(color: Color(0xFFC8A951)),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            icon: const Icon(Icons.chevron_left, size: 15),
                            label: const Text(
                              'PREV',
                              style: TextStyle(fontFamily: 'Courier', fontSize: 10, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Text(
                            'ROLE 0${_selectedHatIndex + 1} / 0${kHats.length}',
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              color: Color(0xFFFBBF24),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _nextRole(size, true),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFDE68A),
                              side: const BorderSide(color: Color(0xFFC8A951)),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            icon: const Icon(Icons.chevron_right, size: 15),
                            label: const Text(
                              'NEXT',
                              style: TextStyle(fontFamily: 'Courier', fontSize: 10, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '✦ TAP CARD TO FLIP · 3D CARD SHOWCASE ✦',
                        style: TextStyle(
                          fontFamily: 'Courier',
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 9.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
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

          // Header Toolbar & Role Selector (Rendered on top so pills/buttons are interactive)
          Positioned(
            top: 14,
            left: isMobile ? 14 : 24,
            right: isMobile ? 14 : 24,
            child: SafeArea(
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC8A951).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFFC8A951).withValues(alpha: 0.5)),
                                  ),
                                  child: const Text(
                                    'COLLECTION CASINO FELT',
                                    style: TextStyle(
                                      color: Color(0xFFFDE68A),
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    isMobile ? '6 ROLES' : 'DECK OF 6 ARCHITECTURAL ROLES',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'THE HATS SPREAD',
                              style: TextStyle(
                                fontFamily: 'Tenada',
                                color: Colors.white,
                                fontSize: isMobile ? 20 : 25,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isMobile)
                        Padding(
                          padding: const EdgeInsets.only(right: 150.0),
                          child: Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _shuffleDeck(size),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFFBBF24),
                                  side: const BorderSide(color: Color(0xFFC8A951)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                                icon: const Icon(Icons.casino, size: 15),
                                label: const Text('SHUFFLE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800)),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              OutlinedButton(
                                onPressed: () => _resetSpread(size),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white70,
                                  side: const BorderSide(color: Colors.white24),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                ),
                                child: const Text('RESET', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Role Selector Pills (Zero inner scroll!)
                  _buildRolePills(size, !isMobile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolePills(Size size, bool isDesktop) {
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
                    : Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _selectedHatIndex == i
                      ? const Color(0xFFFBBF24)
                      : const Color(0xFFC8A951).withValues(alpha: 0.4),
                  width: _selectedHatIndex == i ? 1.6 : 1.0,
                ),
                boxShadow: _selectedHatIndex == i
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
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
                      color: _selectedHatIndex == i ? const Color(0xFFFDE68A) : Colors.white70,
                      fontSize: isDesktop ? 10.0 : 8.5,
                      fontWeight: _selectedHatIndex == i ? FontWeight.w900 : FontWeight.w700,
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
}
