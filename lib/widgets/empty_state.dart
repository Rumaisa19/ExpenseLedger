import 'package:flutter/material.dart';
import 'package:expense_ledger_app/utils/app_constants.dart';

class EmptyState extends StatelessWidget {
  final String? message; // Optional custom message

  const EmptyState({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: AppColors.lTextSecondary.withValues(),
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'No expenses yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.lTextSecondary.withValues(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first expense',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.lTextSecondary.withValues(),
            ),
          ),
        ],
      ),
    );
  }
}