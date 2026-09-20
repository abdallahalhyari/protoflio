import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/hats/bloc/hats_deck_bloc.dart';
import 'package:profile/features/hats/bloc/hats_deck_event.dart';
import 'package:profile/features/hats/bloc/hats_deck_state.dart';

void main() {
  group('HatsDeckBloc Test Suite', () {
    test('initial state is properly configured', () {
      final bloc = HatsDeckBloc(hatCount: 6);
      expect(bloc.state.selectedHatIndex, equals(0));
      expect(bloc.state.renderOrder, equals([0, 1, 2, 3, 4, 5]));
      expect(bloc.state.cardPositions.length, equals(6));
      expect(bloc.state.cardRotations.length, equals(6));
      expect(bloc.state.isInitialized, isFalse);
    });

    test('HatRoleSelected updates selectedHatIndex and brings card to front', () async {
      final bloc = HatsDeckBloc(hatCount: 6);

      bloc.add(const HatRoleSelected(2));
      await expectLater(
        bloc.stream,
        emits(predicate<HatsDeckState>((state) =>
            state.selectedHatIndex == 2 &&
            state.renderOrder.last == 2)),
      );

      await bloc.close();
    });

    test('HatNextRole and HatPrevRole cycle through roles', () async {
      final bloc = HatsDeckBloc(hatCount: 6);

      bloc.add(const HatNextRole());
      await expectLater(
        bloc.stream,
        emits(predicate<HatsDeckState>((state) => state.selectedHatIndex == 1)),
      );

      bloc.add(const HatPrevRole());
      await expectLater(
        bloc.stream,
        emits(predicate<HatsDeckState>((state) => state.selectedHatIndex == 0)),
      );

      // Prev from 0 wraps around to 5
      bloc.add(const HatPrevRole());
      await expectLater(
        bloc.stream,
        emits(predicate<HatsDeckState>((state) => state.selectedHatIndex == 5)),
      );

      await bloc.close();
    });

    test('HatLayoutInitialized sets fan positions and initializes deck', () async {
      final bloc = HatsDeckBloc(hatCount: 6);

      bloc.add(const HatLayoutInitialized(Size(1200, 800)));
      await expectLater(
        bloc.stream,
        emits(predicate<HatsDeckState>((state) =>
            state.isInitialized == true &&
            state.cardPositions.every((pos) => pos != Offset.zero))),
      );

      await bloc.close();
    });

    test('HatCardPositionSet updates position of designated card', () async {
      final bloc = HatsDeckBloc(hatCount: 6);

      bloc.add(const HatCardPositionSet(3, Offset(150, 220)));
      await expectLater(
        bloc.stream,
        emits(predicate<HatsDeckState>((state) =>
            state.cardPositions[3] == const Offset(150, 220))),
      );

      await bloc.close();
    });
  });
}
