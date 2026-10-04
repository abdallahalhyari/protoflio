import 'package:profile/features/contact/data/datasources/contact_local_data_source.dart';
import 'package:profile/features/contact/domain/entities/inquiry_track.dart';
import 'package:profile/features/contact/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactLocalDataSource dataSource;

  const ContactRepositoryImpl([ContactLocalDataSource? dataSource])
      : dataSource = dataSource ?? const ContactLocalDataSourceImpl();

  @override
  List<InquiryTrack> getInquiryTracks() => dataSource.getDefaultTracks();
}
