import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/contact/domain/entities/inquiry_track.dart';
import 'package:profile/features/contact/domain/repositories/contact_repository.dart';

class GetInquiryTracksUseCase implements UseCase<List<InquiryTrack>, NoParams> {
  final ContactRepository repository;

  const GetInquiryTracksUseCase(this.repository);

  @override
  List<InquiryTrack> call(NoParams params) {
    return repository.getInquiryTracks();
  }
}
