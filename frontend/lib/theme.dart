import 'package:flutter/material.dart';

class AppTheme {
  // COLORS
  static const Color primary = Color(0xFF1E40AF);
  static const Color primaryContainer = Color(0xFFEFF6FF);
  static const Color surface = Color(0xFFFDFEFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);

  static const Color onSurface = Color(0xFF0F172A);
  static const Color onSurfaceVariant = Color(0xFF64748B);

  static const Color outline = Color(0xFFD1D5DB);
  static const Color muted = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color pressedOverlay = Color(0xFF1F2937);

  // SPACING
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXl = 24.0;
  static const double spacing2xl = 32.0;

  // BORDER RADIUS
  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 24.0;

  // TYPOGRAPHY (NO DUPLICATES, ALL CONST)
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: onSurface,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: onSurface,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: onSurface,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: onSurface,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: onSurfaceVariant,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: onSurfaceVariant,
  );

  // MOTION
  static const Duration fastMotion = Duration(milliseconds: 180);
  static const Duration transitionMotion = Duration(milliseconds: 280);

  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;

  // CARD STYLE
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surfaceVariant,
    borderRadius: BorderRadius.circular(borderRadiusL),
    border: Border.all(color: outline.withOpacity(0.1)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // INPUT FIELD
  static InputDecoration inputDecoration({
    String? hintText,
    String? labelText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
        borderSide: const BorderSide(color: outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
        borderSide: const BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusM),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}