/// Spacing scale (4pt base). Use these instead of magic numbers.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double smd = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Section rhythm, the same on every page: the masthead's rule, then
  // [sectionControls] to the first control (search, filters, tabs), then
  // [sectionContent] from the last control (or the rule, when a page has
  // no controls) to the content.
  static const double sectionControls = md;
  static const double sectionContent = lg;
}
