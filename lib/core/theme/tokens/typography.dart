/// Typography. One family (Readex Pro, Latin + Arabic + Czech) carries
/// everything; weight and size do the work a display face used to.
///
/// Seven steps, nothing below 12px. Clamp at call site when responsive.
class AppTypography {
  AppTypography._();

  static const String bodyFont = 'ReadexPro';
  static const String displayFont = bodyFont;

  /// Share Tech Mono stands in for OCR-B. Reserved for machine-readable
  /// strings that really are machine-readable (the credential's MRZ
  /// line, APDU bytes) — never for ordinary labels.
  static const String monoFont = 'ShareTechMono';

  static const double label = 12; // meta, chips, captions
  static const double body = 14;
  static const double lead = 16; // intro paragraphs, card titles
  static const double title = 20;
  static const double heading = 28;
  static const double display = 40; // section titles
  static const double hero = 64; // cover statement
  // Credential card design units. The card is scaled as one object, so
  // these render at roughly 12-17px between phone and desktop.
  static const double cardMrz = 13;
  static const double cardBody = 13.5;

  static const double watermark = 220; // fitted background display wordmark
}
