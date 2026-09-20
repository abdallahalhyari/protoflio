import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class HatsDeckEvent extends Equatable {
  const HatsDeckEvent();

  @override
  List<Object?> get props => [];
}

class HatRoleSelected extends HatsDeckEvent {
  final int index;

  const HatRoleSelected(this.index);

  @override
  List<Object?> get props => [index];
}

class HatNextRole extends HatsDeckEvent {
  const HatNextRole();
}

class HatPrevRole extends HatsDeckEvent {
  const HatPrevRole();
}

class HatCardBroughtToFront extends HatsDeckEvent {
  final int index;

  const HatCardBroughtToFront(this.index);

  @override
  List<Object?> get props => [index];
}

class HatCardMoved extends HatsDeckEvent {
  final int index;
  final Offset delta;

  const HatCardMoved(this.index, this.delta);

  @override
  List<Object?> get props => [index, delta];
}

class HatCardPositionSet extends HatsDeckEvent {
  final int index;
  final Offset position;

  const HatCardPositionSet(this.index, this.position);

  @override
  List<Object?> get props => [index, position];
}

class HatDeckShuffled extends HatsDeckEvent {
  final Size size;

  const HatDeckShuffled(this.size);

  @override
  List<Object?> get props => [size.width, size.height];
}

class HatDeckSpreadReset extends HatsDeckEvent {
  final Size size;

  const HatDeckSpreadReset(this.size);

  @override
  List<Object?> get props => [size.width, size.height];
}

class HatLayoutInitialized extends HatsDeckEvent {
  final Size size;

  const HatLayoutInitialized(this.size);

  @override
  List<Object?> get props => [size.width, size.height];
}
