import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/app_constants.dart';
import '../widgets/category_selector.dart';

class EditExpenseBottomSheet extends StatefulWidget {
  final Expense expense;

  const EditExpenseBottomSheet({super.key, required this.expense});

  @override
  State<EditExpenseBottomSheet> createState() => _EditExpenseBottomSheetState();
}

class _EditExpenseBottomSheetState extends State<EditExpenseBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Initialize directly instead of using 'late'
  // This ensures they exist the millisecond the class is created
  late TextEditingController _amountController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    // We assign them here using the widget data
    _amountController = TextEditingController(
      text: widget.expense.amount.toStringAsFixed(2),
    );
    _titleController = TextEditingController(text: widget.expense.title);

    // CRITICAL: Ensure this is exactly as named in your Expense model
    _descriptionController = TextEditingController(
      text: widget.expense.description ?? '',
    );

    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ExpenseProvider>();

      final updatedExpense = Expense(
        id: widget.expense.id,
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: _selectedDate,
        description: _descriptionController.text.trim(),
      );

      provider.updateExpense(updatedExpense);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Expense updated successfully'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Expense',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Amount Card
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusLarge,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'How much?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    prefixText: 'Rs ',
                                    border: InputBorder.none,
                                    prefixStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  validator: (value) =>
                                      (value == null || value.isEmpty)
                                      ? 'Enter amount'
                                      : null,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          _buildLabel(theme, 'Title'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _titleController,
                            decoration: _inputDecoration(
                              theme,
                              'e.g., Grocery shopping',
                            ),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                ? 'Enter title'
                                : null,
                          ),

                          const SizedBox(height: 20),
                          _buildLabel(theme, 'Description'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            maxLength: 150, // Added limit for elegance
                            decoration:
                                _inputDecoration(
                                  theme,
                                  'Add more details...',
                                ).copyWith(
                                  counterStyle: TextStyle(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                          ),

                          const SizedBox(height: 20),
                          _buildLabel(theme, 'Category'),
                          const SizedBox(height: 8),
                          CategorySelector(
                            selectedCategory: _selectedCategory,
                            onCategorySelected: (category) =>
                                setState(() => _selectedCategory = category),
                          ),

                          const SizedBox(height: 20),
                          _buildLabel(theme, 'Date'),
                          const SizedBox(height: 8),
                          _buildDatePicker(theme),

                          const SizedBox(height: 32),
                          _buildSaveButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper Widgets for a cleaner build method
  Widget _buildLabel(ThemeData theme, String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: theme.cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildDatePicker(ThemeData theme) {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _saveExpense,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
