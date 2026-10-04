import 'package:equatable/equatable.dart';
import 'package:profile/features/contact/data/datasources/contact_local_data_source.dart';
import 'package:profile/features/contact/domain/entities/inquiry_track.dart';
import 'package:profile/features/contact/domain/usecases/format_inquiry_message_usecase.dart';

/// Type alias for backward compatibility with existing UI widgets.
typedef InquiryTrackInfo = InquiryTrack;

/// Default inquiry tracks provided via data source.
const List<InquiryTrackInfo> kDefaultInquiryTracks =
    ContactLocalDataSourceImpl.defaultTracks;

class ContactInquiryState extends Equatable {
  final List<InquiryTrackInfo> tracks;
  final int selectedTrackIndex;
  final String name;
  final String company;
  final String body;

  const ContactInquiryState({
    this.tracks = kDefaultInquiryTracks,
    this.selectedTrackIndex = 0,
    this.name = '',
    this.company = '',
    required this.body,
  });

  InquiryTrackInfo get currentTrack =>
      tracks[selectedTrackIndex.clamp(0, tracks.length - 1)];

  String get activeSubject => currentTrack.subject;

  String get formattedMessage => const FormatInquiryMessageUseCase().call(
        FormatInquiryParams(
          name: name,
          company: company,
          body: body,
        ),
      );

  ContactInquiryState copyWith({
    List<InquiryTrackInfo>? tracks,
    int? selectedTrackIndex,
    String? name,
    String? company,
    String? body,
  }) {
    return ContactInquiryState(
      tracks: tracks ?? this.tracks,
      selectedTrackIndex: selectedTrackIndex ?? this.selectedTrackIndex,
      name: name ?? this.name,
      company: company ?? this.company,
      body: body ?? this.body,
    );
  }

  @override
  List<Object?> get props => [
        tracks,
        selectedTrackIndex,
        name,
        company,
        body,
      ];
}
