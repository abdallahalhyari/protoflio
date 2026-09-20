import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_inquiry_event.dart';
import 'contact_inquiry_state.dart';

class ContactInquiryBloc
    extends Bloc<ContactInquiryEvent, ContactInquiryState> {
  ContactInquiryBloc({
    int initialTrackIndex = 0,
    List<InquiryTrackInfo>? tracks,
  }) : super(_createInitialState(initialTrackIndex, tracks ?? kDefaultInquiryTracks)) {
    on<InquiryTrackChanged>(_onTrackChanged);
    on<InquiryNameChanged>(_onNameChanged);
    on<InquiryCompanyChanged>(_onCompanyChanged);
    on<InquiryBodyChanged>(_onBodyChanged);
    on<InquiryCopiedEvent>(_onCopied);
    on<InquiryResetEvent>(_onReset);
  }

  static ContactInquiryState _createInitialState(
    int initialTrackIndex,
    List<InquiryTrackInfo> tracks,
  ) {
    final trackIdx = initialTrackIndex.clamp(0, tracks.length - 1);
    return ContactInquiryState(
      tracks: tracks,
      selectedTrackIndex: trackIdx,
      name: '',
      company: '',
      body: tracks[trackIdx].defaultBody,
      isCopied: false,
    );
  }

  void _onTrackChanged(
    InquiryTrackChanged event,
    Emitter<ContactInquiryState> emit,
  ) {
    final trackIdx = event.trackIndex.clamp(0, state.tracks.length - 1);
    emit(state.copyWith(
      selectedTrackIndex: trackIdx,
      body: state.tracks[trackIdx].defaultBody,
      isCopied: false,
    ));
  }

  void _onNameChanged(
    InquiryNameChanged event,
    Emitter<ContactInquiryState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onCompanyChanged(
    InquiryCompanyChanged event,
    Emitter<ContactInquiryState> emit,
  ) {
    emit(state.copyWith(company: event.company));
  }

  void _onBodyChanged(
    InquiryBodyChanged event,
    Emitter<ContactInquiryState> emit,
  ) {
    emit(state.copyWith(body: event.body));
  }

  void _onCopied(
    InquiryCopiedEvent event,
    Emitter<ContactInquiryState> emit,
  ) {
    emit(state.copyWith(isCopied: true));
  }

  void _onReset(
    InquiryResetEvent event,
    Emitter<ContactInquiryState> emit,
  ) {
    emit(_createInitialState(0, state.tracks));
  }
}
