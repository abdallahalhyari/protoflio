import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/contact/domain/repositories/contact_repository.dart';
import 'package:profile/features/contact/domain/usecases/get_inquiry_tracks_usecase.dart';
import 'package:profile/features/contact/presentation/bloc/contact_inquiry_event.dart';
import 'package:profile/features/contact/presentation/bloc/contact_inquiry_state.dart';

class ContactInquiryBloc
    extends Bloc<ContactInquiryEvent, ContactInquiryState> {
  ContactInquiryBloc({
    int initialTrackIndex = 0,
    List<InquiryTrackInfo>? tracks,
    ContactRepository? repository,
  }) : super(_createInitialState(
          initialTrackIndex,
          tracks ?? repository?.getInquiryTracks() ?? kDefaultInquiryTracks,
        )) {
    _registerHandlers();
  }

  ContactInquiryBloc.withUseCase({
    required GetInquiryTracksUseCase getTracksUseCase,
    int initialTrackIndex = 0,
  }) : super(_createInitialState(
          initialTrackIndex,
          getTracksUseCase(const NoParams()),
        )) {
    _registerHandlers();
  }

  void _registerHandlers() {
    on<InquiryTrackChanged>(_onTrackChanged);
    on<InquiryNameChanged>(_onNameChanged);
    on<InquiryCompanyChanged>(_onCompanyChanged);
    on<InquiryBodyChanged>(_onBodyChanged);
  }

  static ContactInquiryState _createInitialState(
    int initialTrackIndex,
    List<InquiryTrackInfo> tracks,
  ) {
    final trackIdx = initialTrackIndex.clamp(0, tracks.length - 1);
    return ContactInquiryState(
      tracks: tracks,
      selectedTrackIndex: trackIdx,
      body: tracks[trackIdx].defaultBody,
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
}
