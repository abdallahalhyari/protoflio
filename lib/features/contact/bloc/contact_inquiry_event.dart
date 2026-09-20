import 'package:equatable/equatable.dart';

abstract class ContactInquiryEvent extends Equatable {
  const ContactInquiryEvent();

  @override
  List<Object?> get props => [];
}

class InquiryTrackChanged extends ContactInquiryEvent {
  final int trackIndex;

  const InquiryTrackChanged(this.trackIndex);

  @override
  List<Object?> get props => [trackIndex];
}

class InquiryNameChanged extends ContactInquiryEvent {
  final String name;

  const InquiryNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class InquiryCompanyChanged extends ContactInquiryEvent {
  final String company;

  const InquiryCompanyChanged(this.company);

  @override
  List<Object?> get props => [company];
}

class InquiryBodyChanged extends ContactInquiryEvent {
  final String body;

  const InquiryBodyChanged(this.body);

  @override
  List<Object?> get props => [body];
}

class InquiryCopiedEvent extends ContactInquiryEvent {
  const InquiryCopiedEvent();
}

class InquiryResetEvent extends ContactInquiryEvent {
  const InquiryResetEvent();
}
