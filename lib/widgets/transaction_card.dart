import 'package:flutter/material.dart';
import '../models/expense.dart';

class TransactionCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const TransactionCard({
    super.key,
    required this.expense,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Check if description exists and isn't just whitespace
    final hasDescription =
        expense.description != null && expense.description!.trim().isNotEmpty;

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: theme.cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ), // Reduced vertical padding
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
            child: Icon(
              _getCategoryIcon(expense.category),
              color: theme.colorScheme.primary,
            ),
          ),
          title: Text(
            expense.title,
            maxLines: 1, // Keep title on one line
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min, // Fixes vertical expansion
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${expense.date.day}/${expense.date.month}/${expense.date.year}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              if (hasDescription)
                Text(
                  expense.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 12, // Slightly smaller to ensure fit
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min, // Fixes the 1.0px overflow
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Rs ${expense.amount.toStringAsFixed(1)}",
                style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFDC2626),
                  fontWeight: FontWeight.bold,
                  fontSize: 14, // Scaled down slightly for better fit
                ),
              ),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Transport':
        return Icons.directions_car_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Health':
        return Icons.medical_services_rounded;
      case 'Bills':
        return Icons.receipt_long_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      case 'Education':
        return Icons.school_rounded;
      case 'Other':
        return Icons.category_rounded;
      default:
        return Icons.monetization_on_rounded;
    }
  }
}
