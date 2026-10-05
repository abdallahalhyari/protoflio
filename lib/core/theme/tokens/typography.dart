/// Typography scale. Sizes align to a modular scale — clamp at call site
/// when responsive. Prefer these constants over raw `fontSize:` literals;
/// the 6 named steps cover 95% of cases.
class AppTypography {
  AppTypography._();

  static const String displayFont = 'Tenada';
  static const String monoFont = 'Courier';

  // Editorial microtext — magazine-style tiny labels, kickers, meta chips.
  static const double nano = 8.5; // badge numbers, tiny logo badges
  static const double editorialSm = 9.5;
  static const double editorial = 10.5;

  // Standard typographic steps.
  static const double micro =
      10; // meta labels above chip size, timeline stamps
  static const double captionSm =
      11.5; // fine crop between caption and overline
  static const double caption = 11; // sub-body helper text, chip labels
  static const double overlineTight =
      12.5; // fine crop between overline and small
  static const double overline = 12; // uppercase kickers over headings
  static const double small = 13;
  static const double smallLoose = 13.5; // fine crop between small and body
  static const double body = 14;
  static const double bodyLoose = 14.5; // fine crop between body and subtitle
  static const double bodyLg = 15;
  static const double subtitle = 16;
  static const double titleSm = 18;
  static const double title = 20;
  static const double titleMid = 22;
  static const double titleLg = 24;
  static const double heading = 28;
  static const double displaySm = 36;
  static const double statDisplay = 38;
  static const double display = 40; // full-bleed page titles
  static const double displayLg = 54;
  static const double heroSm = 60;
  static const double hero = 72; // intro wordmark, splash impact text
  static const double watermark = 220; // fitted background display wordmark
}
