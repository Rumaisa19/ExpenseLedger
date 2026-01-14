import 'package:expense_ledger_app/utils/app_constants.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46, // Slightly slimmer for elegance
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.pDefault),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // Smoother scrolling feel
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.name;

          return Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 4, top: 2),
            child: InkWell(
              onTap: () => onCategorySelected(category.name),
              borderRadius: BorderRadius.circular(25), // Pill shape
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  // Soft background that barely changes
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Theme.of(context).cardColor.withValues(alpha: 0.5),

                  borderRadius: BorderRadius.circular(25),

                  // Elegant thin border
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : Colors.transparent,
                    width: 1.2,
                  ),

                  // Subtle "Elevation" shadow only when selected
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            blurRadius: 12,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category.icon,
                        size: 16,
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 0.3,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : Theme.of(context).textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
