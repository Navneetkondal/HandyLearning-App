import 'package:flutter/material.dart';

/// Semantic color tokens for handyLearn.
/// Usage: AppColors.of(context).primary or AppColors.primary (static light defaults)
class AppColors {
  // Brand
  static const primary = Color(0xFF4F46E5);        // Indigo-600 (main brand)
  static const primaryLight = Color(0xFF818CF8);    // Indigo-400
  static const primarySurface = Color(0xFFEEF2FF);  // Indigo-50
  
  // Accent
  static const accent = Color(0xFF0EA5E9);          // Sky-500
  static const accentSurface = Color(0xFFF0F9FF);   // Sky-50
  
  // Semantic  
  static const success = Color(0xFF10B981);         // Emerald-500
  static const successSurface = Color(0xFFECFDF5);  // Emerald-50
  static const warning = Color(0xFFF59E0B);         // Amber-500
  static const warningSurface = Color(0xFFFEF3C7);  // Amber-100
  static const error = Color(0xFFEF4444);           // Red-500
  static const errorSurface = Color(0xFFFEF2F2);    // Red-50
  
  // Domain category colors (for iOS prep pillars)
  static const pillarCore = Color(0xFF6366F1);      // Indigo
  static const pillarUI = Color(0xFF0EA5E9);        // Sky  
  static const pillarNetwork = Color(0xFFF59E0B);   // Amber
  static const pillarArchitect = Color(0xFF8B5CF6); // Violet
  
  // Difficulty badges
  static const diffBeginner = Color(0xFF10B981);    // Green
  static const diffIntermediate = Color(0xFF3B82F6);// Blue
  static const diffAdvanced = Color(0xFFF59E0B);    // Amber
  static const diffExpert = Color(0xFFEF4444);      // Red
  
  // Surfaces (Light)
  static const bgApp = Color(0xFFF8FAFC);           // Slate-50
  static const bgCard = Colors.white;
  static const bgElevated = Colors.white;
  static const borderSubtle = Color(0xFFE2E8F0);    // Slate-200
  static const borderMedium = Color(0xFFCBD5E1);    // Slate-300
  
  // Surfaces (Dark)
  static const bgAppDark = Color(0xFF0B0F17);
  static const bgCardDark = Color(0xFF1E293B);
  static const bgElevatedDark = Color(0xFF283548);
  static const borderSubtleDark = Color(0xFF334155);
  static const borderMediumDark = Color(0xFF475569);
  
  // Text (Light)
  static const textPrimary = Color(0xFF0F172A);     // Slate-900
  static const textSecondary = Color(0xFF475569);   // Slate-600 (enhanced WCAG AAA contrast)
  static const textTertiary = Color(0xFF64748B);    // Slate-500 (enhanced contrast)
  
  // Text (Dark)
  static const textPrimaryDark = Color(0xFFF1F5F9); // Slate-100
  static const textSecondaryDark = Color(0xFF94A3B8);
  static const textTertiaryDark = Color(0xFF94A3B8); // Slate-400 (enhanced contrast)
  
  // Convenience helpers
  static Color text(bool isDark) => isDark ? textPrimaryDark : textPrimary;
  static Color textSub(bool isDark) => isDark ? textSecondaryDark : textSecondary;
  static Color textMuted(bool isDark) => isDark ? textTertiaryDark : textTertiary;
  static Color primaryText(bool isDark) => isDark ? primaryLight : primary;
  static Color successText(bool isDark) => isDark ? const Color(0xFF34D399) : const Color(0xFF047857);
  static Color bg(bool isDark) => isDark ? bgAppDark : bgApp;
  static Color card(bool isDark) => isDark ? bgCardDark : bgCard;
  static Color elevated(bool isDark) => isDark ? bgElevatedDark : bgElevated;
  static Color border(bool isDark) => isDark ? borderSubtleDark : borderSubtle;
  static Color warningText(bool isDark) => isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309);
  
  // Gold / Honor badges (Accessible contrast)
  static const gold = Color(0xFFD4AF37);
  static Color goldText(bool isDark) => isDark ? const Color(0xFFFACC15) : const Color(0xFF92400E);
  static Color goldBorder(bool isDark) => isDark ? const Color(0xFFF59E0B) : const Color(0xFFB45309);
  
  /// Returns a muted surface color for a given accent
  static Color surface(Color accent, bool isDark) {
    return accent.withValues(alpha: isDark ? 0.15 : 0.08);
  }
}
