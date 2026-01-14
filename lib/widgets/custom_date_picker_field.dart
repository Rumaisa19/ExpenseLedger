import 'package:expense_ledger_app/utils/app_constants.dart';
import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) onDateChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // FIX: Use surface for background, not onSurface
          color: isDark ? AppColors.dSurface : AppColors.lSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: isDark ? AppColors.dBorder : AppColors.lBorder,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
            const SizedBox(width: 16),
            Text(
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                // Text should use onSurface to contrast with the background
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
