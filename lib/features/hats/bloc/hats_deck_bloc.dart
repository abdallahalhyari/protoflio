import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/hats_data.dart';
import 'hats_deck_event.dart';
import 'hats_deck_state.dart';

const double kCardW = 255;
const double kCardH = 370;
const double kEdgeInset = 16;
const double kTopInset = 80;
const double kFanSideReserve = 200;
const double kFanArcHeight = 30;
const double kShuffleSpread = 260;
const double kShuffleDrop = 100;

class HatsDeckBloc extends Bloc<HatsDeckEvent, HatsDeckState> {
  final int count;

  HatsDeckBloc({int? hatCount})
      : count = hatCount ?? kHats.length,
        super(_createInitialState(hatCount ?? kHats.length)) {
    on<HatRoleSelected>(_onRoleSelected);
    on<HatNextRole>(_onNextRole);
    on<HatPrevRole>(_onPrevRole);
    on<HatCardBroughtToFront>(_onCardBroughtToFront);
    on<HatCardMoved>(_onCardMoved);
    on<HatCardPositionSet>(_onCardPositionSet);
    on<HatLayoutInitialized>(_onLayoutInitialized);
    on<HatDeckShuffled>(_onDeckShuffled);
    on<HatDeckSpreadReset>(_onDeckSpreadReset);
  }

  static HatsDeckState _createInitialState(int count) {
    return HatsDeckState(
      selectedHatIndex: 0,
      renderOrder: List.generate(count, (i) => i),
      cardPositions: List.filled(count, Offset.zero),
      cardRotations: fanRotations(count),
      isInitialized: false,
    );
  }

  static List<double> fanRotations(int count) {
    if (count <= 1) return const [0.0];
    const double spread = 0.28;
    return List<double>.generate(count, (i) {
      final t = i / (count - 1);
      return -spread / 2 + spread * t;
    });
  }

  void _onRoleSelected(HatRoleSelected event, Emitter<HatsDeckState> emit) {
    final newOrder = List<int>.from(state.renderOrder);
    if (newOrder.isNotEmpty && newOrder.last != event.index) {
      newOrder.remove(event.index);
      newOrder.add(event.index);
    }
    emit(state.copyWith(
      selectedHatIndex: event.index,
      renderOrder: newOrder,
    ));
  }

  void _onNextRole(HatNextRole event, Emitter<HatsDeckState> emit) {
    final nextIdx = (state.selectedHatIndex + 1) % count;
    add(HatRoleSelected(nextIdx));
  }

  void _onPrevRole(HatPrevRole event, Emitter<HatsDeckState> emit) {
    final prevIdx = (state.selectedHatIndex - 1 + count) % count;
    add(HatRoleSelected(prevIdx));
  }

  void _onCardBroughtToFront(
      HatCardBroughtToFront event, Emitter<HatsDeckState> emit) {
    if (state.renderOrder.isNotEmpty && state.renderOrder.last == event.index) {
      return;
    }
    final newOrder = List<int>.from(state.renderOrder);
    newOrder.remove(event.index);
    newOrder.add(event.index);
    emit(state.copyWith(renderOrder: newOrder));
  }

  void _onCardMoved(HatCardMoved event, Emitter<HatsDeckState> emit) {
    final positions = List<Offset>.from(state.cardPositions);
    positions[event.index] = positions[event.index] + event.delta;
    emit(state.copyWith(cardPositions: positions));
  }

  void _onCardPositionSet(
      HatCardPositionSet event, Emitter<HatsDeckState> emit) {
    final positions = List<Offset>.from(state.cardPositions);
    positions[event.index] = event.position;
    emit(state.copyWith(cardPositions: positions));
  }

  void _onLayoutInitialized(
      HatLayoutInitialized event, Emitter<HatsDeckState> emit) {
    final positions = _calculateFanPositions(event.size, count);
    emit(state.copyWith(
      cardPositions: positions,
      cardRotations: fanRotations(count),
      isInitialized: true,
    ));
  }

  void _onDeckShuffled(HatDeckShuffled event, Emitter<HatsDeckState> emit) {
    final random = math.Random();
    final size = event.size;
    final positions = List<Offset>.filled(count, Offset.zero);
    final rotations = List<double>.filled(count, 0.0);

    for (int i = 0; i < count; i++) {
      final double rx = (size.width / 2 - kCardW / 2) +
          (random.nextDouble() * kShuffleSpread - kShuffleSpread / 2);
      final double ry = (size.height / 2 - kCardH / 2 + 30) +
          (random.nextDouble() * kShuffleDrop - kShuffleDrop / 2);
      positions[i] = Offset(
        rx.clamp(kEdgeInset, size.width - kCardW - kEdgeInset),
        ry.clamp(kTopInset, size.height - kCardH - kEdgeInset),
      );
      rotations[i] = (random.nextDouble() * 0.36) - 0.18;
    }

    emit(state.copyWith(
      cardPositions: positions,
      cardRotations: rotations,
    ));
  }

  void _onDeckSpreadReset(
      HatDeckSpreadReset event, Emitter<HatsDeckState> emit) {
    final positions = _calculateFanPositions(event.size, count);
    emit(state.copyWith(
      renderOrder: List.generate(count, (i) => i),
      cardPositions: positions,
      cardRotations: fanRotations(count),
      isInitialized: true,
    ));
  }

  static List<Offset> _calculateFanPositions(Size size, int count) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2 + 30;
    final double availableWidth = size.width - kFanSideReserve * 2;
    final double spacing = (availableWidth / (count - 1)).clamp(80.0, 170.0);
    final double totalW = spacing * (count - 1);
    final double startX = centerX - totalW / 2 - kCardW / 2;

    final positions = List<Offset>.filled(count, Offset.zero);
    for (int i = 0; i < count; i++) {
      final double progress = (i - (count - 1) / 2) / ((count - 1) / 2);
      final double arcY = progress * progress * kFanArcHeight;
      positions[i] = Offset(
        (startX + i * spacing)
            .clamp(kEdgeInset * 2, size.width - kCardW - kEdgeInset * 3),
        (centerY - kCardH / 2 + arcY)
            .clamp(kTopInset, size.height - kCardH - kEdgeInset),
      );
    }
    return positions;
  }
}
