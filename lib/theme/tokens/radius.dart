/// Border-radius scale. Mixes tier names (`xxs`-`lg`) with intent names
/// (`chip`, `card`, `pill`). **Prefer intent tokens** when one fits —
/// they encode design decisions and are easier to migrate. Tier tokens
/// remain for one-off geometry.
class AppRadius {
  AppRadius._();
  static const double xxs = 2;
  static const double xs = 4;
  static const double chip = 6; // secondary chips / small pills
  static const double sm = 8;
  static const double smd = 10;
  static const double md = 12;
  static const double card = 16;
  static const double lg = 20;
  static const double pill = 999;

  // Intent tokens — decorative geometry pinned by design, not tiered.
  static const double hairline = 2;      // thin accent bars, progress rules
  static const double hairlineWide = 3;  // 3-4px accent bars
  static const double tile = 14;         // bento skill tiles, medium cards
  static const double playingCard = 18;  // hat / persona playing cards
}
