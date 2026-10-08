import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  EmailService._();
  static final EmailService instance = EmailService._();

  static const String _envServiceId =
      String.fromEnvironment('EMAILJS_SERVICE_ID');
  static const String _envTemplateId =
      String.fromEnvironment('EMAILJS_TEMPLATE_ID');
  static const String _envPublicKey =
      String.fromEnvironment('EMAILJS_PUBLIC_KEY');

  String? _overrideServiceId;
  String? _overrideTemplateId;
  String? _overridePublicKey;

  /// Configures or overrides EmailJS credentials at runtime.
  void configure({
    String? serviceId,
    String? templateId,
    String? publicKey,
  }) {
    _overrideServiceId = serviceId;
    _overrideTemplateId = templateId;
    _overridePublicKey = publicKey;
  }

  /// Resets runtime override credentials.
  void reset() {
    _overrideServiceId = null;
    _overrideTemplateId = null;
    _overridePublicKey = null;
  }

  String get serviceId =>
      _overrideServiceId ??
      (_envServiceId.isNotEmpty ? _envServiceId : 'SERVICE_ID_HERE');

  String get templateId =>
      _overrideTemplateId ??
      (_envTemplateId.isNotEmpty ? _envTemplateId : 'TEMPLATE_ID_HERE');

  String get publicKey =>
      _overridePublicKey ??
      (_envPublicKey.isNotEmpty ? _envPublicKey : 'PUBLIC_KEY_HERE');

  static const String _endpoint = 'https://api.emailjs.com/api/v1.0/email/send';

  /// False until real EmailJS credentials replace the placeholders. The
  /// inquiry composer then hands the draft to the visitor's email app
  /// instead of reporting every send as failed.
  bool get isConfigured =>
      serviceId != 'SERVICE_ID_HERE' && serviceId.isNotEmpty;

  Future<bool> sendEmail({
    required String subject,
    required String body,
    required String name,
    required String company,
  }) async {
    if (!isConfigured) return false;

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
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
