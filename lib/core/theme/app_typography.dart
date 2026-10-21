import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography tokens for handyLearn.
class AppTypography {
  AppTypography._();
  
  // Display
  static TextStyle displayLarge(bool isDark) => TextStyle(
    fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5,
    color: AppColors.text(isDark),
  );
  
  // Headlines
  static TextStyle headlineLarge(bool isDark) => TextStyle(
    fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4,
    color: AppColors.text(isDark),
  );
  static TextStyle headlineMedium(bool isDark) => TextStyle(
    fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.3,
    color: AppColors.text(isDark),
  );
  
  // Titles
  static TextStyle titleLarge(bool isDark) => TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700,
    color: AppColors.text(isDark),
  );
  static TextStyle titleMedium(bool isDark) => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.text(isDark),
  );
  static TextStyle titleSmall(bool isDark) => TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600,
    color: AppColors.text(isDark),
  );
  
  // Body
  static TextStyle bodyLarge(bool isDark) => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500, height: 1.5,
    color: AppColors.text(isDark),
  );
  static TextStyle bodyMedium(bool isDark) => TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400, height: 1.45,
    color: AppColors.text(isDark),
  );
  static TextStyle bodySmall(bool isDark) => TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400, height: 1.4,
    color: AppColors.textSub(isDark),
  );
  
  // Labels/Captions
  static TextStyle labelLarge(bool isDark) => TextStyle(
    fontSize: 13, fontWeight: FontWeight.w700,
    color: AppColors.text(isDark),
  );
  static TextStyle labelMedium(bool isDark) => TextStyle(
    fontSize: 11.5, fontWeight: FontWeight.w600,
    color: AppColors.text(isDark),
  );
  static TextStyle labelSmall(bool isDark) => TextStyle(
    fontSize: 10.5, fontWeight: FontWeight.w600,
    color: AppColors.textSub(isDark),
  );
  
  // Code
  static TextStyle code(bool isDark) => TextStyle(
    fontSize: 12.5, fontWeight: FontWeight.w500, height: 1.5,
    fontFamily: 'monospace',
    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
  );
  
  // Badge/Pill
  static TextStyle badge(Color color) => TextStyle(
    fontSize: 10.5, fontWeight: FontWeight.w700,
    color: color,
  );
}
