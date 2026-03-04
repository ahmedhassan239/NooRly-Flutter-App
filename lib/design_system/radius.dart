/// Design System Border Radius
///
/// Border radius values from Tailwind config
/// All values in logical pixels
class AppRadius {
  AppRadius._();

  static const double sm = 8;  // 8px (0.5rem)
  static const double md = 12; // 12px (0.75rem) - default
  static const double lg = 16; // 16px (1rem)
  static const double xl = 24; // 24px (1.5rem)

  // Common use cases
  static const double button = md;
  static const double card = lg;
  static const double dialog = xl;
  static const double input = sm;
  static const double defaultRadius = md;
}
