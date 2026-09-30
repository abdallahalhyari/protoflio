import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  EmailService._();
  static final EmailService instance = EmailService._();

  // TODO: Replace these with your actual EmailJS credentials
  static const String _serviceId = 'SERVICE_ID_HERE';
  static const String _templateId = 'TEMPLATE_ID_HERE';
  static const String _publicKey = 'PUBLIC_KEY_HERE';
  
  static const String _endpoint = 'https://api.emailjs.com/api/v1.0/email/send';

  Future<bool> sendEmail({
    required String subject,
    required String body,
    required String name,
    required String company,
  }) async {
    if (_serviceId == 'SERVICE_ID_HERE') {
      // Short-circuit if credentials aren't set
      // Short-circuit if credentials aren't set
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'subject': subject,
            'message': body,
            'from_name': name.trim().isEmpty ? 'Anonymous' : name,
            'from_company': company.trim().isEmpty ? 'None' : company,
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      // Silently fail if email fails
      return false;
    }
  }
}
