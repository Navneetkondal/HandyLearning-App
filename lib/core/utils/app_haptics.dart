import 'package:flutter/services.dart';

/// Centralized haptic feedback controller for handyLearn.
/// Provides calibrated tactile feedback for mobile touch interactions.
class AppHaptics {
  AppHaptics._();

  /// Light impact for general button taps, list item clicks, and navigation
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Medium impact for primary actions (resume learning, start journey, modal actions)
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Subtle click for selection changes (tabs, switches, slider ticks, filter chips)
  static void selection() {
    HapticFeedback.selectionClick();
  }

  /// Success celebration for completing topics, passing quiz questions, or finishing tracks
  static void success() {
    HapticFeedback.heavyImpact();
  }
}
