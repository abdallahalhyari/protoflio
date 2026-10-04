import 'package:profile/core/usecases/usecase.dart';

class FormatInquiryParams {
  final String name;
  final String company;
  final String body;

  const FormatInquiryParams({
    required this.name,
    required this.company,
    required this.body,
  });
}

class FormatInquiryMessageUseCase
    implements UseCase<String, FormatInquiryParams> {
  const FormatInquiryMessageUseCase();

  @override
  String call(FormatInquiryParams params) {
    final buffer = StringBuffer();
    final cleanName = params.name.trim();
    final cleanCompany = params.company.trim();
    final cleanBody = params.body.trim();

    if (cleanName.isNotEmpty || cleanCompany.isNotEmpty) {
      buffer.writeln(
          'FROM: ${cleanName.isNotEmpty ? cleanName : 'Visitor'}${cleanCompany.isNotEmpty ? ' ($cleanCompany)' : ''}');
      buffer.writeln('---');
    }
    buffer.writeln(cleanBody);
    return buffer.toString();
  }
}
