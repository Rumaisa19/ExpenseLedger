import 'package:expense_ledger_app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryPicker extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryPicker({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const Map<String, IconData> _categoryIcons = {
    'Food': Icons.restaurant_rounded,
    'Transport': Icons.directions_car_rounded,
    'Shopping': Icons.shopping_bag_rounded,
    'Entertainment': Icons.movie_rounded,
    'Bills': Icons.receipt_long_rounded,
    'Health': Icons.medical_services_rounded,
    'Education': Icons.school_rounded,
    'Other': Icons.category_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: _categoryIcons.entries.map((entry) {
        final isSelected = selectedCategory == entry.key;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick(); // Specific feedback for picking
            onCategorySelected(entry.key);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              // Keep background neutral but slightly tinted when selected
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : (isDark ? AppColors.dSurface : AppColors.lSurface)
                        .withValues(alpha: 0.5),

              borderRadius: BorderRadius.circular(25), // Elegant Pill Shape

              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.6)
                    : AppColors.primary.withValues(alpha: 0.05),
                width: 1.2,
              ),

              // Soft shade glow effect
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  entry.value,
                  size: 16,
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 8),
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 0.2,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.dTextSecondary
                              : AppColors.lTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
