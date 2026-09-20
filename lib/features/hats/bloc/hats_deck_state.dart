import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HatsDeckState extends Equatable {
  final int selectedHatIndex;
  final List<int> renderOrder;
  final List<Offset> cardPositions;
  final List<double> cardRotations;
  final bool isInitialized;

  const HatsDeckState({
    required this.selectedHatIndex,
    required this.renderOrder,
    required this.cardPositions,
    required this.cardRotations,
    required this.isInitialized,
  });

  HatsDeckState copyWith({
    int? selectedHatIndex,
    List<int>? renderOrder,
    List<Offset>? cardPositions,
    List<double>? cardRotations,
    bool? isInitialized,
  }) {
    return HatsDeckState(
      selectedHatIndex: selectedHatIndex ?? this.selectedHatIndex,
      renderOrder: renderOrder ?? this.renderOrder,
      cardPositions: cardPositions ?? this.cardPositions,
      cardRotations: cardRotations ?? this.cardRotations,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
        selectedHatIndex,
        renderOrder,
        cardPositions,
        cardRotations,
        isInitialized,
      ];
}
