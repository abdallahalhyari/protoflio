import 'package:profile/features/contact/domain/entities/inquiry_track.dart';

/// Contract for contact options and inquiry configuration.
abstract class ContactRepository {
  List<InquiryTrack> getInquiryTracks();
}
