/// Design System Spacing
///
/// 8pt grid spacing system from Tailwind config
/// All values in logical pixels
class AppSpacing {
  AppSpacing._();

  // Base spacing values (8pt grid)
  static const double xs = 4;   // 4px
  static const double sm = 8;   // 8px
  static const double md = 16;  // 16px
  static const double lg = 24;  // 24px
  static const double xl = 32;  // 32px
  static const double xl2 = 48; // 48px (2xl)
  static const double xl3 = 64; // 64px (3xl)

  // Common combinations
  static const double padding = md; // Default padding
  static const double margin = md;  // Default margin
  static const double gap = sm;     // Default gap between elements

  // Screen padding
  static const double screenHorizontal = lg; // Horizontal screen padding
  static const double screenVertical = lg;   // Vertical screen padding
}
