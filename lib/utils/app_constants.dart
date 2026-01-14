import 'package:flutter/material.dart';

class AppColors {
  // ========== PRIMARY BRAND COLORS ==========
  static const primary = Color(0xFF6366F1); // Indigo - modern and professional
  static const primaryLight = Color(0xFF818CF8);
  static const primaryDark = Color(0xFF4F46E5);

  static const secondary = Color(0xFF10B981); // Emerald - for positive actions
  static const accent = Color(0xFFF59E0B); // Amber - for highlights

  // Primary Gradient (for cards, buttons, etc.)
  // Primary Gradient (Updated for stability)
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    stops: [0.0, 1.0], // Explicitly define stops to prevent painting assertions
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========== LIGHT THEME COLORS ==========
  static const lBackground = Color(0xFFF8FAFC); // Soft blue-gray
  static const lSurface = Color(0xFFFFFFFF); // Pure white cards
  static const lSurfaceVariant = Color(0xFFF1F5F9); // Lighter variant

  static const lTextPrimary = Color(0xFF0F172A); // Dark slate
  static const lTextSecondary = Color(0xFF64748B); // Medium slate
  static const lTextTertiary = Color(0xFF94A3B8); // Light slate

  static const lBorder = Color(0xFFE2E8F0); // Light border
  static const lDivider = Color(0xFFF1F5F9); // Subtle divider

  // ========== DARK THEME COLORS ==========
  static const dBackground = Color(0xFF0F172A); // Deep dark blue
  static const dSurface = Color(0xFF1E293B); // Elevated surface
  static const dSurfaceVariant = Color(0xFF334155); // Lighter variant

  static const dTextPrimary = Color(0xFFF8FAFC); // Bright white
  static const dTextSecondary = Color(0xFFCBD5E1); // Light gray
  static const dTextTertiary = Color(0xFF94A3B8); // Medium gray

  static const dBorder = Color(0xFF334155); // Dark border
  static const dDivider = Color(0xFF1E293B); // Subtle divider

  // ========== SEMANTIC COLORS (Work in both themes) ==========
  static const success = Color(0xFF10B981); // Green
  static const warning = Color(0xFFF59E0B); // Amber
  static const error = Color(0xFFEF4444); // Red
  static const info = Color(0xFF3B82F6); // Blue

  static const expense = Color(0xFFEF4444); // Red for expenses
  static const income = Color(0xFF10B981); // Green for income

  // ========== CATEGORY COLORS (Vibrant & Professional) ==========
  static const categoryFood = Color(0xFFEF4444); // Red
  static const categoryTransport = Color(0xFF3B82F6); // Blue
  static const categoryShopping = Color(0xFFF59E0B); // Amber
  static const categoryEntertainment = Color(0xFFEC4899); // Pink
  static const categoryBills = Color(0xFF8B5CF6); // Purple
  static const categoryHealth = Color(0xFF10B981); // Green
  static const categoryEducation = Color(0xFF6366F1); // Indigo
  static const categoryOther = Color(0xFF64748B); // Slate

  // ========== CHART COLORS (For Stats) ==========
  static const List<Color> chartColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFF59E0B), // Amber
    Color(0xFF10B981), // Emerald
    Color(0xFF3B82F6), // Blue
    Color(0xFFEF4444), // Red
    Color(0xFF64748B), // Slate
  ];
}

class AppSizes {
  // Padding
  static const double pSmall = 8.0;
  static const double pDefault = 16.0;
  static const double pMedium = 20.0;
  static const double pLarge = 24.0;
  static const double pXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Icon Sizes
  static const double iconSmall = 18.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
}

// Category data structure
class CategoryData {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryData({
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Pre-defined categories list
const List<CategoryData> categories = [
  CategoryData(
    name: 'Food',
    icon: Icons.restaurant,
    color: AppColors.categoryFood,
  ),
  CategoryData(
    name: 'Transport',
    icon: Icons.directions_car,
    color: AppColors.categoryTransport,
  ),
  CategoryData(
    name: 'Shopping',
    icon: Icons.shopping_bag,
    color: AppColors.categoryShopping,
  ),
  CategoryData(
    name: 'Entertainment',
    icon: Icons.movie,
    color: AppColors.categoryEntertainment,
  ),
  CategoryData(
    name: 'Bills',
    icon: Icons.receipt_long,
    color: AppColors.categoryBills,
  ),
  CategoryData(
    name: 'Health',
    icon: Icons.medical_services,
    color: AppColors.categoryHealth,
  ),
  CategoryData(
    name: 'Education',
    icon: Icons.school,
    color: AppColors.categoryEducation,
  ),
  CategoryData(
    name: 'Other',
    icon: Icons.category,
    color: AppColors.categoryOther,
  ),
];
