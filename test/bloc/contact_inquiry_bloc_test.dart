import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/contact/bloc/contact_inquiry_bloc.dart';
import 'package:profile/features/contact/bloc/contact_inquiry_event.dart';
import 'package:profile/features/contact/bloc/contact_inquiry_state.dart';

void main() {
  group('ContactInquiryBloc Test Suite', () {
    test('initial state is configured with default track and empty details',
        () {
      final bloc = ContactInquiryBloc();
      expect(bloc.state.selectedTrackIndex, equals(0));
      expect(bloc.state.name, isEmpty);
      expect(bloc.state.company, isEmpty);
      expect(bloc.state.body, contains('Senior Mobile Architect'));
      expect(bloc.state.isCopied, isFalse);
    });

    test('InquiryTrackChanged updates track and default body', () async {
      final bloc = ContactInquiryBloc();

      bloc.add(const InquiryTrackChanged(1));
      await expectLater(
        bloc.stream,
        emits(predicate<ContactInquiryState>((state) =>
            state.selectedTrackIndex == 1 &&
            state.activeSubject.contains('Architecture Review'))),
      );

      await bloc.close();
    });

    test('form inputs format final inquiry message cleanly', () async {
      final bloc = ContactInquiryBloc();

      bloc.add(const InquiryNameChanged('Sarah Connor'));
      bloc.add(const InquiryCompanyChanged('Cyberdyne Systems'));
      bloc.add(
          const InquiryBodyChanged('We need urgent mobile security audit.'));

      await expectLater(
        bloc.stream.skip(2),
        emits(predicate<ContactInquiryState>((state) =>
            state.formattedMessage
                .contains('FROM: Sarah Connor (Cyberdyne Systems)') &&
            state.formattedMessage
                .contains('We need urgent mobile security audit.'))),
      );

      await bloc.close();
    });

    test('InquiryCopiedEvent updates isCopied flag', () async {
      final bloc = ContactInquiryBloc();

      bloc.add(const InquiryCopiedEvent());
      await expectLater(
        bloc.stream,
        emits(
            predicate<ContactInquiryState>((state) => state.isCopied == true)),
      );

      await bloc.close();
    });
  });
}
