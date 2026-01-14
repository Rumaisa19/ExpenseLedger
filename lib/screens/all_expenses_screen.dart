import 'package:expense_ledger_app/providers/expense_provider.dart';
import 'package:expense_ledger_app/utils/app_constants.dart';
import 'package:expense_ledger_app/widgets/category_selector.dart';
import 'package:expense_ledger_app/widgets/custom_app_bar.dart';
import 'package:expense_ledger_app/widgets/transaction_card.dart';
import '../widgets/edit_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllExpensesScreen extends StatefulWidget {
  const AllExpensesScreen({super.key});

  @override
  State<AllExpensesScreen> createState() => _AllExpensesScreenState();
}

class _AllExpensesScreenState extends State<AllExpensesScreen> {
  String? _selectedFilterCategory;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final filteredExpenses = _selectedFilterCategory == null
        ? provider.expenses
        : provider.expenses
              .where((expense) => expense.category == _selectedFilterCategory)
              .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'All Expenses', showBackButton: true),
      body: Column(
        children: [
          // 1. Fixed Height Category Selector
          CategorySelector(
            selectedCategory: _selectedFilterCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedFilterCategory = _selectedFilterCategory == category
                    ? null
                    : category;
              });
            },
          ),

          // 2. Expanded List Section (This fills remaining space)
          Expanded(
            child: filteredExpenses.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.pDefault),
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Dismissible(
                          key: Key(expense.id),
                          direction: DismissDirection.endToStart,
                          background: _buildDeleteBackground(),
                          confirmDismiss: (direction) =>
                              _confirmDeleteDialog(context),
                          onDismissed: (_) {
                            provider.deleteExpense(expense.id);
                            _showSnackbar(context, "Expense deleted");
                          },
                          child: TransactionCard(
                            expense: expense,
                            onDelete: () => _showDeleteDialog(context, expense),
                            onEdit: () =>
                                _showEditBottomSheet(context, expense),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }

  Future<bool?> _confirmDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete?'),
        content: const Text('Do you want to remove this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showEditBottomSheet(BuildContext context, dynamic expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditExpenseBottomSheet(expense: expense),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic expense) {
    // Your existing delete dialog logic...
  }

  void _showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            "No records found",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
