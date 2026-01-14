import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

// Helper extension to get theme-aware colors
extension ThemeColors on BuildContext {
  // Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Background colors
  Color get backgroundColor =>
      isDarkMode ? AppColors.dBackground : AppColors.lBackground;
  Color get surfaceColor =>
      isDarkMode ? AppColors.dSurface : AppColors.lSurface;
  Color get surfaceVariant =>
      isDarkMode ? AppColors.dSurfaceVariant : AppColors.lSurfaceVariant;

  // Text colors
  Color get textPrimary =>
      isDarkMode ? AppColors.dTextPrimary : AppColors.lTextPrimary;
  Color get textSecondary =>
      isDarkMode ? AppColors.dTextSecondary : AppColors.lTextSecondary;
  Color get textTertiary =>
      isDarkMode ? AppColors.dTextTertiary : AppColors.lTextTertiary;

  // Border colors
  Color get borderColor => isDarkMode ? AppColors.dBorder : AppColors.lBorder;
  Color get dividerColor =>
      isDarkMode ? AppColors.dDivider : AppColors.lDivider;

  // Primary color (same in both themes)
  Color get primaryColor => AppColors.primary;
}
